#' Dissimilarity Index
#'
#' @description Calculates an index of dissimilarity value for a given pair of groups.
#'
#' @param .data A tbl
#' @param popA Column name of group A population count per feature
#' @param popB Column name of group B population count per feature
#' @param dissim If \code{return = "tibble"}, this argument is used to provide name of index variable
#' @param return Specifies output. When \code{index}, a single value will be returned.
#'     When \code{tibble}, a table will be returned with dissimilarity values per feature
#'     appended as a column.
#'
#' @return Based on \code{return}, either a single index of dissimilarity value or
#'     a tibble with dissimilarity values per feature.
#'
#' @importFrom dplyr %>%
#' @importFrom dplyr mutate
#' @importFrom dplyr rename
#' @importFrom dplyr select
#' @importFrom dplyr summarize
#' @importFrom rlang :=
#' @importFrom rlang enquo
#' @importFrom rlang quo
#' @importFrom rlang quo_name
#' @importFrom rlang sym
#'
#' @export
ts_dissim <- function(.data, popA, popB, dissim, return = c("index", "tibble")){

  # save parameters to list
  paramList <- as.list(match.call())

  # To prevent NOTE from R CMD check 'no visible binding for global variable'
  popAB_dissim = popA_prop = popB_prop = NULL

  # check for missing parameters
  if (missing(popA)) {
    stop('An existing variable with population count data for group A must be specified for popA')
  }

  if (missing(popB)) {
    stop('An existing variable with population count data for group B must be specified for popB')
  }

  if (missing(return)) {
    stop('An output type must be specified for return')
  }

  if (missing(dissim) & return == "tibble"){
    stop('A new variable name to store dissimilarity values per feature must be specified for dissim')
  }

  # quote input variables
  if (!is.character(paramList$popA)) {
    popAQ <- rlang::enquo(popA)
  } else if (is.character(paramList$popA)) {
    popAQ <- rlang::quo(!! rlang::sym(popA))
  }

  if (!is.character(paramList$popB)) {
    popBQ <- rlang::enquo(popB)
  } else if (is.character(paramList$popB)) {
    popBQ <- rlang::quo(!! rlang::sym(popB))
  }

  if (!missing(dissim)){
    dissimQ <- rlang::quo_name(rlang::enquo(dissim))
  }

  # calculate proportions
  .data %>%
    dplyr::mutate(popA_prop = !!popAQ/sum(!!popAQ)) %>%
    dplyr::mutate(popB_prop = !!popBQ/sum(!!popBQ)) %>%
    dplyr::mutate(popAB_dissim = popA_prop-popB_prop) %>%
    dplyr::select(-popA_prop, -popB_prop) -> props

  # calculate final output

  if (return == "index"){

    props %>%
      dplyr::summarise(dissim = .5*(sum(abs(popAB_dissim)))) -> value

    out <- value$dissim[1]

  } else if (return == "tibble"){

    props %>%
      dplyr::rename(!!dissimQ := popAB_dissim) -> out

  }

  # return ouput
  return(out)

}
