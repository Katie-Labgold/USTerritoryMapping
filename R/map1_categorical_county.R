#' Categorical choropleth US map with territory geometries at the County Level
#' 
#' This function allows for choropleth mapping of a predefined categorical variable
#' for territory geometries at the county level. 
#' See `map1_categorical()` for choropleth mapping of territory geometries at the state level, and
#' `map2_categorical_county()` for choropleth mapping of territory labels at the county level.
#' 
#' @param data Data frame that already includes the fill variable as a factor. See example code/vignette for more detail.
#' @param join_var Variable to join. Must be 5 number GEOID formatted as a character variable. See example code/vignette for more detail.
#' @param county_data_year Package data frame of county geometry. Two options: "2010" for 2010 Counties and "2020 for 2020 counties. Default "2020".
#' @param fill_var Categorical mapping variable entered as "variable".
#' @param fill_color Values for `scale_fill_manual()`. Recommended to prepare with labels, see example.
#' @param fill_linewidth County geometry border line width. Default linewidth = 0.5.
#' @param fill_linecolor County geometry border line color. Default color = "gray50".
#' @param legend_name Legend title entered as a string.
#' @param legend_face Legend title face. Uses standard ggplot2 element_text face options (e.g.,"plain", "italic", "bold", "bold.italic").
#' @param legend_title_size Legend title size. Default = 16. 
#' @param legend_text_size Legend text size. Default = 14.
#' @param legend_position.x Custom legend position x value. Default = 0.93.
#' @param legend_position.y Custom legend position y value. Default = 1.23.
#' @param inset_box_color Color of inset box for HI, AK, and territories. Set as "white" to remove border.
#' @param territory_label_color Color of territory labels. Set as "white" to remove label.
#' @param title Figure title entered as a string.
#' @param title_size Figure title size. Default 25.
#' @param caption Figure caption entered as a string.
#' @param caption_size Figure caption size. Default = 11.
#' @param border_ids List of county GEOIDs for option to outline specific states and territories.
#' @param border_color Color of optional county highlight border.
#' @param border_linewidth Linewidth of optional county highlight border. Default linewidth = 1.
#' @param state_color Color of state outline. Default color = "black". Set to NULL to remove outline. 
#' @param state_linewidth Linewidth of state outline. Default linewidth = 1.
#' @param save.filepath File path for saving plot as "path/image.png".
#' @import dplyr ggplot2 sf cowplot extrafont grid 
#' @export
#' @examples 
#' # Example 1 Using Census Insurance Data, 2020 County Geometry
#' colors.census <- c("Less than 5%" = "#feebe2", 
#'                    "5% to <10%" = "#f768a1", 
#'                    "10% or Greater" = "#7a0177")
#'
#'border <- c("13031", "13089", "13121")
#'
#'map1_categorical_county(data = census.uninsured19.co, 
#'                        join_var = "GEOID", 
#'                        fill_var = "Percent.Cat", 
#'                        fill_color = colors.census, 
#'                        fill_linewidth = 0.5, 
#'                        fill_linecolor = "gray50",
#'                        legend_name = "Percent Uninsured",
#'                        title = "Figure 1. Percent Uninsured, Ages <19 Years",
#'                        border_ids = border,
#'                        border_color = "red",
#'                        border_linewidth = 0.5,
#'                        state_color = "black", 
#'                        state_linewidth = 1,
#'                        save.filepath = "saved-maps/map1-test-co-highlight.png")
#'
              


