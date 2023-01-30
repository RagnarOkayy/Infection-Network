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

#acts as a middling node in the shortest path
g1between <- betweenness(g1, directed = F, weights = E(g1)$weight)
V(g1)$betweenness <- g1between
sortg1between <- sort(g1between)
head(sortg1between)
tail(sortg1between)
V(g1)$betweenness

edge_density(g1) # Edge density of the entire class

# create a subgraph with only students from class 1A
A1 <- induced_subgraph(g1, V(g1)[Class =="1A"], impl = c("auto")) 
edge_density(A1)
# create a subgraph with only students from class 2B
B2 <- induced_subgraph(g1, V(g1)[Class =="2B"], impl = c("auto"))
edge_density(B2)


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

V(g1)[69]$color = "black"
V(g1)[161]$color = "black"
V(g1)[33]$color = "black"
V(g1)[158]$color = "black"
V(g1)[57]$color = "black"
V(g1)[56]$color = "black"

louvainCluster <- cluster_louvain(g1, weights = E(g1)$weight)
communities(louvainCluster) # Gives a list of all communities

set.seed(222) #Using a constant seed makes it easier to analyze the graph

plot(g1,
     edge.color = "black", #color of the edges
     #vertex.label.cex = 0.5,#label size
     vertex.label = NA, #remove label names/id
     edge.width = E(g1)$weight/300, #The widht of the edge is based on the weight
     vertex.size = V(g1)$betweenness/40,
     #vertex.size = V(g1)$degree/15,
     #vertex.size = V(g1)$Close/50,
     #vertex.size = 0, # constant node/vertex size
     layout = layout.fruchterman.reingold(g1)
     #Force-directed graph drawing - As few crossing edges as possible, and all the edges are rougly the same size
)



classHolder <- c("1A", "1B","2A","2B","3A", "3B", "4A", "4B","5A", "5B","Teacher")
colorHolder <- c("pink","yellow","red","green","brown","orange","purple","grey","yellowgreen","navajowhite1","blue")
legend(x = "bottomleft", legend = classHolder, fill = colorHolder, title = "Classes:") #legend for the graph
