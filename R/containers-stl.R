choose_data <- function (..., data) {
  args <- list(...)
  if (length(args)) {
    if (length(data)) stop("both ... and data provided when constructing a container")
    return(args)
  }
  data
}


#' STL-like containers.
#'
#' @param ... Elements for the container, named for `map`.
#' @param data Alternative way to specify elements.
#'
#' @importFrom proto proto
#'
#' @export
#' @rdname containers
new_vector <- function (..., data = list()) {
  data <- choose_data(..., data = data)
  proto(expr = {
    values    <- data
    push_back <- function (., value) { .$values <- c(.$values, list(value)) }
    pop_front <- function (.) { ans <- first(.$values); .$values <- .$values[-1]; ans }
    erase     <- function (., value) { .$values <- Filter(function(x)!identical(x,value), .$values) }
    find      <- function (., value) as.logical(match(value, .$values, 0L, 0L))
    size      <- function (.) length(.$values)
    data      <- function (.) .$values
  })
}

#' @importFrom proto proto
#'
#' @export
#' @rdname containers
new_map <- function (..., data = list()) {
  data <- choose_data(..., data = data)
  stopifnot(is_all_named(data))

  proto(expr = {
    values <- data
    assign <- function (., key, value) { .$values[[key]] <- value }
    erase  <- function (., key) { .$values[[key]] <- NULL }
    data   <- function (., key = NULL) if (is.null(key)) .$values else .$values[[key]]
    at     <- function (., key, default = NULL) {
      if (is.null(.$values[[key]])) {
        if (is.null(default)) stop(paste0("key '", toString(key), "' not found in map"))
        .$values[[key]] <- default
      }
      .$values[[key]]
    }
  })
}


#' @importFrom proto proto
#'
#' @export
#' @rdname containers
new_set <- function (..., data = list()) {
  data <- choose_data(..., data = data)

  proto(expr = {
    values <- unique(data)
    insert <- function (., values) {
      lapply(values, function (value) {
        if (value %nin% .$values) .$values <- append(.$values, value)
      })
    }
    data   <- function (.) .$values
    size   <- function (.) length(.$values)
    contains <- function (., value) (value %in% .$values)
    remove   <- function (., value) {
      i <- match(value, .$values, nomatch = 0L)
      if (!identical(i, 0L)) {
        .$values <- .$values[-i]
      }
    }
    pop_front <- function (.) {
      if (!length(.$values)) return()
      ans <- .$values[[1]]
      .$values <- .$values[-1]
      return(ans)
    }
  })
}
