# openNHTSA
## Convenient access to the [NHTSA WebAPIs](http://www.nhtsa.gov/webapi/Default.aspx?Recalls/API/83)

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
library("openNHTSA")
```

## Examples

The wrapper currently supports two facilities: [`complaints`](http://www.nhtsa.gov/webapi/Default.aspx?Complaints/Metadata/81) and [`recalls`](http://www.nhtsa.gov/webapi/Default.aspx?Recalls/Metadata/83). Here's an html document showing [how results of the examples should look](https://github.com/statwonk/openNHTSA/blob/master/README.Rmd).

Complaints are reports filed by vehicle owners with the NHTSA. For example, this past weekend the power steering failed on my 2010 Ford Fusion. It was pretty scary so I wanted to see if anyone else had complained to the NHTSA with the same issue:

```{r}
ford_fusion_2010_complaints <- facility("complaints") %>%
    model_year("2010") %>%
    vehicle_make("ford") %>%
    vehicle_model("fusion") %>%
    nhtsa_fetch()

names(ford_fusion_2010_complaints)
# [1] "ODINumber"          "Manufacturer"       "Crash"              "Fire"               "NumberOfInjured"
#  [6] "NumberOfDeaths"     "DateofIncident"     "DateComplaintFiled" "Component"          "Summary"
# [11] "ProductType"        "ModelYear"          "Make"               "Model"              "VIN"

table(grepl("power steering", ford_fusion_2010_complaints$Summary, ignore.case = TRUE))
# FALSE  TRUE 
#  2001   320

head(ford_fusion_2010_complaints$Summary[grepl("power steering", ford_fusion_2010_complaints$Summary, ignore.case = TRUE)], 1)
# [1] "I HAVE A BRAND NEW 2010 FORD FUSION THAT HAS APPROXIMATELY 3000 MILES ON IT.  I HAD A BAD EXPERIENCE WHERE THE POWER STEERING SUDDENLY STOPPED WORKING WHILE PULLING MY CAR OUT OF A PARKING GARAGE.  THE VEHICLE CONSOLE DISPLAY SHOWED A 'POWER STEERING ASSIST FAILURE' MESSAGE.  I PULLED MY CAR OVER TO THE SIDE WITH CONSIDERABLE EFFORT AND SHUT THE IGNITION OFF.  AFTER A FEW MINUTES WAIT, I RESTARTED THE CAR AND EVERYTHING WAS NORMAL.  WITHIN A FEW MINUTES, A LESS THAN A MILE TRAVELED, THE SAME FAILURE OCCURRED AND THE SAME MESSAGE WAS DISPLAYED WHILE IN A ROUND-ABOUT.  I AGAIN PULLED MY CAR OVER AND SHUT IT OFF.  IT AGAIN RESTARTED AND STEERED FINE AND I DROVE IMMEDIATELY TO MY DEALERSHIP.  THE DEALERSHIP READ THE CODE, CLEARED IT AND INFORMED ME THAT THEY COULD NOT GET THE VEHICLE TO REPRODUCE THE PROBLEM.  THIS IS A VERY SCARY ISSUE AND NO COMPONENTS WERE REPLACED.  I AM A PRIOR OWNER OF A CHEVROLET COBALT AND I AM FAMILIAR WITH THEIR RECALL FOR THE ELECTRIC ASSIST.  MY COBALT DID NOT FAIL, BUT THEY REPLACED THE ASSIST MOTOR UNDER RECALL.  I DID NOT REALIZE THAT THE FORD FUSION NOW HAS ELECTRIC ASSIST.  ARE OTHER FUSION OWNERS HAVING INTERMITTENT FAILURES WITH THEIR STEERING? *TR"
```

The NHTSA API, and this wrapper, uses a hierarchical API structure like:
  -  facility (e.g. "recalls" or "complaints")
  -  model_year (e.g. "2010")
  -  vehicle_make("ford")
  -  vehicle_model("fusion")

These functions are "chained" together, much like the UNIX pipe operator. Their order _does_ matter and should be in the order shown in the list above. Finally, the `nhtsa_fetch()` function sends the query to the NHTSA api. The results are returned as a `data.frame`.

Find available years with a query like this:

```{r}
complaints <- facility("complaints") %>%
  nhtsa_fetch()

head(complaints, 5)

