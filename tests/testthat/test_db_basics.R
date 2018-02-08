context('environment management')

# going to stuff around with environments a bit so let's backup the old
old_env <- getOption(DB_ENV_NAME)

test_that('killDBenv works', {
  do.call(options, args=structure(list('foo'), .Names=DB_ENV_NAME))
  killDBenv()
  expect_null(getOption(DB_ENV_NAME))
})

test_that('makeDBenv works', {
  makeDBenv()
  expect_is(getOption(DB_ENV_NAME), 'environment')
  killDBenv()
  expect_null(getOption(DB_ENV_NAME))
})

test_that('getDBenv works', {
  a <- getDBenv()
  b <- getDBenv()
  expect_identical(a, b)
  killDBenv()
  expect_null(getOption(DB_ENV_NAME))
})

context('database basics')

# getDB(dbid) - get a DB instance
# rmDB(dbid) - delete a DB
# existsDB(dbid) - check if DB exists
# registerDB(DB) - save DB to DB environment
# newDB - create a new DB
# listDB() - list all available DBs

test_that('basic functions exist with appropriate return values', {
  makeDBenv()
  expect_error(rmDB('foo'))
  expect_is(newDB('foo', 'bar', 'baz', 'geo', list('qwe')), 'DB')
  expect_null(rmDB('foo'))
  expect_false(existsDB('foo'))
  expect_identical(listDB(), vector('character'))
})

# reset to the old env
do.call(options, args=structure(list(old_env), .Names=DB_ENV_NAME))
