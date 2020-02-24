#FLR4MFCL - R4MFCL built with FLR classes
#Copyright (C) 2018  Rob Scott

#' write
#'
#' Writes MFCL objects to a text file
#'
#' @param x An object of class MFCL eg. MFCLFrq, MFCLPar, etc.
#'
#' @param file The name and path of the file to be written
#'
#' @param append If True append to existing file, If False overwrite any existing file
#'
#' @param ... Additional argument list that might not ever
#'  be used.
#'
#' @return Creates a text file at the specified location.
#'
#' @seealso \code{\link{read.MFCLFrq}} and \code{\link{read.MFCLPar}}
#'
#' @export
#' @docType methods
#' @rdname write-methods
#'
#' @examples
#' write(MFCLFrqStats())

setGeneric('write', function(x, file, append=F, ...) standardGeneric('write'))



#'@export version
setGeneric('version', function(x, ...) standardGeneric('version'))
setMethod('version', signature(x='MFCLPar'),function(x) flagval(x, 1, 200)$value)  #flags(par)[flags(x)$flagtype==1 & flags(x)$flag==200,'value'])

setMethod('version', signature(x='MFCLFrq'),function(x) return(slot(x,'frq_version')))

#'@export flagval
setGeneric('flagval', function(x, flagtype, flag, ...) standardGeneric('flagval'))
setMethod('flagval', signature(x='MFCLPar'), function(x, flagtype, flag) flags(x)[flags(x)$flagtype %in% flagtype & flags(x)$flag %in% flag,])

#'@export
setGeneric('flagval<-', function(x, flagtype, flag, value) standardGeneric('flagval<-'))
setReplaceMethod('flagval', signature(x='MFCLPar'),
                 function(x, flagtype, flag, value){flags(x)[flags(x)$flagtype %in% flagtype & flags(x)$flag %in% flag, 'value'] <- value; return(x)})

#'@export steepness
setGeneric('steepness', function(x) standardGeneric('steepness'))
setMethod('steepness', signature(x='MFCLIni'), function(x) return(slot(x, 'sv')))
setMethod('steepness', signature(x='MFCLPar'), function(x) return(slot(x, 'season_growth_pars')[29]))

setGeneric('steepness<-', function(x, value) standardGeneric('steepness<-'))
setReplaceMethod('steepness', signature(x='MFCLIni'), function(x, value){slot(x, 'sv') <- value; return(x)})
setReplaceMethod('steepness', signature(x='MFCLPar'), function(x, value){slot(x, 'season_growth_pars')[29] <- value; return(x)})

#'@export lw_params
setMethod('lw_params', signature(object='MFCLBiol'), function(object) return(slot(object, 'season_growth_pars')[27:28]))
setReplaceMethod('lw_params', signature(object='MFCLBiol'), function(object, value){slot(object, 'season_growth_pars')[27:28] <- value; return(x)})

#'@export adultBiomass
setMethod('adultBiomass', signature(object='FLQuant'), function(object, par){
  ab <- quantSums(sweep(object, 1, c(qts(mat(par)))*waa(par), '*'))/1000
  return(ab)
  }
)


# Get the unique fishing realisations
#'@export realisations
setGeneric('realisations', function(object,...) standardGeneric('realisations'))
setMethod('realisations', signature(object='MFCLLenFreq'),
          function(object){
            return(slot(object,'cateffpen')[,1:6])
## #            return(slot(object, 'freq')[is.element(slot(object, 'freq')$length, c(NA, slot(object, 'lf_range')['LFFirst'])) &
## #                                        is.element(slot(object, 'freq')$weight, c(NA, slot(object, 'lf_range')['WFFirst'])),])
##   length_realisations <- is.element(slot(object,'freq')$length, c(NA, lf_range(object)['LFFirst']))
##   weight_realisations <- is.element(slot(object,'freq')$weight, c(NA, lf_range(object)['WFFirst']))
##   lw_realisations <- length_realisations & weight_realisations
##   # But some of these lw_realisations may be in the same timestep / fishery
##   # So we need to drag out the unique timestep / fishery combinations only
##   freq2 <- slot(object,'freq')[lw_realisations,]
##   realisations <- unique(freq2[,c("year","month","week","fishery")])
##   # Drop penalty, length, weight and freq column
##   drop_cols <- c("penalty", "length", "weight", "freq")
##   realisations <- freq2[rownames(realisations),!(colnames(freq2) %in% drop_cols)]
##   return(realisations)
})


#'@export as.MFCLLenFreq
setGeneric('as.MFCLLenFreq', function(object,...) standardGeneric('as.MFCLLenFreq'))
setMethod('as.MFCLLenFreq', signature(object='MFCLFrq'),
          function(object){
            res <- MFCLLenFreq()
            ss <- names(getSlots(class(res)))
            for(sn in ss)
              slot(res, sn) <- slot(object, sn)
            return(res)})

setMethod('as.MFCLLenFreq', signature(object='MFCLPseudo'),
          function(object){
            res <- MFCLLenFreq()
            ss <- names(getSlots(class(res)))
            for(sn in ss)
              slot(res, sn) <- slot(object, sn)
            return(res)})



