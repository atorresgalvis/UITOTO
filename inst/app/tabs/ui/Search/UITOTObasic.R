Search <- tabPanel(title = "Find DMCs", 
	value = "Search",
	hr(),
	HTML("<h3><b>Find Diagnostic Molecular Combinations (DMCs)</b></h3>"),
	hr(),
	sidebarLayout(
		sidebarPanel(
			fileInput("FastaFile",
				label = tags$span(
                  "Fasta file with the alignment", 
                  tags$i(
                    class = "glyphicon glyphicon-info-sign", 
                    style = "color:#91bd0d;",
                    title = "The name of the fasta file containing aligned sequences for obtaining the DMCs."
                  ), ":"),			
				accept = c(".fas", ".fasta", ".fs", ".FAS", ".FASTA", ".FS")
			),
			fileInput("species",  
				label = tags$span(
                  "File with the query-taxa", 
                  tags$i(
                    class = "glyphicon glyphicon-info-sign", 
                    style = "color:#91bd0d;",
                    title = "The name of the CSV file with the query-taxa list (i.e., taxa for which you want to find the DMCs)."
                  ), ":"),
				accept = ".csv"
			),
			checkboxInput("GapsNew",
				label = tags$span(
                  "Gaps are treated as a new state", 
                  tags$i(
                    class = "glyphicon glyphicon-info-sign", 
                    style = "color:#91bd0d;",
                    title = "Check this option if you want to treat the gaps as a new state."
                )),
				FALSE
			),
			tags$style("input[type=checkbox] { accent-color: #174364; }"),
			tags$style("input[type=radio] { accent-color: #91bd0d; }"),
			verbatimTextOutput("gaps"),
			textInput("OutName", label = "Name of the output file:", value = "OpDMC_output.csv"),
			sliderInput("iter", 
				label = tags$span(
                  "Iterations x 1000 (i.e. 5 = 5000)",
                  tags$i(
                    class = "glyphicon glyphicon-info-sign", 
                    style = "color:#91bd0d;",
                    title = "This is the number of molecular combinations that will be tested."
                ), ":"),
				min = 5, max = 150,
				value = 20, step = 1
			),
			sliderInput("MnLen", 
				label = tags$span(
					"Minimum length",
					tags$i(
						class = "glyphicon glyphicon-info-sign", 
						style = "color:#91bd0d;",
						title = "This is the minimum length that the resulting DMCs must have."
					), 
					":"
				),
				min = 2, max = 15,
				value = 8, step = 1
			),	
			sliderInput("exclusive", 
				label = tags$span(
					"Minimum number of exclusive character states",
					tags$i(
						class = "glyphicon glyphicon-info-sign", 
						style = "color:#91bd0d;",
						title = "This is the minimum number of exclusive character states that the resulting DMCs must have.
This implies that the resultant DMCs will possess, at minimum, the specified number of 
exclusive character states when compared to other species."
					), 
					":"
				),
				min = 1, max = 10,
				value = 4, step = 1
			),	
			sliderInput("RefStrength", 
				label = tags$span(
					"Refinement strength",
					tags$i(
						class = "glyphicon glyphicon-info-sign", 
						style = "color:#91bd0d;",
						title = "This is the proportion of sub-combinations from each resulting DMC that will be tested. 
The higher the refinement strength, the more likely the program is to identify potential shorter DMCs.
However, take into account that the refinement strength also increases the time consumption."
					), 
					":"
				),
				min = 0.0, max = 1,
				value = 0.25, step = 0.05
			),
			actionButton("do", "Run!", icon("computer"),
				style="color: white; background-color: #174364; border-color: #91bd0d; border-width: 1.5px"),                       	
		),
		mainPanel(
			fluidRow(
				column(12,
					shinyjs::useShinyjs(),
					downloadButton("downloadScript", "Download the OpDMC.R function here"),
					htmlOutput("comando"),
					hr(),
					hidden(downloadButton("downloadResults", "Download the results here")),
					tableOutput("valor")
				)
			)
		)
	)                                                      
)
