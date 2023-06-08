#' Categorical choropleth US map with territory geometries
#' 
#' This function allows for choropleth mapping of a predefined categorical variable
#' for territory geometries. See `map2_categorical()` for choropleth mapping of 
#' territory labels.
#' 
#' @param data Data frame that already includes the fill variable as a factor. See example code/vignette for more detail.
#' @param join_var Variable to join with two letter state/territory USPS code (e.g. VI for Virgin Islands).
#' @param fill_var Categorical mapping variable entered as "variable".
#' @param fill_color Values for `scale_fill_manual()`. Recommended to prepare with labels, see example.
#' @param fill_linewidth State and territory geometry border line width. Default linewidth = 0.8.
#' @param fill_linecolor State and territory geometry border line color. Default color = "black".
#' @param legend_name Legend title entered as a string.
#' @param inset_box_color Color of inset box for HI, AK, and territories. Set as "white" to remove border.
#' @param title Figure title entered as a string.
#' @param border_ids List of state and territory two letter USPS codes for option to outline specific states and territories.
#' @param border_color Color of optional state highlight border.
#' @param border_linewidth Linewidth of optional state highlight border. Default linewidth = 1.
#' @param save.filepath File path for saving plot as "path/image.png".  
#' @export
#' @examples 
#' # Example 1 Using Census Insurance Data
#' colors.census <- c("Less than 5%" = "#feebe2", 
#'                    "5% to <10%" = "#f768a1", 
#'                    "10% or Greater" = "#7a0177")
#'
#' border <- c("OR", "WI", "VA", "VI")
#'
#' map1_categorical(data = census, 
#'                 join_var = "STUSPS", 
#'                 fill_var = "Percent.Cat", 
#'                 fill_color = colors.census, 
#'                 legend_name = "Percent Uninsured",
#'                 title = "Figure 1. Percent Uninsured, Ages <19 Years",
#'                 border_ids = border,
#'                 border_color = "red",
#'                 border_linewidth = 1,
#'                 save.filepath = "saved_maps/map1-test.png")
#'
#' # Example 2 Using CDC Cardiovascular Data 
#' colors.cdc <- c("Q1 (166 to < 198)" = "#ffffcc",
#'                 "Q2 (198 to < 215)" = "#a1dab4",
#'                 "Q3 (215 to < 248)" = "#41b6c4",
#'                 "Q4 (248 to 326)" = "#225ea8")
#'
#'map1_categorical(data = cdc.cvd, 
#'                 join_var = "LocationAbbr",
#'                 fill_var = "data.cat", 
#'                 fill_color = colors.cdc, 
#'                 fill_linewidth = 1.2,
#'                 fill_linecolor = "darkgrey",
#'                 inset_box_color = "white",
#'                 legend_name = "CVD per 100,000",
#'                 border_ids = border,
#'                 border_color = "red",
#'                 border_linewidth = 1.5,
#'                 save.filepath = "saved_maps/cdc-map1-test.png")                


map1_categorical <- function(data, join_var, fill_var, fill_color, fill_linewidth = 0.8, fill_linecolor = "black",
                             legend_name = NULL, inset_box_color = "black",
                             title = "",
                             border_ids = NULL, border_color = NULL, border_linewidth = 1,
                             save.filepath){
  
  all.geo.data <- all.geo %>%
    left_join(data, by = c("STUSPS" = join_var))
  
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
                      name = legend_name) +
    
    labs(title = title,
         #caption = "Caption"
    ) +
    
    geom_sf(
      data = all.geo.census[all.geo.data$group == "mainland" & all.geo.data$STUSPS %in% border_ids, ],
      fill = NA,
      colour = border_color, 
      linewidth = border_linewidth
    ) +
    
    # Prevent ggplot from slightly expanding the map limits beyond the bounding box of the spatial objects
    coord_sf(expand = FALSE) +
    theme_void() +
    theme(
      # legend.justification defines the edge of the legend that the legend.position coordinates refer to
      legend.justification = c(0, 1),
      # Set the legend flush with the left side of the plot, and just slightly below the top of the plot
      legend.position = c(0.97, 1.15)
    ) +
    theme(
      plot.background = element_rect(fill = "white", colour = "white"),
      plot.title = element_text(family = "Arial", size = 25, face = "bold", 
                                margin = margin(b = 50), hjust = -0.2),
      legend.title = element_text(family = "Arial", size = 16),
      legend.text = element_text(family = "Arial", size = 14),
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
      data = all.geo.census[all.geo.data$group == "AK" & all.geo.data$STUSPS %in% border_ids, ],
      fill = NA,
      colour = border_color, 
      linewidth = border_linewidth
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
      data = all.geo.census[all.geo.data$group == "HI" & all.geo.data$STUSPS %in% border_ids, ],
      fill = NA,
      colour = border_color, 
      linewidth = border_linewidth
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
      data = all.geo.census[all.geo.data$group == "GU" & all.geo.data$STUSPS %in% border_ids, ],
      fill = NA,
      colour = border_color, 
      linewidth = border_linewidth
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
      data = all.geo.census[all.geo.data$group == "AS" & all.geo.data$STUSPS %in% border_ids, ],
      fill = NA,
      colour = border_color, 
      linewidth = border_linewidth
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
      data = all.geo.census[all.geo.data$group == "MP" & all.geo.data$STUSPS %in% border_ids, ],
      fill = NA,
      colour = border_color, 
      linewidth = border_linewidth
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
      data = all.geo.census[all.geo.data$group == "PR" & all.geo.data$STUSPS %in% border_ids, ],
      fill = NA,
      colour = border_color, 
      linewidth = border_linewidth
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
      data = all.geo.census[all.geo.data$group == "VI.stt_stj" & all.geo.data$STUSPS %in% border_ids, ],
      fill = NA,
      colour = border_color, 
      linewidth = border_linewidth
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
      data = all.geo.census[all.geo.data$group == "VI.stx" & all.geo.data$STUSPS %in% border_ids, ],
      fill = NA,
      colour = border_color, 
      linewidth = border_linewidth
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
  
  plot
  
  save_plot(filename = save.filepath,
            plot = plot,
            base_width = 15.91, # in
            base_height = 9.1951 #
  )
}
