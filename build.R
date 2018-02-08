# set wd
#setwd("C:/Users/L092804/Local/R Workspace/tera")
# update documentation
devtools::document()
# test the package
devtools::test()
# build the package
Sys.setenv(R_ZIPCMD='C:\\LocalData\\Rtools\\bin\\zip.exe')
bin <- devtools::build(binary = TRUE, args = c('--preclean'))
# copy from H:\
#file.copy(file.path('H:', basename(bin)), bin, overwrite = T)
# delete H:\ version
#file.remove(file.path('H:', basename(bin)))
# deatch
unloadNamespace('tera')
# install the buld
install.packages(repos=NULL, pkgs='../tera_0.1.0.zip')
# load the new package
library(tera)
