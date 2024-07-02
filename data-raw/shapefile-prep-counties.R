#---------------------------------------#
# Download and Prepare Shapefiles at State/Territory Level
# Adding County Level
# K Labgold
# 2024-07-02
#---------------------------------------#

# Details ----
## U.S. Census Bureau provides shapefiles for:
## U.S. States + D.C.
## Five territories: Puerto Rico (PR), U.S. Virgin Islands (USVI), Guam, American Samoa, Commonwealth of Northern Mariana Islands (CNMI)

### KL note to self: Check for freely associated states:
### Federated States of Micronesia (FSM), Republic of the Marshall Islands (RMI), and Republic of Palau (Palau) 


pacman::p_load(dplyr, ggplot2, sf, tidycensus, stringr, extrafont, cowplot, grid)
`%notin%` <- Negate(`%in%`)
load("data-raw/fips_codes_co.rda")


us.co <- get_decennial(geography = "county", variables = "P13_001N", sumfile = "dhc", geometry = TRUE) %>%
            dplyr::mutate(co = substr(GEOID, 3, 5),
                      st = substr(GEOID, 1, 2))

# Some localities are going to need parsed geographies, downloading and formatting these separately using tidycensus
HI.co <- get_decennial(geography = "tract", variables = "P13_001N", state = "HI", sumfile = "dhc", geometry = TRUE) %>%
            filter(value != 0) %>%
            dplyr::mutate(co = substr(GEOID, 3, 5),
                          st = substr(GEOID, 1, 2)) %>%
            dplyr::select(st, co) %>%
            group_by(st, co) %>%
            dplyr::summarise() %>%
            ungroup() %>%
            mutate(group = "HI")

VI.stx.co <- get_decennial(year = 2020, output = "wide", variables = "DP1_0001C", state = "VI", 
                       geography = "county", geometry = TRUE, sumfile = "dpvi") %>%
                       dplyr::filter(GEOID == 78010) %>%
                        ungroup() %>%
                        mutate(co = substr(GEOID, 3, 5),
                               st = substr(GEOID, 1, 2)) %>%
                        dplyr::select(st, co) %>%
                        mutate(group = "VI.stx")

VI.stt_stj.co <- get_decennial(year = 2020, output = "wide", variables = "DP1_0001C", state = "VI", 
                        geography = "county", geometry = TRUE, sumfile = "dpvi") %>%
                        filter(GEOID != 78010) %>%
                        ungroup() %>%
                        mutate(co = substr(GEOID, 3, 5),
                               st = substr(GEOID, 1, 2)) %>%
                        dplyr::select(st, co) %>%
                        mutate(group = "VI.stt_stj")

AS.co <- get_decennial(year = 2020, output = "wide", variables = "DP1_0001C", 
                       state = "AS", geography = "county", geometry = TRUE, sumfile = "dpas") %>%
                       filter(DP1_0001C != 0) %>%
                       mutate(co = substr(GEOID, 3, 5),
                              st = substr(GEOID, 1, 2)) %>%
                       dplyr::select(st, co) %>%
                       group_by(st, co) %>%
                       dplyr::summarise() %>%
                        ungroup() %>%
                        mutate(group = "AS")

MP.co <- get_decennial(year = 2020, output = "wide", variables = "DP1_0001C", state = "MP", 
                       geography = "county", geometry = TRUE, sumfile = "dpmp") %>%
                       filter(GEOID != 69085) %>%
                       mutate(co = substr(GEOID, 3, 5),
                              st = substr(GEOID, 1, 2)) %>%
                      dplyr::select(st, co) %>%
                       group_by(st, co) %>%
                       dplyr::summarise() %>%
                       ungroup() %>%
                       mutate(group = "MP")

GU.co <- get_decennial(year = 2020, output = "wide", variables = "DP1_0001C", state = "GU", 
                       geography = "county", geometry = TRUE, sumfile = "dpgu") %>%
  mutate(co = substr(GEOID, 3, 5),
         st = substr(GEOID, 1, 2)) %>%
  dplyr::select(st, co) %>%
  group_by(st, co) %>%
  dplyr::summarise() %>%
  ungroup() %>%
  mutate(group = "GU")


# Separate out CONUS and OCONUS locales ----
# oconus.list <- c("HI", "AK", "VI", "PR", "GU", "AS", "MP")
oconus.list.co <- c("15", "02", "78", "72", "66", "60", "69")

mainland.co <- us.co %>% 
                filter(st %notin% oconus.list.co) %>%
                #st_transform(5070) %>%  # bring back in the map portion
                dplyr::select(st, co) %>%
                #rename("st" = "STATEFP") %>%
                mutate(group = "mainland")

AK.co <- us.co %>% 
          filter(st == "02") %>% 
          #st_transform(3338) %>%  # bring back in the map portion
          dplyr::select(st, co) %>%
          #rename("st" = "STATEFP") %>%
          mutate(group = "AK")

PR.co <- us.co %>% 
          filter(st == "72") %>%
          dplyr::select(st, co) %>%
          #rename("st" = "STATEFP") %>%
          mutate(group = "PR")
        

# Prepare overarching file: ----
all.geo.co <- mainland.co %>%
            rbind(HI.co) %>%
            rbind(AK.co) %>%
            rbind(PR.co) %>%
            rbind(GU.co) %>%
            rbind(MP.co) %>%
            rbind(AS.co) %>%
            rbind(VI.stx.co) %>% #later use starts with "VI."
            rbind(VI.stt_stj.co) %>%
            left_join(fips_codes, by = c("st" = "state_code",
                                         "co" = "county_code"
                                      )) %>%
            rename("STUSPS" = "st")
            
rm(mainland.co, HI.co, AK.co, PR.co, GU.co, MP.co, AS.co, VI.stx.co, VI.stt_stj.co)

#plot(mainland.co$geometry)
#plot(GU.co$geometry) # ok
#plot(HI.co$geometry) # check other HI? **
#plot(VI.co$geometry) # VI will split islands to bring closer together ***
#plot(AS.co$geometry) # Also needs to be split ***
#plot(PR.co$geometry) # ok
#plot(MP.co$geometry) # Also check? ** (almost everyone lives on Saipan, Tinian, and Rota)

rm(us.co)
