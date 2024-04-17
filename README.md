
<!-- README.md is generated from README.Rmd. Please edit that file -->

# UITOTO

<!-- badges: start -->
<!-- badges: end -->

The development of integrative taxonomy has facilitated the discovery
and description of thousands of new species. However, proper molecular
diagnoses in published descriptions of new species are still uncommon.
This could be attributed to i) the absence of standardized pipelines to
accommodate molecular data to the bionomenclature codes requirements;
and ii) the lack of software that can effectively handle large sequence
datasets. UITOTO addresses the challenges associated with finding,
testing, and visualizing reliable Diagnostic Molecular Combinations
(DMCs), especially those arising from high-throughput taxonomy. The
package also features a user-friendly Shiny App that can be accessed
online or locally in RStudio. UITOTO implements a new algorithm for
building optimal DMCs. Additionally, it enables the identification of
unknown sequences, whether aligned or unaligned, utilizing DMCs (this
option is also helpful in evaluating the reliability of the DMCs through
cross-validation). The Shiny App allows customizable production of
publication-quality DMC comparisons and visualizations.

## Pre-Installation

You may need to complete a pre-installation process to ensure your
environment is configured with the prerequisites required for UITOTO
installation. The list of packages from CRAN required by UITOTO could be
provided by typing in R:

``` r
packages <- c("dplyr", "ggplot2", "readr", "seqinr", "shiny", "shinyjs", "shinyWidgets")
```

Afterward, you can install packages that have not yet been installed all
at once with:

``` r
installed_packages <- packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(packages[!installed_packages])
}
```

As UITOTO uses some packages from Bioconductor (BiocManager, Biostrings,
and DECIPHER), it is highly recommended to follow the instructions in
<https://www.bioconductor.org/install/>. BiocManager is used for
managing Bioconductor resources, so to get Bioconductor you should use:

``` r
# Updated to 17/04/2024.
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install(version = "3.18")
```

After that, you can install Biostrings and DECIPHER by using:

``` r
BiocManager::install("Biostrings")
BiocManager::install("DECIPHER")
```

## Installation

You can install the development version of UITOTO like so:

``` r
# FILL THIS IN! HOW CAN PEOPLE INSTALL YOUR DEV PACKAGE?
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(UITOTO)
## basic example code
```

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

``` r
summary(cars)
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this.

You can also embed plots, for example:

``` r
plot(pressure)
```

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub and CRAN.
