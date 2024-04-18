subopt2	 <- eventReactive(input$do2, { input$subopt2 })
OutName2 <- eventReactive(input$do2, { input$OutName2 })

datos3 <- eventReactive(input$do2, {
	req(input$DMCs)
	req(input$nobody)
	read.csv(input$DMCs$datapath, header= TRUE)
})

inFile2 <- eventReactive(input$do2, {
	req(input$DMCs)
	req(input$nobody)
	#dnas <- readDNAStringSet(input$file1$datapath)
	read.fasta(input$nobody$datapath, whole.header = TRUE, forceDNAtolower = FALSE)
})

output$comando2 <- renderText({
	if(!is.null(input$DMCs)) {
		tortu1 <- input$DMCs$name
	} else {
		tortu1 <-  "DMCsFile"
	}
	if(!is.null(input$nobody)) {
		tortu2 <- input$nobody$name
	} else {
		tortu2 <-  "AlignedFastaFile"
	}
	HTML(paste0("- Note 1: after a run, it is advisable to refresh the webpage before starting a new run with different settings.", '<br/>', 
				"- Note 2: this tool will use the column with the name \"DMC\" (without spaces) in your file of DMCs. Please be sure about having a column with that name.", '<br/>', 
				"- Note 3: if you have >10000 sequences to be identified (or files larger than 5 MB), we strongly recommend running the shiny app locally. Even better, you could use the command-driven version of this tool.", '<br/>', 
				"To do that, use the functions included in the UITOTO package. Alternatively, you can download the previous function and  
				use the following two commands in an R session (make sure you have the \"seqinr\" package installed in R):", '<br/>', '<br/>',
				'<b>', '<tt>', 
					"source(\"Identifier.R\")", '<br/>','<br/>',
					"Identifier(", "\"", tortu1, "\"", ", ", 
					"\"", tortu2, "\"", ", ",
					"mismatches = ", input$subopt2, ", ",
					"OutName  = ", "\"", input$OutName2, "\"", ", ",
					"MissLogFile  = ", "\"", input$OutMiss2, "\"", ")",
				'<tt/>','<b/>', '<br/>', '<br/>',				
			  sep = ""))	  
})

Tableta <- NULL

Tableta <- reactive({
	req(input$DMCs)
	req(input$nobody)

	datos <- inFile2() #fasta
	datiles <- datos3() #DMC
	
	subopt	<- subopt2()	

	datiles$DMC <- gsub(":", ",", datiles$DMC) 
	datiles$DMC <- gsub("'", "", datiles$DMC)
	datiles$DMC <- gsub(",", "", datiles$DMC) 
	datiles$DMC <- gsub("\\[", "", datiles$DMC)
	datiles$DMC <- gsub("\\]", "", datiles$DMC)
	datiles2 <- gsub('[ACGT]','',datiles$DMC); datiles2 <- gsub("  "," ", datiles2)
	datiles2 <- paste(datiles2, collapse = "")
	datiles2 <- strsplit(datiles2, " ")[[1]]
	datiles2 <- sort(unique(as.numeric(datiles2)))	

	FinalTable <- NULL
	logMissing <<- NULL
	if (input$OutMiss2 == "none") {
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
			
			chequeo <- 0
			if (input$OutMiss2 == "none") {
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
					pares <- paste("-", datiles$Species[j], "[", matchi, "/", (length(DMC)/2), "]", sep = "")
					resultado <- paste(resultado, pares, sep = "")
					count <- count + 1
				} else if ( matchi < (length(DMC)/2)    &    matchi >= ((length(DMC)/2)-subopt) ) {
					pares <- paste("-", datiles$Species[j], "[", matchi, "/", (length(DMC)/2), "]", sep = "")
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

output$valor2 <- renderTable(Tableta())

output$downloadScript2 <- downloadHandler(
	filename = "Identifier.R",
	content = function(file) {
		file.copy("functions/Identifier.R", file)
	}
)

observeEvent(input$nobody, {
	shinyjs::toggle("downloadScript2")
})

output$downloadResults2 <- downloadHandler(
	filename = function(){OutName2()},
	content = function(fname) {
		write.csv(Tableta(), fname, row.names = FALSE)
	}
)

observeEvent(Tableta() != NULL, {
	shinyjs::toggle("downloadResults2")
})

output$downloadMissing2 <- downloadHandler(
  filename = function() {
    paste(input$OutMiss2, sep = "")
  },
  content = function(fname) {
	write(logMissing, file= fname)
  }
)

observeEvent(Tableta() != NULL, {
		shinyjs::toggle("downloadMissing2")
})