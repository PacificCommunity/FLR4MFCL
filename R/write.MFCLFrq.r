#FLR4MFCL - R4MFCL built with FLR classes
#Copyright (C) 2018  Rob Scott

##########################################################################
#
#  UNEXPORTED FUNCTIONS
#
##########################################################################

write.stat <- function(x, file, append=F, ...){

  if(file.exists(file) && append==F)
    file.remove(file)
  if(!file.exists(file))
    file.create(file)

  cat("# \n# Definition of fisheries \n# \n", file=file, append=T)
  cat("# Number of   Number of   Use generic   Number of     Year1 \n",  file=file, append=T)
  cat("#  Region     Fisheries    diffusion    tag groups \n", file=file, append=T)
  cat(paste("", n_regions(x), n_fisheries(x), as.numeric(generic_diffusion(x)), n_tag_groups(x), sep='\t\t\t\t\t'), file=file, append=T)
  cat(paste('\t\t\t\t', range(x)['minyear'], "0", as.numeric(frq_age_len(x)), n_recs_yr(x), rec_month(x), frq_version(x), '\n', sep="\t"), file=file, append=T)
  cat("# Relative Region Size \n", file=file, append=T)
  write.table(matrix(region_size(x),nrow=1), file=file, append=T, col.names=F, row.names=F)
  cat("#\n# Region in which each fishery is located \n", file=file, append=T)
  write.table(t(matrix(region_fish(x))), file=file, append=T, col.names=F, row.names=F)
  cat("#\n# \n# Incidence matrix \n", file=file, append=T)
  write.table(move_matrix(x), file=file, append=T, col.names=F, row.names=F, na=" ")
  cat("#\n# \n# Data flags (for records 1, 0=catch in number; 1=catch in weight) \n", file=file, append=T)
  write.table(data_flags(x), file=file, append=T, col.names=F, row.names=F)
#  if(n_regions(x)>1){
    cat("# Season-region flags \n", file=file, append=T)
    write.table(season_flags(x), file=file, append=T, col.names=F, row.names=F)
#  }
  cat("# Number of movements per year \n", file=file, append=T)
  cat(paste(n_move_yr(x), "\n"), file=file, append=T)
  cat("# Weeks in which movement occurs \n", file=file, append=T)
  write.table(matrix(move_weeks(x),nrow=1), file=file, append=T, col.names=F, row.names=F)
}



write.len <- function(x, file, append=T, ...){

  if(file.exists(file) && append==F)
    file.remove(file)

  if(!file.exists(file)){
    file.create(file)
    cat("Warning: There is no existing file. Your .frq file will be incomplete")
  }

  cat("# fishery data \n# \n# \n", file=file, append=T)
  cat("# Datasets / LFIntervals  LFFirst  LFWidth  LFFactor / WFIntervals  WFFirst  WFWidth \n",file=file, append=T)
  ## Automatically set the number of datasets to the length of the output freq ragged array
  lf_range(x)["Datasets"]=dim(unique(cateffpen(x)[,1:4]))[1]
  cat(paste(as.vector(lf_range(x)), collapse="      "), file=file, append=T)
  cat("\n# age_nage   age_age1 \n", file=file, append=T)
  cat(paste(paste(as.vector(age_nage(x)), collapse="      "),"\n"), file=file, append=T)

  ## check for duplicate entries in all three dataframes
  if (any(duplicate(catpeneff(x)[,1:4]))) stop("There was a duplicate in the catch effort and penalty data frame")
  if (any(duplicate(lnfrq(x)[,1:4]))) stop("There was a duplicate in the length frequency data frame")
  if (any(duplicate(wtfrq(x)[,1:4]))) stop("There was a duplicate in the weight frequency data frame")

  cep=catpeneff(x)
  lnfrq=lnfrq(x)
  wtfrq=wtfrq(x)
  LnMatcher=match(interaction(lnfrq[,1:4]),interaction(cep[,1:4]),nomatch=0)
  if(any(LnMatcher==0)) warning("There are entries in the length composition data frame that aren't in the catch effort penalty data frame")
  WtMatcher=match(interaction(wtfrq[,1:4]),interaction(cep[,1:4]),nomatch=0)
  if(any(WtMatcher==0)) warning("There are entries in the weight composition data frame that aren't in the catch effort penalty data frame")
  NoMatch=!(1:dim(cep)[1]%in%c(LnMatcher,WtMatcher))

  output=apply(cep,1,paste,collapse=' ')
  output[LnMatcher]=paste(output[LnMatcher], apply(lnfrq[,-4:-1],1,paste,collapse=' '),sep=' ')
  output[WtMatcher]=paste(output[WtMatcher], apply(wtfrq[,-4:-1],1,paste,collapse=' '),sep=' ')
  output[NoMatch]=paste0(output[NoMatch]," -1 -1")

  writeLines(output,file)



}



##########################################################################
#
#  METHODS
#
##########################################################################




#' @rdname write-methods
#' @aliases write
setMethod("write", signature("MFCLFrqStats"), function(x, file, append=F, ...){

  write.stat(x=x, file=file, append=append, ...)
})



#' @rdname write-methods
#' @aliases write
setMethod("write", signature("MFCLLenFreq"), function(x, file, append=T, ...){

  write.len(x=x, file=file, append=append, ...)
})




#' @rdname write-methods
#' @aliases write
setMethod("write", signature("MFCLFrq"), function(x, file, append=F, ...){

  write.stat(x=x, file=file, append=append, ...)
  write.len(x=x, file=file, append=T, ...)
})



