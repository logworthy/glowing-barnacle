#' This file contains functions for
#' setting up and managing the database environment
#'

# options
DB_ENV_NAME <- 'database_environment'
DB_AUTOIMPORT_NAME <- 'database_autoimport'
DB_AUTOSAVE_NAME <- 'database_autosave'
DB_AUTOSAVEPWD_NAME <- 'database_autosave_pwd'
DB_AUTOCONVERT_NAME <- 'database_autoconvert'
DB_FIRSTRUN <- 'database_firstrun'

# other constants
DB_STORE_NAME <- 'db_store'
DEFAULT_DB_FILE <- normalizePath(file.path('~', '.connections.RDS'), mustWork=F)

#' Remove the current database environment
killDBenv <- function() {
  do.call(options, args=structure(list(NULL), .Names=DB_ENV_NAME))
  invisible(NULL)
}

#' Set up a database environment
makeDBenv <- function() {
  db_env <- new.env(parent=emptyenv())

  # check for existing environments and backup if needed
  old_env <- getOption(DB_ENV_NAME)
  if(!is.null(old_env)) {
    warning(sprintf('old environment found, you can access it with get(\'old_env\', envir=getOption(\'%s\'))', DB_ENV_NAME))
    assign('old_env', old_env, envir=db_env)
  }

  # create an environment to store dbs
  db_store <- new.env(parent=emptyenv())
  assign(DB_STORE_NAME, db_store, envir=db_env)

  # store the db_env in options
  do.call(options, args=structure(list(db_env), .Names=DB_ENV_NAME))

  # dont return anything
  invisible(NULL)
}

#' Internal function to return the package's database environment
getDBenv <- function() {
  old_env <- getOption(DB_ENV_NAME)
  if(is.null(old_env)) {
    makeDBenv()
    old_env <- getOption(DB_ENV_NAME)
  }
  if(!is.environment(old_env)) stop(sprintf('environment is corrupt, try using killDBenv() to clear options(\'%s\')', DB_ENV_NAME))
  old_env
}
