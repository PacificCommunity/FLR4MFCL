#hello.


######################################################################
###
###  Frq file
###
#######################################################################


###### CLASSS MFCLFrqStats  (from .frq file)

validMFCLFrqStats <- function(object){
  #Everything is fine
  return(TRUE)
}
#' An S4 class : Essesntial dimensions and ranges of the frq file.
#'
#' @slot n_regions Number of regions
#' @slot n_fisheries Number of fisheries
#' @slot n_tag_groups Number of tag groups
#' @slot n_recs_yr Number of recruitment events each year
#' @slot rec_month Month in which recruitment occurs - 0 means first month of each period
#' @slot generic_diffusion Logical
#' @slot frq_age_len Logical. Is the frq file age or length based
#' @slot frq_version The version of the frq file
#' @slot region_size Size of each region relative to first region
#' @slot region_fish
#' @slot move_matrix
#' @slot data_flags
#' @slot season_flags
#' @slot n_move_yr
#' @slot move_weeks
#' @slot range
#'
setClass("MFCLFrqStats",
         representation(
           n_regions    = "numeric",
           n_fisheries  = "numeric",
           n_tag_groups = "numeric",
           n_recs_yr    = "numeric",
           rec_month    = "numeric",
           generic_diffusion = "logical",
           frq_age_len  = "logical",
           frq_version  = "numeric",
           region_size  = "FLQuant",
           region_fish  = "FLQuant",
           move_matrix  = "matrix",
           data_flags   = "matrix",
           season_flags = "matrix",
           n_move_yr    = "numeric",
           move_weeks   = "numeric",
           range        = "numeric"
         ),
         prototype=prototype(
           n_regions    = numeric(),
           n_fisheries  = numeric(),
           n_tag_groups = numeric(),
           n_recs_yr    = numeric(),
           rec_month    = numeric(),
           generic_diffusion = logical(),
           frq_age_len  = logical(),
           frq_version  = numeric(),
           region_size  = FLQuant(),
           region_fish  = FLQuant(),
           move_matrix  = matrix(),
           data_flags   = matrix(),
           season_flags = matrix(),
           n_move_yr    = numeric(),
           move_weeks   = numeric(),
           range        =unlist(list(min=NA,max=NA,plusgroup=NA,minyear=1,maxyear=1))
         ),
         validity=validMFCLFrqStats
)
setValidity("MFCLFrqStats", validMFCLFrqStats)
remove(validMFCLFrqStats)
#createMFCLAccesors("MFCLFrqStats")
#'MFCLFrqStats
#'
#'Basic constructor for MFCLFrqStats class
#'@export
MFCLFrqStats <- function() {return(new("MFCLFrqStats"))}



###### CLASSS MFCLLenFreq  (from .frq file)

validMFCLLenFreq <- function(object){
  #Everything is fine
  return(TRUE)
}
#' An S4 class : Length frequency information from the frq file.
#'
#' @slot lf_range Range information of the length frequencies
#' @slot age_nage I don't know what this is but it's in the frq file
#' @slot freq Data frame of length frequency information.
#'
setClass("MFCLLenFreq",
         representation(
           lf_range    ="numeric",
           age_nage    ="numeric",
           freq        ="data.frame"
         ),
         prototype=prototype(
           lf_range     =unlist(list(Datasets=0,LFIntervals=NA,LFFirst=NA,LFWidth=NA,LFFactor=NA,WFIntervals=NA,WFFirst=NA,WFWidth=NA,WFFactor=NA)),
           age_nage     =unlist(list(age_nage=0,age_age1=NA)),
           freq         =data.frame()
         ),
         validity=validMFCLLenFreq
)
setValidity("MFCLLenFreq", validMFCLLenFreq)
remove(validMFCLLenFreq)
#createMFCLAccesors("MFCLLenFreq")
#'MFCLLenFreq
#'
#'Basic constructor for MFCLLenFreq class
#'@export
MFCLLenFreq <- function() {return(new("MFCLLenFreq"))}

###### CLASSS MFCLFrq

validMFCLFrq <- function(object){

  # Everything is fine
  return(TRUE)
}
#' An S4 class : Representation of a frq input file for MFCL
#'
#' A class comprising an MFCLFrqStats object and an MFCLLenFrq object
#'
setClass("MFCLFrq",
         representation(
           "MFCLFrqStats",
           "MFCLLenFreq"
         ),
         validity=validMFCLFrq
)
setValidity("MFCLFrq", validMFCLFrq)
remove(validMFCLFrq)

