# Function Test File

pacman::p_load(dplyr, ggplot2, sf, tidycensus, stringr, extrafont, cowplot, grid)

load("R/sysdata.rda")

colors.census <- c("Less than 5%" = "#feebe2", 
                    "5% to <10%" = "#f768a1", 
                   "10% or Greater" = "#7a0177")

#border <- c("13031", "13089", "13121")

#data("census.uninsured19")
data("census.uninsured19.co")

map1_categorical(data = census.uninsured19, 
                 join_var = "STUSPS", 
                 fill_var = "Percent.Cat", 
                 fill_color = colors.census, 
                 legend_name = "Percent Uninsured",
                 territory_label_color = "black",
                 title = "Figure 1. Percent Uninsured, Ages <19 Years",
                 save.filepath = "saved-maps/map1-uninsure-2024-07-10.png")


map1_categorical_county(data = census.uninsured19.co, 
                        join_var = "GEOID",
                        county_data_year = "2010", # testing 2010 geometry 
                        fill_var = "Percent.Cat", 
                        fill_color = colors.census, 
                        fill_linewidth = 0.5, 
                        fill_linecolor = "gray50",
                        legend_name = "Percent Uninsured",
                        title = "Figure 1. Percent Uninsured, Ages <19 Years",
                        title_size = 25,
                        #border_ids = border,
                        #border_color = "red",
                        #border_linewidth = 0.5,
                        caption = "Q: Respondents who reported using some type of birth control to keep from getting pregnant",
                        state_color = "black", 
                        state_linewidth = 1,
                        save.filepath = "saved-maps/2024_07_title_caption_test.png")


