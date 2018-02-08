# set options per first run
db_setoptions <- function() {

  packageStartupMessage('Configuring package for first-time use')

  choice <- menu(c('Yes', 'No', 'Choose a different file'), title=sprintf('Automatically load default connections file \'%s\' on startup?', DEFAULT_DB_FILE))
  if(choice == 0) return(NULL)
  if(choice == 1) do.call(options, args=structure(list(DEFAULT_DB_FILE), .Names=DB_AUTOIMPORT_NAME))
  if(choice == 2) do.call(options, args=structure(list(NULL), .Names=DB_AUTOIMPORT_NAME))
  if(choice == 3) do.call(options, args=structure(list(file.choose()), .Names=DB_AUTOIMPORT_NAME))

  choice <- menu(c('Yes', 'No'), title=sprintf('Automatically save new connections to file \'%s\'?', getOption(DB_AUTOIMPORT_NAME)))
  if(choice == 0) return(NULL)
  if(choice == 1) do.call(options, args=structure(list(T), .Names=DB_AUTOSAVE_NAME))
  if(choice == 2) do.call(options, args=structure(list(F), .Names=DB_AUTOSAVE_NAME))

  choice <- menu(c('Yes', 'No'), title=sprintf('Automatically save UNENCRYPTED passwords to file \'%s\'?', getOption(DB_AUTOIMPORT_NAME)))
  if(choice == 0) return(NULL)
  if(choice == 1) do.call(options, args=structure(list(T), .Names=DB_AUTOSAVEPWD_NAME))
  if(choice == 2) do.call(options, args=structure(list(F), .Names=DB_AUTOSAVEPWD_NAME))

  choice <- menu(c(
    'Convert to data.table (requires package \'data.table\')',
    'Convert to data_frame (requires package \'tibble\')',
    'Don\'t convert anything'
  ), title='Automatically convert query results?')
  if(choice == 0) return(NULL)
  if(choice == 1) do.call(options, args=structure(list(data.table::data.table), .Names=DB_AUTOCONVERT_NAME))
  if(choice == 2) do.call(options, args=structure(list(tibble::as_data_frame), .Names=DB_AUTOCONVERT_NAME))
  if(choice == 3) do.call(options, args=structure(list(NULL), .Names=DB_AUTOCONVERT_NAME))

  do.call(options, args=structure(list(F), .Names=DB_FIRSTRUN))

}

# show current options
db_listoptions <- function(print=T) {
  conversion <- getOption(DB_AUTOSAVEPWD_NAME)
  conversion_desc <- if(identical(conversion, data.table::data.table)) {
    'data.table'
  } else if(identical(conversion, tibble::as_data_frame)) {
    'data_frame'
  } else 'no conversion'

  result <- c(
  Firstrun=sprintf('Firstrun: %s', getOption(DB_FIRSTRUN)),
  Connections=sprintf('Connections file: %s', getOption(DB_AUTOIMPORT_NAME)),
  Autosave=sprintf('Automatically save connections to file: %s', getOption(DB_AUTOSAVE_NAME)),
  AutosavePwd=sprintf('Automatically save password to file: %s', getOption(DB_AUTOSAVEPWD_NAME)),
  Conversion=sprintf('Automatically convert: %s', conversion_desc)
  )

  if(print==T) {
    cat(paste(result, collapse='\n'))
    NULL
  } else {
    return(result)
  }

}
