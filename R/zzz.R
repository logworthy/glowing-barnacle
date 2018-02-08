

.onLoad <- function(libname, pkgname) {

  # check for first run
  firstrun <- getOption(DB_FIRSTRUN)
  if(is.null(firstrun)) {
    db_setoptions()
  }

  makeDBenv()

  # load connections if needed

}

.onUnload <- function(libpath) {
  killDBenv()
}
