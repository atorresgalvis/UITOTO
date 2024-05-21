<!-- README.md is generated from README.Rmd. Please edit that file -->

<p align="center">
<a href="https://atorresgalvis.shinyapps.io/MolecularDiagnoses/"><img src="https://github.com/atorresgalvis/UITOTO/blob/main/inst/app/www/img/UITOTOprime.PNG" alt="" width="70%"></a>
</p>

<!-- badges: start -->
<p align=center>
<a href="https://github.com/atorresgalvis/UITOTO"><img src="https://img.shields.io/github/r-package/v/atorresgalvis/UITOTO?label=UITOTO%20(Dev)"></a> 
<a href="https://doi.org/10.5281/zenodo.11236953"><img src="https://zenodo.org/badge/DOI/10.5281/zenodo.11236953.svg" alt="DOI"></a>
</p>
<!-- badges: end -->

<p align=center>
<a href="https://www.museumfuernaturkunde.berlin/en/science/research/dynamics-nature/centre-integrative-biodiversity-discovery"><img src="https://github.com/atorresgalvis/UITOTO/blob/main/inst/app/www/img/cibd_logo.jpg" alt="" width="16%"></a>
&emsp;&emsp;
<a href="https://www.museumfuernaturkunde.berlin/"><img src="https://github.com/atorresgalvis/UITOTO/blob/main/inst/app/www/img/mfnLogo.jpg" alt="" width="12%"></a>
</p>

