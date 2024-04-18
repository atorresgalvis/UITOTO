subopt4		<- eventReactive(input$do4, { input$subopt4 })
WinWidth	<- eventReactive(input$do4, { input$WinWidth })
OutName4	<- eventReactive(input$do4, { input$OutName3 })

datos5 <- eventReactive(input$do4, {
	req(input$DMCs3)
	req(input$nobody3)
	read.csv(input$DMCs3$datapath, header= TRUE)
})

inFile5 <- eventReactive(input$do4, {
	req(input$DMCs3)
	req(input$nobody3)
	read.fasta(input$nobody3$datapath, whole.header = TRUE, forceDNAtolower = FALSE)
})

output$comando4 <- renderText({
	if(!is.null(input$DMCs3)) {
		tortu1 <- input$DMCs3$name
	} else {
		tortu1 <-  "DMCsFile"
	}
	if(!is.null(input$nobody3)) {
		tortu2 <- input$nobody3$name
	} else {
		tortu2 <-  "FastaFile"
	}
	HTML(paste0("- Note 1: after a run, it is advisable to refresh the webpage before starting a new run with different settings.", '<br/>', 
				"- Note 2: this tool will use the column with the name \"DMC\" (without spaces) in your file of DMCs. Please be sure about having a column with that name.", '<br/>', 
				"- Note 3: if you have >3000 specimens to be identified (or files larger than 5 MB), you should consider running the shiny app locally. Even better, you could use the command-driven version of this tool.", '<br/>', 
				"To do that, use the functions included in the UITOTO package. Alternatively, you can download the previous function and  
				use the following two commands in an R session (make sure you have the \"seqinr\" and \"Biostrings\" packages installed in R):", '<br/>', '<br/>',
				'<b>', '<tt>', 
					"source(\"IdentifierU.R\")", '<br/>','<br/>',
					"IdentifierU(", "\"", tortu1, "\"", ", ", 
					"\"", tortu2, "\"", ", ",
					"mismatches = ", input$subopt4, ", ",
					"WinWidth = ", input$WinWidth, ", ",
					"OutName  = ", "\"", input$OutName4, "\"", ")",
				'<tt/>','<b/>', '<br/>', '<br/>',				
			  sep = ""))	  
})

Tableta3 <- NULL

Tableta3 <- reactive({
	req(input$DMCs3)
	req(input$nobody3)

	datos <- inFile5() #query
	datiles <- datos5() #DMC
	
	subopt <- subopt4()
	WinWidth <- WinWidth()

	FinalTable <- NULL
	withProgress(message = 'Identifying the uknown specimens', value = 0, style= "old", {
		for (bicho in 1:length(datos)) {
			avance <- round(((bicho-1)/length(datos))*100)
			setProgress(bicho, detail = paste(paste("[", avance, "%", sep=""), "completed]" ))

			count <- 0
			UnkSeq <- as.vector(datos[[bicho]]) # Given sequence
			resultado <- NULL
			for (pista in 1:dim(datiles)[1]) {
				pattern <- datiles$DMC[pista] # Given pattern
				especie <- datiles$Species[pista] # Name of the species that has the given pattern
				# Remove unwanted characters from the pattern
				pattern <- gsub("\\[|\\]|\\s", "", pattern)
				pattern <- gsub("\\,", " ", pattern); pattern <- gsub("\\:", " ", pattern)
				segments <- strsplit(pattern, " ") # Split the pattern by commas and colon
				
				# Extract positions and nucleotides
				positions <- as.numeric(segments[[1]][seq(1, length(segments[[1]]), 2)])
				first <- positions[1]
				nucleotides <- segments[[1]][seq(2, length(segments[[1]]), 2)]
				nucleotides <- toupper(nucleotides)
				
				crite <- length(positions) - subopt
				if (crite < 2) { crite <- 2	}	
				
				# Create a distance matrix with nucleotide labels
				distances <- abs(outer(positions, positions, "-"))
				distanceMatrix <- matrix(distances, nrow = length(positions), ncol = length(positions), dimnames = list(nucleotides, nucleotides))
				
				if ( positions[1] < (WinWidth/2) ) {
					starter <- 1
				} else {	
					starter <- positions[1] - (WinWidth/2)
					if (starter == 0) {
						starter <- 1
					}	
				}
				for (i in starter:(starter+WinWidth) ) {
					toProve <- vector(mode = "character", length = length(positions))
					for (j in 1:length(positions) ) {
						toProve[j] <- UnkSeq[ (i + distanceMatrix[,1][j]) ]
					}
					toProve <- toupper(toProve)
					value <- table(toProve == nucleotides)["TRUE"]; names(value) <- NULL
					if (is.na(value)) {
					} else {
						if (value >= crite) {
							nombres <- i + distanceMatrix[,1]
							distancia <- first - i
							linea <- paste("-", especie, "[", value, "/", length(positions), "{", distancia, "}]", sep="")
							resultado <- paste(resultado, linea, sep="")
							count <- count + 1
						}
					}
				}
			}
			if (count == 0) {
				resultado <- "Unidentified"
			}
			palata <- cbind(attributes(datos)$names[bicho], resultado)
			FinalTable <- rbind(FinalTable, palata)
			colnames(FinalTable) <- c("SpecimenName", "MatchesWith")
			#write.csv(FinalTable, file= OutName)	
		}
	})
	FinalTable
})
output$valor4 <- renderTable(Tableta3())

output$downloadScript4 <- downloadHandler(
	filename = "IdentifierU.R",
	content = function(file) {
		file.copy("functions/IdentifierU.R", file)
	}
)

observeEvent(input$nobody3, {
	shinyjs::toggle("downloadScript4")
})

output$downloadResults4 <- downloadHandler(
	filename = function(){OutName4()},
	content = function(fname) {
		write.csv(Tableta3(), fname, row.names = FALSE)
	}
)

observeEvent(Tableta3() != NULL, {
	shinyjs::toggle("downloadResults4")
})
