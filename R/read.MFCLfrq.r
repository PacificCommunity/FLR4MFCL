


#' MFCL Vital Statistics
#'
#' Extracts the essential ranges and dimensions from the frq file
#'
#' @param frqfile A character string giving the name and path of the frq file to be read 
#' @param cex character expansion for the text (\code{"hsv"} or \code{"cluster"})
#' @param mar margin paramaters; vector of length 4 (see \code{\link[graphics]{par}})
#'
#' @return An object of class MFCLVitalStats
#'
#' @examples
#' read.MFCLVitalStats("C://R4MFCL//test_data//skj_ref_case//skj.frq")
#'
#' @export


read.MFCLVitalStats <- function(frqfile){
  
  res <- new("MFCLVitalStats")
  
  quiet=TRUE
  tt <- scan(frqfile, nlines=400, comment.char='#', quiet=quiet)
  
  res@n_regions <- tt[1]
  res@n_fisheries <- tt[2]
  res@generic_diffusion <- as.logical(tt[3])
  res@n_tag_groups <- tt[4]
  res@range['minyear'] <- tt[5]
  res@frq_age_len <- as.logical(tt[7])
  res@n_recs_yr   <- tt[8]
  res@rec_month   <- tt[9]
  res@frq_version <- tt[10]
  
  frq  <- readLines(frqfile)  
  line <- grep("Relative Region Size", frq)+1
  dat  <- as.numeric(unlist(strsplit(frq[line], split=" ")))
  res@region_size <- FLQuant(dat[!is.na(dat)], 
                             dimnames=list(len='all',year='all',unit='unique',
                                           season='all',area=as.character(1:res@n_regions)))
  
  line <- grep("Region in which each fishery is located", frq)+1
  dat  <- as.numeric(unlist(strsplit(frq[line], split=" ")))
  res@region_fish <- FLQuant(dat[!is.na(dat)], 
                             dimnames=list(len='all',year='all',unit=as.character(1:res@n_fisheries),
                                           season='all',area='all'))
  
  line <- grep("Incidence matrix", frq)
  res@move_matrix <- matrix(NA, nrow=res@n_regions, ncol=res@n_regions)
  for(i in 1:(res@n_regions-1)){
    dat <- as.numeric(unlist(strsplit(frq[line+i], split=" ")))
    res@move_matrix[i,(i+1):res@n_regions] <- dat
  }
    
  line <- grep("Data flags", frq)
  res@data_flags <- matrix(scan(frqfile, nlines=5, skip=line, quiet=quiet), nrow=5, ncol=res@n_fisheries, byrow=T)
  
  line <- grep("Season-region flags", frq)
  res@data_flags <- matrix(scan(frqfile, nlines=res@n_recs_yr, skip=line, quiet=quiet), 
                           nrow=res@n_recs_yr, ncol=res@n_regions, byrow=T)
  
  res@n_move_yr <- as.numeric(frq[grep("Number of movements per year", frq)+1])
  
  line <- grep("Weeks in which movement occurs", frq)
  res@move_weeks <- scan(frqfile, nlines=1, skip=line, quiet=quiet)
  
  return(res)
}



