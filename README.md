# tidyseg

This package implements a tidy approach to calculating various measures of segregation used in demography and spatial statistics.

## Installation

For now, `tidyseg` is not available on CRAN and therefore should be installed from GitHub:

```r
remotes::install_github("slu-openGIS/tidyseg")
```

## Usage

As this time, the package includes a function for estimating index of dissimilarity values:

```r
> df <- stlRace
>
> ts_dissim(df, popA = black, popB = white, return = "index")
[1] 0.6148765
```
