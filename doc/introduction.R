## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

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
class(cdc.cvd$data.cat)
table(cdc.cvd$data.cat)
head(cdc.cvd$LocationAbbr)

## -----------------------------------------------------------------------------
colors.census <- c("Less than 5%" = "#feebe2", 
                    "5% to <10%" = "#f768a1", 
                    "10% or Greater" = "#7a0177")

## ---- warnings = FALSE, message = FALSE, eval = FALSE-------------------------
#  map1_categorical(data = census.uninsured19,
#                   join_var = "STUSPS",
#                   fill_var = "Percent.Cat",
#                   fill_color = colors.census,
#                   legend_name = "Percent Uninsured",
#                   territory_label_color = "black",
#                   title = "Figure 1. Percent Uninsured, Ages <19 Years",
#                   save.filepath = "saved-maps/map1-uninsure.png")

## ---- warnings = FALSE, message = FALSE, eval = FALSE-------------------------
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

## ---- warnings = FALSE, message = FALSE, eval = FALSE-------------------------
#  colors.cdc <- c("Q1 (166 to < 198)" = "#ffffcc",
#                   "Q2 (198 to < 215)" = "#a1dab4",
#                   "Q3 (215 to < 248)" = "#41b6c4",
#                   "Q4 (248 to 326)" = "#225ea8")
#  
#  map1_categorical(data = cdc.cvd,
#                   join_var = "LocationAbbr",
#                   fill_var = "data.cat",
#                   fill_color = colors.cdc,
#                   fill_linewidth = 1.2,
#                   fill_linecolor = "black",
#                   inset_box_color = "white",
#                   territory_label_color = "white",
#                   legend_name = "CVD Mortality per 100,000",
#                   border_ids = border,
#                   border_color = "red",
#                   border_linewidth = 1.5,
#                   save.filepath = "saved-maps/map1-cvd.png")

## ---- warnings = FALSE, message = FALSE, eval = FALSE-------------------------
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

## ---- warnings = FALSE, message = FALSE, eval = FALSE-------------------------
#  colors.cdc <- c("Q1 (166 to < 198)" = "#ffffcc",
#                   "Q2 (198 to < 215)" = "#a1dab4",
#                   "Q3 (215 to < 248)" = "#41b6c4",
#                   "Q4 (248 to 326)" = "#225ea8")
#  
#  map2_categorical(data = cdc.cvd,
#                   join_var = "LocationAbbr",
#                   fill_var = "data.cat",
#                   fill_color = colors.cdc,
#                   fill_linewidth = 1.2,
#                   fill_linecolor = "black",
#                   inset_box_color = "white",
#                   legend_name = "CVD Mortality per 100,000",
#                   border_ids = border,
#                   border_color = "red",
#                   border_linewidth = 1.5,
#                   save.filepath = "saved-maps/map2-cvd.png")

