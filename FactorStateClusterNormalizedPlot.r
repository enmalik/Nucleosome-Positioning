library(ggplot2)
library(gplots)
library(RColorBrewer)

factorStateTable <- read.table("stats/factor-state-table.txt", header = TRUE, as.is=TRUE, row.names=1);
# print(factorStateTable)
class(factorStateTable)

factorStateTallyOverMeanTable <- read.table("stats/factor-state-sample-mean-table.txt", header = TRUE, as.is=TRUE, row.names=1);

# factorStateTallyOverMeanTable <- log(factorStateTallyOverMeanTable)

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

tallyovermeanMatrix <- data.matrix(factorStateTallyOverMeanTable)

# tallyovermeanMatrix <- log2(tallyovermeanMatrix)

print(log(factorStateTallyOverMeanTable))

# test <- data.matrix(factorStateTallyOverMeanTable)
# log2(test)
# log2(tallyovermeanMatrix)



rowClust <- hclust(dist(tallyovermeanMatrix))

# Plot the data table as heatmap and the cluster results as dendrograms.
png("stats/cluster-heatmap-tallyovermean.png", width=2000, height=1500, res=100)
mycl <- cutree(rowClust, k=6); 
# mycolhc <- c("#b8860b", "#ffd700", "#cd5c5c", "#32cd32", "#00bfff", "#ff4500")
mycolhc <- c("#ff9933", "#990000", "#990099", "#009900", "#33CCFF", "#FF0000", "#826561")
mycolhc <- mycolhc[as.vector(mycl)]; 
hm <- heatmap.2(tallyovermeanMatrix, trace="none", RowSideColors=mycolhc, cexRow=0.75, cexCol=1.0, key=TRUE, keysize=1.5, margins=c(10,22))
dev.off()
# print(hm)
# print(mycolhc)
# print(hm$Rowv)

sink("stats/heatmap-cluster-colours-tallyovermean.txt")
cat(mycolhc)
sink()



# Cut the tree at specific height and color the corresponding clusters in the heatmap color bar.