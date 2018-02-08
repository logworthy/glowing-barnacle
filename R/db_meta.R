#' This file contains non-class DB functions

#' @include db_class.R
#' @include environment.R
NULL

# IMPLEMENTED
# getDB(dbid) - get a DB instance
# rmDB(dbid) - delete a DB
# existsDB(dbid) - check if DB exists
# registerDB(DB) - save DB to DB environment
# newDB - create a new DB
# listDB() - list all available DBs

# NOT IMPLEMENTED
# importDB - load one or more DBs from a file
# exportDB - save one or more DBs to a file
# showDB(DB or dbid) - provide detail about a DB

# show all dbs
listDB <- function() {
  db_store <- get(DB_STORE_NAME, envir=getDBenv())
  ls(envir=db_store)
}

# get a DB
getDB <- function(key, mustWork=T) {
  if(!inherits(key, 'character')) stop('key argument must be a character vector')
  db_store <- get(DB_STORE_NAME, envir=getDBenv())
  db <- tryCatch({get(key, envir=db_store)}, error=function(e) NULL)
  if(is.null(db) & mustWork==T) stop(sprintf('DB \'%s\' not found - check that it is setup correctly?', key))
  db
}

# delete a DB
# stub for now
rmDB <- function(key, mustWork=T) {
  if(!inherits(key, 'character')) stop('key argument must be a character vector')
  if(!existsDB(key) & mustWork==T) stop(sprintf('DB \'%s\' does not exist!  Unable to delete it.', key))
  db_store <- get(DB_STORE_NAME, envir=getDBenv())
  rm(list=key, envir=db_store)
  NULL
}

# check if DB exists
# stub for now
existsDB <- function(key) {
  if(!inherits(key, 'character')) stop('key argument must be a character vector')
  db_store <- get(DB_STORE_NAME, envir=getDBenv())
  db <- tryCatch({get(key, envir=db_store)}, error=function(e) NULL)
  if(is.null(db)) F else T
}

# save DB
registerDB <- function(key, db, force=F) {
  if(!inherits(key, 'character')) stop('key argument must be a character vector')
  if(!inherits(db, DB_CLASS_NAME)) stop(sprintf('db argument must be a member of class %s', DB_CLASS_NAME))
  if(existsDB(key) & force==F) stop(sprintf('DB \'%s\' already exists!  Set force=T to overwrite', key))
  db_store <- get(DB_STORE_NAME, envir=getDBenv())
  assign(key, db, envir=db_store)
  NULL
}

# create a new DB
newDB <- function(key, cstr, para, default, opts, force=F) {

  db <- DB$new(
    key=key,
    cstr=cstr,
    para=para,
    default=default,
    opts=opts
  )

  # check for new DB and delete
  if(existsDB(key)) {
    if(force==T) {
      rmDB(key)
    } else {
      stop(sprintf('DB %s already exists!  Set force=T to overwrite', key))
    }
  }

  registerDB(key, db)

  db

}

# exportDB - save one or more DBs to a file
exportDB <- function(keys=listDB(), filename=DEFAULT_DB_FILE) {
  if(length(setdiff(keys, listDB())) >= 1) stop(sprintf('DBs not found: %s', paste(setdiff(keys, listDB()), collapse=', ')))
  dblist <- lapply(keys, getDB)
  names(dblist) <- keys
  saveRDS(dblist, filename)
}


# importDB - load one or more DBs from a file
importDB <- function(filename=DEFAULT_DB_FILE, force=F) {
  dblist <- readRDS(filename)
  collisions <- intersect(names(dblist), listDB())
  if(length(collisions) >= 1 & force==F) stop(sprintf('DBs already exist: %s', paste(collisions, collapse=', ')))
  for(i in seq_len(length(dblist))) {
    registerDB(names(dblist)[i], dblist[i], force)
  }
  NULL
}
