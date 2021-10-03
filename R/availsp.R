#' @title List of available species for ncRNA-target enrichment analysis
#' @description Prints a table with the supported species and the overall number of experimentally validated interactions by specie and ncRNA type that tienrich() uses in the statistical analysis.
#' @usage availsp()
#' @details Experimentally validated interactions between ncRNAs and their gene targets are scanned from the following databases:
#' @details   - miRTarbase: miRNA-target interactions.
#' @details   - RNAInter:  lncRNA, snoRNA and snRNA target interactions
#' @return  An object of class data.frame
#' @export
availsp<-function(){
  f<-read.table("data/available_species/Supported_species.csv", sep=",", header =T)
  return(f)
}
