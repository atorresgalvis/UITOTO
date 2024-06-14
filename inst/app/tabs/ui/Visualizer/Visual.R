Visual <- tabPanel(title = "Visualize DMCs", 
	value = "Visual",
	hr(),
	fixedRow(	
			column(2,
				fileInput("DMCs10",
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
			column(2,
				fileInput("somebody10",
					label = tags$span(
					"Fasta file with the sequences to draw the DMCs of the species included in the previous file", 
					tags$i(
						class = "glyphicon glyphicon-info-sign", 
						style = "color:#91bd0d;",
						title = "The name of the fasta file with specimens to draw the DMCs (the file should contain at least one specimen for each species)."
					), ":"),			
					accept = c(".fas", ".fasta", ".fs", ".FAS", ".FASTA", ".FS")
				),
			),
			column(2,
				sliderTextInput("tamandua3", "Font size for sequence titles (aprox. pt):",
					choices = c(8, 10, 12, 14, 18, 24, 36),
					selected = 14,
					grid = TRUE
				),	
			),			
			column(2,
				sliderTextInput("tamandua1", "Font size for sequence sites (aprox. pt):",
					choices = c(8, 10, 12, 14, 18, 24, 36),
					selected = 12,
					grid = TRUE
				),	
			),
			column(2,
				sliderTextInput("tamandua2", "Font size for DMC's sites (aprox. pt):",
					choices = c(8, 10, 12, 14, 18, 24, 36),
					selected = 24,
					grid = TRUE
				),	
			),
	),
	fixedRow(
			column(2,
				textInput("Colorete0", label = "Hex color code for sequence names:", value = "#0a0a0a"),
				textInput("Colorete1", label = "Hex color code for the sites:", value = "#a9a9a9"),
				textInput("Colorete2", label = "Hex color code for DMC's sites:", value = "#91bd0d"),
			),
			column(2,
					textInput("clavecita",
						label = tags$span(
						"Use the sequences containing the string/word!!!", 
						tags$i(
							class = "glyphicon glyphicon-info-sign", 
							style = "color:#91bd0d;",
							title = "The specimens chosen to draw the DMCs must contain this string in their names. Check that the fasta file contain at least one sequence with this string for each one of the species provided in the DMCs file."
						), ":"),			
						value = "_holotype"
					),
			       selectInput("mayus", "Letter case:",
			                   c("All uppercase" = "uppercase",
			                     "All lowercase" = "lowercase",
			                     "DMC's sites in uppercase" = "DMCuppercase",
			                     "DMC's sites in lowercase" = "DMClowercase"
			                   ), selected= "DMCuppercase"),
			),
			column(2,
				selectInput("tipito1", "Font type for sequence names:",
					c("Arial" = "Arial",
					"Cambria" = "cambria",
					"Candara" = "candara",
					"Century Gothic" = "Century Gothic",
					"Comic Sans" = "comic sans ms",
					"Consolas" = "consolas",
					"Courier" = "Courier",
					"Garamond" = "Garamond",
					"Georgia" = "Georgia",
					"Goudy Old Style" = "goudy old style",
					"Helvetica" = "Helvetica",
					"Perpetua" = "perpetua",
					"Tahoma" = "Tahoma",
					"Times" = "Times",
					"Verdana" = "Verdana"
					), selected= "Century Gothic"),
				selectInput("tipito2", "Font type for sequence sites:",
						c("Arial" = "Arial",
						"Cambria" = "cambria",
						"Candara" = "candara",
						"Century Gothic" = "Century Gothic",
						"Comic Sans" = "comic sans ms",
						"Consolas" = "consolas",
						"Courier" = "Courier",
						"Garamond" = "Garamond",
						"Georgia" = "Georgia",
						"Goudy Old Style" = "goudy old style",
						"Helvetica" = "Helvetica",
						"Perpetua" = "perpetua",
						"Tahoma" = "Tahoma",
						"Times" = "Times",
						"Verdana" = "Verdana"
						), selected= "Courier"),
				shinyjs::useShinyjs(),
				htmlOutput("outpt_colores"),	
      ),
      column(2,
				fixedRow(
				selectInput("formato", "Output format:",
					c("Format 1 (list)" = "format1",
					"Format 2 (free)" = "format2",
					"Format 3 (fixed alignment)" = "format3",
					"Format 4 (table)" = "format4"
					), selected= "format1" ),
				selectInput("NucleoColor", "Nucleotides color (available for the Format 3):",
					c("Palette color 1" = "Pallete1",
					"Palette color 2" = "Pallete2",
					"Palette color 3" = "Pallete3",
					"Palette color 4" = "Pallete4",
					"All black" = "black"
					), selected= "Pallete1" ),	
				)		
            ),
      column(2,
				fixedRow(
				checkboxInput("CombI", "Include DMCs after sequence names", TRUE),
				checkboxInput("italica", "Sequence names in italic", TRUE),
				)
			),
			column(2,
			       fixedRow(
			         checkboxInput("negrilla", "Sequence names in bold", TRUE),
			         checkboxInput("negrilla2", "Sequence sites in bold", FALSE),
			       )
			),
	),	
	hr(),
	fluidRow(
		column(12,
			shinyjs::useShinyjs(),
			hidden(downloadButton("downloadTablita", "Download visualization here")),
			htmlOutput("outpt_fancy")
		)	
	)
)
