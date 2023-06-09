#---------------------------------------#
# Download and Prepare Shapefiles at State/Territory Level
#
# K Labgold
# 2023-05-11
#---------------------------------------#

# Details ----
## U.S. Census Bureau provides shapefiles for:
## U.S. States + D.C.
## Five territories: Puerto Rico (PR), U.S. Virgin Islands (USVI), Guam, American Samoa, Commonwealth of Northern Mariana Islands (CNMI)

### KL note to self: Check for freely associated states:
### Federated States of Micronesia (FSM), Republic of the Marshall Islands (RMI), and Republic of Palau (Palau) 


pacman::p_load(dplyr, ggplot2, sf, tidycensus, stringr, extrafont, cowplot, grid)
`%notin%` <- Negate(`%in%`)

us <- st_read("cb_2018_us_state_500k.shp") # manual download, since tigris package included water areas

# Some localities are going to need parsed geographies, downloading and formatting these separately using tidycensus
HI <- get_decennial(geography = "tract", variables = "H001001", state = "HI", sumfile = "sf1", geometry = TRUE) %>%
            filter(value != 0) %>%
            dplyr::mutate(co = substr(GEOID, 3, 5),
                          st = substr(GEOID, 1, 2),
                          STUSPS = "HI") %>%
            dplyr::select(st, STUSPS) %>%
            group_by(st, STUSPS) %>%
            dplyr::summarise() %>%
            ungroup() %>%
            mutate(group = "HI")

VI.stx <- get_decennial(year = 2020, output = "wide", variables = "DP1_0001C", state = "VI", 
                       geography = "county", geometry = TRUE, sumfile = "dpvi") %>%
                       dplyr::filter(GEOID == 78010) %>%
                        ungroup() %>%
                        mutate(st = substr(GEOID, 1, 2),
                               STUSPS = "VI") %>%
                        dplyr::select(st, STUSPS) %>%
                        mutate(group = "VI.stx")

VI.stt_stj <- get_decennial(year = 2020, output = "wide", variables = "DP1_0001C", state = "VI", 
                        geography = "county", geometry = TRUE, sumfile = "dpvi") %>%
                        filter(GEOID != 78010) %>%
                        ungroup() %>%
                        mutate(st = substr(GEOID, 1, 2),
                               STUSPS = "VI") %>%
                        dplyr::select(st, STUSPS) %>%
                        mutate(group = "VI.stt_stj")

AS <- get_decennial(year = 2020, output = "wide", variables = "DP1_0001C", 
                       state = "AS", geography = "county", geometry = TRUE, sumfile = "dpas") %>%
                       filter(DP1_0001C != 0) %>%
                       mutate(st = substr(GEOID, 1, 2),
                              STUSPS = "AS") %>%
                       dplyr::select(st, STUSPS) %>%
                       group_by(st, STUSPS) %>%
                       dplyr::summarise() %>%
                        ungroup() %>%
                        mutate(group = "AS")

MP <- get_decennial(year = 2020, output = "wide", variables = "DP1_0001C", state = "MP", 
                       geography = "county", geometry = TRUE, sumfile = "dpmp") %>%
                       filter(GEOID != 69085) %>%
                       mutate(st = substr(GEOID, 1, 2),
                              STUSPS = "MP") %>%
                      dplyr::select(st, STUSPS) %>%
                       group_by(st, STUSPS) %>%
                       dplyr::summarise() %>%
                       ungroup() %>%
                       mutate(group = "MP")


# Separate out CONUS and OCONUS locales ----
oconus.list <- c("HI", "AK", "VI", "PR", "GU", "AS", "MP")

mainland <- us %>% 
              filter(STUSPS %notin% oconus.list) %>%
              #st_transform(5070) %>%  # bring back in the map portion
              dplyr::select(STATEFP, STUSPS) %>%
              rename("st" = "STATEFP") %>%
              mutate(group = "mainland")

AK <- us %>% 
      filter(STUSPS == "AK") %>% 
      #st_transform(3338) %>%  # bring back in the map portion
      dplyr::select(STATEFP, STUSPS) %>%
      rename("st" = "STATEFP") %>%
      mutate(group = "AK")

PR <- us %>% 
        filter(STUSPS == "PR") %>%
        dplyr::select(STATEFP, STUSPS) %>%
        rename("st" = "STATEFP") %>%
        mutate(group = "PR")
        
GU <- us %>% 
      filter(STUSPS == "GU") %>% 
      dplyr::select(STATEFP, STUSPS) %>%
      rename("st" = "STATEFP") %>%
      mutate(group = "GU")


# Prepare overarching file: ----
all.geo <- mainland %>%
            rbind(HI) %>%
            rbind(AK) %>%
            rbind(PR) %>%
            rbind(GU) %>%
            rbind(MP) %>%
            rbind(AS) %>%
            rbind(VI.stx) %>% #later use starts with "VI."
            rbind(VI.stt_stj)
            
rm(mainland, HI, AK, PR, GU, MP, AS, VI.stx, VI.stt_stj)

rm(us)

# Make internal data
##usethis::use_data(all.geo, internal = TRUE, compress = TRUE)
