# Function Test File

colors.census <- c("Less than 5%" = "#feebe2", 
                    "5% to <10%" = "#f768a1", 
                   "10% or Greater" = "#7a0177")

border <- c("13031", "13089", "13121")

map1_categorical_county(data = census.uninsured19.co, 
                        join_var = "GEOID", 
                        fill_var = "Percent.Cat", 
                        fill_color = colors.census, 
                        fill_linewidth = 0.5, 
                        fill_linecolor = "gray50",
                        legend_name = "Percent Uninsured",
                        title = "Figure 1. Percent Uninsured, Ages <19 Years",
                        border_ids = border,
                        border_color = "red",
                        border_linewidth = 0.5,
                        state_color = "black", 
                        state_linewidth = 1,
                        save.filepath = "saved-maps/map1-test-co-highlight.png")


