Search <- tabPanel(title = "Find DMCs", 
	value = "Search",
	hr(),
	HTML("<h3><b>Find Diagnostic Molecular Combinations (DMCs)</b></h3>"),
	hr(),
	sidebarLayout(
		sidebarPanel(
			fileInput("FastaFile", "Fasta file with the alignment:", accept = c(".fas", ".fasta", ".fs", ".FAS", ".FASTA", ".FS")),
			fileInput("species", "File with the query-taxa:", accept = ".csv"),
			checkboxInput("GapsNew", "Gaps are treated as a new state", FALSE),
			tags$style("input[type=checkbox] { accent-color: #174364; }"),
			tags$style("input[type=radio] { accent-color: #91bd0d; }"),
			verbatimTextOutput("gaps"),
			textInput("OutName", label = "Name of the output file:", value = "OpDMC_output.csv"),
			sliderInput("iter", "Iterations x 1000 (i.e. 5 = 5000):",
				min = 5, max = 150,
				value = 20, step = 1
			),
			sliderInput("MnLen", "Minimum length:",
				min = 2, max = 15,
				value = 4, step = 1
			),	
			sliderInput("exclusive", "Minimum number of exclusive character states:",
				min = 1, max = 10,
				value = 4, step = 1
			),	
			sliderInput("RefStrength", "Refinement strength:",
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
