#' This file contains the DB class and core functions
#' Full functions to include:
#' DB$query - run a query and return the results
#' DB$save - run a query and save the results to a file
#' DB$cache - run a query and save the results to a file, but if the file exists just load it
#' DB$con - create an RODBC connection, which can then be used for e.g. sqlQuery

DB_CLASS_NAME <- 'DB'

DB <- setRefClass(
  DB_CLASS_NAME,
  fields=list(
    key='character',
    cstr='character',
    para='character',
    default='character',
    opts='list'
  )
)

dbQuery <- function(query) {

  # create persistent global environment to store credentials
  cred_env <- getOption('database_credentials')
  if(is.null(cred_env)) {
    cred_env <- new.env()
    options(database_credentials=cred_env)
  }

  # create db-specific environment to store credentials
  db_env <- tryCatch({get(key, envir=cred_env)}, error=function(e) {NULL})
  if(is.null(db_env)) {
    db_env <- new.env()
    assign(x = key, value=db_env, envir = cred_env)
  }

  # force alignment of names
  if(is.null(names(default))) {
    names(default) <- para
  }
  if(!identical(names(default), para)) {
    stop('If using named defaults, names must align to para!')
  }

  # ask user for password and store in credentials environment
  para_vals <- sapply(para, function(i) {
    val <- default[i]
    if(is.na(val)) {
      val <- tryCatch({get(i, envir=db_env)}, error=function(e) {NULL})
      if(is.null(val)) {
        val <- .rs.askForPassword(i)
        assign(i, val, envir=db_env)
      }
    }
    val
  }, USE.NAMES = T, simplify = T)

  # create the final connection string
  final_cstr <- do.call(sprintf, args = as.list(c(cstr, para_vals)))

  # connect to db
  conn <-  do.call(RODBC::odbcDriverConnect, args=c(list(final_cstr), opts))

  # execute query
  result <- RODBC::sqlQuery(conn, query)
  if(!is.data.frame(result)) {
    stop(paste('\n',paste(result, collapse='\n')))
  }
  if(data.table:::cedta()) {
    result <- data.table:::data.table(result)
  }

  result

}

suppressWarnings(DB$methods(query=dbQuery))