#'MFCLFrq
#'
#'Basic constructor for MFCLFrq class
#'
#'@export

MFCLFrq <- function() {return(new("MFCLFrq"))}




######################################################################
###
###  Par file
###
#######################################################################


###### CLASSS MFCLBiol  (from .par file)

setClass("MFCLBase",
         representation(
           dimensions        ="numeric",
           range             ="numeric"
         ),
         prototype=prototype(
           dimensions        =unlist(list(agecls=as.numeric(NA), years=NA, seasons=NA, regions=NA, fisheries=NA, taggrps=NA)),
           range             =unlist(list(min=NA,max=NA,plusgroup=NA,minyear=1,maxyear=1))
         ))
#'MFCLBase
#'
#'Basic constructor for MFCLBase class
#'@export
MFCLBase <- function() {return(new("MFCLBase"))}         
         


validMFCLBiol <- function(object){
  #Everything is fine
  return(TRUE)
}
setClass("MFCLBiol",
         representation(
           "MFCLBase",
           m                 ="numeric",
           m_devs_age        ="FLQuant",
           log_m             ="FLQuant",
           mat               ="FLQuant",
           growth            ="array",
           richards          ="numeric",
           growth_var_pars   ="array",
           n_mean_constraints="numeric",
           growth_devs_age   ="FLQuant",
           growth_curve_devs ="FLQuant",
           growth_devs_cohort="FLCohort",
           season_growth_pars="numeric",
           len_bias_pars     ="numeric",
           common_len_bias_pars  ="numeric",
           common_len_bias_coffs ="numeric"
           ),
         prototype=prototype(
           m                 =numeric(),
           m_devs_age        =FLQuant(),
           log_m             =FLQuant(),
           mat               =FLQuant(),
           growth            =array(),
           richards          =numeric(),
           growth_var_pars   =array(),
           n_mean_constraints=numeric(),
           growth_devs_age   =FLQuant(),
           growth_curve_devs =FLQuant(),
           growth_devs_cohort=FLCohort(),
           season_growth_pars=numeric(),
           len_bias_pars     =numeric(),
           common_len_bias_pars  =numeric(),
           common_len_bias_coffs =numeric()
           ),
         validity=validMFCLBiol
)
setValidity("MFCLBiol", validMFCLBiol)
remove(validMFCLBiol)
#'MFCLBiol
#'
#'Basic constructor for MFCLBiol class
#'@export
MFCLBiol <- function() {return(new("MFCLBiol"))}




###### CLASSS MFCLFlags

validMFCLFlags <- function(object){
  #Everything is fine
  return(TRUE)
}
setClass("MFCLFlags",
         representation(
           flags   = "data.frame",
           unused  ="list"
           ),
         prototype=prototype(
           flags   = data.frame(),
           unused  =list()
           ),
         validity=validMFCLFlags
)
setValidity("MFCLFlags", validMFCLFlags)
remove(validMFCLFlags)
#'MFCLFlags
#'
#'Basic consstructor for MFCLFlags class
#'@export
MFCLFlags <- function() {return(new("MFCLFlags"))}




###### CLASSS MFCLTagRep

validMFCLTagRep <- function(object){
  #Everything is fine
  return(TRUE)
}
setClass("MFCLTagRep",
         representation(
           tag_fish_rep_rate  = "array",
           tag_fish_rep_grp   = "array",
           tag_fish_rep_flags = "array",
           tag_fish_rep_target= "array",
           tag_fish_rep_pen   = "array",
           rep_rate_dev_coffs = "list",
           range              = "numeric"
         ),
         prototype=prototype(
           tag_fish_rep_rate  = array(),
           tag_fish_rep_grp   = array(),
           tag_fish_rep_flags = array(),
           tag_fish_rep_target= array(),
           tag_fish_rep_pen   = array(),
           rep_rate_dev_coffs = list(),
           range=unlist(list(min=NA,max=NA,plusgroup=NA,minyear=1,maxyear=1))
         ),
         validity=validMFCLTagRep
)
setValidity("MFCLTagRep", validMFCLTagRep)
remove(validMFCLTagRep)
#'MFCLTagRep
#'
#'Basic constructor for MFCLTagRep class
#'@export
MFCLTagRep <- function() {return(new("MFCLTagRep"))}




###### CLASSS MFCLRec

