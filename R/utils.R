#' @title Hypergeometric distribution test
#' @description Statistical source function for target enrichment analysis. The hypergeometric distribution is used to estimate the probability of having k interactions between the ncRNAs in the input list provided to tienrich() and their target/s gene/s (see ?tienrich()).
#' @usage
#' tiehyper(
#'  id,
#'  m,
#'  n,
#'  k,
#'  x,
#'  nhits
#' )
#' @param id character string indicating the name of the  target gene.
#' @param m integer. The number of ncRNAs that interact with gene "id".
#' @param n integer. The number of ncRNAs that do not interact with gene "id".
#' @param k integer. The number of ncRNAs in the input of tienrich (see ?tienrich) that interact with gene "id".
#' @param x vector representing the range of interactions from 0 to min(k, m).
#' @param nhits integer. Number of interactions between gene "id" and ncRNAs in the input of tienrich().
#' @details This function employs the hypergeometric distribution approach to compute the probability distribution of the interactions between the ncRNAs and their target genes (see ?dhyper for detailed info)[1].
#' Note that this function also provides the odds ratio (OR) as well as the standard error and their confidence intervals.
#' @references 1. R Core Team (2020). R: A language and environment for statistical computing. R Foundation for Statistical Computing, Vienna, Austria. URL https://www.R-project.org/.
#' @seealso
#' ?tienrich and ?dhyper
#' @return A object from class data.frame
#' @examples
#' #Define the arguments
#' id <- "BCL2" #Gene id
#' m  <- 38
#' n  <- 2561
#' N  <- n + m
#' k  <- 4
#' nhits <- 2
#' x  <- c(0:min(k,m))
#' #hypergeomentric test.
#' tiehyper(id = id, m = m, n = n, k = k, x = x, nhits = nhits)
#' @importFrom dplyr %>% mutate tibble filter
#' @importFrom Publish table2x2
#' @importFrom stats dhyper p.adjust
tiehyper<-function(id,m,n,k,x,nhits){
  #HYPERGEOMETRIC DISTRIBUTION
  probabilities<- dhyper(x = x,
                         m = m,
                         n = n,
                         k = k)
  # P(X>=nhits)
  pval.hyper <- 1 - sum(probabilities[0:nhits])
  mat <- matrix(c(nhits, (k-nhits), (m-nhits), (n-(k-nhits))), nrow = 2) # contingency table
  stats<- table2x2(mat, stats = c("table","rr", "or")) # Calculation of statistical parameters from mat

  #OUTPUT
  df <- data.frame(Gene_symbol = id,
                   pvalue = pval.hyper,
                   OR = stats$or,
                   OR.SE = stats$se.or,
                   OR.IC.lower = stats$or.lower,
                   OR.IC.upper = stats$or.upper,
                   #RR = stats$rr,
                   #RR.SE = stats$se.rr,
                   #RR.IC.low =  stats$rr.lower,
                   #RR.IC.upper =  stats$rr.upper,
                   num_interactions = nhits
                   )
  return(df)
}
#' @title info_input
#' @description Check whether the input list in tienrich() is in valid format.
#' @param a the argument 'input_list' provided to tienrich()
#' @param c the argument 'type' provided to tienrich()
#' @param b the argument 'organism' provided to tienrich()
#' @param e the argument 'min' provided to tienrich()
info_args<-function(a, b, c, e){
  if(!is.vector(a)){
    stop("Input must be provided in vector format.\n", call. = FALSE)
  }
  if(!(b %in% c('miRNA_mRNA', 'lncRNA_mRNA', 'snRNA_mRNA', 'snoRNA_mRNA'))){
    stop("Invalid type argument. Available options \n'miRNA_mRNA'\n'lncRNA_mRNA'\n'snoRNA_mRNA'\n'snRNA_mRNA'\nSee ?tienrich().\n", call. = FALSE)
  }
  sp<-availsp()
  if(!(c %in% sp$Species)){
    stop("No organism name found. Run availsp() to see supported species.\n", call. = FALSE)
  }
  if(e == 0){
    stop("'min' should be greater than 0 (min > 0)\n", call. = FALSE)
  }
}
#' @title info_items
#' @description Identification of target/s gene/s for the ncRNAs provided in the tienrich() function.
#' @param k vector containing the ncRNAs in the input list of tienrich() for which there have been found target genes.
#' @param l vector containing ALL ncRNAs in the user's input list.
#' @return A subset of ncRNAs IDs for which no target genes are detected.
#' @importFrom dplyr %>%
info_items<-function(k, l){
  found <- k %>% unique(.) %>% length(.)
  if(found == 0){
    stop("No targets were found for any item in the input.\n",call. = FALSE)
  }else if(found == length(l)){
    #message("Interactions found for all items in the input.\n")
    return("Empty")
  }else{
    not_found<-subset(l, !(l%in%k))
    message(paste0("No targets found for:\n", paste0(not_found, collapse = "\n"),sep=""))
    return(not_found)
  }
}
#' @title info_targets
#' @details Informs about the target enrichment analysis details according to the ncRNAs in the input list of tienrich.
#' @param a integer. Inherits the "min" argument from tienrich() function.
#' @param b character string. Inherits the "type" argument from tienrich() function.
#' @param c vector of target genes found for ncRNAs in the input.
#' @return A vector of target genes for the ncRNAs in the input.
#' @importFrom dplyr %>%
info_targets<-function(a, b, c){
  if(a==1){
    message("Analyzing all target genes for ", gsub("_mRNA","",b)," in the input.\n")
    d <-unique(c)
  }
  if(a > 1){
    if(TRUE %in% duplicated(c) == FALSE){
      stop("No ncRNAs in the input with >= interactions. Set min=1...")
    }else{
      message(paste0("\nAnalyzing  target genes with >=",  a," hits for", gsub("_mRNA","",b) ,"in the input.\n", sep=""))
      d <- which(table(c) >= a) %>%
        names(.) %>%
        unique(.)
    }
  }
  return(d)
}
