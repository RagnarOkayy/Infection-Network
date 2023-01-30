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
g1close <- closeness(g1, weights = E(g1)$weight)
centr_degree(g1,normalized = T)
V(g1)$Close <- g1close
V(g1)$Close %>% as.vector()
which.max(g1close)


g1close <- closeness(g1, weights = E(g1)$weight)
V(g1)$Close <- g1close
V(g1)$Close %>% as.vector()


g1degree <- degree(g1)
V(g1)$degree <- g1degree
sortg1degree <- sort(g1degree)
tail(sortg1degree)
V(g1)$degree

g1between <- betweenness(g1, directed = F, weights = E(g1)$weight)
V(g1)$betweenness <- g1between
sortg1between <- sort(g1between)
head(sortg1between)
tail(sortg1between)
V(g1)$betweenness

g1eigen <- evcent(g1)$vector
V(g1)$Eigen <- g1eigen
sortEigen <- sort(g1eigen)
tail(sortEigen)
V(g1)$Eigen

g1Pagerank <- page_rank(
  g1, vids = V(g1),directed = F, damping = 0.85,
  weights = E(g1)$weight) %>% unlist() #Pipe from magrittr, 

V(g1)$pagerank <- g1Pagerank # Store the score as an attribute
sortPage <- sort(g1Pagerank)
tail(sortPage)
V(g1)$pagerank


edge_density(g1) # Edge density of the entire class

# create a subgraph with only students from class 1A
A1 <- induced_subgraph(g1, V(g1)[Class =="1A"], impl = c("auto")) 
edge_density(A1)
# create a subgraph with only students from class 2B
B2 <- induced_subgraph(g1, V(g1)[Class =="2B"], impl = c("auto"))
edge_density(B2)

A2andB2 <- induced_subgraph(g1, V(g1)[Class =="2A" | Class == "2B"], impl = c("auto"))
edge_density(A2andB2)

A2andB4 <- induced_subgraph(g1, V(g1)[Class =="2A" | Class == "4B"], impl = c("auto"))
edge_density(A2andB4)

# transitivity of the entire graph
trans <- transitivity(g1, type = "global", weights = E(g1)$weight)
trans 
# transitivity of class 1A
trans1A <- transitivity(A1, type = "global", weights = E(g1)$weight)
trans1A

#These are nodes that if remove would increase the number of connected components in the system
articulation_points(g1)
components(g1) #parts where every node can get to every other node
 
DF<-as_long_data_frame(g1)

for (x in 1:242) {
  if(V(g1)[x]$Class == "1A"){
    V(g1)[x]$color <- adjustcolor("pink",.5)
  } else if(V(g1)[x]$Class == "1B"){
    V(g1)[x]$color <- adjustcolor("yellow",.5)
  } else if(V(g1)[x]$Class == "2A"){
    V(g1)[x]$color <- adjustcolor("red",.5)
  } else if(V(g1)[x]$Class == "2B"){
    V(g1)[x]$color <- adjustcolor("green",.5)
  } else if(V(g1)[x]$Class == "3A"){
    V(g1)[x]$color <- adjustcolor("brown",.5)
  } else if(V(g1)[x]$Class == "3B"){
    V(g1)[x]$color <- adjustcolor("orange",.5)
  } else if(V(g1)[x]$Class == "4A"){
    V(g1)[x]$color <- adjustcolor("purple",.5)
  } else if(V(g1)[x]$Class == "4B"){
    V(g1)[x]$color <- adjustcolor("grey",.5)
  } else if(V(g1)[x]$Class == "5A"){
    V(g1)[x]$color <- adjustcolor("yellowgreen",.5)
  } else if(V(g1)[x]$Class == "5B"){
    V(g1)[x]$color <- adjustcolor("navajowhite1",.5)
  } else {
    V(g1)[x]$color <- "blue"
  }
}

V(g1)[57]$color = "black"
V(g1)[99]$color = "black"
V(g1)[103]$color = "black"
V(g1)[158]$color = "black"
V(g1)[171]$color = "black"
V(g1)[56]$color = "black"


louvainCluster <- cluster_louvain(g1, weights = E(g1)$weight)
communities(louvainCluster) # Gives a list of all communities

set.seed(222) #Using a constant seed makes it easier to analyze the graph

plot(g1,
     edge.color = "black", #color of the edges
     vertex.label = NA, #remove label names/id
     edge.width = E(g1)$weight/300, #The widht of the edge is based on the weight
     vertex.size = V(g1)$degree/15,
     layout = layout.fruchterman.reingold(g1)
)



classHolder <- c("1A", "1B","2A","2B","3A", "3B", "4A", "4B","5A", "5B","Teacher")
colorHolder <- c("pink","yellow","red","green","brown","orange","purple","grey","yellowgreen","navajowhite1","blue")
legend(x = "bottomleft", legend = classHolder, fill = colorHolder, title = "Classes:") #legend for the graph


g1Pagerank <- g1Pagerank[1:242]
corFrame <- data.frame(g1close,g1degree, g1between, g1eigen, g1Pagerank)
cor(corFrame)
