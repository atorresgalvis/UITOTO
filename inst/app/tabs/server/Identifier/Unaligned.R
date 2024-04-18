subopt3		<- eventReactive(input$do3, { input$subopt3 })
perfect		<- eventReactive(input$do3, { input$perfect})
misma		<- eventReactive(input$do3, { input$misma})
open		<- eventReactive(input$do3, { input$open})
increment	<- eventReactive(input$do3, { input$increment})
gapo		<- eventReactive(input$do3, { input$gapo})
terminal	<- eventReactive(input$do3, { input$terminal})
OutName3	<- eventReactive(input$do3, { input$OutName3 })
alineado	<- eventReactive(input$do3, { input$Agata })
OutNameAli	<- eventReactive(input$do3, { input$OutNameAli })

datos4 <- eventReactive(input$do3, {
	req(input$DMCs2)
	req(input$nobody2)
	req(input$somebody)
	read.csv(input$DMCs2$datapath, header= TRUE)
})

inFile3 <- eventReactive(input$do3, {
	req(input$DMCs2)
	req(input$nobody2)
	req(input$somebody)
	read.fasta(input$nobody2$datapath, whole.header = TRUE, forceDNAtolower = FALSE)
})

inFile4 <- eventReactive(input$do3, {
	req(input$DMCs2)
	req(input$nobody2)
	req(input$somebody)
	read.fasta(input$somebody$datapath, whole.header = TRUE, forceDNAtolower = FALSE)
})

