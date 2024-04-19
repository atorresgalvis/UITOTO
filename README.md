
<!-- README.md is generated from README.Rmd. Please edit that file -->

<p align="center">
<a href="https://atorresgalvis.shinyapps.io/MolecularDiagnoses/"><img src="https://github.com/atorresgalvis/UITOTO/blob/main/inst/app/www/img/UITOTOprime.PNG" alt="" width="70%"></a>
</p>

<!-- badges: start -->
<p align=center>
<a href="https://github.com/atorresgalvis/UITOTO"><img src="https://img.shields.io/github/r-package/v/atorresgalvis/UITOTO?label=UITOTO%20(Dev)"></a>
</p>
<!-- badges: end -->

<p align=center>
<a href="https://www.museumfuernaturkunde.berlin/"><img src="https://github.com/atorresgalvis/UITOTO/blob/main/inst/app/www/img/cibd_logo.jpg" alt="" width="19%"></a>
&emsp;
<a href="https://www.museumfuernaturkunde.berlin/"><img src="https://github.com/atorresgalvis/UITOTO/blob/main/inst/app/www/img/mfnLogo.jpg" alt="" width="16%"></a>
</p>

The development of integrative taxonomy has facilitated the discovery
and description of thousands of new species. However, proper molecular
diagnoses in published descriptions of new species are still uncommon.
This could be attributed to i) the absence of standardized pipelines to
accommodate molecular data to the bionomenclature codes requirements;
and ii) the lack of software that can effectively handle large sequence
datasets. [**`UITOTO`**](https://github.com/atorresgalvis/UITOTO)
addresses the challenges associated with finding, testing, and
visualizing reliable Diagnostic Molecular Combinations (DMCs),
especially those arising from high-throughput taxonomy. The package also
features a user-friendly Shiny App that can be accessed online
[online](https://atorresgalvis.shinyapps.io/MolecularDiagnoses/) or locally in
RStudio. [**`UITOTO`**](https://github.com/atorresgalvis/UITOTO)
implements a new algorithm for building optimal DMCs. Additionally, it
enables the identification of unknown sequences, whether aligned or
unaligned, utilizing DMCs (this option is also helpful in evaluating the
reliability of the DMCs through cross-validation). The Shiny App allows
customizable production of publication-quality DMC comparisons and
visualizations.

## Pre-Installation

You may need to complete a pre-installation process to ensure your
environment is configured with the prerequisites required for
[**`UITOTO`**](https://github.com/atorresgalvis/UITOTO) installation.
The complete list of packages from CRAN required by
[**`UITOTO`**](https://github.com/atorresgalvis/UITOTO) could be
provided by typing in R:

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

As [**`UITOTO`**](https://github.com/atorresgalvis/UITOTO) uses some
packages from Bioconductor (BiocManager, Biostrings, and DECIPHER), it
is highly recommended to follow the instructions in
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

Now you should be ready to install
[**`UITOTO`**](https://github.com/atorresgalvis/UITOTO). However, it is
advisable to restart the RStudio session or simply close and reopen the
program.

## Installation

Now that everything is ready, you have to ways for installing the
package. You can install the released version of
[**`UITOTO`**](https://github.com/atorresgalvis/UITOTO) from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("atorresgalvis/UITOTO")
```

Then, you should load the package into your work session:

``` r
library(UITOTO)
```

## Examples

- Running the [**`UITOTO`**](https://github.com/atorresgalvis/UITOTO)
  Shiny app locally

  ``` r
  runUITOTO()
  ```

  **IMPORTANT:** By default, users of Shiny apps can only upload files
  up to 5 MB. You can increase this limit by setting the option before
  executing the [**`UITOTO`**](https://github.com/atorresgalvis/UITOTO)
  shiny app. For example, to allow up to 12 MB use:

  ``` r
  options(shiny.maxRequestSize = 12 * 1024^2)
  #And then run the UITOTO shiny app normally
  runUITOTO()
  ```

  <div class="figure">

  <img src="https://github.com/atorresgalvis/UITOTO/blob/main/inst/app/www/img/UITOTOCover.PNG" alt="**Fig. 1.** UITOTO Shiny app home page." width="100%" />
  <p class="caption">
  Fig. 1. UITOTO Shiny app home page.
  </p>

  </div>

- This is a basic example which shows you how to solve a common problem:

``` r
library(UITOTO)
## basic example code
```
