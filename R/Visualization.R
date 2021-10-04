#' @title nodeNet
#' @description Interactive Network graph representing the ncRNA-target interactions.
#' @param obj an object from class CoralisResult or data.frame.
#' @param top integer indicating the top interactions to be represented in the graph.
#' @param fixedsize Bolean. If fixedsize=True allows for interactive network, otherwise network motion is restricted.
#' @importFrom networkD3 forceNetwork JS
#' @import htmlwidgets
#' @importFrom dplyr %>% select group_by group_split distinct
#' @importFrom stringr str_split
#' @importFrom scales rescale
#' @importFrom utils head
#' @import ggplot2
#' @import viridis
#' @source The network graph has been built under the networkD3 package [1].
#' @return A object from class networkD3
#' @references 1. J.J. Allaire, Christopher Gandrud, Kenton Russell and CJ Yetman (2017). networkD3: D3 JavaScript Network Graphs from R. R package version 0.4. https://CRAN.R-project.org/package=networkD3
nodeNet<-function(obj, top, fixedsize){
  # 1.Set top interactions
  top <- ifelse(is.null(top), yes = nrow(obj), no = top)

  sets <- obj %>%
    head(n = top) %>%
    select(., Gene_symbol, ncRNAs, FDR, num_interactions) %>%
    group_by(Gene_symbol) %>%
    dplyr::group_split(.)

  # Build network
  networkData<-lapply(sets, function(i){
    spl<- data.frame(src=str_split(i$ncRNAs, " / ") %>% unlist(.))
    spl$target<-i$Gene_symbol
    spl$fdr<-i$FDR
    spl$radi<-i$num_interactions
    return(spl)}) %>%
    do.call(rbind, .) %>%
    select(., target, src, fdr, radi)

  # nodes
  nodes <- data.frame(name = unique(c(networkData$src, networkData$target)))

  # groups
  nodes$group <- factor(nodes$name %in% networkData$src, labels = c("Target genes", "ncRNAs"))

  # Custom nodes radius
  if(fixedsize==FALSE){
    src_size<- unique(networkData$src) %>%
      length() %>%
      rep(5,.)
    target_size <- distinct(networkData, target,radi)$radi  %>%
      rescale(.,c(1,30))

    nodes$radius <- c(src_size, target_size)
  }else{
    nodes$radius<-ifelse(nodes$group == "ncRNAs", 5, 2)
  }

  # edges
  links <- data.frame(source = match(networkData$src, nodes$name) - 1,
                      target = match(networkData$target, nodes$name) - 1)
  # Custom edges
  links$width <- log(networkData$fdr) %>% abs(.) %>% rescale(.,c(1,10)) %>% round(., digits = 2)

  #plot
  forceNetwork(Links = links,
               Nodes = nodes,
               Nodesize = "radius",
               Source = "source",
               Target = "target",
               NodeID ="name",
               Group = "group",
               Value = 'width',
               fontFamily = "mono",
               linkColour = "#A9A9A9",
               #arrow = TRUE,
               legend = TRUE,
               opacity = 1, opacityNoHover = 1, zoom=T,
               linkDistance = networkD3::JS("function(d) { return 10*d.value; }"),
               radiusCalculation = JS("Math.sqrt(d.nodesize)+2"),
               colourScale = JS('d3.scaleOrdinal()
               .domain(["ncRNAs", "Target genes"])
               .range(["#FF6900", "#694489"]);')) %>% return(.)
}
#' @title nodeBar
#' @description Create a barplot to visualize the number of interactions between ncRNAs and their target genes according to the ncRNA-target enrichment analysis (see ?tienrich).
#' @inheritParams nodeNet
#' @importFrom stats reorder
#' @return A object from class ggplot
nodeBar<-function(obj, top){
  top <- ifelse(is.null(top), yes = nrow(obj), no = top)
  obj <- obj[c(1:top),]
  g<-ggplot(obj,aes(y=as.numeric(num_interactions), x=reorder(x = as.factor(Gene_symbol),FDR), fill=FDR))+
    geom_bar(alpha=0.8, stat="identity", color = "gray27") +
    #scale_color_viridis(option = "C",direction = 1) +
    scale_fill_viridis(option  = "C",direction = 1) +
    ggtitle("Number of interactions per target gene")+
    xlab("Gene names") +
    ylab("Nº interactions") +
    theme(panel.border = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          axis.text.y = element_text(size = (9-(top/25))),
          axis.line = element_line(colour = "black"),
          plot.title = element_text(size=14, face="bold.italic"),
          axis.title.x = element_text(size=14, face="bold"),
          axis.title.y = element_text(size=14, face="bold"))+
    scale_x_discrete(expand = c(0,0))+
    scale_y_continuous(expand = c(0,0))+
    coord_flip()
  return(g)
}
#' @title nodeVisu
#' @description Visualization of ncRNA-target enrichment analysis.
#' @inheritParams nodeNet
#' @param type string specifying the type of visual representation. So far "network" and "barplot" are available.
#' @examples
#' # vector of ncRNA IDs
#' data(rnasID)
#' head(ids)
#' # Target enrichment analysis:
#' tar_mir <- tienrich(input_list = ids[['miRNAs']],
#'                     min = 2, fdr = 1, organism = 'Homo sapiens', type = 'miRNA_mRNA')
#' # To visualize the target enrichment analysis as barplot.
#' bar <- nodeVisu(obj = tar_mir, top = 25, type = "barplot")
#' print(bar)
#' # To visualize the target enrichment analysis as network graph.
#' net <- nodeVisu(obj = tar_mir, top = 25, type = "network")
#' print(net)
#' @export
nodeVisu <-function(obj, top=NULL, type, fixedsize=TRUE){
  # 1.1 Parsing inputs
  if(class(obj)=="CoralisResult"){
    obj <- obj@results
  }else{
    obj <- obj
  }
  if(!(type %in% c("network","barplot"))){
    stop("Invalid argument 'type'. See ?nodeVisu().")
  }
  # 2- Choosing graphics
  if(type == "network"){
    return(nodeNet(obj, top, fixedsize))
  }
  if(type == "barplot"){
    return(nodeBar(obj, top))
  }
}
