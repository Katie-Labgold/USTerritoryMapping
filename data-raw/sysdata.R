# Code to create sysdata.rda 
# https://r-pkgs.org/data.html#sec-data-sysdata


all.geo.co_2010 <- all.geo.co_2010 %>% 
                    dplyr::select(names(all.geo.co_2020)) %>%
                    mutate(year = "2010")

all.geo.co_2020 <- all.geo.co_2020 %>%
                      mutate(year = "2020")


all.geo.co <- all.geo.co_2010 %>%
                rbind(all.geo.co_2020)

usethis::use_data(all.geo, all.geo.co, internal = TRUE, overwrite = TRUE)
