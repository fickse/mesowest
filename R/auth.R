# Authentication

#' Request an authentication token from mesowest
#'
#' @param apikey string see details
#' @seealso \code{\link{mwtoken}}
#' @return NULL
#' @description Request an authentication token from mesowest and cache locally
#' @details If apikey = 'find' (default), user prompted to interactively select the file containing the apikey. This file should be stored as a simple txt file with one line and no quotes. Otherwise, the function can take the apikey directly as a stirng.
requestToken <- function(apikey='find'){

  if (apikey == 'find') {
    message("select plain txt file containing api-key")
    key <- choose.files()

  } else {

    key <- apikey

  }

  u <- paste0(baseurl(), "auth?&apikey=", key)

  tok <- jsonlite::fromJSON(u)$TOKEN
  cat(tok, file = '~/.mesowesttoken')
  message( 'token cached to ~/.mesowesttoken')
}


#' Get cached mesowest token
#'
#' @seealso \code{\link{requestToken}}
#' @return cached token
#' @description Automatically searches the 'home' directory (~)  for a simple text file called ".mesowest" containing the token.
#'
mwtoken <- function(){

  tf <- '~/.mesowesttoken'

  if(!file.exists(tf)){

    stop( 'could not find file ~/.mesowesttoken ; Please see requestToken()')

  }

  readLines(tf, warn=F)

}
