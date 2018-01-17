# Mesowest api functions

library(jsonlite)

#todo: generate a token based on cached api key
#token <- "bcdf362f83a74218a89c32733dfcac32"

# base url
baseurl <- function() "http://api.mesowest.net/v2/"


#' Retrieve List of Station Variables
#' @return nested list of potential station variables
#' @example mwvariables()
mwvariables <- function(){
  url = paste0(baseurl(), 'variables?&token=', mwtoken(), '&output=json')
  fromJSON(url, simplifyVector = F)
}


#' Retrieve List of API parameters
#' @param service character corresponding to API service (e.g. 'timeseries', 'network', etc)
#' @return data.frame of paramters and descriptions
#' @example mwparams()
getparams <- function(service = '') {

  data(mwparams)

  if( !service == ''){

    if (service %in% c( 'metadata', 'climatology', 'precipitation', 'statistics', 'timeseries', 'nearesttime', 'latency', 'latest')){

      mwparams <- mwparams[which(mwparams$service %in% c('station', service)),]

    } else {
      mwparams <- mwparams[which(mwparams$service == service),]
    }
    View(mwparams)
  }


  mwparams

}



#' Retrieve Data from mesowest
#'
#' @param service character representing api service (e.g. 'metadata', 'timeseries')
#' @param jsonsimplify Should json results be compacted to a data.frame if possible (default = TRUE)
#' @param ... parameters in the mesowest api corresponding to service (https://synopticlabs.org/api/explore/)
#' @return List of data from JSON response
#' @details If a request with nested lists (eg. climate variables per station) is made, the station metadata will be an awkward dataframe. It is suggested in this case to use jsonsimplify=FALSE.
#' @examples
#' # Station metadata is a data.frame
#' mw( 'metadata', complete=1, stid=c('COOPTEEA3','mtmet'))
#' # Station metadata is a list
#' mw( 'metadata', complete=1,sensorvars=1, stid=c('COOPTEEA3','mtmet'))
mw <- function(service, jsonsimplify=TRUE, ...){

  args <- list(...)
  pp <- getparams()
  params <- pp$parameter[which(pp$service == service)]

  if (service %in% c( 'metadata', 'climatology', 'precipitation', 'statistics', 'nearesttime', 'latency', 'latest', 'timeseries')){

    service <- paste0('stations/',service)
    params <- c(params, pp$parameter[which(pp$service == 'station')])

  }

  url <- paste0(baseurl(), service,'?&token=', mwtoken())

  for (argname in names(args)){

    if (argname %in% params){
      # ugly results if simplify = TRUE
      text = paste(args[[argname]], collapse = ',')
      url <- paste0( url , '&', argname, '=', text)}
    else {
      stop ( "Api parameter ", argname, " not found. see https://synopticlabs.org/api/explore/")

    }
  }
  return (fromJSON(url, simplifyVector = jsonsimplify))

}