output$comando3 <- renderText({
	if (input$Agata == "First taxon") {
		gatuno <- "First"
	} else  {
		gatuno <- "All"
	}
	if(!is.null(input$DMCs2)) {
		tortu1 <- input$DMCs2$name
	} else {
		tortu1 <-  "DMCsFile"
	}
	if(!is.null(input$somebody)) {
		tortu2 <- input$somebody$name
	} else {
		tortu2 <-  "AlignedFastaFile"
	}
	if(!is.null(input$nobody2)) {
		tortu3 <- input$nobody2$name
	} else {
		tortu3 <-  "UnalignedFastaFile"
	}	
	HTML(paste0("- Note 1: after a run, it is advisable to refresh the webpage before starting a new run with different settings.", '<br/>', 
				"- Note 2: this tool will use the column with the name \"DMC\" (without spaces) in your file of DMCs. Please be sure about having a column with that name.", '<br/>', 
				"- Note 3: if you have >5000 sequences to be identified (or files larger than 5 MB), we strongly recommend running the shiny app locally. Even better, you can use the command-driven version of this tool (especially if the \"All sequences available\" option is used, which is much more time-consuming).", '<br/>', 
				"To do that, use the functions included in the UITOTO package. Alternatively, you can download the previous function and  
				use the following two commands in an R session (make sure you have the \"Biostrings\", \"DECIPHER\" and \"seqinr\" packages installed in R):", '<br/>', '<br/>',
				'<b>', '<tt>', 
					"source(\"ALnID.R\")", '<br/>','<br/>',
					"ALnID(", "\"", tortu1, "\"", ", ", 
					"\"", tortu2, "\"", ", ",
					"\"", tortu3, "\"", ", ",
					"mismatches = ", input$subopt3, ", ",
					"against = ", "\"", gatuno, "\"", ", ",
					"perfectMatch = ", input$perfect, ", ",
					"misMatch = ", input$misma, ", ",				
					"gapOpening = ", input$open, ", ",
					"gapExtension = ", input$increment, ", ",
					"gapPower = ", input$gapo, ", ",
					"terminalGap = ", input$terminal, ", ",
					"OutName  = ", "\"", input$OutName3, "\"", ", ",
					"MissLogFile  = ", "\"", input$OutMiss1, "\"", ", ",
					"AligName  = ", "\"", input$OutNameAli, "\"", ")",
				'<tt/>','<b/>', '<br/>', '<br/>',				
			  sep = ""))	  
})

Tableta2 <- NULL

Tableta2 <- reactive({
	req(input$DMCs2)
	req(input$nobody2)
	req(input$somebody)

	raw_records <- inFile4() #target
	datos <- inFile3() #query
	datiles <- datos4() #DMC
	nombres <- names(datos)
	
	subopt <- subopt3()
	perfect	<- perfect()
	misma <- misma()
	open <- open()
	increment <- increment()
	gapo <- gapo()
	terminal <- terminal()

	datiles$DMC <- gsub(":", ",", datiles$DMC) 
	datiles$DMC <- gsub("'", "", datiles$DMC)
	datiles$DMC <- gsub(",", "", datiles$DMC) 
	datiles$DMC <- gsub("\\[", "", datiles$DMC)
	datiles$DMC <- gsub("\\]", "", datiles$DMC)
	datiles2 <- gsub('[ACGT]','',datiles$DMC); datiles2 <- gsub("  "," ", datiles2)
	datiles2 <- paste(datiles2, collapse = "")
	datiles2 <- strsplit(datiles2, " ")[[1]]
	datiles2 <- sort(unique(as.numeric(datiles2)))

	cadena <- NULL
	identi <- NULL
	for (i in 1:length(raw_records)) {
		cuerda <- as.character(raw_records[[i]]); cuerda <- paste(cuerda, collapse= "")
		if (is.element(cuerda, cadena) == TRUE) {
			next
		} else {
			cadena <- c(cadena, cuerda)
			identi <- c(identi, i)
			nombrecito <- attributes(raw_records)$names[i]
		}
	}
	raw_records <- raw_records[identi]
	propia <<- NULL
	FinalTable <- NULL
	logMissing <<- NULL
	if (input$OutMiss1 == "none") {
	} else {		
		liniers <- paste("Sequence","SpeciesDMC","N_Missing", sep=",")
		logMissing <<- rbind(logMissing, liniers)
	}
	withProgress(message = 'Identifying the uknown specimens', value = 0, style= "old", {
		for (i in 1:length(datos)) {
			count <- 0
			resultado <- NULL
			avance <- round(((i-1)/length(datos))*100)
			setProgress(i, detail = paste(paste("[", avance, "%", sep=""), "completed]" ))
			
			query <- paste(as.vector(datos[[i]]), collapse = "")
			query <- toupper(query)
			query <- DNAString(gsub("-", "N", query))
			query2 <- as.character(complement(query))
			query3 <- as.character(reverseComplement(query))
			query4 <- as.character(rev(query))
			query <- as.character(query)
			queries <- c(query, query2, query3, query4)

			if (input$Agata == "First taxon") {			
				patron <- raw_records[[1]]
				patron <- paste(patron, collapse= "")
	
				mindista <- 1
				for (pilas in 1:4) {
					prueba <- AlignProfiles(DNAStringSet(patron), DNAStringSet(queries[pilas]), 
									perfectMatch= perfect, 
									misMatch= misma, 
									gapOpening = open,
									gapExtension = increment,
									gapPower = gapo,
									terminalGap = terminal)
					meximo <- max(DistanceMatrix(prueba, verbose=F))
					if (meximo < mindista) {
						mindista <- meximo
						prueba2 <- prueba
					}
				}
				resul2 <- compareStrings(as.character(prueba2[2]), as.character(prueba2[1]))
				if ( grepl("\\+", resul2) ) {
					paeliminar <- strsplit(resul2, split="")[[1]]
					funar <- NULL
					for (mas in 1:length(paeliminar)){
						if(paeliminar[mas] == "+") {
							funar <- c(funar, mas)
						}	
					}
					alineado <- strsplit( as.character(prueba2[2]), split="")[[1]]
					datos[[i]] <- alineado[-c(funar)]
					propia[[i]] <<- datos[[i]]
				} else {
					datos[[i]] <- strsplit(as.character(prueba2[2]), split="")[[1]]
					propia[[i]] <<- datos[[i]]
				}
			}
			
			chequeo <- 0
			if (input$OutMiss1 == "none") {
			} else {
				MissEntries <- which(as.character(datos[[i]]) == "-")
				if (length(MissEntries) > 0) {
					ImporMiss <- c(MissEntries, datiles2)[which(duplicated(c(MissEntries, datiles2)))]
					if (length(ImporMiss) > 0) {
						chequeo <- 1
					}		
				}
			}	

			for (j in 1:dim(datiles)[1]) {
				DMC <- datiles$DMC[j]
				DMC <- strsplit(DMC, " ")[[1]]

				if (input$Agata == "All sequences available") {			
					especie <- datiles$Species[j]
					for (catch in 1:length(raw_records)) { #Catching a sequence of the target taxon
						if ( grepl(especie, (attributes(raw_records)$names[catch]) ) ){
							patron <- raw_records[[catch]]
							patron <- paste(patron, collapse= "")
							break
						}
					}
					
					mindista <- 1
					for (pilas in 1:4) {
						prueba <- AlignProfiles(DNAStringSet(patron), DNAStringSet(queries[pilas]), 
										perfectMatch= perfect, 
										misMatch= misma, 
										gapOpening = open,
										gapExtension = increment,
										gapPower = gapo,
										terminalGap = terminal)
						meximo <- max(DistanceMatrix(prueba, verbose=F))
						if (meximo < mindista) {
							mindista <- meximo
							prueba2 <- prueba
						}
					}
					resul2 <- compareStrings(as.character(prueba2[2]), as.character(prueba2[1]))
					if ( grepl("\\+", resul2) ) {
						paeliminar <- strsplit(resul2, split="")[[1]]
						funar <- NULL
						for (mas in 1:length(paeliminar)){
							if(paeliminar[mas] == "+") {
								funar <- c(funar, mas)
							}	
						}
						alineado <- strsplit( as.character(prueba2[2]), split="")[[1]]
						datos[[i]] <- alineado[-c(funar)]
						propia[[i]] <<- datos[[i]]
					} else {
						datos[[i]] <- strsplit(as.character(prueba2[2]), split="")[[1]]
						propia[[i]] <<- datos[[i]]
					}
				}
				
				if (chequeo == 1) {
					DMCtemp <- gsub('[ACGT]','', DMC); DMCtemp <- gsub("  "," ", DMCtemp)
					DMCtemp <- as.numeric(na.exclude(as.numeric(DMCtemp)))
					cuantos <- c(ImporMiss, DMCtemp)[which(duplicated(c(ImporMiss, DMCtemp)))]
					if (length(cuantos) > subopt) {
						liniers <- paste(attributes(datos)$names[i],
									datiles$Species[j], 
									paste("[", cuantos, "]", collapse=" "), sep=",")
						logMissing <<- rbind(logMissing, liniers)
						#write(logMissing, file= MissLogFile)
						next
					}
				}
				
				key <- NULL
				totest <- NULL
				for (k in 1:(length(DMC)/2)){
					key <- c(key, DMC[2*k])
					totest <- c(totest, datos[[i]][(as.numeric(DMC[k+(k-1)]))])
				}
				matchi <- (sum((key == toupper(totest)), na.rm = TRUE))
				if (identical(toupper(key),toupper(totest))) {
					pares <- paste("-", datiles$Species[j], "[", matchi, "/", (length(DMC)/2), " {", format(meximo, digits = 3), "}]", sep = "")
					resultado <- paste(resultado, pares, sep = "")
					count <- count + 1
				} else if ( matchi < (length(DMC)/2)    &    matchi >= ((length(DMC)/2)-subopt) ) {
					pares <- paste("-", datiles$Species[j], "[", matchi, "/", (length(DMC)/2), " {", format(meximo, digits = 3), "}]", sep = "")
					resultado <- paste(resultado, pares, sep = "")
					count <- count + 1
				}	
			}
			if (count == 0) {
				resultado <- "Unidentified"
			}
			palata <- cbind(i, attributes(datos)$names[i], resultado)
			FinalTable <- rbind(FinalTable, palata)
			colnames(FinalTable) <- c("SpecimenNumber", "SpecimenName", "MatchesWith")
			#write.csv(FinalTable, file= OutName)	
		}
	})
	FinalTable
})

output$valor3 <- renderTable(Tableta2())

output$downloadScript3 <- downloadHandler(
	filename = "ALnID.R",
	content = function(file) {
		file.copy("functions/ALnID.R", file)
	}
)

observeEvent(input$nobody2, {
	shinyjs::toggle("downloadScript3")
})

output$downloadResults3 <- downloadHandler(
	filename = function(){OutName3()},
	content = function(fname) {
		write.csv(Tableta2(), fname, row.names = FALSE)
	}
)

observeEvent(Tableta2() != NULL, {
	shinyjs::toggle("downloadResults3")
})


output$downloadAlignment <- downloadHandler(
  filename = function() {
    paste(input$OutNameAli, sep = "")
  },
  content = function(fname) {
    write.fasta(propia, names = names(inFile3()), file.out = fname)
  }
)

observeEvent(Tableta2() != NULL, {
		shinyjs::toggle("downloadAlignment")
})

output$downloadMissing1 <- downloadHandler(
  filename = function() {
    paste(input$OutMiss1, sep = "")
  },
  content = function(fname) {
	write(logMissing, file= fname)
  }
)

observeEvent(Tableta2() != NULL, {
		shinyjs::toggle("downloadMissing1")
})


observeEvent(input$alineamientos,{
  showModal(
    modalDialog(
      size = "l",
      title = HTML("<h3><a href='https://bioconductor.org/packages/devel/bioc/vignettes/Biostrings/inst/doc/PairwiseAlignments.pdf'> Available here</a></h3>"),
      tags$iframe(style = "height:400px; width:100%; scrolling = yes", src = "pdf/ArtOfAlignmentInR.pdf"),
      footer = tagList(modalButton("Close"))
    ))
})
