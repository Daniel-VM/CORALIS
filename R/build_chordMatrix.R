#' @title Adapt CORALIS object
#' @description Data frame transformation of CORALIS object into chrod diagram format
#' @param obj an object from class CoralisResult or data.frame.
#' @param top integer indicating the top interactions to be represented in the graph. Max allowed 25 interactions.
build_chordMatrix<-function(mti){

  mirs<-strsplit(mti$ncRNAs, " / ")
  for (i in 1:length(mti$Gene_symbol)){
    names(mirs)[i]<-mti$Gene_symbol[i]
  }

  cc=1
  ls_mat<-list()
  for (x in 1:length(mirs)){
    df<-data.frame(mir=mirs[[x]],
                   gene=rep(names(mirs)[x], length(mirs[[x]])))
    ls_mat[[cc]]<-df
    cc=cc+1
  }
  mat<-do.call(rbind, ls_mat)
  return(mat)
}
