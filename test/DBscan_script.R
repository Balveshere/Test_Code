#install.packages("dbscan")
#install.packages("fpc")
#install.packages("rlas")

library("dbscan")
library("fpc")
library("rlas")
library("data.table")

testCloud <- read.las("C:/Users/Brandon Alveshere/OneDrive - University of Connecticut/Desktop/Temp/CompleteBlockLAS.las")
testCloud <- as.matrix(testCloud[1:1500, 1:3]) #rows 1-1500, columns 1-3
summary(testCloud)
head(testCloud)

nrow(testCloud)

#plot optimal eps value
dbscan::kNNdistplot(testCloud, k =  500)
abline(h = 0.0001, lty = 2)

# Compute DBSCAN using fpc package
set.seed(123)
res.fpc <- fpc::dbscan(testCloud, eps = 0.001, MinPts = 50)
res.db <- dbscan::dbscan(testCloud, 0.001, 50)

res.fpc <- as.list(res.fpc$cluster)
typeof(res.fpc$cluster)
all(res.fpc$cluster == res.db)

# Plot DBSCAN results
plot(res.fpc, testCloud, main = "DBSCAN", frame = FALSE)

head(res.db)



#unzip factoextra file - doesn't work - not a real package?
f <- tempfile("C:/Users/Brandon Alveshere/AppData/Local/Temp/Rtmpe6XN1l/downloaded_packages/factoextra_1.0.6.tar.gz")
unzip(f, exdir=tempdir())
file.copy(file.path(tempdir(), '.RData'), 'bivpois.RData')

foo <- source("C:/Users/Brandon Alveshere/AppData/Local/Temp/Rtmpe6XN1l/downloaded_packages/factoextra_1.0.6/factoextra/R/fviz_cluster.R")

# Plot DBSCAN results - other option
if(!require(devtools)) install.packages("devtools")
devtools::install_github("kassambara/factoextra")

library("factoextra")

fviz_cluster(res.fpc, testCloud, stand = FALSE, frame = FALSE, geom = "point")


# rlidar
#lidR