#' @importFrom jsonlite fromJSON
#' @importFrom magrittr %>%
NULL

#' Pipe operator for chaining together operations.
#'
#' Imported from magrittr, use this to chain together
#' operations in a natural way.
#'
#' @examples
#' \dontrun{
#' # instead of
#' a(b(c("hello")), "bob")
#'
#' # we can write:
#'
#' c("hello") \%>\% b() \%>\% a("bob")
#'
#' # this also allows for currying common arguments:
#'
#' my_query <- facility("recalls") %>%
#'               model_year("2010") %>%
#'               vehicle_make("ford") %>%
#'               vehicle_model("f-150") %>%
#'               nhtsa_fetch()
#' }
#'
#' @aliases chain_query
#' @rdname chain_query
#' @name %>%
#' @export
NULL

api_url <- function()  { "http://www.nhtsa.gov/webapi/api" }

#' @title Choose the NHTSA facility
#'
#' @return data.frame
#' @export
facility <- function(q) {
  if(q == "complaints") {
    suffix <- "/Complaints/vehicle"
  } else if (q == "recalls") {
    suffix <- "/Recalls/vehicle"
  }

  paste0(api_url(), suffix)
}

#' @title Choose a model year
#'
#' @return data.frame
#' @export
model_year <- function(q, year) {
  paste0(q, "/modelyear/", year)
}

#' @title Choose a car make (e.g. ford)
#'
#' @return data.frame
#' @export
vehicle_make <- function(q, make) {
  paste0(q, "/make/", gsub(" ", "%20", make))
}

#' @title Choose a car model (e.g. fusion)
#'
#' @return data.frame
#' @export
vehicle_model <- function(q, model) {
  paste0(q, "/model/", gsub(" ", "%20", model))
}

response_format <- function(q, type = "json")  {
  paste0("format=", type)
}

#' Fetch the given URL as JSON.
#'
#' This uses jsonlite to fetch the URL.  The result is coerced into
#' a data frame.
#'
#' @return data.frame
#' @export
nhtsa_fetch <- function(url, debug=FALSE) {
  # This function is verbatim copied from:
  # https://github.com/rOpenHealth/openfda/blob/master/R/openfda.R

  if (debug == TRUE) {
    cat("Fetching:", url, "\n")
  }

  result = httr::GET(url)
  # The API servers return 404 for empty search results, so
  # distinguish that case from 'real' errors.
  if (result$status_code == 404) {
    warning('Received 404 response from NHTSA servers.\n',
            'Interpreting as an empty result set.')
    return(data.frame(results=c()));
  }

  httr::stop_for_status(result)

  fromJSON(httr::content(result, as='text'))$Results
}

#' openNHTSA: A package for interfacing with the U.S. Department of Transportation's National Highway Traffic Safety Administration API
#'
#' This package provides a simple wrapper around the NHTSA API (http://www.nhtsa.gov/webapi/Default.aspx?Recalls/API/83).
#' Credit for the design and architecture of the wrapper should go to the authors of the openfda wrapper housed here: https://github.com/rOpenHealth/openfda/
#' Many parts of this wrapper are direct copies of their work and hence this package is released under license GPL v2.
#'
#' It uses the \code{magrittr} piping interface to simplify
#' building complex queries.
#'
#' @examples
#' # Queries generally have the following format
#' \dontrun{
#' facility("recalls") %>%
#'   model_year("2010") %>%
#'   vehicle_make("ford") %>%
#'   vehicle_model("fusion") %>%
#'   nhtsa_fetch()
#'
#' facility("complaints") %>%
#'   model_year("2010") %>%
#'   vehicle_make("ford") %>%
#'   vehicle_model("fusion") %>%
#'   nhtsa_fetch()
#' }
#'
#' @docType package
#' @name openNHTSA
NULL
