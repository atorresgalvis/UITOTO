## Title: IdentifierU
## Version: 0.1-1
## Date: 2024-05-15
## Author: Ambrosio Torres (Researcher [Ctr. Integr. Biodivers. Discov. - Museum für Naturkunde, Berlin, Germany)
## Maintainer: Ambrosio Torres <atorresgalvis@gmail.com> <Ambrosio.TorresGalvis@mfn.berlin>
## Depends: R version (>= 4.2.2 ). Packages   seqinr (4.2-23)
## Description: identifies the specimens of the unaligned sequences given in a fasta file, based on a pool of DMCs (e.g., those included in an Output-File from OpDMC).
## License: GPL (3)
## Usage: IdentifierU("OpDMC_output.csv", "MycetoSpecies170622_COI_aligned_313only_hap_SMH_dataset1_mold.fas", mismatches = 0, WinWidth = 10, OutName = "IdentificationOutput.csv")

require("seqinr")

IdentifierU <- function(DMC_Output, dataset, mismatches = 1, WinWidth = 20, OutName = "IdentificationOutput.csv") { 
	
	datos <- read.fasta(dataset, whole.header = TRUE, forceDNAtolower = FALSE)
	datiles <- read.csv(DMC_Output, header = TRUE)
	
	FinalTable <- NULL
	texto <- paste("Identifying the specimens", "of the", dataset, "file.")
	for (bicho in 1:length(datos)) {
		avance <- round((bicho/length(datos))*100)
		texto <- paste("Identifying the specimens", "of the", dataset, "file.", "(", avance, "%", ")")
		cat('\014')
		message(texto)
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
			
			crite <- length(positions) - mismatches
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
			for ( i in starter:(starter+WinWidth) ) {
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
		write.csv(FinalTable, file= OutName)	
	}
}








