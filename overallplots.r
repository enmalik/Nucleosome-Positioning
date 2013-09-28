# terminal arguments:
# Rscript overallplots.r #doesn't make any plots
# Rscript overallplots.r all #makes an overall scatterplot for all factors
# Rscript overallplots.r all 100 200 3 4 # makes a zoomed in plot of x from 100 to 200 and y from 3 to 4
# Rscript overallplots.r wgEncodeHaibTfbsGm12878Usf1Pcr2xPkRep1.broadPeak # example factor name, highlights the specific factor on the overall scatterplot
# Rscript overallplots.r wgEncodeHaibTfbsGm12878Usf1Pcr2xPkRep1.broadPeak 100 200 3 4 # zoomed in version, if factor is on window, will be highlighted

library(sm)
library(calibrate)
library(directlabels)
library(lattice)
library(ggplot2)
library(gridExtra)


vioplot2 <- function(x,...,range=1.5,h=NULL,ylim=NULL,names=NULL, horizontal=FALSE, 
  col="magenta", border="black", lty=1, lwd=1, rectCol="black", colMed="white", pchMed=19, at, add=FALSE, wex=1, 
  drawRect=TRUE)
{
    # process multiple datas
    datas <- list(x,...)
    n <- length(datas)
   
    if(missing(at)) at <- 1:n
    
    # pass 1
    #
    # - calculate base range
    # - estimate density
    #
    
    # setup parameters for density estimation
    upper  <- vector(mode="numeric",length=n)
    lower  <- vector(mode="numeric",length=n) 
    q1     <- vector(mode="numeric",length=n)
    q3     <- vector(mode="numeric",length=n)
    med    <- vector(mode="numeric",length=n)
    base   <- vector(mode="list",length=n)
    height <- vector(mode="list",length=n)
    baserange <- c(Inf,-Inf)
    
    # global args for sm.density function-call   
    args <- list(display="none")
       
    if (!(is.null(h)))
        args <- c(args, h=h)
   
            
    for(i in 1:n) {

        data<-datas[[i]]
        
        # calculate plot parameters
        #   1- and 3-quantile, median, IQR, upper- and lower-adjacent
        
        data.min <- min(data)
        data.max <- max(data)
        q1[i]<-quantile(data,0.25)
        q3[i]<-quantile(data,0.75)
        med[i]<-median(data)
        iqd <- q3[i]-q1[i]
        upper[i] <- min( q3[i] + range*iqd, data.max )
        lower[i] <- max( q1[i] - range*iqd, data.min )
        
       
        #   strategy:
        #       xmin = min(lower, data.min))
        #       ymax = max(upper, data.max))
        #

        est.xlim <- c( min(lower[i], data.min), max(upper[i], data.max) ) 
        
        # estimate density curve
        
        smout <- do.call("sm.density", c( list(data, xlim=est.xlim), args ) )

        
        # calculate stretch factor
        #
        #  the plots density heights is defined in range 0.0 ... 0.5 
        #  we scale maximum estimated point to 0.4 per data
        #
        
        hscale <- 0.4/max(smout$estimate) * wex
        
        
        # add density curve x,y pair to lists
        
        base[[i]]   <- smout$eval.points
        height[[i]] <- smout$estimate * hscale
        
        
        # calculate min,max base ranges
        
        t <- range(base[[i]])
        baserange[1] <- min(baserange[1],t[1])
        baserange[2] <- max(baserange[2],t[2])

    }
   
    # pass 2
    #
    # - plot graphics
    
    # setup parameters for plot

    if(!add){
      xlim <- if(n==1) 
               at + c(-.5, .5)
              else 
               range(at) + min(diff(at))/2 * c(-1,1)
    
      if (is.null(ylim)) {
         ylim <- baserange
      }
    }
    if (is.null(names)) {
        label <- 1:n
    } else {
        label <- names
    }

    boxwidth <- 0.05 * wex
    
        
    # setup plot

    if(!add)
      plot.new()
    if(!horizontal) {
      if(!add){
        plot.window(xlim = xlim, ylim = ylim)
        axis(2)
        axis(1,at = at, label=label, las = 2 ) #ADDED LAS = 2 FOR VERTICAL AXIS LABELS
      }  
      
      box()
      
      for(i in 1:n) {
       
          # plot left/right density curve
        
          polygon( c(at[i]-height[[i]], rev(at[i]+height[[i]])), 
                   c(base[[i]], rev(base[[i]])),
                   col = col[i], border=border, lty=lty, lwd=lwd)  #ADDED COL[I] FOR MULTIPLE COLOURS
        
        
          if(drawRect){
            # plot IQR
            lines( at[c( i, i)], c(lower[i], upper[i]) ,lwd=lwd, lty=lty)
        
            # plot 50% KI box
        
            rect( at[i]-boxwidth/2, q1[i], at[i]+boxwidth/2, q3[i], col=rectCol)
        
            # plot median point
        
            points( at[i], med[i], pch=pchMed, col=colMed )
         }
      }

    }
    else {
      if(!add){
        plot.window(xlim = ylim, ylim = xlim)
        axis(1)
        axis(2,at = at, label=label )
      }
      
      box()
      for(i in 1:n) {
       
          # plot left/right density curve
        
          polygon( c(base[[i]], rev(base[[i]])),
                   c(at[i]-height[[i]], rev(at[i]+height[[i]])),
                   col = col, border=border, lty=lty, lwd=lwd)
        
        
          if(drawRect){
            # plot IQR
            lines( c(lower[i], upper[i]), at[c(i,i)] ,lwd=lwd, lty=lty)
        
            # plot 50% KI box
        
            rect( q1[i], at[i]-boxwidth/2, q3[i], at[i]+boxwidth/2,  col=rectCol)
        
            # plot median point
            points( med[i], at[i], pch=pchMed, col=colMed )
          }
      }

      
    }

    
    invisible (list( upper=upper, lower=lower, median=med, q1=q1, q3=q3))
}

