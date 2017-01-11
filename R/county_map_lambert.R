#' Dataset with the lat. / long. of county FIPS codes used for mapping county-level data to a Lambert projection
#' To access the data directly, issue the command \code{county_map_lambert}.
#' 
#' @title Dataset for mapping U.S. counties
#' @description A fortified data set that includes U.S. counties and is suitable for making maps with \code{ggplot2}.
#' The county FIPS codes and boundary lines from the most recent TIGER release from the U.S. Census Bureau.
#'
#' \itemize{
#'   \item \code{long}: County longitude
#'   \item \code{lat}: County latitude
#'   \item \code{order}: Polygon order
#'   \item \code{hole}: hole
#'   \item \code{piece}: Polygon piece
#'   \item \code{id}: FIPS Code
#'   \item \code{group}: group
#' }
#'
#' @docType data
#' @keywords datasets
#' 
#' @name county_map_lambert
#' @usage data(county_map_lambert)
#' @note Last updated 2016-05-26
#' @format A data frame with 206,500 rows and 7 variables
"county_map_lambert"