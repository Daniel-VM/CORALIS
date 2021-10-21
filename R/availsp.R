#' @title List of available species for ncRNA-target enrichment analysis
#' @description Prints a table with the supported species and the overall number of experimentally validated interactions by specie and by ncRNA type.
#' @usage availsp()
#' @importFrom utils read.table
#' @details Experimentally validated interactions between ncRNAs and their gene targets are scanned from the following databases:
#' @details   - miRTarbase: miRNA-target interactions.
#' @details   - RNAInter:  lncRNA, snoRNA and snRNA target interactions
#' @return  An object of class data.frame
#' @export
availsp<-function(){
  data("targetsummary")
  return(intersummary)
}
