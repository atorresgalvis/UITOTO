\name{runUITOTO}
\alias{runUITOTO}
\title{Run the UITOTO shiny app locally}
\description{
	Execute the UITOTO shiny app locally. You can also run UITOTO online by visiting \cr
	\href{https://atorresgalvis.shinyapps.io/MolecularDiagnoses/}{https://atorresgalvis.shinyapps.io/MolecularDiagnoses/}.
}
\usage{
runUITOTO()
}
%- maybe also 'usage' for other objects documented here.
\details{
IMPORTANT: By default, users of Shiny apps can only upload files up to 5 MB.
You can increase this limit by setting the \code{shiny.maxRequestSize} option 
before executing UITOTO. 

\code{#For example, to allow up to 12 MB use:} \cr
\code{options(shiny.maxRequestSize = 12 * 1024^2)} \cr
\code{#And then run UITOTO normally:} \cr
\code{runUITOTO()} \cr
}
