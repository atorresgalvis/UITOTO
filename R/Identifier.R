## Title: Identifier
## Version: 0.1-1
## Date: 2024-05-15
## Author: Ambrosio Torres (Researcher [Ctr. Integr. Biodivers. Discov. - Museum für Naturkunde, Berlin, Germany)
## Maintainer: Ambrosio Torres <atorresgalvis@gmail.com> <Ambrosio.TorresGalvis@mfn.berlin>
## Depends: R version (>= 4.2.2 ). Packages   seqinr (4.2-23)
## Description: identifies the specimens of the aligned sequences given in a fasta file, based on a pool of DMCs (e.g., those included in an Output-File from OpDMC).
## License: GPL (3)
## Usage: Identifier("OpDMC_output.csv", "DatasetAlignedQuery.fas", mismatches = 1, OutName = "IdentificationOutput.csv", MissLogFile= "LogMissing.csv")

require("seqinr")

Identifier <- function(DMC_Output, dataset, mismatches = 1, OutName = "IdentificationOutput.csv", MissLogFile= "LogMissing.csv") { 

	datos <- read.fasta(dataset, whole.header = TRUE, forceDNAtolower = FALSE)
	
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
	
	FinalTable <- NULL
	options(width = 50)
	texto <- paste("Identifying the specimens", "of the", dataset, "file.")
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
		cat(if (i == length(datos)) '\n' else '\014')
		
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
		
		count <- 0
		resultado <- NULL
		for (j in 1:dim(datiles)[1]) {
			DMC <- datiles$DMC[j]
			DMC <- strsplit(DMC, " ")[[1]]
			
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
				pares <- paste("-", datiles$Species[j], "[", matchi, "/", (length(DMC)/2), "]", sep = "")
				resultado <- paste(resultado, pares, sep = "")
				count <- count + 1
			} else if ( matchi < (length(DMC)/2)    &    matchi >= ((length(DMC)/2)-mismatches) ) {
				pares <- paste("-", datiles$Species[j], "[", matchi, "/", (length(DMC)/2), "]", sep = "")
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
	}
}
