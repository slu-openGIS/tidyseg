#' Sample demographic data for St. Louis, Missouri
#'
#' @description A data set containing estimates for total population, number of white residents,
#'     and number of African American residents per census tract in St. Louis, Missouri.
#'
#' @docType data
#'
#' @usage data(stlRace)
#'
#' @format a tibble with 106 rows and 8 variables
#' \describe{
#'    \item{GEOID}{full census tract id number}
#'    \item{NAME}{census tract name, string}
#'    \item{totalPop}{total population count, estimate}
#'    \item{totalPop_m}{total population count, margin of error}
#'    \item{white}{white population count, estimate}
#'    \item{white_m}{white population count, margin of error}
#'    \item{black}{black population count, estimate}
#'    \item{black_m}{black population count, margin of error}
#' }
#'
#' @source \code{tidycensus}
#'
#' @examples
#' str(stlRace)
#' head(stlRace)
#'
"stlRace"
