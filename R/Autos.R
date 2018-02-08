# makeNamespace <- function(name, version = NULL, lib = NULL) {
#   impenv <- new.env(parent = .BaseNamespaceEnv, hash = TRUE)
#   attr(impenv, "name") <- paste("imports", name, sep = ":")
#   env <- new.env(parent = impenv, hash = TRUE)
#   name <- as.character(as.name(name))
#   version <- as.character(version)
#   info <- new.env(hash = TRUE, parent = baseenv())
#   env$.__NAMESPACE__. <- info
#   info$spec <- c(name = name, version = version)
#   setNamespaceInfo(env, "exports", new.env(hash = TRUE,
#                                            parent = baseenv()))
#   dimpenv <- new.env(parent = baseenv(), hash = TRUE)
#   attr(dimpenv, "name") <- paste("lazydata", name,
#                                  sep = ":")
#   setNamespaceInfo(env, "lazydata", dimpenv)
#   setNamespaceInfo(env, "imports", list(base = TRUE))
#   setNamespaceInfo(env, "path", normalizePath(file.path(lib,
#                                                         name), "/", TRUE))
#   setNamespaceInfo(env, "dynlibs", NULL)
#   setNamespaceInfo(env, "S3methods", matrix(NA_character_,
#                                             0L, 3L))
#   env$.__S3MethodsTable__. <- new.env(hash = TRUE,
#                                       parent = baseenv())
#   .Internal(registerNamespace(name, env))
#   env
# }

#Autos
# during package load, create a temprary package basd on contents of inst
# load this temprary package and install connections


# hmm..  better idea
# have a stateful object
# do something like
# DB <- getDB('tdp1')
# DB$query('select foo from bar')

# getDB(dbid) - set the current working DB
# showDB(DB or dbid) - provide detail about a DB
# newDB - create a new DB
# rmDB(DB or dbid) - delete a DB

# listDB - list all available DBs
# importDB - load one or more DBs from a file
# exportDB - save one or more DBs to a file

# DB$query - run a query and return the results
# DB$save - run a query and save the results to a file
# DB$cache - run a query and save the results to a file, but if the file exists just load it
# DB$con - create an RODBC connection, which can then be used for e.g. sqlQuery


# key <- 'acms'
# cstr <- 'Driver={SQL Server Native Client 11.0};Database=%s;Server=%s;Uid=%s;Pwd=%s;'
# para <- c('database', 'server', 'uid', 'pwd')
# default <- as.vector(c(NA,NA,NA,NA), mode='character')
# opts <- list()

tera:::newDB(
    key='acms',
    cstr='Driver={SQL Server Native Client 11.0};Database=%s;Server=%s;Uid=%s;Pwd=%s;',
    para=c('database', 'server', 'uid', 'pwd'),
    default=as.vector(c(NA,NA,NA,NA), mode='character'),
    opts=list(),
    force=T
)

tera:::listDB()

DB <- tera:::getDB('foo')

DB$query('select count(*) from BAR')