# end of vioplot2


args <- commandArgs(trailingOnly = TRUE)
print(args)
print(args[1])

highlightName <- ""
highlightFactor <- ""

if (is.na(args[1]) == FALSE) {
  highlightName <- paste("-", args[1], sep="")
  highlightFactor <- args[1]
}

x1 <- 0
x2 <- 0
y1 <- 0
y2 <- 0

if (is.na(args[2]) == FALSE & is.na(args[3]) == FALSE & is.na(args[4]) == FALSE & is.na(args[5]) == FALSE) {
  x1 <- as.numeric(args[2])
  x2 <- as.numeric(args[3])
  y1 <- as.numeric(args[4])
  y2 <- as.numeric(args[5])
}

# print(x1)

tfList <- read.table("stats/run.txt", as.is=TRUE, col.names=c("tfNames"));
tfListRow <- as.data.frame(t(as.matrix(tfList)));
tfListChar <- data.frame(lapply(tfListRow, as.character), stringsAsFactors=FALSE)

scatterPlotData <- read.table("stats/scatter-plot-data.txt", as.is=TRUE, col.names=c("scatterDistance", "scatterIntensity", "tfColour", "scatterLabel", "scatterNumberLabel", "scatterNumberNameLabel", "scatterPointColour", "scatterName"));
# print(scatterPlotData)
scatterPlotData["factorNames"] <- tfList

# # print(scatterPlotData$scatterPointColour)

for (i in 1:nrow(scatterPlotData))  {
   scatterPlotData$scatterPointColour[i] <- paste("#",scatterPlotData$scatterPointColour[i],sep="")
   # rest is the same
}

# print(scatterPlotData$scatterPointColour);



#INTERESTING
# chooseColors <- function(x, y) {
#   return(rgb(green=y/max(y), blue=y/max(y), red=x/max(x)))
# }

# chooseColors <- function(x, y) {
#   return(rgb(green=0, red=y/max(y), blue=x/max(x)))
# }

# chooseColors2 <- function(x, y, maxX, maxY) {
#   x <- 1-x/maxX
#   # y <- 1-((max(y)/min(y))*(y/(max(y))))
#   y <- 1-y/maxY
#   y <- y + 0.3
#   print(rgb(green=y, red=y, blue=x))
#   return(rgb(green=y, red=y, blue=x))
# }

# chooseColors3 <- function(x, y, maxX, maxY, name) {

#   if (name == highlightFactor) {
#     print(name)
#     print("IN");
#     return (rgb(green=0, red=1, blue=0))
#   } else {
#     print("OUT");
#     x <- 1-x/maxX
#     # y <- 1-((max(y)/min(y))*(y/(max(y))))
#     y <- 1-y/maxY
#     y <- y + 0.3
#     print(rgb(green=y, red=y, blue=x))
#     return(rgb(green=y, red=y, blue=x))
#   }
# }