validMFCLRec <- function(object){
  #Everything is fine
  return(TRUE)
}
setClass("MFCLRec",
         representation(
           rec_init_pop_diff   ="numeric",
           rec_times           ="numeric",
           rel_rec             ="FLQuant",
           tot_pop             ="numeric",
           tot_pop_implicit    ="numeric",
           rel_ini_pop         ="array",
           range               ="numeric"
         ),
         prototype=prototype(
           rec_init_pop_diff   =numeric(),
           rec_times           =numeric(),
           rel_rec             =FLQuant(),
           tot_pop             =numeric(),
           tot_pop_implicit    = numeric(),
           rel_ini_pop         =array(),
           range               =unlist(list(min=NA,max=NA,plusgroup=NA,minyear=1,maxyear=1))
         ),
         validity=validMFCLRec
)
setValidity("MFCLRec", validMFCLRec)
remove(validMFCLRec)
#'MFCLRec
#'
#'Basic constructor for MFCLRec class
#'@export
MFCLRec <- function() {return(new("MFCLRec"))}



###### CLASSS MFCLRegion

validMFCLRegion <- function(object){
  #Everything is fine
  return(TRUE)
}
setClass("MFCLRegion",
         representation(
           control_flags         = "matrix",
           move_map              = "numeric",
           diff_coffs            = "matrix",
           diff_coffs_mat        = "matrix",
           diff_coffs_age_ssn        = "array",
           diff_coffs_age_period = "array",
           diff_coffs_age        = "array",
           diff_coffs_nl         = "array",
           diff_coffs_priors     = "array",
           diff_coffs_age_priors = "array",
           diff_coffs_nl_priors  = "array",
           region_rec_var        = "FLQuant",
           region_pars           = "matrix",
           range                 = "numeric"
         ),
         prototype=prototype(
           control_flags         = matrix(),
           move_map              = numeric(),
           diff_coffs            = matrix(),
           diff_coffs_mat        = matrix(),
           diff_coffs_age_ssn        = array(),
           diff_coffs_age_period = array(),
           diff_coffs_age        = array(),
           diff_coffs_nl         = array(),
           diff_coffs_priors     = array(),
           diff_coffs_age_priors = array(),
           diff_coffs_nl_priors  = array(),
           region_rec_var        = FLQuant(),
           region_pars           = matrix(),
           range=unlist(list(min=NA,max=NA,plusgroup=NA,minyear=1,maxyear=1))
         ),
         validity=validMFCLRegion
)
setValidity("MFCLRegion", validMFCLRegion)
remove(validMFCLRegion)
#'MFCLRegion
#'
#'Basic constructor for MFCLRegion class
#'@export
MFCLRegion <- function() {return(new("MFCLRegion"))}



###### CLASSS MFCLSel

validMFCLSel <- function(object){
  #Everything is fine
  return(TRUE)
}
setClass("MFCLSel",
         representation(
           availability_coffs   = "FLQuant",
           fishery_sel          = "FLQuant",
           fishery_sel_age_comp = "FLQuant",
           av_q_coffs           = "FLQuant",
           ini_q_coffs          = "FLQuant",
           q0_miss              = "FLQuant",
           q_dev_coffs          = "list",
           effort_dev_coffs     = "list",
           catch_dev_coffs      = "list",
           catch_dev_coffs_flag = "numeric",
           sel_dev_corr         = "FLQuant",
           sel_dev_coffs        = "matrix",
           sel_dev_coffs2       = "list",
           season_q_pars        = "matrix",
           fish_params          = "matrix",
           spp_params           = "matrix",
           range                = "numeric"
         ),
         prototype=prototype(
           availability_coffs   = FLQuant(),
           fishery_sel          = FLQuant(),
           fishery_sel_age_comp = FLQuant(),
           av_q_coffs           = FLQuant(),
           ini_q_coffs          = FLQuant(),
           q0_miss              = FLQuant(),
           q_dev_coffs          = list(),
           effort_dev_coffs     = list(),
           catch_dev_coffs      = list(),
           catch_dev_coffs_flag = numeric(),
           sel_dev_corr         = FLQuant(),
           sel_dev_coffs        = matrix(),
           sel_dev_coffs2       = list(),
           season_q_pars        = matrix(),
           fish_params          = matrix(),
           spp_params           = matrix(),
           range                = unlist(list(min=NA,max=NA,plusgroup=NA,minyear=1,maxyear=1))
         ),
         validity=validMFCLSel
)
setValidity("MFCLSel", validMFCLSel)
remove(validMFCLSel)
#'MFCLSel
#'
#'Basic constructor for MFCLSel class
#'@export
MFCLSel <- function() {return(new("MFCLSel"))}


