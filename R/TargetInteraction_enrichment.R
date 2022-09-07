#' @title non-coding RNA target enrichment analysis
#' @description Conducts a target enrichment analysis for a set of ncRNAs. Only experimentally validated interactions between ncRNAs and their target genes are considered (see Details section).
#' @usage tienrich(
#'  input_list,
#'  type,
#'  organism,
#'  min = 1,
#'  fdr = 1
#' )
#' @param input_list a vector of ncRNAs IDs in miRBase format for microRNAs (ie: 'hsa-miR-3196') or Official Gene Symbol format for lncRNAs, snoRNAs or snRNAs (i.e: 'RUNX2').
#' @param type character string indicating the desired type of ncRNA target enrichment analysis (ie:'miRNA_mRNA' for microRNA-target interactions or 'lncRNA_mRNA' for lncRNA-target interactions, 'snoRNA_mRNA' for snoRNA-target interactions or 'snRNA_mRNA' for snRNA-target interactions).
#' @param organism character string specifying the organism name (i.e: "Homo sapiens"). Run availsp() to list supported organisms and a summary of interactions by specie and ncRNA type.
#' @param min integer specifying the minimum number of interactions that target genes must have with the ncRNAs in the input.
#' @param fdr adjusted p-value (Benjamin & Hochberg approach) threshold at which enriched target-genes are found.
#' @details
#' The tienrich function analyses the interactions between ncRNAs and their target genes thought enrichment/overrepresentation analysis.
#' To this end, this function employs the hypergeometric distribution test to estimate the p-values of the interaction between the ncRNAs provided in the input_list and their target genes.
#' So far, only experimentally validated interactions listed in miRTarbase (for microRNAs-target interactions)[1] and RNAInter Database (for lncRNAs, snoRNAs or snRNAs target interactions)[2] are used as background in the enrichment analysis.
#' Additionally, tienrich provides other interesting statistical parameters such the odds ratio (OR), the conficence intevalsand the adjusted p-value (false discovery rate -FDR- using Benjamin-Hochberg correction).
#' @examples
#' \dontrun{
#'# vector of ncRNA IDs
#'data(rnasID)
#'head(ids)
#'# Homo sapiens -----> ids[['miRNAs']]
#'# Homo sapiens -----> ids[['lncRNAs']]
#'# Mus musculus -----> ids[['snRNAs']]
#'# Mus musculus -----> ids[['snoRNAs']]
#'
#'# Run target enrichment analysis:
#'tar_mir<-tienrich(input_list=ids[['miRNAs']],
#'                  min = 2,fdr = 1,organism='Homo sapiens',type = 'miRNA_mRNA')
#'tar_lnc<-tienrich(input_list=ids[['lncRNAs']],
#'                  min = 2,fdr = 1,organism='Homo sapiens',type = 'lncRNA_mRNA')
#'tar_sn <-tienrich(input_list=ids[['snRNAs']],
#'                  min = 2,fdr = 1,organism='Mus musculus',type = 'snRNA_mRNA')
#'tar_sno<-tienrich(input_list=ids[['snoRNAs']],
#'                  min = 2,fdr = 1,organism='Mus musculus',type = 'snoRNA_mRNA')
#'}
#' @references 1. Huang HY et al. 2020. miRTarBase 2020: updates to the experimentally validated microRNA-target interaction database. Nucleic Acids Res. 2020 Jan 8;48(D1):D148-D154. doi: 10.1093/nar/gkz896. PMID: 31647101; PMCID: PMC7145596.
#' @references 2. Lin Y et al. 2020. RNAInter in 2020: RNA interactome repository with increased coverage and annotation. Nucleic Acids Res. 2020 Jan 8;48(D1):D189-D197. doi: 10.1093/nar/gkz804. PMID: 31906603; PMCID: PMC6943043.
#' @return An object of class CoralisResult.
#' @author Daniel Valle-Millares
#' @importFrom dplyr filter %>% mutate tibble rename select arrange pull
#' @importFrom RSQLite SQLite
#' @importFrom DBI dbConnect dbGetQuery dbDisconnect
#' @importFrom methods setClass new
#' @importFrom stats p.adjust
#' @export
tienrich<-function(input_list, type, organism, min=1,  fdr=1){
  # Input processing
  info_args(a = input_list, b = type, c = organism, e = min)
  #.onLoad = function (libname, pkgname) {
  #  datafile = system.file("extdata", "CORALIS_db.sqlite", package = "CORALIS")
  #  assign('datafile', datafile, envir = .GlobalEnv)
  #}
  # SQLite connection
  db_file <- system.file("extdata", "CORALIS_db.sqlite", package = "CORALIS")
  lite  <- SQLite()
  #con   <- dbConnect(lite, dbname = .onLoad())
  con   <- dbConnect(lite, dbname = db_file)
  query <- "SELECT Genes.name AS 'genes', Ncrnas.name AS 'ncrnas'
            FROM Source JOIN Organism JOIN Ncrnas JOIN Mti JOIN Genes
            ON Ncrnas.source_id = Source.id
            AND Ncrnas.organism_id = Organism.id
            AND Mti.ncrna_id = Ncrnas.id
            AND Mti.gene_id = Genes.id "

  # Reformatting ncRNA IDs into SQLite vector
  ncr  <- paste0("'", input_list, "'", collapse=", ") %>% paste0("(", ., ")")
  org  <- paste0("'", organism, "'", sep="")
  type <- paste0("'", type, "'", sep="")

  # SQLite query. Returns ncRNA-target (i.e: miRNA-gene) interactions.
  my_mti     <- dbGetQuery(con, paste0(query, "WHERE Source.name = ", type, " AND Organism.name = ", org, " AND Ncrnas.name IN ", ncr))
  not_my_mti <- dbGetQuery(con, paste0(query, "WHERE Source.name = ", type, " AND Organism.name = ", org, " AND Ncrnas.name NOT IN ", ncr))

  # SQLite query. Returns the number of ncRNAs (i.e: miRNAs) annotated in miRTarbase or RNAInter database without repetition.
  total_mir <- as.numeric(dbGetQuery(con, paste0("SELECT COUNT(*)
                                                FROM Source JOIN Organism JOIN Ncrnas
                                                ON Ncrnas.source_id = Source.id
                                                AND Ncrnas.organism_id = Organism.id
                                                WHERE Source.name = ", type, " AND Organism.name = ", org)))

  dbDisconnect(con) # closing database connection
  # Get info from items in the input list
  nf <- info_items(k= my_mti$ncrnas, l=input_list)

  # Get info from targets that susceptible of ncRNA-target enrichment analysis
  list_of_genes <- info_targets(a = min , b = type, c = my_mti$genes)

  # Outputs target enrichment analysis. Tasks: 1) identification of enrichment analysis parameters; 2) Enrichment analysis execuetion through tienrich()
  do_enrichtment<-function(i){

    gname <- i
    i     <- paste0("'",i,"'") # reformatting target gene id

    # Number of interactions between ncRNAs in the input and gene i
    hits     <- filter(my_mti, genes %in% gname) %>% pull(.)
    num_hits <- length(hits)

    # HPERGEOMETRIC PARAMETERS
    g  <- length(input_list)                        # Number of items in the input list provided by the user
    N  <- total_mir                                 # The total number of ncRNAs with annotation in MIRTARBASE or RNAInter
    m1 <- subset(my_mti, genes==gname)$ncrnas %>% unique(.) %>% length(.)
    m2 <- subset(not_my_mti, genes==gname)$ncrnas %>% unique(.) %>% length(.)
    m  <- m1+m2                                     # Total number of ncRNAs (in the source databases) that interacts with  gene "i"
    n  <- N-m                                       # Total number of ncRNAs (in the source databases) that interacts with other genes != than gene "i"
    k  <- my_mti$ncrnas %>% unique(.) %>% length(.) # Total number of ncRNAs in the user's input list that interacts with gene "i"
    x  <- 0:min(k,m)                                # Range from 0 to k

    # RUN STATISTICS / Hypergeometric distribution test
    resi <- tiehyper(id=gname, m=m, n=n, k=k, x=x, nhits=num_hits)
    resi$num_interactions <- num_hits
    resi$ncRNAs <- paste(hits, collapse = ' / ')
    return(resi)
  }

  # Target-enrichment analysis over each target gene for the ncRNAs in the input list
  enrichment <- lapply(list_of_genes, do_enrichtment) %>%
                do.call(rbind,.) %>%
                mutate(FDR=p.adjust(.$pvalue,method = "BH")) %>%
                filter(.,FDR <= fdr ) %>%
                dplyr::arrange(.,FDR) %>%
                dplyr::select(
                              ., Gene_symbol, num_interactions,
                              ncRNAs, pvalue, FDR,
                              OR, OR.SE, OR.IC.lower, OR.IC.upper
                              #RR, RR.SE, RR.IC.low, RR.IC.upper
                              )

  # This stores ncRNA-target enrichment analysis into a object from  class 'CoralisResult'
  setClass("CoralisResult", slots = list(results="data.frame", not_found=c("character", NULL)))
  out<-new(Class = "CoralisResult", results = enrichment, not_found = nf)

  message("\nAnalysis complete\n")
  return(out)
}
