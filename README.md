<!-- Add a project state badge
See https://github.com/BCDevExchange/Our-Project-Docs/blob/master/discussion/projectstates.md
If you have bcgovr installed and you use RStudio, click the 'Insert BCDevex Badge' Addin. -->

offSiteTrees
============

Series of functions and scripts to analyze silviculture information for
tree species planted outside their natural range in British Columbia.

### Features

So far, this package has the following functions:

-   extractData() to download silviculture information for a given
    species and region in the province. This function uses the bcdata
    package to query RESULTS. Careful, this function can take a long
    time to download.
-   cleanData() cleans data returned from the extractData() function for
    analysis.

### Installation

You can download this package from Github directly:

``` r
remotes::install_github("bcgov/offSiteTrees")
```

Load the library into your workspace:

``` r
library(offSiteTrees)
```

### Usage

First thing is to download some species data for a certain region. In
this example, let’s download silviculture information for Douglas-fir
planted in Skeena Region:

``` r
rsk<-extractData(regionCode="rsk",speciesList=c("FD","FDI","FDC"))
```

This will take a few minutes. Note that I provided several species codes
to the function. This package already comes with this dataset (?rskFDI)

Next, let’s clean the data:

``` r
x<- cleanData(rskFDI)
```

#### Data summaries

Now we can summarize some of the data. Let’s omit data for polygons in
climatic units that the Chief Forester’s Reference Guide already lists
Douglas-fir as suitable:

``` r
spp_offsite<-
  cfrgPG %>%
  mutate(Spp=toupper(Spp)) %>% # convert spp to uppercase to match RESULTS
  filter(Spp%in%"FD") %>%   # filter for species of interest
  anti_join(x,.,by=c("BGC"="ZoneSubzone")) # anti join returns X where it is not listed in CFRG
```

Note this just lists polygons in climatic units where Douglas-fir is not
currently considered acceptable on any site series, according to the
CFRG. This code ignores site series.

Now we can summarize data:

``` r
spp_offsite %>% 
  group_by(BGC) %>% 
  summarize(Num.openings=n(), # Summarize number of openings planted with Fd
            Area.planted=sum(SILV_POLYGON_AREA,na.rm=T), # summarize area planted with Fd
            Total.WS.trees=sum(WELL_SPACED_HA,na.rm=T)) %>% # summarize total Fd well spaced
  filter(BGC!="NANA") # remove NA BGC units
#> # A tibble: 5 x 4
#>   BGC    Num.openings Area.planted Total.WS.trees
#>   <chr>         <int>        <dbl>          <dbl>
#> 1 ESSFmc           48       1685.           13209
#> 2 ICHmc1           32        664             7721
#> 3 SBSd              3          5.4            920
#> 4 SBSmc             3         14.4           1160
#> 5 SBSmc2          910      28499.          290626
```

### Project Status

Developmental/preliminary

### Getting Help or Reporting an Issue

To report bugs/issues/feature requests, please file an
[issue](https://github.com/bcgov/offSiteTrees/issues/).

### How to Contribute

If you would like to contribute to the package, please see our
[CONTRIBUTING](CONTRIBUTING.md) guidelines.

Please note that this project is released with a [Contributor Code of
Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree
to abide by its terms.

### License

    Copyright 2019 Province of British Columbia

    Licensed under the Apache License, Version 2.0 (the &quot;License&quot;);
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an &quot;AS IS&quot; BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and limitations under the License.

------------------------------------------------------------------------

*This project was created using the
[bcgovr](https://github.com/bcgov/bcgovr) package.*
