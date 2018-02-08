context('transformations')

test_that('rebinning into fewer categories works', {
  expect_equal(downmap(seq_len(10), from=seq_len(5), to=1), c(1,1,1,1,1,6,7,8,9,10))
  x <- c('Divorced', 'Defacto', 'Married', 'Single')
  expect_equal(downmap(x, from=list(c('Divorced', 'Single'), c('Defacto', 'Married')), to=c('Single', 'Partnered')),
               c('Single', 'Partnered', 'Partnered', 'Single'))
  expect_equal(downmap(factor(c('foo','bar','baz')), 'foo', 'geo'), factor(c('geo', 'bar', 'baz'), levels=c('bar','baz', 'foo','geo')))
})

test_that('log cut works on nothing', {
  expect_equal(length(levels(log_cut(iris$Sepal.Length, minsize=150))), 3) # <0, 0, >0
  expect_equal(length(levels(log_cut(iris$Sepal.Length, minsize=150, 'positive'))), 3) #  0, >0
  expect_equal(length(levels(log_cut(iris$Sepal.Length, minsize=150, 'negative'))), 3) # <0, 0
  expect_equal(length(levels(log_cut(iris$Sepal.Length, minsize=10, 'positive'))), 6) # <0, 0
})

# test_that('log cut works', {
#   expect_equal(downmap(seq_len(10), from=seq_len(5), to=1), c(1,1,1,1,1,6,7,8,9,10))
#   x <- c('Divorced', 'Defacto', 'Married', 'Single')
#   expect_equal(downmap(x, from=list(c('Divorced', 'Single'), c('Defacto', 'Married')), to=c('Single', 'Partnered')),
#                c('Single', 'Partnered', 'Partnered', 'Single'))
#   expect_equal(downmap(factor(c('foo','bar','baz')), 'foo', 'geo'), factor(c('geo', 'bar', 'baz'), levels=c('bar','baz', 'foo','geo')))
# })
