#' Extract silviculture data for species and region
#'
#' This function uses the bcdata package to extract RESULTS entries for
#' given species and region.
#'
#' Function can take a VERY long time to run, so recommended to filter by single region at a time
#' and do not filter for commonly planted species (e.g., Pli).
#'
#'@param regionCode Three-letter region code (e.g., "ROM").
#'@param speciesList List of species codes to be extracted (e.g., c("FD","FDI"))
#' @import dplyr bcdata sf
#' @keywords
#' @export

extractData<-function(regionCode,speciesList) {

  regionCode=toupper(regionCode)

  region<-
    bcdata::bcdc_query_geodata("natural-resource-nr-regions") %>% #query region
    bcdata::filter(ORG_UNIT%in%regionCode) %>% # for region(s) of interest
    bcdata::collect() %>% # collect
    sf::st_union() # combine polygons into single

  results<-
    bcdata::bcdc_query_geodata("WHSE_FOREST_VEGETATION.RSLT_FOREST_COVER_SILV_SVW") %>%
    bcdata::filter(INTERSECTS(region)) %>%
    bcdata::filter(S_SPECIES_CODE_1%in%sppList|
             S_SPECIES_CODE_2%in%sppList|
             S_SPECIES_CODE_3%in%sppList|
             S_SPECIES_CODE_4%in%sppList|
             S_SPECIES_CODE_5%in%sppList) %>%
    bcdata::select(1:60) %>%
              collect()

    return(results)

}