The [**`UITOTO`**](https://github.com/atorresgalvis/UITOTO)
[R](https://www.r-project.org/) package addresses the challenges
associated with finding, testing, and visualizing reliable Diagnostic
Molecular Combinations (DMCs), especially those arising from
high-throughput taxonomy. The package also features a user-friendly
[Shiny](https://shiny.posit.co/) App that can be accessed
[online](https://atorresgalvis.shinyapps.io/MolecularDiagnoses/) or
locally in [RStudio](https://posit.co/products/open-source/rstudio/).

## 🧰 Pre-Installation

You may need to complete a pre-installation process to ensure your
environment is configured with the prerequisites required for
[**`UITOTO`**](https://github.com/atorresgalvis/UITOTO) installation.
The complete list of packages from [CRAN](https://cran.r-project.org/)
required by [**`UITOTO`**](https://github.com/atorresgalvis/UITOTO)
could be provided by typing in [R](https://www.r-project.org/):

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
packages from [Bioconductor](https://www.bioconductor.org) (Biostrings
and DECIPHER), it is highly recommended to follow the instructions
included in <https://www.bioconductor.org/install/>. The BiocManager
package is used for managing
[Bioconductor](https://www.bioconductor.org) resources, so to get it you
should use:

``` r
# Updated to 17/04/2024.
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install(version = "3.18")
```

After that, you can install
[Biostrings](https://bioconductor.org/packages/release/bioc/html/Biostrings.html):

``` r
BiocManager::install("Biostrings")
```

As well as the
[DECIPHER](https://www.bioconductor.org/packages/release/bioc/html/DECIPHER.html)
package:

``` r
BiocManager::install("DECIPHER")
```

Now you should be ready to install
[**`UITOTO`**](https://github.com/atorresgalvis/UITOTO). However, it is
advisable to restart the RStudio session or simply close and reopen the
program.

## 💾 Installation

Now that everything is ready, you have different ways for installing the
package.

1.  You can install the released version of
  [**`UITOTO`**](https://github.com/atorresgalvis/UITOTO) from
  <a href="https://github.com/"><img src="https://github.com/atorresgalvis/UITOTO/blob/main/inst/app/www/img/github-icon-mini.png" alt="" width="3%"></a> with:

  ``` r
  # Install and load devtools, if you don't have it, with the commands:
  # 		install.packages("devtools"); library(devtools)
  devtools::install_github("atorresgalvis/UITOTO")
  ```

2.  Additionally, you can download the source package (*e.g.*, the
  folder UITOTO_1.0.0.tar.gz) and install it using mouse-only navigation 🖱
  in [RStudio](https://posit.co/products/open-source/rstudio/):

  <div class="figure">
  <img src="https://github.com/atorresgalvis/UITOTO/blob/main/inst/app/www/img/Install2.PNG" alt="Installation of UITOTO using mouse-only navigation in RStudio." width="100%" />
  <p class="caption">
  Installation of UITOTO using mouse-only navigation in RStudio.
  </p>
  </div>

Then, you should load the package into your work session:

``` r
library(UITOTO)
```

## 👩‍💻 Get Started

- 🏃‍♂️ **Running the [**`UITOTO`**](https://github.com/atorresgalvis/UITOTO)**
  **Shiny app locally:**

  ``` r
  runUITOTO()
  ```

  ⚠️ **IMPORTANT:** By default, users of
  [Shiny](https://shiny.posit.co/) apps can only upload files up to 5
  MB. You can increase this limit by setting the option before executing
  the [**`UITOTO`**](https://github.com/atorresgalvis/UITOTO) shiny app.
  For example, to allow up to 12 MB use:

  ``` r
  options(shiny.maxRequestSize = 12 * 1024^2)
  #And then run the UITOTO shiny app normally
  runUITOTO()
  ```

  <div class="figure">
  <img src="https://github.com/atorresgalvis/UITOTO/blob/main/inst/app/www/img/UITOTOCover.PNG" alt="UITOTO Shiny app home page." width="100%" />
  <p class="caption">
  UITOTO Shiny app home page.
  </p>
  </div>

- 🔍 **Find Diagnostic Molecular Combinations (DMCs)**

  You could use the module *Find DMCs* of the
  [**`UITOTO`**](https://atorresgalvis.shinyapps.io/MolecularDiagnoses/)
  Shiny app for identifying reliable DMCs. However, for very
  time-consuming searches ⏳, the command-driven version is strongly
  recommended. For this, you will need to use the `OpDMC` function.
  You will notice that the function includes eight different arguments for configuring searches. 
	However, most of them are provided with default settings, enhancing user-friendliness while also 
	enabling customized DMC searches. The complete syntax of the ```OpDMC``` function is outlined below.
	Information regarding each argument can be found in the [package manual](https://github.com/atorresgalvis/UITOTO/blob/main/UITOTO_1.0.0.pdf), 
	function help documentation (use `?OpDMC` in the console), or directly within the 
	[**```UITOTO```**](https://atorresgalvis.shinyapps.io/MolecularDiagnoses/) Shiny app:

  ``` r
  OpDMC("FastaFile.fasta", 
        "SpeciesList.csv", 
        iter = 20000, 
        MnLen = 4, 
        exclusive = 4, 
        RefStrength = 0.25, 
        OutName = "OpDMC_output.csv", 
        GapsNew = FALSE
  )
  ```

  👀 Note well that the
  [**`UITOTO`**](https://atorresgalvis.shinyapps.io/MolecularDiagnoses/)
  Shiny app can also function as a scripter. This means you don’t have
  to worry about the syntax of the commands; you simply need to drag the
  files and modify the settings using mouse-only navigation 🖱. The app
  will then automatically display the equivalent
  [R](https://www.r-project.org/) commands based on the actions you
  performed visually:

  <div class="figure">
  <img src="https://github.com/atorresgalvis/UITOTO/blob/main/inst/app/www/img/FindDMC.PNG" alt="Module 'Find DMCs' of the UITOTO Shiny app." width="100%" />
  <p class="caption">
  Module 'Find DMCs' of the UITOTO Shiny app.
  </p>

  The two mandatory arguments that the user must provide are the names of the input files to be used during the 
	searches. The format and conventions of the input files used by
  [**`UITOTO`**](https://github.com/atorresgalvis/UITOTO) are quite
  simple. First, just provide a single-column csv file with the list of
  entities (*e.g.*, species, genera, OTUs) you wish to diagnose:

  ``` r
  Megaselia_fengae
  Megaselia_oliverleei
  Megaselia_singaporensis
  Megaselia
  ```

  On the other hand, the `OpDMC` function reads each one of the rows of the previous file
  as a character/string vector and selects those sequences from the
  fasta file that have the string in its header. So, it doesn’t matter
  the format of the header of your sequence as long as it contains the
  recognition pattern/string. For example, the fasta file could look
  like this::

  ``` r
  >ZRCBDP0359666_Senph04Megaselia_oliverleei_holotype
  -tt-tcgtcatctattgcacatatcggctatgctgttgatttagcaattttctcccttcacttggccggaattttttttattttaggagcagtaaatttttttactacaattattggtatacgctcatcaggaatctcattcgaccgaatgcctttatttgtaaaatacgtaggaattaccgcccttttacttcttttat--------gtattagccggagctatcacaatattattaacagatcgaaattttaatacatcatttttcgaccctgcaggaggaggagatccccttttatatca----------
  >Megaselia_fengae
  tttctcgtcatctattgcacatatcggctatgctgttgatttagcaattttctcccttcacttggccggaattttttttattttaggagcagtaaatttttttactacaattattggtatacgctcatcaggaatctcattcgaccgaatgcctttatttgtaaaatacgtaggaattaccgcccttttacttcttttatcgtattagccggagctatcacaatattattaacagatcgaaattttaatacatcatttttcgaccctgcaggaggaggagatccccttttatatca-----------------   
  >ZRCBDP0364918_LPU09_PU14_Pulau-Ubin_19Apr2018|Megaselia_singaporensis
  cggagctatcacaatattatt---a--attg-g--ta-acg-tc--tca-c-g-aat-ct--tt-atttgtaaaatacg-taggaattaccg-cccttt-tacttcttttatcgtattagccggagctatcacaatattattaacagatcgaaattttaatacatcatttttcgaccctgcaggaggaggagatccccttttatatcaatctattgcacatatcggctatgctgttgatttagcaattttctcccttcacttgatctattgcacatatcggctatgctgttgatttagcaattttctcccttc
  ```
  That's it! Once you have your input files, you are ready to perform DMC searches using the command-drive version or the [**```UITOTO```**](https://atorresgalvis.shinyapps.io/MolecularDiagnoses/) Shiny app.

- 🧬 **Identifying unknown –aligned and unaligned– sequences using DMCs**

  …👷‍♀️🚧👷‍♂️

## 📝 Citation
