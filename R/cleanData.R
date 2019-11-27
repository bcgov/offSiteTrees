#' Clean RESULTS data extracted using extractData function()
#'
#' This function takes the output from extractData() and prepares it for summaries.
#'
#'
#'@param extractOut output from extractData().
#' @import dplyr tidyr
#' @keywords
#'

cleanData<-function(extractOut) {


  extractOut %>%

    # Unite multiple columns for each species
    unite(col=Species_1,ends_with("_1"),sep="_") %>%
    unite(col=Species_2,ends_with("_2"),sep="_") %>%
    unite(col=Species_3,ends_with("_3"),sep="_") %>%
    unite(col=Species_4,ends_with("_4"),sep="_") %>%
    unite(col=Species_5,ends_with("_5"),sep="_") %>%

    # pivot longer to allow for summaries
    pivot_longer(
      cols=starts_with("Species_"),
      names_to="species_rank",
      values_to = "value") %>%

    # Create BGC column
    mutate(BGC=paste(BGC_ZONE_CODE,BGC_SUBZONE_CODE,BGC_VARIANT,sep="")) %>%
    mutate(BGC=stringr::str_remove(BGC,"NA")) %>% # Remove NA
    mutate(SITE_SERIES=as.numeric(BEC_SITE_SERIES)) %>%


  # extract species information
    mutate(SPECIES_CODE=stringr::str_split(value,"_",simplify = TRUE)[,1]) %>%
    mutate(SPECIES_PCT=stringr::str_split(value,"_",simplify = TRUE)[,2]) %>%
    mutate(SPECIES_AGE=stringr::str_split(value,"_",simplify = TRUE)[,3]) %>%
    mutate(SPECIES_HT=stringr::str_split(value,"_",simplify = TRUE)[,4]) %>%
    filter(SPECIES_CODE!="NA") %>%  # remove any rows with NA in SPECIES_CODE

  # adjust well spaced stems based on species percentages
    mutate(WELL_SPACED_HA=round(S_WELL_SPACED_STEMS_PER_HA*as.numeric(SPECIES_PCT)/100,0)) %>%

  # Select final columns to return

  # select columns for final data frame
  dplyr::select(1:8,BGC,SITE_SERIES,
                S_SILV_LABEL,
                SPECIES_RANK=species_rank,
                contains("SPECIES_",ignore.case=FALSE),
                WELL_SPACED_HA,
                OBJECTID,geometry) %>%


  # return
  return()

}
