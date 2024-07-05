## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

library(tidycensus)

## ----setup--------------------------------------------------------------------
library(USTerritoryMapping)

## -----------------------------------------------------------------------------
data(census.uninsured19)
data(cdc.cvd)

## -----------------------------------------------------------------------------
class(census.uninsured19$Percent.Cat)
table(census.uninsured19$Percent.Cat)
head(census.uninsured19$STUSPS)

## -----------------------------------------------------------------------------
data("fips_codes_state")

cdc.cvd <- fips_codes_state %>%
              left_join(cdc.cvd, by = c("state" = "LocationAbbr")) %>%
              mutate(data.cat = factor(
                      case_when(
                            Data_Value < 198 ~ "Q1 (166 to < 198)",
                            Data_Value >= 198 & Data_Value < 215 ~ "Q2 (198 to < 215)",
                            Data_Value >= 215 & Data_Value < 248 ~ "Q3 (215 to < 248)",
                            Data_Value >= 248 & Data_Value < 400 ~ "Q4 (248 to 326)",
                            is.na(Data_Value) ~ "Data Not Available"
                      ),
                      levels = c("Q1 (166 to < 198)", "Q2 (198 to < 215)",
                                 "Q3 (215 to < 248)", "Q4 (248 to 326)", "Data Not Available")
                  )
               )

table(cdc.cvd$data.cat)
class(cdc.cvd$data.cat)

## -----------------------------------------------------------------------------
colors.census <- c("Less than 5%" = "#feebe2", 
                    "5% to <10%" = "#f768a1", 
                    "10% or Greater" = "#7a0177")

## ----warnings = FALSE, message = FALSE, eval = FALSE--------------------------
#  map1_categorical(data = census.uninsured19,
#                   join_var = "STUSPS",
#                   fill_var = "Percent.Cat",
#                   fill_color = colors.census,
#                   legend_name = "Percent Uninsured",
#                   territory_label_color = "black",
#                   title = "Figure 1. Percent Uninsured, Ages <19 Years",
#                   save.filepath = "saved-maps/map1-uninsure.png")

## ----warnings = FALSE, message = FALSE, eval = FALSE--------------------------
#  border <- c("OR", "WI", "VA", "VI")
#  
#  map1_categorical(data = census.uninsured19,
#                   join_var = "STUSPS",
#                   fill_var = "Percent.Cat",
#                   fill_color = colors.census,
#                   legend_name = "Percent Uninsured",
#                   title = "Figure 1. Percent Uninsured, Ages <19 Years",
#                   border_ids = border,
#                   border_color = "red",
#                   border_linewidth = 1,
#                   save.filepath = "saved-maps/map1-uninsure2.png")

## ----warnings = FALSE, message = FALSE, eval = FALSE--------------------------
#  colors.cdc <- c("Q1 (166 to < 198)" = "#ffffcc",
#                   "Q2 (198 to < 215)" = "#a1dab4",
#                   "Q3 (215 to < 248)" = "#41b6c4",
#                   "Q4 (248 to 326)" = "#225ea8",
#                   "Data Not Available" = "grey80")
#  
#  map1_categorical(data = cdc.cvd,
#                   join_var = "state",
#                   fill_var = "data.cat",
#                   fill_color = colors.cdc,
#                   fill_linewidth = 1.2,
#                   fill_linecolor = "black",
#                   inset_box_color = "white",
#                   territory_label_color = "white",
#                   legend_name = "CVD Mortality Rate\nper 100,000 persons",
#                   border_ids = border,
#                   border_color = "red",
#                   border_linewidth = 1.5,
#                   save.filepath = "saved-maps/map1-cvd.png")

## ----warnings = FALSE, message = FALSE, eval = FALSE--------------------------
#  colors.census <- c("Less than 5%" = "#feebe2",
#                      "5% to <10%" = "#f768a1",
#                      "10% or Greater" = "#7a0177")
#  
#  border <- c("OR", "WI", "VA", "VI")
#  
#  map2_categorical(data = census.uninsured19,
#                   join_var = "STUSPS",
#                   fill_var = "Percent.Cat",
#                   fill_color = colors.census,
#                   legend_name = "Percent Uninsured",
#                   title = "Figure 1. Percent Uninsured, Ages <19 Years",
#                   border_ids = border,
#                   border_color = "red",
#                   border_linewidth = 1,
#                   save.filepath = "saved-maps/map2-uninsure.png")

## ----warnings = FALSE, message = FALSE, eval = FALSE--------------------------
#  colors.cdc <- c("Q1 (166 to < 198)" = "#ffffcc",
#                   "Q2 (198 to < 215)" = "#a1dab4",
#                   "Q3 (215 to < 248)" = "#41b6c4",
#                   "Q4 (248 to 326)" = "#225ea8",
#                   "Data Not Available" = "grey80")
#  
#  map2_categorical(data = cdc.cvd,
#                   join_var = "state",
#                   fill_var = "data.cat",
#                   fill_color = colors.cdc,
#                   fill_linewidth = 1.2,
#                   fill_linecolor = "black",
#                   inset_box_color = "white",
#                   legend_name = "CVD Mortality Rate\nper 100,000 persons",
#                   border_ids = border,
#                   border_color = "red",
#                   border_linewidth = 1.5,
#                   save.filepath = "saved-maps/map2-cvd.png")

## -----------------------------------------------------------------------------
fips_county <- tidycensus::fips_codes
head(fips_county)

## -----------------------------------------------------------------------------
data(census.uninsured19.co)

## -----------------------------------------------------------------------------
class(census.uninsured19.co$Percent.Cat)
table(census.uninsured19.co$Percent.Cat)
head(census.uninsured19.co$GEOID)

## -----------------------------------------------------------------------------
colors.census <- c("Less than 5%" = "#feebe2", 
                    "5% to <10%" = "#f768a1", 
                    "10% or Greater" = "#7a0177")

## ----warnings = FALSE, message = FALSE, eval = FALSE--------------------------
#  map1_categorical_county(data = census.uninsured19.co,
#                          join_var = "GEOID",
#                          county_data_year = all.geo.co_2020,
#                          fill_var = "Percent.Cat",
#                          fill_color = colors.census,
#                          fill_linewidth = 0.5,
#                          fill_linecolor = "gray50",
#                          legend_name = "Percent Uninsured",
#                          title = "Figure 1. Percent Uninsured, Ages <19 Years",
#                          state_color = "black",
#                          state_linewidth = 1,
#                          save.filepath = "saved-maps/map1-uninsure-co.png")

