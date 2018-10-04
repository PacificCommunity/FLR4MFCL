#FLR4MFCL - R4MFCL built with FLR classes
#Copyright (C) 2018  Rob Scott


#' qts
#'
#' Returns a quarterly time series from a seasonally structured FLQuant.
#'
#' @param quant:  An FLQuant object 
#' 
#'
#' @return An object of class FLQuant
#'
#' @examples
#' flq(stock.n(ple4))
#'
#' @export

qts <- function(quant){
  
  if(!is.FLQuant(quant))
    stop('quant must be an object of class FLQuant')
  
  ssns <- dim(quant)[4]
  if(ssns<=1){
    warning("object has only 1 season: nothing changed")
    return(quant)
  }
  
  q2 <- aperm(quant, c(4,2,1,3,5,6))
  q3 <- array(c(q2), dim=c(dim(q2)[3], dim(q2)[1]*dim(q2)[2], dim(q2)[4], 1, dim(q2)[5:6]))
  
  dimnames(q3) <- list(age = dimnames(quant)$age,
                       year= as.character(rep(as.numeric(dimnames(quant)$year),each=ssns)+(1/(2*ssns))*seq(1, by=2, length.out=ssns)),
                       unit= dimnames(quant)$unit,
                       season="all",
                       area= dimnames(quant)$area,
                       iter= dimnames(quant)$iter)
  
  return(as.FLQuant(q3))
  
}