chooseColorsOverall <- function(data, maxX, maxY) {
  # print(dim(data))
  rowsNo <- dim(data)[1]
  colsNo <- dim(data)[2]
  # print(rowsNo)
  # print(colsNo)

  # print(data[,7])

  print(data$scatterPointColour)

  # maxX <- max(data[,1])
  # print(maxX)
  # maxY <- max(data[,2])
  # print(maxY)

  colours <- c()
  if (length(grep("#-", data$scatterPointColour[1])) != 0) {
    print("here");
    for (i in 1:rowsNo) {

      if (data$factorNames[9] == highlightFactor) {
      # print("red")
        colours <- append(colours, rgb(green=0, red=1, blue=0))
      } else {
        # print("else colour")
        x <- data$scatterDistance[1]
        y <- data$scatterIntensity[2]

        x <- 1-x/maxX
        # y <- 1-((max(y)/min(y))*(y/(max(y))))
        y <- 1-y/maxY
        y <- y + 0.3
        # print(rgb(green=y, red=y, blue=x))
        colours <- append(colours, rgb(green=y, red=y, blue=x))
      }
    }
  } else {
    print("there");
    colours <- data$scatterPointColour
  }
  # print(colours)
  return(colours)
}

choosePointSize <- function(data) {
  rowsNo <- dim(data)[1]
  colsNo <- dim(data)[2]
  sizes <- c()

  for (i in 1:rowsNo) {
    if (data$factorNames[i] == highlightFactor) {
      sizes <- append(sizes, 8)
    } else {
      sizes <- append(sizes, 4)
    }
  }
  return(sizes)
}

addZoomPlot <- function(limX1, limX2, limY1, limY2) {
  scatterPlotDataZoom <- subset(scatterPlotData, scatterDistance <= limX2 & scatterDistance >= limX1 & scatterIntensity <= limY2 & scatterIntensity>=limY1)
  fileName <- paste("stats/OverallScatterPlot-Numbered",highlightName, "-",limX1,"-",limX2,"-",limY1,"-",limY2,".png",sep="")
  print(fileName)
  png(fileName, width = 2000, height = 1500, res = 100);
  ggplotZoom <- ggplot(scatterPlotDataZoom, aes(x=scatterDistance, y=scatterIntensity, label=scatterNumberLabel)) +
  geom_point(colour=chooseColorsOverall(scatterPlotDataZoom, max(scatterPlotData$scatterDistance), max(scatterPlotData$scatterIntensity)), size=choosePointSize(scatterPlotDataZoom)) +
  geom_text(hjust=0, vjust=0) +
  xlab("Distance (bp)") +
  ylab("Intensity") +
  coord_cartesian(xlim=c(limX1,limX2), ylim=c(limY1,limY2)) +
  ggtitle("Intensity vs. Distance Plot")
  # ggplotZoom
  grid.arrange(ggplotZoom, legend = tableGrob(scatterPlotDataZoom$scatterNumberNameLabel))
  # direct.label(ggplotXYlim)
}

# print(is.na(args[1]))
# print(is.na(args[2]))
# print(is.na(args[3]))
# print(is.na(args[4]))
# print(is.na(args[5]))

# print(class(args[4]))


# PLOTS FROM INPUT FROM TERMINAL

if (is.na(args[2]) == TRUE & (highlightFactor == "all" | highlightFactor != "")) {
  # print("here")
  png(paste("stats/OverallScatterPlot-Numbered-Labels", highlightName, ".png", sep=""), width = 4000, height = 3500, res = 80);
  ggplotNumLabels <- ggplot(scatterPlotData, aes(x=scatterDistance, y=scatterIntensity, label=scatterNumberLabel)) +
  geom_point(colour=chooseColorsOverall(scatterPlotData, max(scatterPlotData$scatterDistance), max(scatterPlotData$scatterIntensity)), size=choosePointSize(scatterPlotData)) +
  geom_text(hjust=0, vjust=0) +
  xlab("Distance (bp)") +
  ylab("Intensity") +
  ggtitle("Intensity vs. Distance Plot")
  # ggplotNumLabels
  grid.arrange(ggplotNumLabels, legend = tableGrob(scatterPlotData$scatterNumberNameLabel))
  dev.off()

  png(paste("stats/OverallScatterPlot-non-Numbered", highlightName, ".png", sep=""), width = 2000, height = 1500, res = 80);
  ggplotNum <- ggplot(scatterPlotData, aes(x=scatterDistance, y=scatterIntensity, label=scatterNumberLabel)) +
  geom_point(colour=chooseColorsOverall(scatterPlotData, max(scatterPlotData$scatterDistance), max(scatterPlotData$scatterIntensity)), size=choosePointSize(scatterPlotData)) +
  # geom_text(hjust=0, vjust=0) +
  xlab("Distance (bp)") +
  ylab("Intensity") +
  ggtitle("Intensity vs. Distance Plot")
  ggplotNum

  # direct.label(ggplotNumLabels)
} else if (is.na(args[2]) == FALSE & is.na(args[3]) == FALSE & is.na(args[4]) == FALSE & is.na(args[5]) == FALSE) {# & class(args[2]) == "numeric" & class(args[3]) == "numeric" & class(args[4]) == "numeric" & class(args[5]) == "numeric") {
  # print("there")
  addZoomPlot(x1, x2, y1, y2)
}
dev.off()




