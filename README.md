# USTerritoryMapping

Something I hear a lot as an applied territorial epidemiologist is that the territories are excluded from national maps due to the trickiness of inset mapping. Thus, the goal of this R package is to make it easier to plot US maps that include the US territories, specifically American Samoa, Guam, Northern Mariana Islands, Puerto Rico, and the US Virgin Islands.

This release includes three functions for choropleth mapping a categorical variable. For state and territory-level maps: `map1_categorical()` allows for mapping of territory geometries, while `map2_categorical()` allows for mapping of territory labels. For county and county equivalent-level maps: `map1_categorical_county()` allows for 2010 & 2020 county mapping of territory geometries. 

[Vignette](http://htmlpreview.github.io/?https://github.com/Katie-Labgold/USTerritoryMapping/blob/main/doc/introduction.html)

Any feedback is welcome. Happy mapping!

![](man/figures/logov2.png)

Thank you to Liz Lamere and Dr. Musheng Alishahi for their feedback in developing and testing this package.

# Installation
```
#install.packages("devtools")
library(devtools)
devtools::install_github("Katie-Labgold/USTerritoryMapping")
```
