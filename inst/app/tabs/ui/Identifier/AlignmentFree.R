AlignmentFree <- tabPanel(title = "Alignment-free", 
	value = "AlignmentFree", #uf
	hr(),
	fixedRow(	
			column(2,
				fileInput("DMCs3", "File with the available DMCs (e.g. Output from the OpDMC approach):", accept = ".csv"),
			),	
			column(2,
				fileInput("nobody3", "Fasta file with specimens to be identified (it should contain at least one specimen):", accept = c(".fas", ".fasta", ".fs", ".FAS", ".FASTA", ".FS")),
			),
			column(2,
				sliderInput("subopt4", "Maximum mismatches allowed:",
					min = 0, max = 3,
					value = 0, step = 1
				),	
			),
			column(2,
				sliderInput("WinWidth", "Width of the sliding window:",
					min = 4, max = 40,
					value = 20, step = 2
				),	
			),			
			column(2,
				textInput("OutName4", label = "Name of the output file:", value = "IdentificationOutput.csv"),
			),
			column(2,
				actionButton("do4", "Run!", icon("computer"),
				style="color: white; background-color: #174364; border-color: #91bd0d; border-width: 1.5px"),
			),
	),
	hr(),			                     	
	mainPanel(
		fluidRow(
			column(12,
				shinyjs::useShinyjs(),
				downloadButton("downloadScript4", "Download the IdentifierU.R function here"),
				htmlOutput("comando4"),
				hidden(downloadButton("downloadResults4", "Download the results here")),
				tableOutput("valor4")
			)
		)
	),
)
