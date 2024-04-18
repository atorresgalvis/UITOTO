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
				fileInput("DMCs2", "File with the available DMCs (e.g. Output from the OpDMC approach):", accept = ".csv"),
			),	
			column(2,
				fileInput("somebody", "Fasta file with sequences used for obtaining the DMCs included in the previous file:", accept = c(".fas", ".fasta", ".fs", ".FAS", ".FASTA", ".FS")),
			),
			column(2,
				fileInput("nobody2", "Fasta file with specimens to be identified (it should contain at least one specimen):", accept = c(".fas", ".fasta", ".fs", ".FAS", ".FASTA", ".FS")),
			),
			column(2,
				sliderInput("subopt3", "Maximum mismatches allowed:",
					min = 0, max = 8,
					value = 1, step = 1
				),	
			),
			column(3,
				textInput("OutName3", label = "Name of the output file:", value = "IdentificationOutput.csv"),
				textInput("OutMiss1", label = "Name of the file for missing data information:", value = "LogMissing.csv"),
				textInput("OutNameAli", label = "Name of the final alignment file:", value = "ResultingAlignment.fasta"),
			),
			column(1,
				actionButton("do3", "Run!", icon("computer"),
				style="color: white; background-color: #174364; border-color: #91bd0d; border-width: 1.5px"),
			),
	),
	h4("Pairwise sequence alignment settings:"),
	fixedRow(	
			column(2,
				sliderInput("perfect", "Reward for aligning 2 matching nucleotides:",
					min = 1, max = 10,
					value = 5, step = 1
				),	
			),
			column(2,
				sliderInput("misma", "Cost for aligning 2 mismatched nucleotides:",
					min = 0, max = 10,
					value = 0, step = 1
				),	
			),
			column(2,
				sliderInput("open", "Cost for opening a gap:",
					min = -25, max = 0,
					value = -14, step = 1
				),	
			),
			column(2,
				sliderInput("increment", "Cost for extending an open gap:",
					min = -15, max = 0,
					value = -2, step = 1
				),	
			),
			column(2,
				sliderInput("gapo", "Exponent for gap cost function:",
					min = -5, max = 5,
					value = -1, step = 1
				),	
			),
			column(2,
				sliderInput("terminal", "Cost for allowing leading and trailing gaps:",
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
