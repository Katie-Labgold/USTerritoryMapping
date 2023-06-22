#' Percentage of individuals 19 years of age and younger who are uninsured
#' 
#' Data set with Percentage of individuals 19 years of age and younger who are uninsured.
#' State & D.C. data came from 2020 American Community Survey ("B18135_002", "B18135_007", "B18135_012") and territory data came from
#' island area files 2020 Decennial Census ("DP3_0071P"). Note this is not a perfect match, and was created
#' for example purposes.
#' 
#' @docType data
#' 
#' @usage data(census.uninsured19)
#' 
#' @format A data frame with 56 observations (50 US States, D.C., and 5 territories) and 5 variables:
#' \describe{
#'     \item{GEOID}{GEOID}
#'     \item{NAME}{Jurisdiction name}
#'     \item{Percent Ages 19 or Under with No Insurance}{the Percentage Ages 19 or Under with No Health Insurance as a number}
#'     \item{STUSPS}{2-letter US postal service code}
#'     \item{Percent.Cat}{the Percentage Ages 19 or Under with No Health Insurance categorized as a factor} 
#' 
#' }
#' 
#' @keywords datasets
#' 
#' @references Walker K, Herman M (2023). tidycensus: Load US Census Boundary and Attribute Data as 'tidyverse' and 'sf'-Ready Data Frames. R package version 1.4.1, https://walker-data.com/tidycensus/.
#' 
#' @source \href{https://walker-data.com/tidycensus/}{tidycensus package}
#' 
#' @examples
#' data(census.uninsured19)
#' table(census.uninsured19$Percent.Cat)
#' head(census.uninsured19$Percent.Cat)
"census.uninsured19"