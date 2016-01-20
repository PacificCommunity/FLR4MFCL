#' read.MFCLRep
#'
#' Reads information from the .rep file and creates an MFCLRep object
#'
#' @param inifile:  A character string giving the name and path of the .rep file to be read 
#' 
#'
#' @return An object of class MFCLRep
#'
#' @examples
#' read.MFCLIni("C://R4MFCL//test_data//skj_ref_case//plot-out.par.rep")
#' read.MFCLIni("/home/roberts/skj/HCR/run0/plot-out.par.rep")
#'
#' @export

read.MFCLRep <- function(repfile) {
  
  trim.leading  <- function(x) sub("^\\s+", "", x) 
  splitter      <- function(ff, tt, ll=1, inst=1) unlist(strsplit(trim.leading(ff[grep(tt, ff)[inst]+ll]),split="[[:blank:]]+")) 
  
  
  res <- new("MFCLRep")
  
  pp    <- readLines(repfile)
  pp    <- pp[nchar(pp)>=1]                                          # remove blank lines
  if(any(grepl("# ", pp) & nchar(pp)<3))
    pp <- pp[-seq(1,length(pp))[grepl("# ", pp) & nchar(pp)<3]]   # remove single hashes with no text "# "
  
  dimensions(res)['agecls']    <- c(as.numeric(trim.leading(pp[grep("# Number of age classes", pp)+1])))
  dimensions(res)['years']     <- c(as.numeric(trim.leading(pp[grep("# Number of time periods", pp)+1])))
  dimensions(res)['seasons']   <- c(as.numeric(trim.leading(pp[grep("# Number of recruitments per year", pp)+1])))
  dimensions(res)['regions']   <- c(as.numeric(trim.leading(pp[grep("# Number of regions", pp)+1])))
  dimensions(res)['fisheries'] <- c(as.numeric(trim.leading(pp[grep("# Number of fisheries", pp)+1])))
  
  res@range['minyear'] <- as.numeric(trim.leading(pp[grep("# Year 1", pp)+1]))
  res@range['maxyear'] <- range(res)['minyear'] + (as.numeric(trim.leading(pp[grep("# Number of time periods", pp)+1]))/dimensions(res)['seasons'])-1
  res@range['min']     <- 0
  res@range['max']     <- (dimensions(res)['agecls']/dimensions(res)['seasons'])-1
  
  dnms1 <- list(age=0:range(res)['max'],year='all', unit='unique', season=1:dimensions(res)['seasons'])
  dnms2 <- list(age='all', year=range(res)['minyear']:range(res)["maxyear"], unit='unique', season=1:dimensions(res)['seasons'], area=1:dimensions(res)['regions'])
  dnms3 <- list(age=1:dimensions(res)['agecls'], year='all', unit=1:dimensions(res)['fisheries'], season='all', area='all')
  
  
  # fishery realisations - incomplete (to come back to later when it's important)
  temp <- pp[(grep("# Time of each realization by fishery", pp)+1):(grep("# Time of each realization by fishery", pp)+dimensions(res)['fisheries'])]
  temp2<- lapply(temp, function(xx){as.numeric(unlist(strsplit(trim.leading(xx), split="[[:blank:]]+")))})
  fishery_realizations(res) <- FLQuant(FALSE, dimnames=list(age='all', year=as.character(range(res)['minyear']:range(res)['maxyear']), 
                                                            unit=as.character(1:dimensions(res)['fisheries']), season=as.character(1:dimensions(res)['seasons'])))
  
  # mean length at age
  mean_laa(res) <- FLQuant(aperm(array(as.numeric(splitter(pp, "# Mean lengths at age")),
                                       dim=c(dimensions(res)['seasons'], (range(res)['max']-range(res)['min']+1), 1,1,1)), c(1,3,4,2,5)), dimnames=dnms1 )
  
  # sd length at age
  sd_laa(res) <- FLQuant(aperm(array(as.numeric(splitter(pp, "# SD of length at age")),
                                       dim=c(dimensions(res)['seasons'], (range(res)['max']-range(res)['min']+1), 1,1,1)), c(1,3,4,2,5)), dimnames=dnms1 )
  
  # m at age
  m_at_age(res) <- FLQuant(aperm(array(as.numeric(splitter(pp, "# Natural mortality at age")),
                                       dim=c(dimensions(res)['seasons'], (range(res)['max']-range(res)['min']+1), 1,1,1)), c(1,3,4,2,5)), dimnames=dnms1 )
  
  
  # adult biomass  
  adultBiomass(res) <- FLQuant(aperm(array(as.numeric(splitter(pp, "# Adult biomass", 1:dimensions(res)['years'])), 
                                     dim=c(dimensions(res)["regions"], dimensions(res)['seasons'], dimensions(res)['years']/dimensions(res)["seasons"],1,1)), 
                               c(4,3,5,2,1)), dimnames=dnms2)
  
  # adult biomass_no_fish  
  adultBiomass_nofish(res) <- FLQuant(aperm(array(as.numeric(splitter(pp, "# Adult biomass in absence of fishing", 1:dimensions(res)['years'])), 
                                           dim=c(dimensions(res)["regions"], dimensions(res)['seasons'], dimensions(res)['years']/dimensions(res)["seasons"],1,1)), 
                                     c(4,3,5,2,1)), dimnames=dnms2)
  
  # Selectivity by age class
  sel(res)  <- FLQuant(aperm(array(as.numeric(splitter(pp, "# Selectivity by age class", 1:dimensions(res)['fisheries'])),
                             dim=c(dimensions(res)['agecls'], dimensions(res)['fisheries'],1,1,1)), c(1,3,2,4,5)),dimnames=dnms3)
  
  # Fishing mortality by age class (across), year (down) and region (block)
  dat     <- pp[(grep("# Fishing mortality by age class", pp)[2]+2) : (grep("# Fishing mortality by age class", pp)[2]+(dimensions(res)['years']*dimensions(res)['regions'])+dimensions(res)['regions'])]
  dat     <- dat[-grep("# Region", dat)] 
  fdat    <- array(as.numeric(unlist(strsplit(trim.leading(dat),split="[[:blank:]]+"))), dim=c(dimensions(res)['agecls'], dimensions(res)['years'], dimensions(res)['regions'],1,1)) 
  res@fm  <- FLQuant(aperm(fdat, c(1,2,4,5,3)))  
    
  
  
    
  return(res)
}
