## ----setup, include = FALSE, message=FALSE------------------------------------
require(knitr)
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
opts_knit$set(root.dir = normalizePath('../'))

#Loading PKG
library(knitr)
library(kableExtra)
library(stringr)
library(dplyr)
require(prettydoc)
devtools::document()

## ----Table_1, echo=FALSE------------------------------------------------------
# List of available interactions with experimental support by species
table_nums <- captioner::captioner(prefix = "Table")
tab.1_cap  <- table_nums(name = "Table 1", 
                         caption = "Supported species in CORALIS for ncRNA-gene target enrichment analysis. Each entry indicates the number and type of ncRNA-target interaction in CORALIS by specie.")
availsp() %>% 
  kbl(caption = tab.1_cap) %>%
  kable_classic(full_width = F, html_font = "Cambria")

## ----Table2, echo = FALSE-----------------------------------------------------
# Build 2x2 matrix
mat<-matrix(0L, nrow = 3, ncol = 3)
colnames(mat)<-c(" ncRNAs in input ", "NOT ncRNAs in input","Total")
rownames(mat)<-c(" gene i", " NOT gene i", "Total")
mat[,1]<-c("a","c","a+c")
mat[,2]<-c("b","d","b+d")
mat[,3]<-c("a+b","c+d","N=a+b+c+d")
df<-as.data.frame(mat)

# Setup title
tab.2_cap  <- table_nums(name = "Table 2", 
                         caption = "The 2X2 contingenc table for gene i analysis as potential gene-target of ncRNAs that user set in the input with the cell fequencies represented as a, b, c and d, and the marginal totals as a+b, c+d, a+b, and c+b")

# print table in pretty format
df %>% 
    kbl(caption = tab.2_cap) %>%
    kable_classic(full_width = F, html_font = "Cambria") 


## ----Installation, eval=FALSE-------------------------------------------------
#  # install.packages("devtools")
#  devtools::install_github("Daniel-VM/CORALIS")
#  

## ----Load_library, eval=FALSE-------------------------------------------------
#  library(CORALIS)

## ----load_dataset-------------------------------------------------------------
# Load rnasID object 
data("rnasID")

# rnasID contains the IDs of several ncRNAs (See: help(ids)). In this example we are going to choose 50 miRNAs where the first five have significantly higher expression levels after treatment (deferentially expressed miRNAs).
mirs<-ids[["miRNAs"]][1:9]
head(mirs)


## ----input_check--------------------------------------------------------------
# check mirs class
class(mirs)

# check mirs format
is.vector(mirs)


## ----tienrich-----------------------------------------------------------------
# miRNA-target enrichment analysis with tienrich()
genetar <- tienrich( 
                    input_list = mirs, 
                    type = "miRNA_mRNA", 
                    organism = "Homo sapiens", 
                    min = 2, 
                    fdr = 0.05  
                    ) 


# Exploring tienrich output.
class(genetar)
genetar@results %>% head()
genetar@not_found


## ----Target_barplot-----------------------------------------------------------
# Barplot of targets genes
bar <- nodeVisu(obj = genetar,top = 30, type = "barplot")
print(bar)

## ----Target_network-----------------------------------------------------------
# Interactive 3D network
net <- nodeVisu(obj = genetar, 
                top = 30, 
                fixedsize = FALSE, # if true, default node size is fixed
                type = "network")
net

## ----Functional_GOanalysis, message=FALSE-------------------------------------
# Load dependencies for pathway enrichment analysis
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

#if (!require("biomaRt", quietly = TRUE))
#  BiocManager::install("biomaRt")
library(biomaRt)

#if (!require("clusterProfiler", quietly = TRUE))
#  BiocManager::install("clusterProfiler")
library(clusterProfiler)

#if (!require("org.Hs.eg.db", quietly = TRUE))
#  BiocManager::install("org.Hs.eg.db")
library(org.Hs.eg.db)

# 1- convert gene target's symbol into ENTREZID format
gene <- genetar@results$Gene_symbol[1:25] # top 25 targets

# Use Homo sapiens dataset
ensembl <-useDataset("hsapiens_gene_ensembl",
                     mart = useEnsembl("ensembl","oaries_gene_ensembl"))

# Get the gene IDs
gene_id <- unique(getBM(attributes = c("hgnc_symbol", "entrezgene_id"),    
                        filters = "hgnc_symbol",
                        values = gene,
                        mart = ensembl))

# 2- Functional enrichment analysis (GO terms)
biopro <- enrichGO(gene          = gene_id$entrezgene_id,
                   keyType       = "ENTREZID",
                   OrgDb         = org.Hs.eg.db,
                   ont           = "BP",
                   pAdjustMethod = "fdr",
                   pvalueCutoff  = 0.05,
                   qvalueCutoff  = 0.05)

# Let's filter GO temrs which FDR (p.adjust) < 0.05
s_biopro <- subset(biopro@result, p.adjust < 0.05)
head(s_biopro, n = 10)


## ----GOterm_inspect-----------------------------------------------------------
# Filter the miRNA target enrichment matrix to identify the miRNAs involved in the deregulation of genes in GO:1904646
genes_go1904646_entrezid <- subset(s_biopro, ID == "GO:1904646") %>%
                            dplyr::select(., geneID) %>%
                            str_split(., "/", simplify = FALSE) %>%
                            unlist(.)

genes_go1904646_symbol <- subset(gene_id, entrezgene_id %in% genes_go1904646_entrezid) %>% 
                          dplyr::select(., hgnc_symbol) %>% 
                          pull(.)

# Fin the miRNAs involved in the regulation of genes in GO:1904646
mirnas_go1904646<- subset(genetar@results, Gene_symbol %in% genes_go1904646_symbol)
mirnas_go1904646

## -----------------------------------------------------------------------------
# Plot 3D network of interactions between genes in GO:1904646 and the deregulated miRNAs.
net_go1904646<- nodeVisu(obj = mirnas_go1904646,
                         type= "network")
net_go1904646

## ----info_session-------------------------------------------------------------
sessionInfo()

