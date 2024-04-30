iter		<- eventReactive(input$do, { input$iter })
MnLen		<- eventReactive(input$do, { input$MnLen })
exclusive	<- eventReactive(input$do, { input$exclusive })
RefStrength	<- eventReactive(input$do, { input$RefStrength })
OutName		<- eventReactive(input$do, { input$OutName })
GapsNew		<- eventReactive(input$do, { input$GapsNew })

inFile <- eventReactive(input$do, {
	req(input$FastaFile)
	req(input$species)
	#dnas <- readDNAStringSet(input$file1$datapath)
	read.fasta(input$FastaFile$datapath, whole.header = TRUE, forceDNAtolower = TRUE)
})

datos2 <- eventReactive(input$do, {
	req(input$FastaFile)
	req(input$species)
	read.csv(input$species$datapath, header= FALSE, col.names = c("QueryTaxa"))
})

output$comando <- renderText({
	if(!is.null(input$FastaFile)) {
		tortu1 <- input$FastaFile$name
	} else {
		tortu1 <-  "FastaFile"
	}
	if(!is.null(input$species)) {
		tortu2 <- input$species$name
	} else {
		tortu2 <-  "SpeciesList"
	}
	iteraciones <- input$iter *1000
	HTML(paste0("- Note 1: after a run, it is advisable to refresh the webpage before starting a new run with different settings.", '<br/>', 
				"- Note 2: if your analysis is very time-consuming (e.g. >1000 sequences for >50 species; files larger than 5 MB), we strongly recommend running the shiny app locally. Even better, you could use the command-driven version of this approach. Especially if you used more than 5000 iterations.", '<br/>', 
				"To do that, use the functions included in the UITOTO package. Alternatively, you can download the previous function and 
				use the following two commands in an R session (make sure you have the \"seqinr\" package installed in R):", '<br/>', '<br/>',
				'<b>', '<tt>', 
					"source(\"OpDMC.R\")", '<br/>','<br/>',
					"OpDMC(", "\"", tortu1, "\"", ", ", 
					"\"", tortu2, "\"", ", ",
					"iter = ", iteraciones, ", ",
					"MnLen = ", input$MnLen, ", ",
					"exclusive = ", input$exclusive, ", ",
					"RefStrength = ", input$RefStrength, ", ",
					"OutName  = ", "\"", input$OutName, "\"", ", ",
					"GapsNew =  ", input$GapsNew, ")",
				'<tt/>','<b/>', '<br/>', '<br/>',				
			  sep = ""))	  
})

FinalTable <- NULL

FinalTable <- reactive({
	req(input$FastaFile)
	req(input$species)
	
	raw_records <- inFile()
	datos <- datos2()
	
	exclusive	<- exclusive()	
	OutName	<- OutName()
	GapsNew	<- GapsNew()	
	minlength <- MnLen()
	refinStrength <- RefStrength()
	iteraciones <- iter()*1000
	
	if (minlength < 2) {
		minlength <- 2
		message("The MnLen parameter cannot be smaller than 2. Thus, it was reset automatically to become 2.")
	}
	
	if (exclusive < 1) {
		exclusive <- 1
		message("The exclusive parameter cannot be smaller than 1. Thus, it was reset automatically to become 1.")
	}
	
	if (minlength < exclusive) {
		minlength <- exclusive
		message("The MnLen parameter cannot be smaller than the exclusive parameter. Thus, it was reset automatically.")
	}
	
	maxlength <- minlength + 2
	
	lappend <- function (lst, ...){
		lst <- c(lst, list(...))
		return(lst)
	}
	
	validation1 <- function(input) {
		if (input == 0) {
			paste("The species", qTAXA, "is not present in your fasta file.",
			"Please make sure you have at least one sequence/specimen in your fasta file for each of the species included in your query-taxa file.")
		}
	}
	
	raw_records <- inFile()
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
	
	VarSites <- NULL
	for (i in 1:length(raw_records[[1]])) {
		if ( (length(levels(factor(unname(sapply(raw_records, `[`, i)))))) > 1) {
			VarSites <- c(VarSites, i)
		}
	}
	
	TablaFinal <- NULL
	withProgress(message = 'Identifying possible DMCs for:', value = 0, {
		for (cladin in 1:(dim(datos)[1]) ) {
			maxlength <- minlength + 2
			avance <- round(((cladin-1)/(dim(datos)[1]))*100)
			
			qTAXA <- datos[cladin,]
			incProgress(1/((dim(datos)[1])+1), detail = paste(qTAXA, paste("[", avance, "%", sep=""), "completed]" ))
			clado <- NULL; cuentaClado <- 0
			for (i in 1:length(raw_records)) {
				if ( grepl(qTAXA, (attributes(raw_records)$names[i]) ) ){
					clado <- c(clado, i)
					cuentaClado <- cuentaClado + 1
				}
			}
			cat(paste("\t", "Doing", qTAXA, "\t", "-", "\t", paste(avance, "%", sep=""), "of the species have been completed.", "\n"))
			shared <- NULL
			validate(
				validation1(cuentaClado)
			)			
			
			for (i in 1:length(VarSites)) {
				if ( (length(levels(factor(unname(sapply(raw_records[clado], `[`, VarSites[i])))))) == 1 ) {
					if (GapsNew == FALSE) {
						if (toupper(raw_records[clado][[1]][VarSites[i]]) != "-" && toupper(raw_records[clado][[1]][VarSites[i]]) != "N" && toupper(raw_records[clado][[1]][VarSites[i]]) != "?" ) {
							shared <- c(shared, VarSites[i])
						}
					} else {
						shared <- c(shared, VarSites[i])
					}			
				}	
			}
		
			unica <- NULL
			unicount <- 0
			puntajes <- NULL
			for (i in 1:length(shared)) {
				a <- levels(factor(unname(sapply(raw_records[clado], `[`, shared[i]))))
				b <- levels(factor(unname(sapply(raw_records[-(clado)], `[`, shared[i]))))
				if (is.element(a, b) == FALSE){
					unica <- c(unica, shared[i])
					puntajes[i] <- 0
					unicount <- unicount + 1 
				} else {
					palaruleta <- table(factor(unname(sapply(raw_records[-(clado)], `[`, shared[i]))))
					contraElDado <- palaruleta[dimnames(palaruleta)[[1]] == a]; names(contraElDado) <- NULL
					contraElDado <- (contraElDado / length(raw_records[-(clado)]))*100
					puntajes[i] <- contraElDado
				}			
			}	
			
			lista <- NULL
			lista2 <- NULL
			lista <- list()
			AltrDNC <- NULL
			minimo <- maxlength
			soluciones <- 0
			iteraciones2 <- iteraciones

			habilitados <- as.numeric(table(puntajes > 50)[1])
			IterPosibles <- 0
			for (tamanduas in minlength:maxlength) {
				cuasi <- choose(habilitados, tamanduas)
				IterPosibles <- IterPosibles + cuasi
			}
			if(IterPosibles < iteraciones2){
				iteraciones2 <- round(IterPosibles / 3)
			}

			breakadicionales <- round(iteraciones2*0.2)
			veces <- 0
			buffi <- NULL
			while (soluciones < 2) {
				if (veces == 6) {
					maxlength <- maxlength + 1
					minimo <- maxlength
					message("None of the combinations tested are suitable to become a DMC.")
					message(paste("The maximum length of the DMCs has been reset to", maxlength))
					iteraciones2 <- iteraciones
					
					IterPosibles <- 0
					for (tamanduas in minlength:maxlength) {
						cuasi <- choose(habilitados, tamanduas)
						IterPosibles <- IterPosibles + cuasi
					}
					if(IterPosibles < iteraciones2){
						iteraciones2 <- round(IterPosibles / 3)
					}
					
					breakadicionales <- round(iteraciones2*0.2)
					veces <- 0
				}
				reales <- 0
				while (reales < iteraciones2) {
					if (minimo <= minlength) {
						size <- minlength
					} else {
						size <- sample(minlength:maxlength, 1)
					}	
					if (unicount > 0 && unicount < minlength) {
						while (unicount > size){
							if (minimo <= minlength) {
								size <- minlength
							} else {
								size <- sample(minlength:maxlength, 1)
							}
						}	
						size <- size - unicount
						shared2 <- setdiff(shared, unica)
						llenado <- 0
						tokey <- NULL
						while (llenado < size) { 
							dado <- sample(10:50, 1) #Those with >50 are always discarded. Those with < 10 are always taken into account.
							pallenar <- sample(1:length(shared2), 1)
							if (puntajes[pallenar] <= dado) {
								tokey <- c(tokey, shared2[pallenar])
								llenado <- llenado + 1
								shared2 <- shared2[-pallenar]
							}
						}						
						tokey <- c(tokey, unica)						
						key <- unname(sapply(raw_records[clado[1]], `[`, tokey))[,1]
						names(key) <- tokey
					} else if (unicount > 0 && unicount >= minlength) {
						tokey <- sample(unica, minlength)
						key <- unname(sapply(raw_records[clado[1]], `[`, tokey))[,1]
						names(key) <- tokey
						AltrDNC <- key
						lista <- lappend(lista, key)
						soluciones <- soluciones + 1
						if (soluciones > 1000) {
							break
						} else {
							next
						}	
					} else {
						shared2 <- shared
						llenado <- 0
						tokey <- NULL
						while (llenado < size) { 
							dado <- sample(10:50, 1) #Those with >50 are always discarded. Those with < 10 are always taken into account.
							pallenar <- sample(1:length(shared2), 1)
							if (puntajes[pallenar] <= dado) {
								tokey <- c(tokey, shared2[pallenar])
								llenado <- llenado + 1
								shared2 <- shared2[-pallenar]
							}
						}				
						key <- unname(sapply(raw_records[clado[1]], `[`, tokey))[,1]
						names(key) <- tokey
					}	
					tokey2 <- paste(tokey[order(tokey)], collapse= "-")
					if (is.element(tokey2, buffi) == TRUE) {
						next
					} else {
						buffi <- c(buffi, tokey2)
						reales <- reales + 1
					}
					ContLista <- 0
					for (j in 1:length(raw_records[-(clado)])) {
						tocomp <- unname(sapply(raw_records[-(clado)][j], `[`, tokey))[,1]
						matchi <- (sum((toupper(key) == toupper(tocomp)), na.rm = TRUE))
						if (matchi > size-exclusive) {
							break
						} else {
							ContLista <- ContLista + 1
						}	
					}
					if (ContLista == length(raw_records[-(clado)])) {
						if (length(key) <= minimo && length(key) >= minlength){
							minimo <- length(key)
							AltrDNC <- key
						}
						lista <- lappend(lista, key)
						soluciones <- soluciones + 1
						if (soluciones > 1000) {
							break
						}	
					}						
				}
				veces <- veces + 1
				if (soluciones < 2){
					iteraciones2 <- breakadicionales
				}
			}
			lista2 <- list()
			if (minimo <= minlength) {
				lista2 <- lista
			} else {	
				for (i in 1:length(lista)) {
					key2 <- lista[[i]]
					if (length(key2) <= minlength){
						lista2[[i]] <- lista[[i]]
						next
					}			
					chances <- 0
					Posibles <- list()
					for (cha in (length(key2)-1):minlength){
						tocha <- combn(1:length(key2), cha)
						for (combi in 1:dim(tocha)[2]){
							Posibles <- lappend(Posibles, tocha[,combi])
						}	
						tocha <- dim(tocha)[2]
						chances <- chances+tocha
					}
					cuales <- sample(1:length(Posibles), (round(chances*refinStrength)))
					for (j in 1:length(cuales)) {
						key3 <- key2[Posibles[[cuales[j]]]]
						tokey3 <- as.numeric(names(key3))
						ContLista2 <- 0
						size2 <- length(key3)
						for (k in 1:length(raw_records[-(clado)])) {
							tocomp2 <- unname(sapply(raw_records[-(clado)][k], `[`, tokey3))[,1]
							matchi2 <- (sum((toupper(key3) == toupper(tocomp2)), na.rm = TRUE))
							if (matchi2 > size2-exclusive) {
								break
							} else {
								ContLista2 <- ContLista2 + 1
							}	
						}
						if (ContLista2 == length(raw_records[-(clado)])) {
							lista2[[i]] <- key3
							if (length(key3) <= minimo && length(key3) >= minlength){
								minimo <- length(key3)
								AltrDNC <- key3
							}
						} else {
							lista2[[i]] <- lista[[i]]
						}
					}	
				}
			}	
			histograma <- NULL
			for (i in 1:length(lista2)) {
				histograma <- c(histograma, names(lista2[[i]]))
			}
			histograma <- table(histograma)[order(table(histograma),decreasing = TRUE)]
			definitiva <- 0
			veces <- 0
			tama <- length(AltrDNC)
			while (definitiva == 0) {
				IndexrDNC <- as.numeric(names(histograma[1:tama]))
				vueltas <- combn(IndexrDNC, length(AltrDNC))
				for (vu in 1:dim(vueltas)[2] ) {
					tokey4 <- vueltas[,vu]
					key4 <- unname(sapply(raw_records[clado[1]], `[`, tokey4))[,1]
					contador <- 0
					for (cada in 1:length(raw_records[-(clado)])) {
						tocomp4 <- unname(sapply(raw_records[-(clado)][cada], `[`, tokey4))[,1]
						matchi4 <- (sum((toupper(key4) == toupper(tocomp4)), na.rm = TRUE))
						if (matchi4 > (length(AltrDNC)- exclusive) ) {
							break
						} else {
							contador <- contador + 1
						}	
					}
					if (contador == length(raw_records[-(clado)])) {
						IndexrDNC <- tokey4
						definitiva <- definitiva + 1
					}
				}
				if (definitiva == 0){
					tama <- tama + 1
					veces <- veces + 1
				}
				if (veces >= 6){
					IndexrDNC <- AltrDNC
					break
				}		
			}			
			rDNC <- unname(sapply(raw_records[clado[1]], `[`, IndexrDNC))[,1]
			names(rDNC) <- IndexrDNC; rDNC <- rDNC[order(as.numeric(names(rDNC)))]
			AltrDNC <- AltrDNC[order(as.numeric(names(AltrDNC)))]
			rDNCpropio <- paste(names(rDNC), toupper(rDNC), sep = ": ")
			AltrDNCpropio <- paste(names(AltrDNC), toupper(AltrDNC), sep = ": ")
			rDNCpropio <- paste("[", paste(rDNCpropio, collapse=", "), "]", sep = "")
			AltrDNCpropio <- paste("[", paste(AltrDNCpropio, collapse=", "), "]", sep = "")
			PaLaTabla <- cbind(as.character(qTAXA), rDNCpropio, AltrDNCpropio)
			colnames(PaLaTabla) <- c("Species", "DMC", "Alter-DMC")
			TablaFinal <- rbind(TablaFinal, PaLaTabla)
		}
	})
	TablaFinal	
})

output$valor <- renderTable(FinalTable())

output$downloadScript <- downloadHandler(
	filename = "OpDMC.R",
	content = function(file) {
		file.copy("functions/OpDMC.R", file)
	}
)

observeEvent(input$species, {
	shinyjs::toggle("downloadScript")
})

output$downloadResults <- downloadHandler(
	filename = function(){OutName()},
	content = function(fname) {
		write.csv(FinalTable(), fname, row.names = FALSE)
	}
)

observeEvent(FinalTable() != NULL, {
	shinyjs::toggle("downloadResults")
})
