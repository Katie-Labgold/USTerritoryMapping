# USTerritoryMapping

Something I hear a lot as an applied territorial epidemiologist is that the territories are excluded from national maps due to the trickiness of inset mapping. Thus, the goal of this R package is to make it easier to plot US maps that include the US territories, specifically American Samoa, Guam, Northern Mariana Islands, Puerto Rico, and the US Virgin Islands.

Initial release includes two functions for choropleth mapping a categorical variable at the state and territory level. `map1_categorical()` allows for mapping of territory geometries, while `map2_categorical()` allows for mapping of territory labels.

Code used to develop the package is also provided, allowing folks to refine the code to their own specific needs as interested.

Any feedback is welcome. Happy mapping!

# Installation
```
devtools::install_github("Katie-Labgold/USTerritoryMapping")
```
