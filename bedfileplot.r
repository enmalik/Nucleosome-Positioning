library(hexbin)
library(lattice)

args <- commandArgs(trailingOnly = TRUE)
tf <- args[1]

statFile <- paste("stats/", tf ,"/bedfileparts-gteq1.5peak-summit/all-bed-stats.txt", sep="")
zeroTenScatter <- paste("stats/", tf ,"/bedfileparts-gteq1.5peak-summit/010scatterplot.png", sep="")
zeroTenHeatmap <- paste("stats/", tf ,"/bedfileparts-gteq1.5peak-summit/010heatmap.png", sep="")
zeroUnlScatter <- paste("stats/", tf ,"/bedfileparts-gteq1.5peak-summit/0Unlscatterplot.png", sep="")
zeroUnlHeatmap <- paste("stats/", tf ,"/bedfileparts-gteq1.5peak-summit/0Unlheatmap.png", sep="")
zeroTenSmoothscatter <- paste("stats/", tf ,"/bedfileparts-gteq1.5peak-summit/010smoothscatter.png", sep="")
zeroUnlSmoothscatter <- paste("stats/", tf ,"/bedfileparts-gteq1.5peak-summit/0Unlsmoothscatter.png", sep="")
zeroTenSpline <- paste("stats/", tf ,"/bedfileparts-gteq1.5peak-summit/010spline.png", sep="")

zeroTenScatterTitle <- paste(tf, " - 0 to 10 Scatter plot" , sep="");
zeroTenHeatmapTitle <- paste(tf, " - 0 to 10 Heat map" , sep="");
zeroTenSmoothscatterTitle <- paste(tf, " - 0 to 10 Smooth Scatter", sep="");
zeroUnlScatterTitle <- paste(tf, " - 0 to Unl Scatter plot" , sep="");
zeroUnlHeatmapTitle <- paste(tf, " - 0 to Unl Heat map" , sep="");
zeroUnlSmoothscatterTitle <- paste(tf, " - 0 to Unl Smooth Scatter", sep="");
zeroTenSplineTitle <- paste(tf, " - 0 to 10 Spline", sep="");

data <- read.table(statFile, as.is=TRUE);

xpts010 <- data[,1][ data[,2] <= 10 & data[,2]>=0] 
ypts010 <- data[,2][ data[,2] <= 10 & data[,2]>=0]

spl010 <- smooth.spline(xpts010, ypts010)
xSplPts <- spl010[1]
ySplPts <- spl010[2]
ySplPtsUnlist <- unlist(ySplPts)
xSplPtsUnlist <- unlist(xSplPts)

maxXIndex <- which.max(ySplPtsUnlist)
maxX <- xSplPtsUnlist[maxXIndex];
maxY <- max(ySplPtsUnlist)

xpts0Unl <- data[,1]
ypts0Unl <- data[,2]

bin010 <- hexbin(x=xpts010, y=ypts010);
bin0Unl <- hexbin(x=xpts0Unl, y=ypts0Unl);

png(zeroTenScatter, width = 1000, height = 1000);
plot(xpts010, ypts010, main = zeroTenScatterTitle, xlab = "Distance (bp)", ylab = "Intensity", col=rgb(0,0,0,100,maxColorValue=255), pch=16);
dev.off();

png(zeroTenHeatmap, width = 1000, height = 1000);
plot(bin010, main = zeroTenHeatmapTitle, xlab = "Distance (bp)", ylab = "Intensity");
dev.off();

png(zeroTenSmoothscatter, width = 1000, height = 1000);
smoothScatter(xpts010, ypts010, nbin = 1000, main = zeroTenSmoothscatterTitle, xlab = "Distance (bp)", ylab = "Intensity");
lines(spl010);
dev.off();

png(zeroTenSpline, width = 1000, height = 1000);
plot(spl010, main = zeroTenSplineTitle, xlab = "Distance (bp)", ylab = "Intensity", type = "l");
dev.off();

png(zeroUnlScatter, width = 1000, height = 1000);
plot(xpts0Unl, ypts0Unl, main = zeroUnlScatterTitle, xlab = "Distance (bp)", ylab = "Intensity", col=rgb(0,0,0,100,maxColorValue=255), pch=16);
dev.off();

png(zeroUnlHeatmap, width = 1000, height = 1000);
plot(bin0Unl, main = zeroUnlHeatmapTitle, xlab = "Distance (bp)", ylab = "Intensity");
dev.off();

png(zeroUnlSmoothscatter, width = 1000, height = 1000);
smoothScatter(xpts0Unl, ypts0Unl, nbin = 1000, main = zeroUnlSmoothscatterTitle, xlab = "Distance (bp)", ylab = "Intensity");
dev.off();

sink(paste("stats/", tf ,"/bedfileparts-gteq1.5peak-summit/splinemaxpeak.txt", sep=""))
cat(maxX)
cat("\t")
cat(maxY)
sink()