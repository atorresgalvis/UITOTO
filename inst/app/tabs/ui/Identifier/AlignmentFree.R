AlignmentFree <- tabPanel(title = "Alignment-free", 
	value = "AlignmentFree", #uf
	hr(),
	fixedRow(	
			column(2,
				fileInput("DMCs3",
					label = tags$span(
					"CSV file containing the available DMCs", 
					tags$i(
						class = "glyphicon glyphicon-info-sign", 
						style = "color:#91bd0d;",
						title = "The name of the CSV file that contains the available DMCs (e.g., Output from the OpDMC approach)."
					), ":"),			
					accept = c(".csv", ".CSV")
				),
			),	
			column(2,
				fileInput("nobody3",
					label = tags$span(
					"Fasta file with specimens to be identified", 
					tags$i(
						class = "glyphicon glyphicon-info-sign", 
						style = "color:#91bd0d;",
						title = "The name of the fasta file with the sequences/specimens to be identified."
					), ":"),			
					accept = c(".fas", ".fasta", ".fs", ".FAS", ".FASTA", ".FS")
				),
			),
			column(2,
				sliderInput("subopt4", 
					label = tags$span(
					"Maximum mismatches allowed",
					tags$i(
						class = "glyphicon glyphicon-info-sign", 
						style = "color:#91bd0d;",
						title = "The maximum number of mismatches allowed for the identification step."
					), ":"),
					min = 0, max = 3,
					value = 1, step = 1
				),	
			),
			column(2,
				sliderInput("WinWidth", 
					label = tags$span(
					"Width of the sliding window",
					tags$i(
						class = "glyphicon glyphicon-info-sign", 
						style = "color:#91bd0d;",
						title = "Width of the sliding window expresed in number of sites."
					), ":"),
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
