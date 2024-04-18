## Title: OpDMC
## Version: 0.1-1
## Date: 2024-04-17
## Author: Ambrosio Torres (Researcher [Ctr. Integr. Biodivers. Discov. - Museum für Naturkunde, Berlin, Germany)
## Maintainer: Ambrosio Torres <atorresgalvis@gmail.com> <Ambrosio.TorresGalvis@mfn.berlin>
## Depends: R version (>= 4.2.2 ). Packages   seqinr (4.2-23)
## Description: the function finds Optimal Diagnostic Molecular Combinations based on the stability of their specificity.
## License: GPL (3)
## Usage: OpDMC("MegaseliaTraining.fasta", "SpeciesListMegaselia.csv", iter = 5000, MnLen = 3, exclusive = 2, RefStrength = 0.10, OutName = "OpDMC_Megaselia.csv", GapsNew = FALSE)

OpDMC <- function(FastaFile, species, iter = 20000, 
				  MnLen = 4, exclusive = 4, RefStrength = 0.25,
				  OutName = "OpDMC_output.csv", GapsNew = FALSE){
	require("seqinr")
	
	if (MnLen < 2) {
		MnLen <- 2
		message("The MnLen parameter cannot be smaller than 2. Thus, it was reset automatically to become 2.")
	}
	
	if (exclusive < 1) {
		exclusive <- 1
		message("The exclusive parameter cannot be smaller than 1. Thus, it was reset automatically to become 1.")
	}
	
	if (MnLen < exclusive) {
		MnLen <- exclusive
		message("The MnLen parameter cannot be smaller than the exclusive parameter. Thus, it was reset automatically.")
	}
	
	iteraciones <- iter
	minlength <- MnLen
	refinStrength <- RefStrength
	maxlength <- MnLen + 2
	
	lappend <- function (lst, ...){ #Function to append objects to a list
		lst <- c(lst, list(...))
		return(lst)
	}
	
	muestrear <- function (victor, punta, tamano){ #Function for Simple Weighted Random Sampling
		llenado <- 0
		clave <- NULL
		while (llenado < tamano) {
			dado <- sample(10:90, 1) #The extreme values are always discarded (those with >90), or they are always taking into account (those with < 10)
			pallenar <- sample(1:length(victor), 1)
			if (punta[pallenar] <= dado) {
				clave <- c(clave, victor[pallenar])
				llenado <- llenado + 1
			}
		}
		return(clave)
	}	
	
	raw_records <- read.fasta(FastaFile, whole.header = TRUE, forceDNAtolower = TRUE)
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
	for (i in 1:length(raw_records[[1]])) { #The invariable sites are discarded
		if ( (length(levels(factor(unname(sapply(raw_records, `[`, i)))))) > 1) {
			VarSites <- c(VarSites, i)
		}
	}	
	
	datos <- read.csv(species, header= FALSE)
	TablaFinal <- NULL
	message("Identifying possible DMCs for the species:")
	for (cladin in 1:(dim(datos)[1]) ) {
		maxlength <- MnLen + 2
		avance <- round(((cladin-1)/(dim(datos)[1]))*100)
		
		qTAXA <- datos[cladin,]
		clado <- NULL; cuentaClado <- 0
		for (i in 1:length(raw_records)) { #Creating the list of sequences of the Query taxon
			if ( grepl(qTAXA, (attributes(raw_records)$names[i]) ) ){
				clado <- c(clado, i)
				cuentaClado <- cuentaClado + 1
			}
		}
		cat(paste("\t", "Doing", qTAXA, "\t", "-", "\t", paste(avance, "%", sep=""), "of the species have been completed.", "\n"))
		shared <- NULL
		if (cuentaClado == 0) {
			stop(
				paste("The species", qTAXA, "is not present in your fasta file.",
				"Please make sure you have at least one sequence/specimen in your fasta file for each of the species included in your query-taxa file.")
			)
		}	
		
		for (i in 1:length(VarSites)) { #Only the sites that have the same state for all the sequences of the query taxon will be taking into account (i.e. 'type 5 characters')
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
		for (i in 1:length(shared)) { #Creating a vector that contains the weights of the sites. Type 1 characters are identified in this step
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
		breakadicionales <- round(iteraciones*0.2)
		iteraciones2 <- iteraciones
		veces <- 0
		buffi <- NULL
		while (soluciones < 2) { # If there are not at least 2 possible DMCs, more iterations will be added.
			if (veces == 6) {    # 20% more iterations are added each time, until (= 2 x the user-defined iterations) have been tested.
				maxlength <- maxlength + 1
				minimo <- maxlength
				message("None of the combinations tested are suitable to become a DMC.")
				message(paste("The maximum length of the DMCs has been reset to", maxlength))
				iteraciones2 <- iteraciones
				veces <- 0
			}
			reales <- 0
			while (reales < iteraciones2) { #Repetead combinations do not count as one interation
				if (minimo <= minlength) {
					size <- minlength #If a combination of size ==  minlength is succesful, the remaining combinations to be tested will have the size of minlenght...
				} else {
					size <- sample(minlength:maxlength, 1) #...otherwise, combinations of diferent sizes will be tested
				}	
				if (unicount > 0 && unicount < minlength) { # Type 1 characters are always included in the possible combinations
					while (unicount > size){
						if (minimo <= minlength) {
							size <- minlength
						} else {
							size <- sample(minlength:maxlength, 1)
						}
					}	
					size <- size - unicount
					tokey <- muestrear(shared, puntajes, size)
					tokey <- c(tokey, unica)
					while (	any(duplicated(tokey)) == TRUE) {
						tokey <- muestrear(shared, puntajes, size)
						tokey <- c(tokey, unica)
					}
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
					tokey <- muestrear(shared, puntajes, size)
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
		write.csv(TablaFinal, file= OutName)
	}
	message("100% of the species completed.")	
}    
