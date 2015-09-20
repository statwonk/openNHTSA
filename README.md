# openNHSTA
## Convenient access to the [NHSTA WebAPIs](http://www.nhtsa.gov/webapi/Default.aspx?Recalls/API/83)

This package provides some simple helpers for accessing the U.S. Department of Transportation's [National Highway Traffic Safety Administration API](http://www.nhtsa.gov/webapi/Default.aspx?Recalls/API/83) 
from R.  It uses the `jsonlite` and `magrittr` packages to provide a simple way to convert from National Highway Traffic Safety Administration queries to R dataframes suitable for quick analysis and plotting.

## Installation

This library has not yet been added to CRAN, so you'll need the devtools
package to install it:

```R
install.packages("devtools")
````

Once devtools is installed, you can grab this package:

```R
library("devtools")
devtools::install_github("statwonk/openNHTSA")
```

Load it in like any other package:

```{r}
library("openNHSTA")
library("magrittr")
```

## Examples

```{r, echo=FALSE, results='hide'}
library("knitr")
opts_knit$set(upload.fun = imgur_upload, base.url = NULL)
```

```{r}
complaints <- facility("complaints") %>%
  nhtsa_fetch()

head(complaints, 5)
```

```{r}
complaints_2010 <- facility("complaints") %>%
  model_year("2010") %>%
  nhtsa_fetch()

head(complaints_2010, 5)
```

```{r}
ford_2010_complaints <- facility("complaints") %>%
    model_year("2010") %>%
    vehicle_make("ford") %>%
    nhtsa_fetch()

head(ford_2010_complaints, 5)
```


```{r}
ford_fusion_2010_complaints <- facility("complaints") %>%
    model_year("2010") %>%
    vehicle_make("ford") %>%
    vehicle_model("fusion") %>%
    nhtsa_fetch()

str(ford_fusion_2010_complaints)
```

## Acknowledgment
I highly admire the functional programming technique used by the authors of the [openfda API](https://github.com/rOpenHealth/openfda) wrapper (@rjpower and @leeper). Much of the code and documentation in this package is directly copied from that wrapper. That package is licenced under GPLv2, and so this package is also licened under the same licence. If either @rjpower or @leeper read this and would like to be made an author, I'll happily add them. :)
