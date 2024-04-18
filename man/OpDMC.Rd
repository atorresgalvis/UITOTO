\name{OpDMC}
\alias{OpDMC}
\title{Find Diagnostic Molecular Combinations (DMCs)}
\description{
	Find reliable Diagnostic Molecular Combinations (DMCs) to be used in high-throughput taxonomy.
}
\usage{
OpDMC(
	FastaFile, 
	species, 
	iter = 20000, 
	MnLen = 4, 
	exclusive = 4, 
	RefStrength = 0.25, 
	OutName = "OpDMC_output.csv", 
	GapsNew = FALSE
)
}
\arguments{
	\item{FastaFile}{
		mandatory: the name of the fasta file containing aligned sequences for obtaining the DMCs.
	}
	\item{species}{
		mandatory: the name of the CSV file with the query-taxa list (i.e., taxa for which you want to find the DMCs).
	}
	\item{iter}{
		optional integer: the number of iterations (i.e., the number of molecular combinations to be tested). The default is \code{20000}.
	}
	\item{MnLen}{
		optional integer: the minimum length that DMCs must have. The default is \code{4}.
	}
	\item{exclusive}{
		optional integer: the minimum number of exclusive character states that DMCs must have. The default is \code{4}.
	}
	\item{RefStrength}{
		optional double (decimal value): the refinement strength (i.e., the proportion of sub-combinations from each DMC to test). The default is \code{0.25}.
	}
	\item{OutName}{
		optional: the name of the CSV output file containing the DMCs. The default is \code{"OpDMC_output.csv"}.
	}
	\item{GapsNew}{	
		optional logical (\code{TRUE} or \code{TRUE}): If \code{TRUE}, the gaps will be treated as a new state. The default is \code{FALSE}.
	}
}
\details{
	This method assigns a weight to each site based on the Jaccard index 
	(i.e., the number of sequences in which the site states differ from the site state in the query taxon). It then uses a Weighted Random Sampling approach to 
	build the candidate combinations to become DMCs. At the same time, the method uses a stability measure of the specificity of the candidate combinations to assess 
	their reliability. This measure relies on the minimum number of exclusive character states for each one of the candidate combinations.
	As a final step, with the most frequent sites in the combinations that meet the preceding criterion, the final DMC is built (which must also meet the same criterion).
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
	Charif, D., Lobry, J.R. (2007). SeqinR 1.0-2: A Contributed Package to the R Project for Statistical Computing Devoted to Biological Sequences Retrieval and Analysis. In: Bastolla, U., Porto, M., Roman, H.E., Vendruscolo, M. (eds) Structural Approaches to Sequence Evolution. Biological and Medical Physics, Biomedical Engineering. Springer, Berlin, Heidelberg.
}
\author{
	Ambrosio Torres (Researcher [Ctr. Integr. Biodivers. Discov. - Museum für Naturkunde, Berlin, Germany)
}
\note{
%%  ~~further notes~~
}

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
## You can find the files "XXX" and "XXX" in the data folder of the packages. 
## If you want to run the example. Make sure you have these files in your current working directory.
OpDMC(
	"MegaseliaTraining.fasta", 
	"SpeciesListMegaselia.csv", 
	iter = 5000, 
	MnLen = 3, 
	exclusive = 2, 
	RefStrength = 0.10, 
	OutName = "OpDMC_Megaselia.csv", 
	GapsNew = FALSE
)
}
