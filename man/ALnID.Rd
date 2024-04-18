\name{ALnID}
\alias{ALnID}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Align and Identify unknown sequences using DMCs}
\description{
	Align a pool of unknown sequences against the alignment used for obtaining the provided DMCs.
	Susequently, the resulting aligned unknown sequences are identified based on their matching patterns with respect to the DMCs.
	This procedure could also be used to evaluate the performance of the available DMCs.
}	
\usage{
ALnID(
	DMC_Output, 
	dataTarget, 
	dataQuery, 
	mismatches = 1, 
	against = c("First", "All"), 
	perfectMatch = 5, 
	misMatch = 0, 
	gapOpening = -14, 
	gapExtension = -2, 
	gapPower = -1, 
	terminalGap = 0, 
	OutName = "IdentificationOutput.csv", 
	MissLogFile = "LogMissing.csv", 
	AligName = "None"
)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
	\item{DMC_Output}{
		mandatory: the name of the CSV file that contains the available DMCs.
	}
	\item{dataTarget}{
		mandatory: the name of the fasta file with the alingment used for obtaining the DMCs.
	}
	\item{dataQuery}{
		mandatory: the name of the fasta file with the sequences/specimens to be identified.
	}
	\item{mismatches}{
		optional integer: the maximum number of mismatches allowed for the identification step. The default is \code{1}.
	}
	\item{against}{
		optional: align each unknown sequence against the \code{First} sequence or against \code{All} sequences available in the \code{dataTarget} file. 
		The default is \code{First} (much faster than option \code{All}).
	}
	\item{perfectMatch}{
		optional numeric: giving the reward for aligning two matching nucleotides in the alignment. The default is \code{5}.
	}
	\item{misMatch}{
		optional numeric: giving the cost for aligning two mismatched nucleotides in the alignment. The default is \code{0}.
	}
	\item{gapOpening}{
		optional numeric: giving the cost for opening a gap in the alignment. The default is \code{-14}.
	}
	\item{gapExtension}{
		optional numeric: giving the cost for extending an open gap in the alignment. The default is \code{-2}.
	}
	\item{gapPower}{
		optional numeric: specifying the exponent to use in the gap cost function (see the function \code{AlignProfiles} of the \code{DECIPHER} package). The default is \code{-1}.
	}
	\item{terminalGap}{
		optional numeric: giving the cost for allowing leading and trailing gaps ("-" or "." characters) in the alignment. The default is \code{0}.
	}
	\item{OutName}{
		optional: the name of the CSV output file containing the identification of the unknown sequences. The default is \code{"IdentificationOutput.csv"}.
	}
	\item{MissLogFile}{
		optional: the name of the CSV output file containing the comparisons that were not possible to do due missing data. The default is \code{"LogMissing.csv"}. If you use \code{"none"}, the step of checking for missing data will not be performed (this saves a lot of time but comparisons are less precise. Thus, this option is not recommended for sequences that could result in gappy alignments).
	}
	\item{AligName}{
		optional: the name of the output fasta file containing the resulting alignment. The default is \code{"ResultingAlignment.fasta"}.
	}
}
\details{
	The alignment function \code{AlignProfiles} of the \code{DECIPHER} package is used for aligning the unknown sequences against the alignment 
	used for obtaining the provided DMCs. The users can modify the different settings of the alignment step.
	In addition, the users can define the number of mismatches allowed for the identification step.
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
	
	Pagès, H., Aboyoun, P., Gentleman, R., DebRoy, S. (2024). Biostrings: Efficient manipulation of biological strings. R package \href{https://bioconductor.org/packages/Biostrings}{https://bioconductor.org/packages/Biostrings}.
	
	Wright, E.S. (2016). Using DECIPHER v2.0 to Analyze Big Biological Sequence Data in R. The R Journal, 8(1), 352-359.
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
ALnID(
	"OpDMC_output.csv", 
	"DatasetAlignedTarget.fas", 
	"DatasetUnalignedQuery.fas", 
	mismatches = 1, 
	against= "First", 
	perfectMatch=5, 
	misMatch=0, 
	gapOpening = -14, 
	gapExtension = -2, 
	gapPower = -1, 
	terminalGap = 0, 
	OutName = "IdentificationOutput.csv", 
	MissLogFile= "LogMissing.csv", 
	AligName = "None"
)
}
