#---------------------------------------#
# Testing data merges w/ and w/o complete territory data for county level data
#
# K Labgold
# 2023-06-01
#---------------------------------------#

#source("shapefile-prep.R")

########################################################-
# 1) First using data from 2020 Decennial Census ----
########################################################-

# Download and prep data for rbind
acs5 <- load_variables(year = 2020, "acs5")
dpvi <- load_variables(year = 2020, "dpvi")

fips_co <- fips_codes %>%
            mutate(county_name = paste0(county, ", ", state_name))


vars.acs <- c("B18135_002", "B18135_007", "B18135_012") # Estimate!!Total:!!Under 19 years:
vars.dpvi <- c("DP3_0071P") #Percent!!HEALTH INSURANCE COVERAGE STATUS!!Civilian population under 19 years in households!!No health insurance coverage

states <- get_acs(year = 2020, output = "wide", variables = vars.acs, 
                        geography = "county", sumfile = "acs5") %>% # includes PR
                    left_join(fips_co, by = c("NAME" = "county_name")) %>%
                    mutate(
                      "Percent Ages 19 or Under with No Insurance" = round(((B18135_007E + B18135_012E)/B18135_002E)*100, 1),
                    STUSPS = state) %>%
                    dplyr::select(GEOID, NAME, `Percent Ages 19 or Under with No Insurance`, STUSPS)
  
VI <- get_decennial(year = 2020, output = "wide", variables = vars.dpvi, state = "VI", 
                        geography = "county", sumfile = "dpvi") %>%
                    mutate(STUSPS = "VI") %>%
                    rename("Percent Ages 19 or Under with No Insurance" = "DP3_0071P")

GU <- get_decennial(year = 2020, output = "wide", variables = vars.dpvi, state = "GU", 
                    geography = "county", sumfile = "dpgu") %>%
                    mutate(STUSPS = "GU") %>%
                    rename("Percent Ages 19 or Under with No Insurance" = "DP3_0071P")

MP <- get_decennial(year = 2020, output = "wide", variables = vars.dpvi, state = "MP", 
                    geography = "county", sumfile = "dpmp") %>%
                    mutate(STUSPS = "MP") %>%
                    rename("Percent Ages 19 or Under with No Insurance" = "DP3_0071P")

AS <- get_decennial(year = 2020, output = "wide", variables = vars.dpvi, state = "AS", 
                    geography = "county", sumfile = "dpas") %>%
                    mutate(STUSPS = "AS") %>%
                    rename("Percent Ages 19 or Under with No Insurance" = "DP3_0071P")

# Rbind
census.co <- states %>%
            rbind(VI) %>%
            rbind(GU) %>%
            rbind(MP) %>%
            rbind(AS) %>%
            # Create Categorical Percent 
            mutate(Percent.Cat = case_when(
              `Percent Ages 19 or Under with No Insurance` < 5 ~ "Less than 5%",
              `Percent Ages 19 or Under with No Insurance` >= 5 & `Percent Ages 19 or Under with No Insurance` < 10 ~ "5% to <10%",
              `Percent Ages 19 or Under with No Insurance` >= 10 ~ "10% or Greater",
            ),
            Percent.Cat = factor(Percent.Cat, levels = c("Less than 5%", "5% to <10%", "10% or Greater")))

rm(states, VI, GU, MP, acs5, dpvi, AS, vars.acs, vars.dpvi, oconus.list.co)

census.uninsured19.co <- census.co %>% dplyr::select(-c("STUSPS"))

# Join with all geo

all.geo.census.co <- all.geo.co %>%
                      mutate(GEOID = paste0(STUSPS, co)) %>%
                      left_join(census.co, by = c("GEOID"))


########################################################-
# 2) Using CDC downloaded data - missing territories ----
########################################################-

## CDC Wonder: Chronic Disease Indicators Cardiovascular Disease
## https://nccd.cdc.gov/cdi/rdPage.aspx?rdReport=DPH_CDI.ExploreByTopic&islTopic=CVD&islYear=9999&go=GO

#cdc.cvd <- rio::import("data-raw/cdcwonder_cardiovasculardisease.csv") %>%
            #filter(!is.na(ID), # remove empty rows
            #       LocationAbbr != "US") %>% # remove total US value
            #dplyr::select(LocationAbbr, Data_Value)  %>%
            #mutate(data.cat = case_when(
            #  Data_Value < 198 ~ "Q1 (166 to < 198)",
            #  Data_Value >= 198 & Data_Value < 215 ~ "Q2 (198 to < 215)",
            #  Data_Value >= 215 & Data_Value < 248 ~ "Q3 (215 to < 248)",
            #  Data_Value >= 248 & Data_Value < 400 ~ "Q4 (248 to 326)"
            #))


# Merge cdc data w/ all.geo file
#all.geo.cdc <- all.geo %>%
                #left_join(cdc.cvd, by = c("STUSPS" = "LocationAbbr"))