# THESE PLOTS BELOW WERE FIRST MADE FOR PLOTTING DIRECTLY FROM THE SCRIPT

# png(paste("stats/OverallScatterPlot-Numbered-Labels", highlightName, ".png", sep=""), width = 4000, height = 3500, res = 80);
# ggplotNumLabels <- ggplot(scatterPlotData, aes(x=scatterDistance, y=scatterIntensity, label=scatterNumberLabel)) +
# geom_point(colour=chooseColorsOverall(scatterPlotData, max(scatterPlotData$scatterDistance), max(scatterPlotData$scatterIntensity)), size=choosePointSize(scatterPlotData)) +
# geom_text(hjust=0, vjust=0) +
# xlab("Distance (bp)") +
# ylab("Intensity") +
# ggtitle("Intensity vs. Distance Plot")
# # ggplotNumLabels
# grid.arrange(ggplotNumLabels, legend = tableGrob(scatterPlotData$scatterNumberNameLabel))
# # direct.label(ggplotNumLabels)
# dev.off()

# png(paste("stats/OverallScatterPlot-Numbered", highlightName, ".png", sep=""), width = 2000, height = 1500, res = 80);
# ggplotNum <- ggplot(scatterPlotData, aes(x=scatterDistance, y=scatterIntensity, label=scatterNumberLabel)) +
# geom_point(colour=chooseColorsOverall(scatterPlotData, max(scatterPlotData$scatterDistance), max(scatterPlotData$scatterIntensity)), size=choosePointSize(scatterPlotData)) +
# geom_text(hjust=0, vjust=0) +
# xlab("Distance (bp)") +
# ylab("Intensity") +
# ggtitle("Intensity vs. Distance Plot")
# ggplotNum
# # direct.label(ggplotNum)
# dev.off()








# #adds extra zoomed in plot. params: (low distance, high distance, low intensity, high intensity)
# addZoomPlot(-10, 100, 2.25, 3.25)
# dev.off()
# addZoomPlot(100, 200, 3, 3.25)
# dev.off()
# addZoomPlot(100, 200, 2.25, 3.25)
# dev.off()
# addZoomPlot(400, 510, 2.25, 2.75)
# dev.off()


#VIOLIN PLOTS

#VIOLIN PLOTS DATG

# violinDistanceData <- read.table("stats/violin-distance.txt", fill=TRUE, nrows = 60);#;, na.strings = "0");
# columnViolinDistanceData <- read.table("stats/violin-distance-modifiedcolumns.txt");
# columnViolinIntensityData <- read.table("stats/violin-intensity-modifiedcolumns.txt");
# names(columnViolinDistanceData)[1] <- "x";
# names(columnViolinIntensityData)[1] <- "x";

# dim(columnViolinDistanceData);
# dim(columnViolinIntensityData);

# png("stats/OveralllDistanceViolinPlot.png", width = 3000, height = 1800, res=80);
# # png("stats/AllDistanceViolinPlot.png", width = 2000, height = 2390);
# mar.orig <- par()$mar # save the original values
# par(mar = c(30,4,4,4)) # set your new values EACH 1 IS 15 PX
# do.call(vioplot2, c(lapply(columnViolinDistanceData, na.omit),list(names=tfListChar),list(col=scatterPlotData$tfColour)));
# title("Distances at Highest Spline Intensities");
# par(mar = mar.orig) # put the original values back
# dev.off()

# png("stats/OverallIntensityViolinPlot.png", width = 3000, height = 1800, res=80);
# # png("stats/AllIntensityViolinPlot.png", width = 2000, height = 2390);
# mar.orig <- par()$mar # save the original values
# par(mar = c(30,4,4,4)) # set your new values EACH 1 IS 15 PX FOR DEFAULT RES
# do.call(vioplot2, c(lapply(columnViolinIntensityData, na.omit),list(names=tfListChar),list(col=scatterPlotData$tfColour)));
# title("Highest Spline Intensities");
# par(mar = mar.orig) # put the original values back
# dev.off()