read.MFCLLenFreq <- function(frqfile){
  
  res <- new("MFCLLenFreq")
  
  frq  <- readLines(frqfile)  
  
  line <- grep("Datasets", frq)+1
  dat  <- as.numeric(unlist(strsplit(frq[line], split="[[:blank:]]+")))
  dat  <- dat[!is.na(dat)]
  names(dat) <- names(res@lf_range)
  res@lf_range <- dat
  
  line <- grep("age_nage", frq)+1
  dat  <- as.numeric(unlist(strsplit(frq[line], split="[[:blank:]]+")))
  dat  <- dat[!is.na(dat)]
  names(dat) <- names(res@age_nage)
  res@age_nage <- dat
  
  nbins <- res@lf_range['LFIntervals']
  
  lffrq <- frq[(line+1):length(frq)]
  lfobs <- as.numeric(unlist(lapply(lapply(lapply(lffrq, strsplit, split="[[:blank:]]+"),el,1),el, 8))) != -1
  
  arr <- array(as.numeric(unlist(lapply(lffrq[lfobs], strsplit, split="[[:blank:]]+"))),dim=c(61,5))[8:61,]
  
  df <- data.frame(year = rep(as.numeric(unlist(lapply(lapply(lapply(lffrq[lfobs], strsplit, split="[[:blank:]]+"),unlist),el,1))),each=nbins),
                   month= rep(as.numeric(unlist(lapply(lapply(lapply(lffrq[lfobs], strsplit, split="[[:blank:]]+"),unlist),el,2))),each=nbins),
                   week = rep(as.numeric(unlist(lapply(lapply(lapply(lffrq[lfobs], strsplit, split="[[:blank:]]+"),unlist),el,3))),each=nbins),
                   fish = rep(as.numeric(unlist(lapply(lapply(lapply(lffrq[lfobs], strsplit, split="[[:blank:]]+"),unlist),el,4))),each=nbins),
                   catch= rep(as.numeric(unlist(lapply(lapply(lapply(lffrq[lfobs], strsplit, split="[[:blank:]]+"),unlist),el,5))),each=nbins),
                   effort=rep(as.numeric(unlist(lapply(lapply(lapply(lffrq[lfobs], strsplit, split="[[:blank:]]+"),unlist),el,6))),each=nbins),
                   pen  = rep(as.numeric(unlist(lapply(lapply(lapply(lffrq[lfobs], strsplit, split="[[:blank:]]+"),unlist),el,7))),each=nbins),
                   lenfrq= as.vector(arr))
  
  df2<- data.frame(year = as.numeric(unlist(lapply(lapply(lapply(lffrq[!lfobs], strsplit, split="[[:blank:]]+"),unlist),el,1))),
                   month= as.numeric(unlist(lapply(lapply(lapply(lffrq[!lfobs], strsplit, split="[[:blank:]]+"),unlist),el,2))),
                   week = as.numeric(unlist(lapply(lapply(lapply(lffrq[!lfobs], strsplit, split="[[:blank:]]+"),unlist),el,3))),
                   fish = as.numeric(unlist(lapply(lapply(lapply(lffrq[!lfobs], strsplit, split="[[:blank:]]+"),unlist),el,4))),
                   catch= as.numeric(unlist(lapply(lapply(lapply(lffrq[!lfobs], strsplit, split="[[:blank:]]+"),unlist),el,5))),
                   effort=as.numeric(unlist(lapply(lapply(lapply(lffrq[!lfobs], strsplit, split="[[:blank:]]+"),unlist),el,6))),
                   pen  = as.numeric(unlist(lapply(lapply(lapply(lffrq[!lfobs], strsplit, split="[[:blank:]]+"),unlist),el,7))),
                   lenfrq= -1)
  
  res@freq <- rbind(df, df2)
  res@freq <- res@freq[order(res@freq$year, res@freq$month),]
  
  return(res)
  
}



read.MFCLFrq <- function(frqfile){
  
  lenfreq <- read.MFCLLenFreq(frqfile)
  vitals  <- read.MFCLVitalStats(frqfile)
  
  res <- new("MFCLFrq")
  
  for(slotname in slotNames(lenfreq)){
    slot(res, slotname) <- slot(lenfreq, slotname)
  }
  
  for(slotname in slotNames(vitals)){
    slot(res, slotname) <- slot(vitals, slotname)
  }
  
  minlen <- lenfreq@lf_range['LFFirst']
  maxlen <- lenfreq@lf_range['LFFirst'] + lenfreq@lf_range['LFIntervals'] * lenfreq@lf_range['LFFirst']
  res@range[c('min','max')] <- c(minlen,maxlen)
  res@range['maxyear']      <- max(res@freq[,'year'])
  
  return(res)
    
}


#frqfile <- 'C://R4MFCL//test_data//skj_ref_case//skj.frq'