###### CLASSS MFCLParBits

validMFCLParBits <- function(object){
  #Everything is fine
  return(TRUE)
}
setClass("MFCLParBits",
         representation(
           fm_level_devs        = "character",
           obj_fun              = "numeric",
           n_pars               = "numeric",
           tag_lik              = "numeric",
           mn_len_pen           = "numeric",
           max_grad             = "numeric",
           av_fish_mort_inst    = "numeric",
           av_fish_mort_year    = "numeric",
           av_fish_mort_age     = "numeric",
           logistic_normal_params = "character",
           lagrangian             = "character",
           range                = "numeric",
           historic_flags       = "character"
         ),
         prototype=prototype(
           fm_level_devs        = character(),
           obj_fun              = numeric(),
           n_pars               = numeric(),
           tag_lik              = numeric(),
           mn_len_pen           = numeric(),
           max_grad             = numeric(),
           av_fish_mort_inst    = numeric(),
           av_fish_mort_year    = numeric(),
           av_fish_mort_age     = numeric(),
           logistic_normal_params = character(),
           lagrangian             = character(),
           range                = unlist(list(min=NA,max=NA,plusgroup=NA,minyear=1,maxyear=1)),
           historic_flags       = character()
         ),
         validity=validMFCLParBits
)
setValidity("MFCLParBits", validMFCLParBits)
remove(validMFCLParBits)
#'MFCLParBits
#'
#'Basic constructor for MFCLParBits class
#'@export
MFCLParBits <- function() {return(new("MFCLParBits"))}


###### CLASSS MFCLIniBits

validMFCLIniBits <- function(object){
  #Everything is fine
  return(TRUE)
}
setClass("MFCLIniBits",
         representation(
           age_pars            ="matrix",
           rec_dist            ="numeric",
           lw_params           ="numeric",
           sv                  ="numeric",
           sd_length_at_age    ="numeric",
           sd_length_dep       ='numeric'
         ),
         prototype=prototype(
           age_pars            =matrix(),
           rec_dist            =numeric(),
           lw_params           =numeric(),
           sv                  =numeric(),
           sd_length_at_age    =numeric(),
           sd_length_dep       =numeric()
         ),
         validity=validMFCLIniBits
)
setValidity("MFCLIniBits", validMFCLIniBits)
remove(validMFCLIniBits)
#'MFCLIniBits
#'
#'Basic constructor for MFCLIniBits class
#'@export
MFCLIniBits <- function() {return(new("MFCLIniBits"))}


###### CLASSS MFCLIni

validMFCLIni <- function(object){
  #Everything is fine
  return(TRUE)
}
setClass("MFCLIni",
         representation(
           "MFCLBase",
           "MFCLTagRep",
           "MFCLBiol",
           "MFCLRegion",
           "MFCLIniBits"
         ),
         prototype=prototype(
         ),
         validity=validMFCLIni
)
setValidity("MFCLIni", validMFCLIni)
remove(validMFCLIni)
#'MFCLIni
#'
#'Basic constructor for MFCLIni class
#'@export
MFCLIni <- function() {return(new("MFCLIni"))}






###### CLASSS MFCLPar

validMFCLPar <- function(object){

   # Everything is fine
   return(TRUE)
}



setClass("MFCLPar",
         representation(
           "MFCLBiol",
           "MFCLFlags",
           "MFCLTagRep",
           "MFCLRec",
           "MFCLRegion",
           "MFCLSel",
           "MFCLParBits",
           range="numeric"
           ),
         prototype=prototype(
           ),
         validity=validMFCLPar
)
setValidity("MFCLPar", validMFCLPar)
remove(validMFCLPar)
#'MFCLPar
#'
#'Basic constructor for MFCLPar class
#'@export
MFCLPar <- function() {return(new("MFCLPar"))}






###### CLASSS MFCLTag