map1_categorical_county <- function(data, join_var, county_data_year = "2020",
                                    fill_var, fill_color, fill_linewidth = 0.5, fill_linecolor = "gray50",
                             legend_name = NULL, legend_face = "plain", 
                             legend_title_size = 16, legend_text_size = 14,
                             legend_position.x = 0.93, legend_position.y = 1.23,
                             inset_box_color = "black",
                             territory_label_color = "black",
                             title = "",
                             title_size = 25,
                             caption = "",
                             caption_size = 11,
                             border_ids = NULL, border_color = NULL, border_linewidth = 1,
                             state_color = "black", state_linewidth = 1,
                             save.filepath){
  
  all.geo.co <- all.geo.co %>% filter(year == county_data_year)
  
  all.geo.data <- all.geo.co %>%
         mutate(GEOID = paste0(all.geo.co$STUSPS, all.geo.co$co)) %>%
         left_join(data, by = c("GEOID" = join_var))
  
  all.geo.state <- all.geo.data %>% 
                    group_by(state, group) %>%
                    dplyr::summarise() %>%
                    ungroup()
  
  main.map <- all.geo.data %>%
    filter(group == "mainland") %>%
    st_transform(5070) %>%
    ggplot() +
    geom_sf( 
      aes(fill = get(fill_var)), 
      linewidth = fill_linewidth, 
      colour = fill_linecolor
    ) +
    scale_fill_manual(values = fill_color,
                      na.value = "grey80",
                      name = legend_name,
                      drop = FALSE) +
    
    labs(title = title,
         #subtitle = subtitle,
         #caption = caption
         NULL
    ) +
    
    ## Mainland County Highlight Borders ---
    geom_sf(
      data = all.geo.data[all.geo.data$group == "mainland" & all.geo.data$GEOID %in% border_ids, ],
      fill = NA,
      colour = border_color, 
      linewidth = border_linewidth
    ) +
    ## Mainland State Borders ---
    geom_sf(
      data = all.geo.state[all.geo.state$group == "mainland", ],
      fill = NA,
      colour = state_color, 
      linewidth = state_linewidth
    ) +
    
    # Prevent ggplot from slightly expanding the map limits beyond the bounding box of the spatial objects
    coord_sf(expand = FALSE) +
    theme_void() +
    theme(
      # legend.justification defines the edge of the legend that the legend.position coordinates refer to
      legend.justification = c(0, 1),
      # Set the legend flush with the left side of the plot, and just slightly below the top of the plot
      legend.position = c(legend_position.x, legend_position.y) #c(0.93, 1.23)
    ) +
    theme(
      plot.background = element_rect(fill = "white", colour = "white"),
      plot.title = element_text(family = "Arial", size = title_size, face = "bold", #size 25
                                margin = margin(b = 50), hjust = -0.2),
      legend.title = element_text(family = "Arial", size = legend_title_size, face = legend_face),
      legend.text = element_text(family = "Arial", size = legend_text_size),
      #plot.subtitle = element_text(family = "Arial", size = subtitle_size),
      #plot.caption = element_text(family = "Arial", vjust = -1, hjust = 1, face = "italic"),
      plot.margin = unit(c(t = 2, r = 5.5, b = 2.5, l = 5.5), "cm") # testing different margins
    )
  
  ## Alaska ----
  ak.map <- all.geo.data %>%
    filter(group == "AK") %>% 
    st_transform(3338) %>%
    ggplot() +
    geom_sf( 
      aes(fill = get(fill_var)), 
      linewidth = fill_linewidth, 
      colour = fill_linecolor
    ) +
    scale_fill_manual(values = fill_color,
                      na.value = "grey80",
                      name = legend_name) +
    geom_sf(
      data = all.geo.data[all.geo.data$group == "AK" & all.geo.data$GEOID %in% border_ids, ],
      fill = NA,
      colour = border_color, 
      linewidth = border_linewidth
    ) +
    
    ## AK State Border ---
    geom_sf(
      data = all.geo.state[all.geo.state$group == "AK", ],
      fill = NA,
      colour = state_color, 
      linewidth = state_linewidth
    ) +
    
    # Prevent ggplot from slightly expanding the map limits beyond the bounding box of the spatial objects
    coord_sf(expand = FALSE) +
    theme_void() +
    theme(
      # legend.justification defines the edge of the legend that the legend.position coordinates refer to
      legend.justification = c(0, 1),
      # Set the legend flush with the left side of the plot, and just slightly below the top of the plot
      legend.position = "none"
    ) +
    theme(
      text = element_text(family = "Arial")
    )
  
  ## Hawaii ----
  hi.map <- all.geo.data %>%
    filter(group == "HI") %>%
    ggplot() +
    geom_sf( 
      aes(fill = get(fill_var)), 
      linewidth = fill_linewidth, 
      colour = fill_linecolor
    ) +
    scale_fill_manual(values = fill_color,
                      na.value = "grey80",
                      name = legend_name) +
    geom_sf(
      data = all.geo.data[all.geo.data$group == "HI" & all.geo.data$GEOID %in% border_ids, ],
      fill = NA,
      colour = border_color, 
      linewidth = border_linewidth
    ) +
    
    ## HI State Border ---
    geom_sf(
      data = all.geo.state[all.geo.state$group == "HI", ],
      fill = NA,
      colour = state_color, 
      linewidth = state_linewidth
    ) +
    
    # Prevent ggplot from slightly expanding the map limits beyond the bounding box of the spatial objects
    coord_sf(expand = FALSE) +
    theme_void() +
    theme(
      # legend.justification defines the edge of the legend that the legend.position coordinates refer to
      legend.justification = c(0, 1),
      # Set the legend flush with the left side of the plot, and just slightly below the top of the plot
      legend.position = "none"
    ) +
    theme(
      text = element_text(family = "Arial")
    )
  
  ## Guam ----
  gu.map <- all.geo.data %>%
    filter(group == "GU") %>%
    ggplot() +
    geom_sf( 
      aes(fill = get(fill_var)),
      linewidth = fill_linewidth, 
      colour = fill_linecolor
    ) +
    scale_fill_manual(values = fill_color,
                      na.value = "grey80",
                      name = legend_name) +
    geom_sf(
      data = all.geo.data[all.geo.data$group == "GU" & all.geo.data$GEOID %in% border_ids, ],
      fill = NA,
      colour = border_color, 
      linewidth = border_linewidth
    ) +
    
    ## GU Border ---
    geom_sf(
      data = all.geo.state[all.geo.state$group == "GU", ],
      fill = NA,
      colour = state_color, 
      linewidth = state_linewidth
    ) +
    
    # Prevent ggplot from slightly expanding the map limits beyond the bounding box of the spatial objects
    coord_sf(expand = FALSE) +
    theme_void() +
    theme(
      # legend.justification defines the edge of the legend that the legend.position coordinates refer to
      legend.justification = c(0, 1),
      # Set the legend flush with the left side of the plot, and just slightly below the top of the plot
      legend.position = "none"
    ) +
    theme(
      text = element_text(family = "Arial")
    )
  
  ## American Samoa ----
  as.map <- all.geo.data %>%
    filter(group == "AS") %>% 
    ggplot() +
    geom_sf( 
      aes(fill = get(fill_var)), 
      linewidth = fill_linewidth, 
      colour = fill_linecolor
    ) +
    scale_fill_manual(values = fill_color,
                      na.value = "grey80",
                      name = legend_name) +
    geom_sf(
      data = all.geo.data[all.geo.data$group == "AS" & all.geo.data$GEOID %in% border_ids, ],
      fill = NA,
      colour = border_color, 
      linewidth = border_linewidth
    ) +
    
    ## AS Border ---
    geom_sf(
      data = all.geo.state[all.geo.state$group == "AS", ],
      fill = NA,
      colour = state_color, 
      linewidth = state_linewidth
    ) +
    
    # Prevent ggplot from slightly expanding the map limits beyond the bounding box of the spatial objects
    coord_sf(expand = FALSE) +
    theme_void() +
    theme(
      # legend.justification defines the edge of the legend that the legend.position coordinates refer to
      legend.justification = c(0, 1),
      # Set the legend flush with the left side of the plot, and just slightly below the top of the plot
      legend.position = "none"
    ) +
    theme(
      text = element_text(family = "Arial")
    ) 
  
  ## Northern Mariana Islands ----
  nmi.map <- all.geo.data %>%
    filter(group == "MP") %>% 
    ggplot() +
    geom_sf( 
      aes(fill = get(fill_var)),
      linewidth = fill_linewidth, 
      colour = fill_linecolor
    ) +
    scale_fill_manual(values = fill_color,
                      na.value = "grey80",
                      name = legend_name) +
    geom_sf(
      data = all.geo.data[all.geo.data$group == "MP" & all.geo.data$GEOID %in% border_ids, ],
      fill = NA,
      colour = border_color, 
      linewidth = border_linewidth
    ) +
    
    ## MP Border ---
    geom_sf(
      data = all.geo.state[all.geo.state$group == "MP", ],
      fill = NA,
      colour = state_color, 
      linewidth = state_linewidth
    ) +
    
    # Prevent ggplot from slightly expanding the map limits beyond the bounding box of the spatial objects
    coord_sf(expand = FALSE) +
    theme_void() +
    theme(
      # legend.justification defines the edge of the legend that the legend.position coordinates refer to
      legend.justification = c(0, 1),
      # Set the legend flush with the left side of the plot, and just slightly below the top of the plot
      legend.position = "none"
    ) +
    theme(
      text = element_text(family = "Arial")
    ) 
  
  ## PR ----
  pr.map <- all.geo.data %>%
    filter(group == "PR") %>% 
    ggplot() +
    geom_sf( 
      aes(fill = get(fill_var)),
      linewidth = fill_linewidth, 
      colour = fill_linecolor
    ) +
    scale_fill_manual(values = fill_color,
                      na.value = "grey80",
                      name = legend_name) +
    geom_sf(
      data = all.geo.data[all.geo.data$group == "PR" & all.geo.data$GEOID %in% border_ids, ],
      fill = NA,
      colour = border_color, 
      linewidth = border_linewidth
    ) +
    
    ## PR Border ---
    geom_sf(
      data = all.geo.state[all.geo.state$group == "PR", ],
      fill = NA,
      colour = state_color, 
      linewidth = state_linewidth
    ) +
    
    # Prevent ggplot from slightly expanding the map limits beyond the bounding box of the spatial objects
    coord_sf(expand = FALSE) +
    theme_void() +
    theme(
      # legend.justification defines the edge of the legend that the legend.position coordinates refer to
      legend.justification = c(0, 1),
      # Set the legend flush with the left side of the plot, and just slightly below the top of the plot
      legend.position = "none"
    ) +
    theme(
      text = element_text(family = "Arial")
    )
  
  ## VI ----
  VI.sttstj.map <- all.geo.data %>%
    filter(group == "VI.stt_stj") %>%
    ggplot() +
    geom_sf( 
      aes(fill = get(fill_var)), 
      linewidth = fill_linewidth, 
      colour = fill_linecolor
    ) +
    scale_fill_manual(values = fill_color,
                      na.value = "grey80",
                      name = legend_name) +
    geom_sf(
      data = all.geo.data[all.geo.data$group == "VI.stt_stj" & all.geo.data$GEOID %in% border_ids, ],
      fill = NA,
      colour = border_color, 
      linewidth = border_linewidth
    ) +
    ## VI stt stj Border ---
    geom_sf(
      data = all.geo.state[all.geo.state$group == "VI.stt_stj", ],
      fill = NA,
      colour = state_color, 
      linewidth = state_linewidth
    ) +
    
    # Prevent ggplot from slightly expanding the map limits beyond the bounding box of the spatial objects
    coord_sf(expand = FALSE) +
    theme_void() +
    theme(
      # legend.justification defines the edge of the legend that the legend.position coordinates refer to
      legend.justification = c(0, 1),
      # Set the legend flush with the left side of the plot, and just slightly below the top of the plot
      legend.position = "none"
    ) +
    theme(
      text = element_text(family = "Arial")
    )
  
  VI.stx.map <- all.geo.data %>%
    filter(group == "VI.stx") %>%
    ggplot() +
    geom_sf( 
      aes(fill = get(fill_var)), 
      linewidth = fill_linewidth, 
      colour = fill_linecolor
    ) +
    scale_fill_manual(values = fill_color,
                      na.value = "grey80",
                      name = legend_name) +
    geom_sf(
      data = all.geo.data[all.geo.data$group == "VI.stx" & all.geo.data$GEOID %in% border_ids, ],
      fill = NA,
      colour = border_color, 
      linewidth = border_linewidth
    ) +
    ## VI stx Border ---
    geom_sf(
      data = all.geo.state[all.geo.state$group == "VI.stx", ],
      fill = NA,
      colour = state_color, 
      linewidth = state_linewidth
    ) +
    
    # Prevent ggplot from slightly expanding the map limits beyond the bounding box of the spatial objects
    coord_sf(expand = FALSE) +
    theme_void() +
    theme(
      # legend.justification defines the edge of the legend that the legend.position coordinates refer to
      legend.justification = c(0, 1),
      # Set the legend flush with the left side of the plot, and just slightly below the top of the plot
      legend.position = "none"
    ) +
    theme(
      text = element_text(family = "Arial")
    )
  
  # add square for USVI ----
  rect <- rectGrob(
    x = unit(12.73, "in"),
    #y = unit(1, "npc") - unit(1, "in"),
    y = unit(1.6, "in"),
    width = unit(1.6, "in"),
    height = unit(1.25, "in"),
    hjust = 0, vjust = 1,
    gp = gpar(col = inset_box_color, fill = "transparent")
  )
  
  # Final Map ----
  plot <-  ggdraw(main.map) +
    # territory labels ----
    draw_label("MP", x = 0.12, y = 0.24, fontface = "bold", color = territory_label_color) +
    draw_label("GU", x = 0.175, y = 0.24, fontface = "bold", color = territory_label_color) + 
    draw_label("AS", x = 0.52, y = 0.034, fontface = "bold", color = territory_label_color) +
    draw_label("VI", x = 0.893, y = 0.05, fontface = "bold", color = territory_label_color) +
    draw_label("PR", x = 0.89, y = 0.2, fontface = "bold", color = territory_label_color) +
    draw_label(caption, x = 0.54, y = 0.005, hjust = 0, vjust = 0,
               size = caption_size, fontface = "italic", color = "black") +
    # Adding AK
    draw_plot(
      {
        ak.map +
          theme(legend.position = "none",
                plot.background = element_rect(color = inset_box_color, linewidth = 0.7), # if you want a border
                plot.margin = unit(c(t = 0.5, r = 0.5, b = 0.5, l = 0.5), "cm")) # testing different margins)
      },
      # The distance along a (0,1) x-axis to draw the left edge of the plot
      x = 0.05, 
      # The distance along a (0,1) y-axis to draw the bottom edge of the plot
      y = 0.02,
      # The width and height of the plot expressed as proportion of the entire ggdraw object
      width = 0.2, 
      height = 0.2) +
    
    # Adding HI
    draw_plot(
      {
        hi.map +
          theme(legend.position = "none",
                plot.background = element_rect(color = inset_box_color, linewidth = 0.7),
                plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), "cm")) # testing different margins)
      },
      # The distance along a (0,1) x-axis to draw the left edge of the plot
      x = 0.239, 
      # The distance along a (0,1) y-axis to draw the bottom edge of the plot
      y = 0.02,
      # The width and height of the plot expressed as proportion of the entire ggdraw object
      width = 0.15, 
      height = 0.15) +
    
    # Adding GU
    draw_plot(
      {
        gu.map +
          theme(legend.position = "none",
                plot.background = element_rect(color = inset_box_color, linewidth = 0.7), # if you want a border
                plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), "cm")) # testing different margins)
      },
      # The distance along a (0,1) x-axis to draw the left edge of the plot
      x = 0.111, 
      # The distance along a (0,1) y-axis to draw the bottom edge of the plot
      y = 0.23,
      # The width and height of the plot expressed as proportion of the entire ggdraw object
      width = 0.1, 
      height = 0.1) +
    
    # Adding AS
    draw_plot(
      {
        as.map +
          theme(legend.position = "none",
                plot.background = element_rect(color = inset_box_color, linewidth = 0.7), # if you want a border
                plot.margin = unit(c(0.4, 0.4, 0.4, 0.4), "cm")) # testing different margins)
      },
      # The distance along a (0,1) x-axis to draw the left edge of the plot
      x = 0.381, 
      # The distance along a (0,1) y-axis to draw the bottom edge of the plot
      y = -0.0199,
      # The width and height of the plot expressed as proportion of the entire ggdraw object
      width = 0.15, 
      height = 0.15) +
    
    # Adding NMI
    draw_plot(
      {
        nmi.map +
          theme(legend.position = "none",
                plot.background = element_rect(color = inset_box_color, linewidth = 0.7), # if you want a border
                plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), "cm")) # testing different margins)
      },
      # The distance along a (0,1) x-axis to draw the left edge of the plot
      x = -0.008, 
      # The distance along a (0,1) y-axis to draw the bottom edge of the plot
      y = 0.23,
      # The width and height of the plot expressed as proportion of the entire ggdraw object
      width = 0.2, 
      height = 0.2) +
    
    
    # Adding PR
    draw_plot(
      {
        pr.map +
          theme(legend.position = "none",
                plot.background = element_rect(color = inset_box_color, linewidth = 0.7),
                plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), "cm")) # testing different margins)
      },
      # The distance along a (0,1) x-axis to draw the left edge of the plot
      x = 0.8, 
      # The distance along a (0,1) y-axis to draw the bottom edge of the plot
      y = 0.175,
      # The width and height of the plot expressed as proportion of the entire ggdraw object
      width = 0.1, 
      height = 0.1) +
    
    # Adding VI (STT & STJ)
    draw_plot(
      {
        VI.sttstj.map +
          theme(legend.position = "none",
                plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), "cm")) # testing different margins)
      },
      # The distance along a (0,1) x-axis to draw the left edge of the plot
      x = 0.8, 
      # The distance along a (0,1) y-axis to draw the bottom edge of the plot
      y = 0.08,
      # The width and height of the plot expressed as proportion of the entire ggdraw object
      width = 0.1, 
      height = 0.1) +
    
    draw_plot(
      {
        VI.stx.map +
          theme(legend.position = "none",
                plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), "cm")) # testing different margins)
      },
      # The distance along a (0,1) x-axis to draw the left edge of the plot
      x = 0.8, 
      # The distance along a (0,1) y-axis to draw the bottom edge of the plot
      y = 0.02,
      # The width and height of the plot expressed as proportion of the entire ggdraw object
      width = 0.1, 
      height = 0.1) +
    
    draw_grob(rect) 
  
  save_plot(filename = save.filepath,
            plot = plot,
            base_width = 15.91, # in
            base_height = 9.1951 #
  )
}
