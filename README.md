# mesowest: Simple R functions for working with the Mesowest / SynopticLabs climate data API

`mesowest` provides utilities for interfacing with the mesowest API using R

## Installation

```
library(devtools)
install_github('fickse/mesowest')
```

## Authentication

After you have obtained an [API key](https://synopticlabs.org/api/guides/?getstarted), request a token...

```r
library(mesowest)

requestToken(apikey = "YoUrApIkEY918202s")

# or interactively choose a text file with the key...
requestToken()

``` 
The token is saved to a text file in your root directory (`~/`)

## Getting data

Services are accessed through the function `mesowest::mw`
Parameters can be input as named arguments 

```r
mw(service = 'metadata', complete=1, state='UT', county='Garfield')

```  
If this results in awkward nested dataframes, include `jsonsimplify = FALSE` as an argument.  

Data can be queried using named parameters in the api

### Timeseries
``r
# request hourly timeseries data
d <- mw(service = 'timeseries', stid ='SFLU1', vars = c('air_temp', 'relative_humidity'), start = '201610250001', end = '201610260001', jsonsimplify= TRUE)

# parsing the nested lists
clim <- data.frame( lapply( d$STATION$OBSERVATIONS, unlist) )

```

### Latest data
``r
d <- mw(service = 'latest', county = 'Garfield', state = 'UT', vars = 'air_temp')

cbind(d$STATION$STID,  d$STATION$OBSERVATIONS)

```

### Precip
``r
# requesting hourly totals
mw(service = 'precipitation', stid='SFLU1', start =  '201610250010', end ='201611250001', pmode='intervals', interval = 'hour', jsonsimplify = TRUE, returnURL =FALSE)
```

A quick reference for parameters can be accessed with `getparams()`

```r
# all parameters for all services
getparams()

# parameters for a specific service
getparams('networks')
```

There is also a shortcut api call to list variables

```r
mwvariables()
```

## Debugging

The mw() function generates an API request which may be inspected by setting `returnURL = TRUE`.  

E.g. this query
`mw(service = 'latest', county = 'Garfield', state = 'UT', vars = 'air_temp', returnURL = TRUE)`
returns this:
`http://api.mesowest.net/v2/stations/latest?&token=XX_YOURTOKEN_XX&county=Garfield&state=UT&vars=air_temp`


---

Note: This package was created independently from SynopticLabs, MesoWest, or any associates. It is intended to be used for research purposes only.