validMFCLTag <- function(object){
  #Everything is fine
  return(TRUE)
}
setClass("MFCLTag",
         representation(
           release_groups  = "numeric",
           release_lengths = "numeric",
           recoveries      = "numeric",
           releases        = "data.frame",
           recaptures      = "data.frame",
           range           = "numeric"
         ),
         prototype=prototype(
           release_groups  = numeric(),
           release_lengths  = numeric(),
           recoveries      = numeric(),
           releases        = data.frame(rel.group=NULL, region=NULL, year=NULL, month=NULL, program=NULL, length=NULL, lendist=NULL),
           recaptures      = data.frame(rel.group=NULL, region=NULL, year=NULL, month=NULL, program=NULL, rel.length=NULL, recap.fishery=NULL, recap.year=NULL, recap.month=NULL, recap.number=NULL),
           range           = unlist(list(min=NA,max=NA,plusgroup=NA,minyear=1,maxyear=1))
           ),
         validity=validMFCLTag
)
setValidity("MFCLTag", validMFCLTag)
remove(validMFCLTag)
#'MFCLTag
#'
#'Basic constructor for MFCLTag class
#'@export
MFCLTag <- function() {return(new("MFCLTag"))}







###### CLASSS MFCLRep

validMFCLRep <- function(object){
  #Everything is fine
  return(TRUE)
}

setClass("MFCLRep",
         representation(
           "MFCLBase",
           fishery_realizations="FLQuant",
           mean_laa            ="FLQuant",
           sd_laa              ="FLQuant",
           m_at_age            ="FLQuant",
           sel                 ="FLQuant",
           q_fishery           ='FLQuant',
           q_effdev            ='FLQuant',
           fm                   ='FLQuant',
           popN                 ='FLQuant',
           rec_region          ='FLQuant',
           totalBiomass        ='FLQuant',
           adultBiomass        ='FLQuant',
           adultBiomass_nofish ='FLQuant',
           vulnBiomass         ='FLQuant',
           srr                 ='FLPar',
           ssb                 ='FLQuant',
           ssb_obs             ='FLQuant',
           rec                 ='FLQuant',
           rec_obs             ='FLQuant',
           eq_biomass          ='FLQuant',
           eq_yield            ='FLQuant'
         ),
         prototype=prototype(
           fishery_realizations=FLQuant(),
           mean_laa            =FLQuant(),
           sd_laa              =FLQuant(),
           m_at_age            =FLQuant(),
           sel                 =FLQuant(),
           q_fishery           =FLQuant(),
           q_effdev            =FLQuant(),
           fm                  =FLQuant(),
           popN                =FLQuant(),
           rec_region          =FLQuant(),
           totalBiomass        =FLQuant(),
           adultBiomass        =FLQuant(),
           adultBiomass_nofish =FLQuant(),
           vulnBiomass         =FLQuant(),
           srr                 =FLPar(),
           ssb                 =FLQuant(),
           ssb_obs             =FLQuant(),
           rec                 =FLQuant(),
           rec_obs             =FLQuant(),
           eq_biomass          =FLQuant(),
           eq_yield            =FLQuant()
         ),
         validity=validMFCLRep
)
setValidity("MFCLRep", validMFCLRep)
remove(validMFCLRep)
#'MFCLRep
#'
#'Basic constructor for MFCLRep class
#'@export
MFCLRep <- function() {return(new("MFCLRep"))}




###### CLASSS projControl

validMFCLprojControl <- function(object){
  #Everything is fine
  return(TRUE)
}
setClass("MFCLprojControl",
         representation(
           nyears              ="numeric",
           nsims               ="numeric",
           avyrs               ="character",
           fprojyr             ="numeric",
           controls            ="data.frame"
         ),
         prototype=prototype(
           nyears              =numeric(),
           nsims               =numeric(),
           avyrs               =character(),
           fprojyr             =numeric(),
           controls            =data.frame(name=NULL, region=NULL, caeff=NULL, scaler=NULL, ess=NULL)
         ),
         validity=validMFCLprojControl
)
setValidity("MFCLprojControl", validMFCLprojControl)
remove(validMFCLprojControl)
#'projControl
#'
#'Basic constructor for projControl class
#'@export
MFCLprojControl <- function(nyears=as.numeric(NULL), nsims=as.numeric(NULL), avyrs='', fprojyr=as.numeric(NULL), controls=data.frame(name=NULL, region=NULL, caeff=NULL, scaler=NULL, ess=NULL)) {

  res <- new("MFCLprojControl")
  slot(res, 'nyears') <- nyears
  slot(res, 'nsims')  <- nsims
  slot(res, 'avyrs')  <- avyrs
  slot(res, 'fprojyr') <- fprojyr
  slot(res, 'controls')  <- controls
  
  return(res)
}
#pp <- MFCLprojControl(nyears=3, nsims=200, avyrs='2012', caeff=1, scaler=1)





