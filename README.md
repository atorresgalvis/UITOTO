
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
online (<https://atorresgalvis.shinyapps.io/MolecularDiagnoses/>) or
locally in RStudio. UITOTO implements a new algorithm for building
optimal DMCs. Additionally, it enables the identification of unknown
sequences, whether aligned or unaligned, utilizing DMCs (this option is
also helpful in evaluating the reliability of the DMCs through
cross-validation). The Shiny App allows customizable production of
publication-quality DMC comparisons and visualizations.

## Pre-Installation

You may need to complete a pre-installation process to ensure your
environment is configured with the prerequisites required for UITOTO
installation. The complete list of packages from CRAN required by UITOTO
could be provided by typing in R:

``` r
packages <- c("dplyr", "ggplot2", "readr", "seqinr", "shiny", "shinyjs", "shinyWidgets")
```

Afterward, you can install the packages that have not yet been installed
all at once with:

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

After that, you can install Biostrings:

``` r
BiocManager::install("Biostrings")
```

As well as the DECIPHER package:

``` r
BiocManager::install("DECIPHER")
```

Now you should be ready to install UITOTO. However, it is advisable to
restart the RStudio session or simply close and reopen the program.

## Installation

Now that everything is ready, you have to ways for installing UITOTO.

``` r
# ....
```

## Examples

- Running the UITOTO Shiny app locally

  ``` r
  runUITOTO()
  ```

  **IMPORTANT:** By default, users of Shiny apps can only upload files
  up to 5 MB. You can increase this limit by setting the option before
  executing the UITOTO shiny app. For example, to allow up to 12 MB use:

  ``` r
  options(shiny.maxRequestSize = 12 * 1024^2)
  #And then run the UITOTO shiny app normally
  runUITOTO()
  ```

  <img src="https://github.com/atorresgalvis/UITOTO/tree/main/inst/app/www/img/UITOTOCover.PNG" alt="alt text" width="100%" />
  <p class="caption">
  Fig. 1. UITOTO Shiny app home page.
  </p>


- This is a basic example which shows you how to solve a common problem:

``` r
library(UITOTO)
## basic example code
```
