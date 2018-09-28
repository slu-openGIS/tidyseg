#' Entropy Index
#'
#' @param .data A tbl
#' @param id A unique identifier for each feature
#' @param total Column with the total number of individuals per feature
#' @param newVar If \code{return = "tibble"}, this argument is used to provide name of entropy variable
#' @param return Specifies output. When \code{index}, a single value will be returned.
#'     When \code{tibble}, a table will be returned with entropy values per feature
#'     appended as a column.
#' @param ... An quoted list of variable names containing individual group population counts.
#'
#' @export
ts_entropy <- function(.data, id, total, newVar, return = c("index", "tibble"), ...){

  # save parameters to list
  paramList <- as.list(match.call())

  # To prevent NOTE from R CMD check 'no visible binding for global variable'
  . = funs = tp = NULL

  # check for missing parameters
  if (missing(id)) {
    stop('An existing variable with unique identification numbers per feature must be specified for id')
  }

  if (missing(total)) {
    stop('An existing variable with total population count data must be specified for total')
  }

  if (missing(return)) {
    stop('An output type must be specified for return')
  }

  if (missing(newVar) & return == "tibble"){
    stop('A new variable name to store entropy values per feature must be specified for newVar')
  }

  # quote input variables
  if (!is.character(paramList$id)) {
    idQ <- rlang::enquo(id)
  } else if (is.character(paramList$id)) {
    idQ <- rlang::quo(!! rlang::sym(id))
  }

  idQN <- rlang::quo_name(rlang::enquo(id))

  if (!is.character(paramList$total)) {
    totalQ <- rlang::enquo(total)
  } else if (is.character(paramList$total)) {
    totalQ <- rlang::quo(!! rlang::sym(total))
  }

  totalQN <- rlang::quo_name(rlang::enquo(total))

  if (!missing(newVar)){
    if (!is.character(paramList$newVar)) {
      newVarQ <- rlang::enquo(newVar)
    } else if (is.character(paramList$newVar)) {
      newVarQ <- rlang::quo(!! rlang::sym(newVar))
    }

    newVarQN <- rlang::quo_name(rlang::enquo(newVar))
  }

  # store ldots in object
  varList <- unlist(list(...), recursive = TRUE, use.names = TRUE)

  # calculate logged proportions and sum
  .data %>%
    dplyr::mutate_at(.vars = dplyr::vars(varList), .funs = funs(./!!totalQ)) %>%
    dplyr::mutate_at(.vars = dplyr::vars(varList), .funs = funs(.*log(.))) %>%
    dplyr::mutate_at(.vars = dplyr::vars(varList), .funs = funs(ifelse(is.na(.), 0, .))) %>%
    dplyr::mutate(!!newVarQN := -(rowSums(select(., varList)))) -> props

  # calculate final output

  if (return == "index"){

    varListF <- c(totalQN, varList)

    .data %>%
      dplyr::summarise_at(.vars = dplyr::vars(varListF), sum) %>%
      dplyr::mutate_at(.vars = dplyr::vars(varList), .funs = funs(./!!totalQ)) %>%
      dplyr::mutate_at(.vars = dplyr::vars(varList), .funs = funs(.*log(.))) %>%
      dplyr::mutate_at(.vars = dplyr::vars(varList), .funs = funs(ifelse(is.na(.), 0, .))) %>%
      dplyr::mutate(hhat = -(rowSums(select(., varList)))) -> cityProps

    props %>%
      dplyr::mutate(tp = !!totalQ/sum(!!totalQ)) %>%
      dplyr::mutate(wa = tp*!!newVarQ) -> props

    hbar <- sum(props$wa)
    hhat <- cityProps$hhat[1]

    out <- (hhat-hbar)/hhat

  } else if (return == "tibble"){

    props %>%
      dplyr::select(!!idQ, !!newVarQ) -> props

    out <- dplyr::left_join(.data, props, by = idQN)

    if (class(out)[1] == "data.frame"){

      out <- dplyr::as_tibble(out)

    }

  }

  # return output
  return(out)

}


