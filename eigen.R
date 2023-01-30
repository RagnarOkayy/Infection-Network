library(igraph)
library(ggscater)
library('Cairo')
CairoWin()

nodes <- read.csv("nodeData.csv")
edgesTemp <- read.csv("edgeData.csv")
class(edgesTemp)

D <- as.data.frame(table(edgesTemp))
edges <- subset(D, Freq > 0)

head(edgesTemp)       
head(edges)

g1 <- graph.data.frame(edges, directed = FALSE,nodes)#Important to specify                   
#that this is an undirected network
g1 #displays the first 21 edges
E(g1)$weight <- E(g1)$Freq
# The $Freq data of the edges is saved as $weight
# because many of the default centrality functions
# automatily scan for it as an argument
class(g1) #The object is of igraph class



g1[c(1:15),c(1:15)] # Returns a 15x15 sparse matrix with the correcspondign weights for each edge

#V(g1)$size <- degree(g1)/10

#The distance between one node and all the other nodes, adds them up and finds the inverse

g1eigen <- evcent(g1)$vector
V(g1)$Eigen <- g1eigen
sortEigen <- sort(g1eigen)
tail(sortEigen)
V(g1)$Eigen

meanEigen <- mean(V(g1)$Eigen) # find the mean of V(g1)$Eigen
meanEigen # show the mean
meanEigen1B <- mean(V(g1)[Class == "1B"]$Eigen) # find the mean of -;- for Class 1B
meanEigen1B # show the mean of 1B
meanEigennot1B <- mean(V(g1)[Class != "1B"]$Eigen) # find the mean of -;- for not 1B
meanEigennot1B # show the mean




DF<-as_long_data_frame(g1)

for (x in 1:242) {
  if(V(g1)[x]$Class == "1A"){
    V(g1)[x]$color <- adjustcolor("pink",.7)
  } else if(V(g1)[x]$Class == "1B"){
    V(g1)[x]$color <- adjustcolor("yellow",.7)
  } else if(V(g1)[x]$Class == "2A"){
    V(g1)[x]$color <- adjustcolor("red",.7)
  } else if(V(g1)[x]$Class == "2B"){
    V(g1)[x]$color <- adjustcolor("green",.7)
  } else if(V(g1)[x]$Class == "3A"){
    V(g1)[x]$color <- adjustcolor("brown",.7)
  } else if(V(g1)[x]$Class == "3B"){
    V(g1)[x]$color <- adjustcolor("orange",.7)
  } else if(V(g1)[x]$Class == "4A"){
    V(g1)[x]$color <- adjustcolor("purple",.7)
  } else if(V(g1)[x]$Class == "4B"){
    V(g1)[x]$color <- adjustcolor("grey",.7)
  } else if(V(g1)[x]$Class == "5A"){
    V(g1)[x]$color <- adjustcolor("yellowgreen",.7)
  } else if(V(g1)[x]$Class == "5B"){
    V(g1)[x]$color <- adjustcolor("navajowhite1",.7)
  } else {
    V(g1)[x]$color <- "blue"
  }
}

louvainCluster <- cluster_louvain(g1, weights = E(g1)$weight)
communities(louvainCluster) # Gives a list of all communities

set.seed(222) #Using a constant seed makes it easier to analyze the graph

plot(g1,
     edge.color = "black", #color of the edges
     #vertex.label.cex = 0.5,#label size
     vertex.label = NA, #remove label names/id
     edge.width = E(g1)$weight/300, #The widht of the edge is based on the weight
     vertex.size = sqrt(V(g1)$Eigen)*10,
     layout = layout.fruchterman.reingold(g1)
     #Force-directed graph drawing - As few crossing edges as possible, and all the edges are rougly the same size
)

classHolder <- c("1A", "1B","2A","2B","3A", "3B", "4A", "4B","5A", "5B","Teacher")
colorHolder <- c("pink","yellow","red","green","brown","orange","purple","grey","yellowgreen","navajowhite1","blue")
legend(x = "bottomleft", legend = classHolder, fill = colorHolder, title = "Classes:") #legend for the graph



