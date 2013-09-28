library(ggplot2)
library(gplots)
library(RColorBrewer)

factorStateTable <- read.table("stats/factor-state-table.txt", header = TRUE, as.is=TRUE, row.names=1);
# print(factorStateTable)
class(factorStateTable)

factorStatePercentTable <- read.table("stats/factor-state-percent-table.txt", header = TRUE, as.is=TRUE, row.names=1);

stepColours <- read.table("stats/step-colours.txt", header = FALSE, as.is=TRUE)
stepColoursRow <- as.matrix(as.data.frame(t(stepColours), stringsAsFactors=FALSE));
print(stepColours)
print(stepColoursRow)
class(stepColours)
class(stepColoursRow)

for (i in 1:ncol(stepColoursRow))  {
   stepColoursRow[1,i] <- paste("#",stepColoursRow[1,i],sep="")
}

print(stepColoursRow)


# print(max(factorStateTable[,2:ncol(factorStateTable)]))
# print(sum(factorStateTable[,1:15]))

# print(factorStatePercentTable)

percentMatrix <- data.matrix(factorStatePercentTable)

################

# ## The colors you specified.
# stepColours <- stepColoursRow
# ## Defining breaks for the color scale
# # stepBreaks <- c(0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1)

# library(sparcl)

# png("stats/cluster-heatmap-morecolours.png", width=2000, height=1500, res=100)
# rc <- rainbow(nrow(percentMatrix), start = 0, end = .3)
# cc <- rainbow(ncol(percentMatrix), start = 0, end = .3)

# hc <- hclust(dist(percentMatrix))
# dd <- as.dendrogram(hc)

# hm <- heatmap.2(percentMatrix, #Rowv=NA, Colv=NA,
#                 # col = stepColours, ## using your colors
#                 # breaks = stepBreaks, ## using your breaks
#                 # dendrogram = "none",  ## to suppress warnings
#                 cexRow=0.75, cexCol=1.0, key=TRUE, keysize=1.5,
#                 margins=c(10,22),
#                 trace="none")
# # ColorDendrogram(hm,main="My Simulated Data",branchlength=3)
# # legend("topright", fill = stepColours,
# #     legend = c("0 to 10%", "10%+ to 20%", "20%+ to 30%", "30%+ to 40%", "40%+ to 50%", "50%+ to 60%", "60%+ to 70%", "70%+ to 80%", "80%+ to 90%", "90%+ to 100%"))
# # mar.orig <- par()$mar # save the original values
# # par(mar = c(4,4,50,4)) # set your new values EACH 1 IS 15 PX
# # par(mar = mar.orig) # put the original values back

# dev.off()

##################

# mydatascale <- t(scale(t(percentMatrix))) # Centers and scales data.
rowClust <- hclust(dist(percentMatrix))

# print(rowClust[])
# # colClust <- hclust(as.dist(percentMatrix))
# hr <- hclust(as.dist(1-cor(t(mydatascale), method="pearson")), method="complete") # Cluster rows by Pearson correlation.
# hc <- hclust(as.dist(1-cor(mydatascale, method="spearman")), method="complete") 
#    # Clusters columns by Spearman correlation.
# heatmap(percentMatrix)# Rowv=as.dendrogram(hr), Colv=as.dendrogram(hc)) 




   # Plot the data table as heatmap and the cluster results as dendrograms.
png("stats/cluster-heatmap-morecolours.png", width=2000, height=1500, res=100)
mycl <- cutree(rowClust, k=6); 
# mycolhc <- c("#b8860b", "#ffd700", "#cd5c5c", "#32cd32", "#00bfff", "#ff4500")
mycolhc <- c("#ff9933", "#990000", "#990099", "#009900", "#33CCFF", "#FF0000")
mycolhc <- mycolhc[as.vector(mycl)]; 
hm <- heatmap.2(percentMatrix, RowSideColors=mycolhc, trace="none", cexRow=0.75, cexCol=1.0, key=TRUE, keysize=1.5, margins=c(10,22))
dev.off()
print(hm)
print(mycolhc)
print(hm$Rowv)

sink("stats/heatmap-cluster-colours.txt")
cat(mycolhc)
sink()



   # Cut the tree at specific height and color the corresponding clusters in the heatmap color bar.