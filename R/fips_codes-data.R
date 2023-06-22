#' US FIPS Codes
#' 
#' Data set with 2-letter US postal service state code, FIPS code, and state name for easier
#' identification of 2-letter US postal service code.
#' 
#' @docType data
#' 
#' @usage data(fips_codes)
#' 
#' @format A data frame with 57 observations (50 US States, D.C., 5 territories, and minor outlying islands) and 3 variables:
#' \describe{
#'     \item{state}{2-letter US Postal Service Code}
#'     \item{state_code}{FIPS code}
#'     \item{state_name}{Full state name} 
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
#' data(fips_codes)
#' head(fips_codes$state)
"fips_codes"