# iter {{{
setMethod("iter", signature(obj="MFCLPseudo"),
          function(obj, iter) {

            if(iter > max(slot(obj, "catcheff")$iter))
              stop("max iter exceeded")

            slot(obj, "catcheff") <- slot(obj, "catcheff")[slot(obj, "catcheff")$iter==iter,-c('iter')]

            for(ss in c("l_frq", "w_frq")){
              if(nrow(slot(obj, ss))>0)
                slot(obj, ss) <- slot(obj, ss)[slot(obj, ss)$iter==iter ,-c('iter')]
            }

            ## slot(obj, 'freq') <- slot(obj,'freq')[,c('year','month','week','fishery',paste0('catch_',iter), paste0('effort_',iter),'penalty','length','weight',paste0('freq_',iter))]
            ## colnames(slot(obj, 'freq')) <- c('year','month','week','fishery','catch','effort','penalty','length','weight','freq')
            return(obj)
          }
) # }}}


setMethod("+", signature(e1="MFCLLenFreq", e2="MFCLLenFreq"),
          function(e1, e2) {
              if(any(is.element(interaction(cateffpen(e1)[,1:4]), interaction(cateffpen(e2)[,1:4]))))
              stop("Looks like you are duplicating fishery realisations!")

              cateffpen(e1) <- rbind(cateffpen(e1), cateffpen(e2))
              lnfrq(e1) <- rbind(lnfrq(e1), lnfrq(e2))
              wtfrq(e1) <- rbind(wtfrq(e1), wtfrq(e2))


            lf_range(e1)['Datasets'] <- nrow(cateffpen(e1)) # not really necessary
            range(e1)[c('minyear','maxyear')] <- range(cateffpen(e1)$year)

            return(e1)
          }
) # }}}

setMethod("+", signature(e1="MFCLFrq", e2="MFCLFrq"),
          function(e1, e2) {
            if(frq_version(e1) != frq_version(e2))
              stop("Error : different frq versions")
            if(n_regions(e1) != n_regions(e2) | n_fisheries(e1) != n_fisheries(e2))
              warning("Objects may not be compatible")

            lenfreq_e1 <- as.MFCLLenFreq(e1) + as.MFCLLenFreq(e2)

            cateffpen(e1)     <- cateffpen(lenfreq_e1)
            lnfrq(e1)     <- lnfrq(lenfreq_e1)
            wtfrq(e1)     <- wtfrq(lenfreq_e1)
            lf_range(e1) <- lf_range(lenfreq_e1)

            n_tag_groups(e1) <- n_tag_groups(e1) + n_tag_groups(e2)
            return(e1)
          }
) # }}}

setMethod("+", signature(e1="MFCLFrq", e2="MFCLPseudo"),
          function(e1, e2) {

            if(any(is.element(interaction(cateffpen(e1)[,1:4]), interaction(cateffpen(e2)[,1:4]))))
              warning("Hopefully you are replacing all fishery realisations.")
            if ('iter' %in% colnames(cateffpen(e2)))
              stop("Looks like you need to call iter on the MFCLPseudo object!")
            # add future pseudo data to the original FRQ
            if(any(range(e1)[c("minyear","maxyear")] != slot(e2, 'range')[c("minyear","maxyear")]))
              {
                cateffpen(e1) <- rbind(cateffpen(e1), slot(e2,"cateff"))                                                      #catcheff(e2)[,1:10])
                lnfrq(e1) <- rbind(lnfrq(e1),slot(e2,"l_frq"))
                wtfrq(e1) <- rbind(wtfrq(e1),slot(e2,"w_frq"))
              }

            # add historical pseudo data to the PROJFRQ
            if(all(range(e1)[c("minyear","maxyear")] == slot(e2, 'range')[c("minyear","maxyear")]))
            {
              freq(e1) <- cateff(e2)                                                                       #catcheff(e2)[,1:10]
              lnfrq(e1) <- slot(e2,"l_frq")
              wtfrq(e1) <- slot(e2,"w_frq")
            }

            lf_range(e1)['Datasets'] <- nrow(cateffpen(e1))
            range(e1)[c('minyear','maxyear')] <- range(cateffpen(e1)$year)

            return(e1)
          }
) # }}}

setMethod("+", signature(e1="MFCLTag", e2="MFCLTag"),
          function(e1, e2) {

            mrg.hist       <- max(releases(e1)$rel.group)
            releases(e2)$rel.group   <- releases(e2)$rel.group   + mrg.hist
            recaptures(e2)$rel.group <- recaptures(e2)$rel.group + mrg.hist

            releases(e1)   <- rbind(releases(e1), releases(e2))
            recaptures(e1) <- rbind(recaptures(e1), recaptures(e2))

            release_groups(e1) <- max(releases(e1)$rel.group)
            recoveries(e1)     <- c(recoveries(e1), recoveries(e2))
            # Remove the following line
            #releases(e1)       <- rbind(releases(e1), releases(e2))

            range(e1)['maxyear'] <- range(e2)['maxyear']

            return(e1)
          }
) # }}}


##-----------------------------
## Control objects

setMethod("+", signature(e1="MFCLPseudoControl", e2="MFCLprojControl"),
          function(e1, e2) {

            for(ss in slotNames(e2))
              slot(e1, ss) <- slot(e2, ss)

            return(e1)
          }
) # }}}

setMethod("+", signature(e1="MFCLMSEControl", e2="MFCLprojControl"),
          function(e1, e2) {

            for(ss in slotNames(e2))
              slot(e1, ss) <- slot(e2, ss)

            return(e1)
          }
) # }}}

setMethod("+", signature(e1="MFCLMSEControl", e2="MFCLPseudoControl"),
          function(e1, e2) {

            for(ss in slotNames(e2))
              slot(e1, ss) <- slot(e2, ss)

            return(e1)
          }
) # }}}

setMethod("+", signature(e1="MFCLMSEControl", e2="MFCLEMControl"),
          function(e1, e2) {

            for(ss in slotNames(e2))
              slot(e1, ss) <- slot(e2, ss)

            return(e1)
          }
) # }}}
