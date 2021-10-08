
<!-- README.md is generated from README.Rmd. Please edit that file -->

# CORALIS

<!-- badges: start -->
<!-- badges: end -->

The goal of CORALIS is to statistically analyze the interactions between
non-coding RNA and their target genes . To this end CORALIS gathers
experimentally validated interactions from miRTarbase and RNAInter
database into a single database that will work as background when
performing the analysis. The hypergeometric distribution test has been
chosen to determine enriched target genes given a list of non-coding
RNAs in [miRBase](http://www.mirbase.org/search.shtml) format for
microRNA-target enrichment analysis (ie: ‘hsa-miR-3196’) or [Official
Gene Symbol](https://www.genenames.org/) format for the rest of ncRNAs
(i.e: ‘RUNX2’).

You can install both the released and the development version of CORALIS
from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("Daniel-VM/CORALIS")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
# LOAD PACKAGES
library(CORALIS)

# Load ncRNA IDs data
data(rnasID)
# help("ids")
head(ids)
#> $miRNAs
#>  [1] "hsa-miR-1291"      "hsa-miR-642a-3p"   "hsa-miR-485-5p"   
#>  [4] "hsa-miR-98-5p"     "hsa-miR-4433b-3p"  "hsa-miR-3605-3p"  
#>  [7] "hsa-miR-582-3p"    "hsa-miR-589-3p"    "hsa-miR-548ae-5p" 
#> [10] "hsa-miR-1908-5p"   "hsa-miR-1275"      "hsa-miR-423-3p"   
#> [13] "hsa-miR-197-3p"    "hsa-miR-9-5p"      "hsa-miR-7977"     
#> [16] "hsa-miR-642a-5p"   "hsa-miR-590-3p"    "hsa-miR-493-5p"   
#> [19] "hsa-miR-4531"      "hsa-miR-33a-5p"    "hsa-miR-296-5p"   
#> [22] "hsa-miR-664b-5p"   "hsa-miR-451a"      "hsa-miR-412-5p"   
#> [25] "hsa-miR-150-5p"    "hsa-miR-21-3p"     "hsa-miR-624-5p"   
#> [28] "hsa-miR-3677-3p"   "hsa-miR-20a-3p"    "hsa-miR-1249-3p"  
#> [31] "hsa-miR-889-3p"    "hsa-miR-4508"      "hsa-miR-151a-3p"  
#> [34] "hsa-miR-432-5p"    "hsa-miR-10399-3p"  "hsa-miR-342-5p"   
#> [37] "hsa-miR-381-3p"    "hsa-miR-125b-2-3p" "hsa-miR-148a-5p"  
#> [40] "hsa-miR-4772-3p"   "hsa-miR-181b-2-3p" "hsa-miR-31-5p"    
#> [43] "hsa-miR-1248"      "hsa-miR-122-5p"    "hsa-miR-23a-5p"   
#> [46] "hsa-miR-3651"      "hsa-miR-2467-5p"   "hsa-miR-11400"    
#> [49] "hsa-miR-4433b-5p"  "hsa-miR-101-5p"   
#> 
#> $lncRNAs
#>  [1] "DTX2P1-UPK3BP1-PMS2P11" "CAT4"                   "EPN2-AS1"              
#>  [4] "GHRLOS"                 "DANCR"                  "CAMTA1-IT1"            
#>  [7] "ERICH6-AS1"             "CNALPTC1"               "CT66"                  
#> [10] "CAT8"                   "FAM201A"                "CAT3"                  
#> [13] "DLG2-AS1"               "ERC2-IT1"               "FAM230J"               
#> [16] "FOXP1-IT1"              "DUBR"                   "FLJ12825"              
#> [19] "EPHA1-AS1"              "EML2-AS1"               "DIO3OS"                
#> [22] "C9orf170"               "DDC-AS1"                "CAT15"                 
#> [25] "C9orf135-DT"            "CAT9"                   "FAM242C"               
#> [28] "CAT5"                   "DOCK9-DT"               "FAM27E5"               
#> [31] "DLGAP1-AS5"             "FAM74A7"                "DDR1-DT"               
#> [34] "CDR1-AS"                "ERVK9-11"               "CDKN2B-AS1"            
#> [37] "E2F3-IT1"               "FLG-AS1"                "FLJ31356"              
#> [40] "DKFZP434K028"           "FMR1-AS1"               "DPH6-DT"               
#> [43] "ELOVL2-AS1"             "GAS1RR"                 "FLJ22447"              
#> [46] "FAM95A"                 "CASC23"                 "COL18A1-AS1"           
#> [49] "ENTPD3-AS1"             "CAT14"                 
#> 
#> $snRNAs
#>  [1] "Gm25949"    "Gm23895"    "Gm24046"    "Gm23511"    "Gm24032"   
#>  [6] "Gm25328"    "Gm22068"    "Gm23737"    "Gm24036"    "Gm25282"   
#> [11] "Gm22658"    "Gm23472"    "Gm24525"    "Gm26435"    "Gm24265"   
#> [16] "Gm23661"    "Gm25682"    "Gm25813"    "Gm24650"    "Gm22126"   
#> [21] "Gm26361"    "Gm26264"    "Gm23680"    "Gm23376"    "Gm26411"   
#> [26] "Gm24497"    "Gm23055"    "Gm23686"    "Gm22003"    "U5"        
#> [31] "U4"         "Gm25514"    "Gm23510"    "AC120136.1" "Gm25179"   
#> [36] "Gm24283"    "Gm25131"    "Gm23345"    "Gm25106"    "Gm24859"   
#> [41] "Gm23928"    "Rnu12"      "Gm23805"    "Gm22067"    "Gm23444"   
#> [46] "Rnu1b1"     "Gm26505"    "Rnu1b2"     "AC120136.3" "Gm23464"   
#> 
#> $snoRNAs
#>  [1] "Snord96a"   "Snord34"    "AL808027.2" "Gm24357"    "Gm26387"   
#>  [6] "Snord2"     "Gm22980"    "Gm24299"    "Snord88a"   "Snord107"  
#> [11] "Gm23212"    "Gm24438"    "Snord13"    "SNORA25"    "Gm23105"   
#> [16] "Gm24920"    "Gm24837"    "Gm25663"    "Gm24451"    "Snord17"   
#> [21] "Snord14d"   "Gm25894"    "Snord91a"   "Gm24044"    "Gm24355"   
#> [26] "Gm24339"    "Snord14e"   "SNORA19"    "Snora73b"   "Rnu73b"    
#> [31] "Gm24727"    "Gm22680"    "Gm25188"    "Gm25582"    "Gm26286"   
#> [36] "Gm25791"    "Snora69"    "Snord59a"   "Snord110"   "Snord15b"  
#> [41] "Gm25635"    "Gm26175"    "SNORA84"    "Gm23969"    "Gm22422"   
#> [46] "Gm25107"    "Gm25500"    "Snord55"    "DQ267101"   "Snord57"

# Run target enrichment analysis using as input a set of microARN IDs:
head(ids[["miRNAs"]])
#> [1] "hsa-miR-1291"     "hsa-miR-642a-3p"  "hsa-miR-485-5p"   "hsa-miR-98-5p"   
#> [5] "hsa-miR-4433b-3p" "hsa-miR-3605-3p"

# Execute enrcichment statistics with tienrich
tar_mir<-tienrich(input_list=ids[['miRNAs']], min = 2, fdr = 1, organism='Homo sapiens', type = 'miRNA_mRNA')
#> No targets found for:
#> hsa-miR-10399-3p
#> hsa-miR-11400
#> 
#> Analyzing  target genes with >=2 hits for'miRNA'in the input.
#> 
#> Analysis complete

# View target enrichment analysis output
# View(tar_mir)

# Output visualization
bar <- nodeVisu(obj = tar_mir,
                top=25,
                type = "barplot") %>% print
```

<img src="man/figures/README-example-1.png" width="100%" />

``` r
net <- nodeVisu(obj = tar_mir, 
                top = 25, 
                fixedsize = FALSE, # if true, deafult node size is fixed
                type = "network") %>% print
```

![Figure](../docs/imgs/Captura_img.PNG)
