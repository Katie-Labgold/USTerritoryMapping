#' CDC Cardiovascular Mortality Rate Data for 50 US States and D.C.
#' 
#' Data from CDC Wonder Chronic Disease Indicators Cardiovascular Disease.
#' Specifically, 2020 age-adjusted mortality rate from total cardiovascular disease per 100,000.
#' 
#' @docType data
#' 
#' @usage data(cdc.cvd)
#' 
#' @format A data frame with 51 observations (50 US States & D.C.) and 12 variables:
#' \describe{
#'     \item{LocationAbbr}{2-letter US Postal Service Code}
#'     \item{data.cat}{the CVD mortality rate per 100,000 persons, categorized as a factor} 
#' 
#' }
#' 
#' @keywords datasets
#' 
#' @references Centers for Disease Control and Prevention, National Center for Chronic Disease Prevention and Health Promotion, Division of Population Health. Chronic Disease Indicators (CDI) Data [online]. [accessed Jun 22, 2023]. URL: https://nccd.cdc.gov/cdi.
#' 
#' @source \href{https://nccd.cdc.gov/cdi/rdPage.aspx?rdReport=DPH_CDI.ExploreByTopic&islTopic=CVD&islYear=9999&go=GO}{CDC Wonder}
#' 
#' @examples
#' data(cdc.cvd)
#' class(cdc.cvd$data.cat)
#' table(cdc.cvd$data.cat)
#' head(cdc.cvd$LocationAbbr)
"cdc.cvd"