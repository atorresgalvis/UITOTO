Aligned <- tabPanel(title = "Aligned sequences", 
	value = "Aligned",
	hr(),
	fixedRow(	
			column(3,
				fileInput("DMCs",
					label = tags$span(
					"File with the available DMCs (e.g. Output from the OpDMC approach)", 
					tags$i(
						class = "glyphicon glyphicon-info-sign", 
						style = "color:#91bd0d;",
						title = "The name of the CSV file that contains the available DMCs (e.g., Output from the OpDMC approach)."
					), ":"),			
					accept = c(".csv", ".CSV")
				),
			),	
			column(3,
				fileInput("nobody",
					label = tags$span(
					"Fasta file with specimens to be identified (the file should contain at least one specimen)", 
					tags$i(
						class = "glyphicon glyphicon-info-sign", 
						style = "color:#91bd0d;",
						title = "The name of the fasta file with the aligned sequences/specimens to be identified."
					), ":"),			
					accept = c(".fas", ".fasta", ".fs", ".FAS", ".FASTA", ".FS")
				),
			),
			column(3,
				sliderInput("subopt2", 
					label = tags$span(
					"Maximum mismatches allowed",
					tags$i(
						class = "glyphicon glyphicon-info-sign", 
						style = "color:#91bd0d;",
						title = "The maximum number of mismatches allowed for the identification step."
					), ":"),
					min = 0, max = 8,
					value = 1, step = 1
				),
			),
			column(2,
				textInput("OutName2", label = "Name of the output file:", value = "IdentificationOutput.csv"),
				textInput("OutMiss2", label = "Name of the file for missing data information:", value = "LogMissing.csv"),
			),
			column(1,
				actionButton("do2", "Run!", icon("computer"),
				style="color: white; background-color: #174364; border-color: #91bd0d; border-width: 1.5px"),
			),
		),
		hr(),			                     	
		mainPanel(
			fluidRow(
				column(12,
					shinyjs::useShinyjs(),
					downloadButton("downloadScript2", "Download the Identifier.R function here"),
					htmlOutput("comando2"),
					hidden(downloadButton("downloadResults2", "Download the results here")),
					hidden(downloadButton("downloadMissing2", "Download the missing data information here")),
					tableOutput("valor2")
				)
			)
		),
)
