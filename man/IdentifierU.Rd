\name{IdentifierU}
\alias{IdentifierU}
\title{Alignment-free identification of unknown sequences using DMCs}
\description{
	This approach follows an alignment-free methodology	for identification of unknown sequences using DMCs.
}
\usage{
IdentifierU(
	DMC_Output, 
	dataset, 
	mismatches = 1, 
	WinWidth = 20, 
	OutName = "IdentificationOutput.csv"
)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{DMC_Output}{
		mandatory: the name of the CSV file that contains the available DMCs.
}
  \item{dataset}{
		mandatory: the name of the fasta file with the (aligned or unaligned) sequences to be identified.
}
  \item{mismatches}{
		optional integer: the maximum number of mismatches allowed for the identification step. The default is \code{1}.
}
  \item{WinWidth}{
		optional integer: width of the sliding window expresed in number of sites. The default is \code{20}.
}
  \item{OutName}{
		optional: the name of the CSV output file containing the identification of the unknown sequences. The default is \code{"IdentificationOutput.csv"}.
}
}
\details{
	Through iterative exploration utilizing a dynamic sliding window, it compares the extracted patterns with each provided DMC pattern. 
	Users can also set a number of mismatches allowed. This procedure is the less precise among the methods included in UITOTO for 
	Taxonomic verification and identification using DMCs. Thus, it is only recommended for special situations in which the 
	alignment used for obtaining the provided DMCs is not available.
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

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
## You can find the files "XXX" and "XXX" in the data folder of the packages. 
## If you want to run the example. Make sure you have these files in your current working directory.
IdentifierU(
	"OpDMC_output.csv",
	"DatasetQuerySequences.fas",
	mismatches = 0,
	WinWidth = 20,
	OutName = "IdentificationOutput.csv"
)
}