##   ModelYear
## 1      9999
## 2      2016
## 3      2015
## 4      2014
## 5      2013
```

# Find the vehicle makes available for a model year,

```{r}
complaints_2010 <- facility("complaints") %>%
  model_year("2010") %>%
  nhtsa_fetch()

head(complaints_2010, 5)

#   ModelYear      Make
# 1      2010    5STARR
# 2      2010     ACURA
# 3      2010  AERO CUB
# 4      2010  AEROLITE
# 5      2010 AIRSTREAM
```

# Find the vehicle models available for a make,

```{r}
ford_2010_complaints <- facility("complaints") %>%
    model_year("2010") %>%
    vehicle_make("ford") %>%
    nhtsa_fetch()

head(ford_2010_complaints, 5)
#   ModelYear Make          Model
# 1      2010 FORD CROWN VICTORIA
# 2      2010 FORD          E-150
# 3      2010 FORD          E-250
# 4      2010 FORD          E-350
# 5      2010 FORD          E-450
```

Fetch the actual complaints (or recalls):

```{r}
ford_fusion_2010_complaints <- facility("complaints") %>%
    model_year("2010") %>%
    vehicle_make("ford") %>%
    vehicle_model("fusion") %>%
    nhtsa_fetch()

str(ford_fusion_2010_complaints)
# 'data.frame':	2321 obs. of  15 variables:
#  $ ODINumber         : int  10270140 10273260 10267371 10281453 10284037 10285614 10287396 10294648 10296446 10299496 ...
#  $ Manufacturer      : chr  "Ford Motor Company" "Ford Motor Company" "Ford Motor Company" "Ford Motor Company" ...
#  $ Crash             : chr  "No" "No" "No" "No" ...
#  $ Fire              : chr  "No" "No" "No" "No" ...
#  $ NumberOfInjured   : int  0 0 0 0 0 0 0 0 0 0 ...
#  $ NumberOfDeaths    : int  0 0 0 0 0 0 0 0 0 0 ...
#  $ DateofIncident    : chr  "/Date(1239336000000-0400)/" "/Date(1243396800000-0400)/" "/Date(1240804800000-0400)/" "/Date(1244692800000-0400)/" ...
#  $ DateComplaintFiled: chr  "/Date(1243396800000-0400)/" "/Date(1244520000000-0400)/" "/Date(1241064000000-0400)/" "/Date(1251000000000-0400)/" ...
#  $ Component         : chr  "VISIBILITY" "SERVICE BRAKES, ELECTRIC" "VISIBILITY:WINDSHIELD" "LATCHES/LOCKS/LINKAGES" ...
#  $ Summary           : chr  "CAR WAS PURCHASED NEW CAR IS 2010 FUSION HYBRID. NOTICED CRACK IN WINDSHIELD STARTING UNDER REARVIEW MIRROR DO WEST FOR APPROX "| __truncated__ "I BOUGHT A 2010 FORD FUSION HYBRID ON MAY 23, 2009 FROM CROWN FORD OF FAYETTEVILLE, NC.   ON MAY 27, WHILE DRIVING DOWN THE ROA"| __truncated__ "TL*THE CONTACT OWNS A 2010 FORD FUSION SPORT. THE CONTACT STATED THAT THE WINDSHIELD CONTAINED A STRESS CRACK DUE TO THE HEAT. "| __truncated__ "THE HOOD ON MY 2010 FORD FUSION HYBRID UNLATCHES ITSELF AT INTERSTATE HIGHWAY SPEED. THE SAFETY CATCH HAS SUCCESSFULLY RESTRAIN"| __truncated__ ...
#  $ ProductType       : chr  "VEHICLE" "VEHICLE" "VEHICLE" "VEHICLE" ...
#  $ ModelYear         : chr  "2010" "2010" "2010" "2010" ...
#  $ Make              : chr  "FORD" "FORD" "FORD" "FORD" ...
#  $ Model             : chr  "FUSION" "FUSION" "FUSION" "FUSION" ...
#  $ VIN               : chr  NA "3FADP0L35AR" "3FAHP0KC2AR" "3FADP0L33AR" ...
```

## Acknowledgment
I highly admire the functional programming technique used by the authors of the [openfda API](https://github.com/rOpenHealth/openfda) wrapper (@rjpower and @leeper). Much of the code and documentation in this package is directly copied from that wrapper. That package is licenced under GPLv2, and so this package is also licened under the same licence. If either @rjpower or @leeper read this and would like to be made an author, I'll happily add them. :)
