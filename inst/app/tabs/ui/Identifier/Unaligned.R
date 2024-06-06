Unaligned <- tabPanel(title = "Align + Identify", 
	value = "Unaligned", #uf
	hr(),
	fixedRow(
		tags$head(tags$style(HTML('.irs--shiny .irs-bar {
										background: #91bd0d;
										border-top: 2px solid #91bd0d;
										border-bottom: 2px solid #91bd0d;
									}
									.irs--shiny .irs-to, .irs--shiny .irs-from {
										background-color: #174364;
									}
									.irs--shiny .irs-handle {
									border: 1.5px solid #91bd0d;
									background-color: #174364;
									}
									.irs--shiny .irs-min{
									border: 0px solid #91bd0d;
									background-color: #174364;
									color: white;
									border-radius: 0% 40% 0% 40%;
									}
									.irs--shiny .irs-max {
									border: 0px solid #91bd0d;
									background-color: #174364;
									color: white;
									border-radius: 40% 0% 40% 0%;
									}
									.irs--shiny .irs-single {
									border: 0px solid #91bd0d;
									background-color: #174364;
									color: white;
									border-radius: 0% 0% 90% 90%;
									}
									.btn-file {  
									background-color:#91bd0d; 
									border-color: #174364; 
									}
									.progress-bar {
									background-color: #174364;
									}
									.form-control {
									opacity: 1;
									border-color: #174364;
									color: black;
									}
									.form-control[disabled], .form-control[readonly], fieldset[disabled] .form-control {
									background-color: white;
									color: black;
									opacity: 1;
									}
									.btn-default {
									color: black;
									background-color: #91bd0d;
									border-color: #174364;
									}
									.bttn-fill.bttn-success {
									background: #91bd0d;
									color: black;
									opacity: 0.5;
									border-color: #174364;
									}
								  ')
							 )
		),
			column(2,
				fileInput("DMCs2",
					label = tags$span(
					"File with the available DMCs", 
					tags$i(
						class = "glyphicon glyphicon-info-sign", 
						style = "color:#91bd0d;",
						title = "The name of the CSV file that contains the available DMCs (e.g., Output from the OpDMC approach)."
					), ":"),			
					accept = c(".csv")
				),
			),	
			column(2,
				fileInput("somebody",
					label = tags$span(
					"Fasta file with the aligned sequences", 
					tags$i(
						class = "glyphicon glyphicon-info-sign", 
						style = "color:#91bd0d;",
						title = "The name of the fasta file with the alingment used for obtaining the DMCs."
					), ":"),			
					accept = c(".fas", ".fasta", ".fs", ".FAS", ".FASTA", ".FS")
				),
			),
			column(2,
				fileInput("nobody2",
					label = tags$span(
					"Fasta file with specimens to be identified", 
					tags$i(
						class = "glyphicon glyphicon-info-sign", 
						style = "color:#91bd0d;",
						title = "The name of the fasta file with the sequences/specimens to be identified (it should contain at least one specimen)."
					), ":"),			
					accept = c(".fas", ".fasta", ".fs", ".FAS", ".FASTA", ".FS")
				),
			),
			column(2,
				sliderInput("subopt3", 
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
			column(3,
				textInput("OutName3", label = "Name of the identification output file:", value = "IdentificationOutput.csv"),
				textInput("OutMiss1", label = "Name of the file for missing data information:", value = "LogMissing.csv"),
				textInput("OutNameAli", label = "Name of the final alignment output file:", value = "ResultingAlignment.fasta"),
			),
			column(1,
				actionButton("do3", "Run!", icon("computer"),
				style="color: white; background-color: #174364; border-color: #91bd0d; border-width: 1.5px"),
			),
	),
	h4("Pairwise sequence alignment settings:"),
	fixedRow(	
			column(2,
				sliderInput("perfect", 
					label = tags$span(
					"Reward for aligning matching nucleotides",
					tags$i(
						class = "glyphicon glyphicon-info-sign", 
						style = "color:#91bd0d;",
						title = "Numeric value giving the reward for aligning two matching nucleotides in the alignment."
					), ":"),
					min = 1, max = 10,
					value = 5, step = 1
				),
			),
			column(2,
				sliderInput("misma", 
					label = tags$span(
					"Cost for aligning mismatched nucleotides",
					tags$i(
						class = "glyphicon glyphicon-info-sign", 
						style = "color:#91bd0d;",
						title = "Numeric value giving the cost for aligning two mismatched nucleotides in the alignment."
					), ":"),
					min = 0, max = 10,
					value = 0, step = 1
				),			
			),
			column(2,
				sliderInput("open", 
					label = tags$span(
					"Cost for opening a gap",
					tags$i(
						class = "glyphicon glyphicon-info-sign", 
						style = "color:#91bd0d;",
						title = "Numeric value giving the cost for opening a gap in the alignment."
					), ":"),
					min = -25, max = 0,
					value = -14, step = 1
				),
			),
			column(2,
				sliderInput("increment", 
					label = tags$span(
					"Cost for extending an open gap",
					tags$i(
						class = "glyphicon glyphicon-info-sign", 
						style = "color:#91bd0d;",
						title = "Numeric value giving the cost for extending an open gap in the alignment."
					), ":"),
					min = -15, max = 0,
					value = -2, step = 1
				),
			),
			column(2,
				sliderInput("gapo", 
					label = tags$span(
					"Exponent for gap cost function",
					tags$i(
						class = "glyphicon glyphicon-info-sign", 
						style = "color:#91bd0d;",
						title = "Numeric value specifying the exponent to use in the gap cost function (see the function AlignProfiles of the DECIPHER package)."
					), ":"),
					min = -5, max = 5,
					value = -1, step = 1
				),
			),
			column(2,
				sliderInput("terminal", 
					label = tags$span(
					"Cost for allowing leading and trailing gaps",
					tags$i(
						class = "glyphicon glyphicon-info-sign", 
						style = "color:#91bd0d;",
						title = "Numeric value giving the cost for allowing leading and trailing gaps (\"-\" or \".\" characters) in the alignment."
					), ":"),
					min = -15, max = 0,
					value = 0, step = 1
				),
			),			
			column(2,
				radioButtons("Agata", "Align against the reference/target matrix using:", choices = c("First taxon", "All sequences available"), selected = "First taxon", inline = F),	
			),		
			column(1,
			actionBttn(inputId = "alineamientos", 
						label = "More information (see function 'AlignProfiles')", 
						style = "fill", 
						color = "success", 
						icon = icon("book"), size = "sm")            
			),			
	),	
	hr(),			                     	
	mainPanel(
		fluidRow(
			column(12,
				shinyjs::useShinyjs(),
				downloadButton("downloadScript3", "Download the ALnID.R function here"),
				htmlOutput("comando3"),
				hidden(downloadButton("downloadResults3", "Download the results here")),
				hidden(downloadButton("downloadMissing1", "Download the missing data information here")),
				hidden(downloadButton("downloadAlignment", "Download the final alignment here")),
				tableOutput("valor3")
			)
		)
	),
)