###### CLASSS MFCLCatch

validMFCLCatch <- function(object){
  #Everything is fine
  return(TRUE)
}
setClass("MFCLCatch",
         representation(
           total_catch         ="FLQuant",
           fishery_catch       ="FLQuant",
           range               ="numeric"
         ),
         prototype=prototype(
           total_catch         =FLQuant(),
           fishery_catch       =FLQuant(),
           range               =unlist(list(min=NA,max=NA,plusgroup=NA,minyear=1,maxyear=1))
         ),
         validity=validMFCLCatch
)
setValidity("MFCLCatch", validMFCLCatch)
remove(validMFCLCatch)
#'MFCLCatch
#'
#'Basic constructor for MFCLCatch class
#'@export
MFCLCatch <- function() {return(new("MFCLCatch"))}




########################
##
## MFCL diagnostics output classes
##
########################


###### CLASSS MFCLLenFit

validMFCLLenFit <- function(object){
  #Everything is fine
  return(TRUE)
}
setClass("MFCLLenFit",
         representation(
           laa                 ="FLQuant",
           lenfits             ="data.frame",
           lenagefits          ="data.frame",
           range               ="numeric"
         ),
         prototype=prototype(
           laa                 =FLQuant(),
           lenfits             =data.frame(fishery=NULL, year=NULL, month=NULL, length=NULL, obs=NULL, pred=NULL),
           lenagefits          =data.frame(fishery=NULL, year=NULL, month=NULL, length=NULL, age=NULL, pred=NULL), 
           range               =unlist(list(min=NA,max=NA,plusgroup=NA,minyear=1,maxyear=1))
         ),
         validity=validMFCLLenFit
)
setValidity("MFCLLenFit", validMFCLLenFit)
remove(validMFCLLenFit)
#'MFCLLenFit
#'
#'Basic constructor for MFCLCatch class
#'@export
MFCLLenFit <- function() {return(new("MFCLLenFit"))}




########################
##
## MFCL pseudo data objects
##
########################


###### CLASSS MFCLPseudo

validMFCLPseudo <- function(object){
  #Everything is fine
  return(TRUE)
}
setClass("MFCLPseudo",
         representation(
           catch               ="data.frame",
           effort              ="data.frame",
           l_frq               ="data.frame",
           w_frq               ="data.frame",
           range               ="numeric"
         ),
         prototype=prototype(
           catch               =data.frame(year=NULL, month=NULL, fishery=NULL, iter=NULL, data=NULL),
           effort              =data.frame(year=NULL, month=NULL, fishery=NULL, iter=NULL, data=NULL), 
           l_frq               =data.frame(year=NULL, month=NULL, fishery=NULL, length=NULL, iter=NULL, freq=NULL),
           w_frq               =data.frame(year=NULL, month=NULL, fishery=NULL, weight=NULL, iter=NULL, freq=NULL),
           range               =unlist(list(min=NA,max=NA,plusgroup=NA,minyear=1,maxyear=1))
         ),
         validity=validMFCLPseudo
)
setValidity("MFCLPseudo", validMFCLPseudo)
remove(validMFCLPseudo)
#'MFCLPseudo
#'
#'Basic constructor for MFCLPseudo class
#'@export
MFCLPseudo <- function(catch =data.frame(year=NULL, month=NULL, fishery=NULL, iter=NULL, data=NULL),
                       effort=data.frame(year=NULL, month=NULL, fishery=NULL, iter=NULL, data=NULL),
                       l_frq =data.frame(year=NULL, month=NULL, fishery=NULL, length=NULL, iter=NULL, freq=NULL),
                       w_frq =data.frame(year=NULL, month=NULL, fishery=NULL, weight=NULL, iter=NULL, freq=NULL)) {
  res <- new("MFCLPseudo")
  slot(res, "catch") <- catch
  slot(res, "effort") <- effort
  slot(res, "l_frq") <- l_frq
  slot(res, "w_frq") <- w_frq
  slot(res, "range") <- unlist(list(min=NA,max=NA,plusgroup=NA,minyear=1,maxyear=1))
  
  if(nrow(catch)>0)
    slot(res, "range")[c("minyear","maxyear")] <- range(catch$year)
  if(nrow(l_frq)>0)
    slot(res, "range")[c("min", "max")] <- range(l_frq$length)
  
  return(res)
  }














