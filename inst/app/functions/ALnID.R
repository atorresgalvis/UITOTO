## Title: ALnID
## Version: 0.1-1
## Date: 2024-03-27
## Author: Ambrosio Torres (Researcher [Ctr. Integr. Biodivers. Discov. - Museum für Naturkunde, Berlin, Germany)
## Maintainer: Ambrosio Torres <atorresgalvis@gmail.com> <Ambrosio.TorresGalvis@mfn.berlin>
## Depends: R version (>= 4.2.2). Packages   seqinr (4.2-23); Biostrings (2.66.0); DECIPHER (2.30.0)
## Description: identifies the specimens of the unaligned sequences given in a fasta file, based on a pool of DMCs (e.g., those included in an Output-File from OpDMC).
## License: GPL (3)
## Usage: ALnID("OpDMC_output.csv", "DatasetAlignedTarget.fas", "DatasetUnalignedQuery.fas", mismatches = 1, against= "First", perfectMatch=5, misMatch=0, gapOpening = -14, gapExtension = -2, gapPower = -1, terminalGap = 0, OutName = "IdentificationOutput.csv", MissLogFile= "LogMissing.csv", AligName = "ResultingAlignment.fasta")

ALnID <- function(DMC_Output, dataTarget, dataQuery, 
				  mismatches = 1,
				  against = c("First","All"),
				  perfectMatch=5, 
				  misMatch=0, 
				  gapOpening = -14,
				  gapExtension = -2,
				  gapPower = -1,
				  terminalGap = 0,
				  OutName = "IdentificationOutput.csv",
				  MissLogFile= "LogMissing.csv",
				  AligName = "ResultingAlignment.fasta"				  
				  ) { 
	require("Biostrings")
	require("seqinr")
	require("DECIPHER")
	
	datos <- read.fasta(dataQuery, whole.header = TRUE, forceDNAtolower = FALSE)
	nombres <- names(datos)
	raw_records <- read.fasta(dataTarget, whole.header = TRUE, forceDNAtolower = FALSE)
	datiles <- read.csv(DMC_Output, header = TRUE)
	
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
	
	FinalTable <- NULL
	options(width = 50)
	texto <- paste("Identifying the specimens", "of the", dataQuery, "file.")
	logMissing <- NULL
	liniers <- paste("Sequence","SpeciesDMC","N_Missing", sep=",")
	logMissing <- rbind(logMissing, liniers)
	for (i in 1:length(datos)) {
		extra <- nchar('||100%')
		width <- options()$width
		step <- round(i / length(datos) * (width - extra))
		text <- sprintf('|%s%s|% 3s%%', strrep('=', step),
						strrep(' ', width - step - extra), round(i / length(datos) * 100))
		cat(paste(texto,'\n',text))
		count <- 0
		resultado <- NULL
		
		query <- paste(as.vector(datos[[i]]), collapse = "")
		query <- toupper(query)
		query <- DNAString(gsub("-", "N", query))
		query2 <- as.character(complement(query))
		query3 <- as.character(reverseComplement(query))
		query4 <- as.character(rev(query))
		query <- as.character(query)
		queries <- c(query, query2, query3, query4)
		
		if (against == "First") {			
			patron <- raw_records[[1]]
			patron <- paste(patron, collapse= "")
			
			mindista <- 1
			for (pilas in 1:4) {
				prueba <- AlignProfiles(DNAStringSet(patron), DNAStringSet(queries[pilas]), 
								perfectMatch= perfectMatch, 
								misMatch= misMatch, 
								gapOpening = gapOpening,
								gapExtension = gapExtension,
								gapPower = gapPower,
								terminalGap = terminalGap)
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
			} else {
				datos[[i]] <- strsplit(as.character(prueba2[2]), split="")[[1]]
			}
		}
		
		chequeo <- 0
		if (MissLogFile == "none") {
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

			if (against == "All") {			
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
									perfectMatch= perfectMatch, 
									misMatch= misMatch, 
									gapOpening = gapOpening,
									gapExtension = gapExtension,
									gapPower = gapPower,
									terminalGap = terminalGap)
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
				} else {
					datos[[i]] <- strsplit(as.character(prueba2[2]), split="")[[1]]
				}
			}
			
			if (chequeo == 1) {
				DMCtemp <- gsub('[ACGT]','', DMC); DMCtemp <- gsub("  "," ", DMCtemp)
				DMCtemp <- as.numeric(na.exclude(as.numeric(DMCtemp)))
				cuantos <- c(ImporMiss, DMCtemp)[which(duplicated(c(ImporMiss, DMCtemp)))]
				if (length(cuantos) > mismatches) {
					liniers <- paste(attributes(datos)$names[i],
								 datiles$Species[j], 
								 paste("[", cuantos, "]", collapse=" "), sep=",")
					logMissing <- rbind(logMissing, liniers)
					write(logMissing, file= MissLogFile)
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
				pares <- paste("-", datiles$Species[j], "[", matchi, "/", (length(DMC)/2), " {", format(meximo, digits = 3), "}",  "]", sep = "")
				resultado <- paste(resultado, pares, sep = "")
				count <- count + 1
			} else if ( matchi < (length(DMC)/2)    &    matchi >= ((length(DMC)/2)-mismatches) ) {
				pares <- paste("-", datiles$Species[j], "[", matchi, "/", (length(DMC)/2), " {", format(meximo, digits = 3), "}",  "]", sep = "")
				resultado <- paste(resultado, pares, sep = "")
				count <- count + 1
			}	
		}
		if (count == 0) {
			resultado <- "Unidentified"
		}
		palata <- cbind(attributes(datos)$names[i], resultado)
		FinalTable <- rbind(FinalTable, palata)
		colnames(FinalTable) <- c("SpecimenName", "MatchesWith")
		write.csv(FinalTable, file= OutName)
		write.fasta(datos, names= nombres, file.out = AligName)	
		cat(if (i == length(datos)) '\n' else '\014')
		#print(as.character(prueba2[1]))
		#print(as.character(prueba2[2]))	
	}
}
