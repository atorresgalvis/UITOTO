\name{Identifier}
\alias{Identifier}
\title{Identify unknown aligned sequences using DMCs}
\description{
	A set of unknown aligned sequences are identified based on their matching patterns with respect to the DMCs.
	This procedure could also be used to evaluate the performance of the available DMCs. Additionally, the users can define the 
	number of mismatches allowed for the identification.
}
\usage{
Identifier(
	DMC_Output, 
	dataset, 
	mismatches = 1, 
	OutName = "IdentificationOutput.csv", 
	MissLogFile = "LogMissing.csv"
)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
	\item{DMC_Output}{
		mandatory: the name of the CSV file that contains the available DMCs.
	}
	\item{dataset}{
		mandatory: the name of the fasta file with the sequences/specimens to be identified.
	}
	\item{mismatches}{
		optional integer: the maximum number of mismatches allowed for the identification step. The default is \code{1}.
	}
	\item{OutName}{
		optional: the name of the CSV output file containing the identification of the unknown sequences. The default is \code{"IdentificationOutput.csv"}.
	}
	\item{MissLogFile}{
		optional: the name of the CSV output file containing the comparisons that could not be done due missing data. The default is \code{"LogMissing.csv"}. If you use \code{"none"}, the step of checking for missing data will not be performed (this saves a lot of time but comparisons are less precise. Thus, this option is not recommended for gappy alignments).
	}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
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
Identifier(
	"OpDMC_output.csv",
	"DatasetAlignedQuery.fas",
	mismatches = 1,
	OutName = "IdentificationOutput.csv",
	MissLogFile= "LogMissing.csv"
)
}

