library(plyr)

rawDistanceRows <- readLines("stats/violin-distance.txt")
rawIntensityRows <- readLines("stats/violin-intensity.txt")

# split by sep
rawDistanceRowsSplits <- strsplit(rawDistanceRows, "\t")
# Make each into a list of dataframes (for rbind.fill)
rawDistanceRowsSplits <- lapply(rawDistanceRowsSplits, function(x)as.data.frame(t(x)))
# now bind
distanceRowsModified <- rbind.fill(rawDistanceRowsSplits)
distanceColumnsModified <- as.data.frame(t(as.matrix(distanceRowsModified)));

write.table(distanceRowsModified, "stats/violin-distance-modifedrows.txt");
write.table(distanceColumnsModified, "stats/violin-distance-modifiedcolumns.txt");



# split by sep
rawIntensityRowsSplits <- strsplit(rawIntensityRows, "\t")
# Make each into a list of dataframes (for rbind.fill)
rawIntensityRowsSplits <- lapply(rawIntensityRowsSplits, function(x)as.data.frame(t(x)))
# now bind
intensityRowsModified <- rbind.fill(rawIntensityRowsSplits)
intensityColumnsModified <- as.data.frame(t(as.matrix(intensityRowsModified)));

write.table(intensityRowsModified, "stats/violin-intensity-modifedrows.txt");
write.table(intensityColumnsModified, "stats/violin-intensity-modifiedcolumns.txt");


dim(distanceRowsModified)
dim(distanceColumnsModified)
dim(intensityRowsModified)
dim(intensityColumnsModified)