lento <- eventReactive(input$DMCs10, {
	req(input$DMCs10)
	req(input$somebody10)
	read.csv(input$DMCs10$datapath, header= TRUE)
})

rapido <- eventReactive(input$somebody10, {
	req(input$DMCs10)
	req(input$somebody10)
	read.fasta(input$somebody10$datapath, whole.header = TRUE, forceDNAtolower = FALSE)
})

observeEvent(input$formato, {
	if(input$formato == "format3"){
		shinyjs::disable("tipito1")
		shinyjs::disable("tipito2")
		shinyjs::disable("tamandua1")
		shinyjs::disable("tamandua2")
		shinyjs::disable("CombI")
		shinyjs::enable("NucleoColor")
	} else if(input$formato == "format4"){
		shinyjs::enable("tipito1")
		shinyjs::enable("tipito2")
		shinyjs::enable("tamandua1")
		shinyjs::enable("tamandua2")
		shinyjs::enable("CombI")
		shinyjs::enable("NucleoColor")
	} else{
		shinyjs::enable("tipito1")
		shinyjs::enable("tipito2")
		shinyjs::enable("tamandua1")
		shinyjs::enable("tamandua2")
		shinyjs::enable("CombI")
		shinyjs::disable("NucleoColor")
	}
})            

frasesita <- reactive({

	secular <- rapido() #query
	datafono <- lento() #DMC
	nombres <- names(secular)
	
	tamandua1 <- which(c(8, 10, 12, 14, 18, 24, 36) == input$tamandua1)
	tamandua2 <- which(c(8, 10, 12, 14, 18, 24, 36) == input$tamandua2)
	tamandua3 <- which(c(8, 10, 12, 14, 18, 24, 36) == input$tamandua3)
	
	if (input$formato == "format3") {
		tamandua2 <- tamandua3; tamandua1 <- tamandua3
	}
	
	nimi <- grep(input$clavecita, names(secular))
	maximiliano <- 0
	for (p in nimi) {
		pirulo <- length(strsplit(nombres[p], "")[[1]])
		if (pirulo > maximiliano) {
			maximiliano <- pirulo
		}	
	}
	maximiliano2 <- 0
	for (pi in 1:length(datafono$DMC)) {
		pirulo <- length(strsplit(datafono$DMC[pi], "")[[1]])
		if (pirulo > maximiliano2) {
			maximiliano2 <- pirulo
		}	
	}
	
	maximiliano <- maximiliano + maximiliano2 + 8
	
	
	
	if (input$formato == "format4"){
		frase <- c(
		"<style>
		th, td {
			border:0.5px solid black; text-align:left;
		}
		</style>
		<body>",
		"<table style=padding:0em 0>")
	} else if (input$formato == "format3") {
		frase <- c('<b>', "<font size=\'", tamandua1, "\' ", "color=\'", input$Colorete1,"\'", "face=\'", "courier", "\'>")
	} else {	
		frase <- c('<b>', "<font size=\'", tamandua1, "\' ", "color=\'", input$Colorete1,"\'", "face=\'", input$tipito2, "\'>")
	}		
	
	
	withProgress(message = 'Rendering the DMCs', value = 0, style= "old", {
		for (codi in 1:length(datafono$DMC) ) {
			
			avance <- round(((codi-1)/length(datafono$DMC))*100)
			setProgress(codi, detail = paste(paste("[", avance, "%", sep=""), "completed]" ))
			
			DMC <- datafono$DMC[codi]; DMCori <- datafono$DMC[codi]; DMCori <- gsub(" ", "&nbsp;", DMCori)
			if (input$CombI == TRUE) {
				combi <- c("&nbsp;", "<font color=\'", input$Colorete2,"\'>", DMCori, "</font>")
				if (input$negrilla == FALSE) {
					combi <- c("</b>", combi, "<b>")
				}	
			} else {
				combi <- ""
			}	
			especie <- datafono$Species[codi]
			DMC <- gsub(":", ",", DMC); DMC <- gsub("'", "", DMC); DMC <- gsub(" ", "", DMC)
			DMC <- gsub("\\[", "", DMC); DMC <- gsub("\\]", "", DMC)
			DMC <- gsub("[a-zA-Z ]", "", DMC) 
			DMC <- strsplit(DMC, ",,")[[1]]; DMC <- as.numeric(gsub(",", "", DMC))
			
			cual <- grep(especie, nombres)[grep(input$clavecita, nombres[c(grep(especie, nombres))], nombres)]
			patron <- toupper(secular[[cual]]);
			
			if (input$italica == TRUE) {
				nominal <- c("<i>", "<font color=\'", input$Colorete0, "\'>", nombres[cual], "</font>", "</i>")
				if (input$negrilla == FALSE) {
					nominal <- c("</b>", nominal, "<b>")
				}	
			} else {
				nominal <- c("<font color=\'", input$Colorete0, "\'>", nombres[cual], "</font>")
				if (input$negrilla == FALSE) {
					nominal <- c("</b>", nominal, "<b>")
				}
			}
			
			if (input$formato == "format1") {
				frase <- c(frase, "<font size=\'", tamandua3, "\' ", "face=\'", input$tipito1, "\'>", "<font color=\'", input$Colorete0, "\'>", codi, ". ", "</font>", nominal, combi, "</font>", '<br/>')
			} else if (input$formato == "format2") {
				espacios <- maximiliano - (length(strsplit((nombres[cual]), "")[[1]]) + length(strsplit(datafono$DMC[codi], "")[[1]]) + 1) 
				frase <- c(frase, "<font size=\'", tamandua3, "\' ", "face=\'", input$tipito1, "\'>", nominal, combi, "</font>", rep('&nbsp;', espacios) )
			} else if (input$formato == "format3") {
				tamandua2 <- tamandua3; tamandua1 <- tamandua3
				espacios <- maximiliano - (length(strsplit((nombres[cual]), "")[[1]]) + length(strsplit(datafono$DMC[codi], "")[[1]]) + 1) 
				frase <- c(frase, "<font size=\'", tamandua3, "\' ", "face=\'", "courier", "\'>", nominal, combi, "</font>", rep('&nbsp;', espacios) )
			} else  {
				frase <- c(frase, "<tr> <td>", "<font size=\'", tamandua3, "\' ", "face=\'", input$tipito1, "\'>", '<b>', nominal, combi, '</b>', "</font>", '</td>')
			}		
	
			if (input$negrilla2 == FALSE) {
				frase <- c(frase, "</b>")
			}
			
			tofrase <- "<nobr>"
			for (i in 1:length(patron)) {
				if (is.element(i, DMC)==TRUE) {
					frase <- c(frase, tofrase)
					if (input$formato == "format3") {
						if (input$NucleoColor == "Pallete1") {
							if (patron[i] == "A") { culor <- "#003f5c" } else if (patron[i] == "C") { culor <- "#7a5195" } else if (patron[i] == "G") { culor <- "#ef5675" } else if (patron[i] == "T") { culor <- "#ffa600" } else {culor <- "#121211"}
						} else if (input$NucleoColor == "Pallete2") {
							if (patron[i] == "A") { culor <- "#e41a1c" } else if (patron[i] == "C") { culor <- "#377eb8" } else if (patron[i] == "G") { culor <- "#984ea3" } else if (patron[i] == "T") { culor <- "#ff7f00" } else {culor <- "#121211"}
						} else if (input$NucleoColor == "Pallete3") {
							if (patron[i] == "A") { culor <- "#17301C" } else if (patron[i] == "C") { culor <- "#4F86C6" } else if (patron[i] == "G") { culor <- "#7F0799" } else if (patron[i] == "T") { culor <- "#F34213" } else {culor <- "#121211"}
						} else if (input$NucleoColor == "Pallete4") {
							if (patron[i] == "A") { culor <- "#86007D" } else if (patron[i] == "C") { culor <- "#008018" } else if (patron[i] == "G") { culor <- "#FF0018" } else if (patron[i] == "T") { culor <- "#0000F9" } else {culor <- "#121211"}
						} else {
							culor <- "#121211"
						}	
						caja <- 0.0
						if (input$mayus == "uppercase") {
								mani <- toupper(patron[i])
							} else if (input$mayus == "lowercase") {
								mani <- tolower(patron[i])
							} else if (input$mayus == "DMCuppercase") {
								mani <- toupper(patron[i])
							} else {
								mani <- tolower(patron[i])
						}
						tofrase <- c("<font style=\'border:", caja, "px solid black ;text-align:center ;padding:0em 30; background:", input$Colorete2, "80;\' size=\'", tamandua2, "\' ", "color=\'", culor,"\'>", mani, "</font>")
					} else if (input$formato == "format4") {
						if (input$NucleoColor == "Pallete1") {
							if (patron[i] == "A") { culor <- "#003f5c" } else if (patron[i] == "C") { culor <- "#7a5195" } else if (patron[i] == "G") { culor <- "#ef5675" } else if (patron[i] == "T") { culor <- "#ffa600" } else {culor <- "#121211"}
						} else if (input$NucleoColor == "Pallete2") {
							if (patron[i] == "A") { culor <- "#e41a1c" } else if (patron[i] == "C") { culor <- "#377eb8" } else if (patron[i] == "G") { culor <- "#984ea3" } else if (patron[i] == "T") { culor <- "#ff7f00" } else {culor <- "#121211"}
						} else if (input$NucleoColor == "Pallete3") {
							if (patron[i] == "A") { culor <- "#17301C" } else if (patron[i] == "C") { culor <- "#4F86C6" } else if (patron[i] == "G") { culor <- "#7F0799" } else if (patron[i] == "T") { culor <- "#F34213" } else {culor <- "#121211"}
						} else if (input$NucleoColor == "Pallete4") {
							if (patron[i] == "A") { culor <- "#86007D" } else if (patron[i] == "C") { culor <- "#008018" } else if (patron[i] == "G") { culor <- "#FF0018" } else if (patron[i] == "T") { culor <- "#0000F9" } else {culor <- "#121211"}
						} else {
							culor <- "#121211"
						}
						if (input$negrilla2 == TRUE) {
							if (input$mayus == "uppercase") {
								mani <- c("<b>", toupper(patron[i]), "<b/>")
							} else if (input$mayus == "lowercase") {
								mani <- c("<b>", tolower(patron[i]), "<b/>")
							} else if (input$mayus == "DMCuppercase") {
								mani <- c("<b>", toupper(patron[i]), "<b/>")
							} else {
								mani <- c("<b>", tolower(patron[i]), "<b/>")
							}
						} else {
							if (input$mayus == "uppercase") {
								mani <- toupper(patron[i])
							} else if (input$mayus == "lowercase") {
								mani <- tolower(patron[i])
							} else if (input$mayus == "DMCuppercase") {
								mani <- toupper(patron[i])
							} else {
								mani <- tolower(patron[i])
							}	
						}	
						frase <- c(frase, "<td>", "<font style= background:", input$Colorete2, "80;\' size=\'", tamandua2, "\' ", "face=\'", input$tipito2, "\' ", "color=\'", culor,"\'>", mani, "</font>", '</td>') 
					} else {
						if (input$mayus == "uppercase") {
								mani <- toupper(patron[i])
							} else if (input$mayus == "lowercase") {
								mani <- tolower(patron[i])
							} else if (input$mayus == "DMCuppercase") {
								mani <- toupper(patron[i])
							} else {
								mani <- tolower(patron[i])
						}
						tofrase <- c("<font size=\'", tamandua2, "\' ", "color=\'", input$Colorete2,"\'>", mani, "</font>")
					}
					frase <- c(frase, tofrase, "</nobr>")
					tofrase <- "<nobr>" 
				} else {
					if (input$formato == "format3") {
						if (input$NucleoColor == "Pallete1") {
							if (patron[i] == "A") { culor <- "#003f5c" } else if (patron[i] == "C") { culor <- "#7a5195" } else if (patron[i] == "G") { culor <- "#ef5675" } else if (patron[i] == "T") { culor <- "#ffa600" } else {culor <- "#121211"}
						} else if (input$NucleoColor == "Pallete2") {
							if (patron[i] == "A") { culor <- "#e41a1c" } else if (patron[i] == "C") { culor <- "#377eb8" } else if (patron[i] == "G") { culor <- "#984ea3" } else if (patron[i] == "T") { culor <- "#ff7f00" } else {culor <- "#121211"}
						} else if (input$NucleoColor == "Pallete3") {
							if (patron[i] == "A") { culor <- "#17301C" } else if (patron[i] == "C") { culor <- "#7F0799" } else if (patron[i] == "G") { culor <- "#4F86C6" } else if (patron[i] == "T") { culor <- "#F34213" } else {culor <- "#121211"}
						} else if (input$NucleoColor == "Pallete4") {
							if (patron[i] == "A") { culor <- "#86007D" } else if (patron[i] == "C") { culor <- "#008018" } else if (patron[i] == "G") { culor <- "#FF0018" } else if (patron[i] == "T") { culor <- "#0000F9" } else {culor <- "#121211"}
						} else {
							culor <- "#121211"
						}
						caja <- 0.0
						if (input$mayus == "uppercase") {
								mani <- toupper(patron[i])
							} else if (input$mayus == "lowercase") {
								mani <- tolower(patron[i])
							} else if (input$mayus == "DMCuppercase") {
								mani <- tolower(patron[i])
							} else {
								mani <- toupper(patron[i])
						}
						tofrase <- c(tofrase, "<font style=\'border:", caja, "px solid black ;text-align:center ;padding:0em 30;\' ", "color=\'", culor,"\'>", mani, "</font>")
					} else if (input$formato == "format4") {
						if (input$NucleoColor == "Pallete1") {
							if (patron[i] == "A") { culor <- "#003f5c" } else if (patron[i] == "C") { culor <- "#7a5195" } else if (patron[i] == "G") { culor <- "#ef5675" } else if (patron[i] == "T") { culor <- "#ffa600" } else {culor <- "#121211"}
						} else if (input$NucleoColor == "Pallete2") {
							if (patron[i] == "A") { culor <- "#e41a1c" } else if (patron[i] == "C") { culor <- "#377eb8" } else if (patron[i] == "G") { culor <- "#984ea3" } else if (patron[i] == "T") { culor <- "#ff7f00" } else {culor <- "#121211"}
						} else if (input$NucleoColor == "Pallete3") {
							if (patron[i] == "A") { culor <- "#17301C" } else if (patron[i] == "C") { culor <- "#4F86C6" } else if (patron[i] == "G") { culor <- "#7F0799" } else if (patron[i] == "T") { culor <- "#F34213" } else {culor <- "#121211"}
						} else if (input$NucleoColor == "Pallete4") {
							if (patron[i] == "A") { culor <- "#86007D" } else if (patron[i] == "C") { culor <- "#008018" } else if (patron[i] == "G") { culor <- "#FF0018" } else if (patron[i] == "T") { culor <- "#0000F9" } else {culor <- "#121211"}
						} else {
							culor <- "#121211"
						}
						if (input$negrilla2 == TRUE) {
							if (input$mayus == "uppercase") {
								mani <- c("<b>", toupper(patron[i]), "<b/>")
							} else if (input$mayus == "lowercase") {
								mani <- c("<b>", tolower(patron[i]), "<b/>")
							} else if (input$mayus == "DMCuppercase") {
								mani <- c("<b>", tolower(patron[i]), "<b/>")
							} else {
								mani <- c("<b>", toupper(patron[i]), "<b/>")
							}			
						} else {
							if (input$mayus == "uppercase") {
								mani <- toupper(patron[i])
							} else if (input$mayus == "lowercase") {
								mani <- tolower(patron[i])
							} else if (input$mayus == "DMC's sites in uppercase") {
								mani <- tolower(patron[i])
							} else {
								mani <- toupper(patron[i])
							}
						}
						frase <- c(frase, "<td>", "<font style= background:", "#fffcfd", "000;\' size=\'", tamandua1, "\' ", "face=\'", input$tipito2, "\' ", "color=\'", culor,"\'>", mani, "</font>", '</td>')
					} else {
						if (input$mayus == "uppercase") {
								mani <- toupper(patron[i])
							} else if (input$mayus == "lowercase") {
								mani <- tolower(patron[i])
							} else if (input$mayus == "DMCuppercase") {
								mani <- tolower(patron[i])
							} else {
								mani <- toupper(patron[i])
						}
						tofrase <- c(tofrase, mani)
					}
				}
				if (i == length(patron)) {
					frase <- c(frase, tofrase, "</nobr>")
				}	
			}
			if (input$negrilla2 == FALSE) {
				frase <- c(frase, "<b>")
			}
			if (input$formato == "format4") {
				frase <- c(frase, '</tr>')
			} else {
				frase <- c(frase, '<br/>')
			}
		}
	})
	if (input$formato == "format4") {
		frase <- c(frase, "</table>")
	} else {	
		frase <- c(frase, "</font>", '<b/>')
	}
	frase <- paste(frase, collapse="")
})

output$outpt_fancy <- renderText({
	HTML(frasesita())
})

output$outpt_colores <- renderText({
	req(input$formato == "format3" | input$formato == "format4")
	HTML(paste(c("<b>", "Palette color 1:", '&nbsp;', '&nbsp;',
						 "<font color=\'", "#003f5c","\' face=\'", "courier","\'size=\'", "4","\' >", "A", "</font>", 
						 "<font color=\'", "#7a5195","\' face=\'", "courier","\'size=\'", "4","\' >", "C", "</font>", 
						 "<font color=\'", "#ef5675","\' face=\'", "courier","\'size=\'", "4","\' >", "G", "</font>", 
						 "<font color=\'", "#ffa600","\' face=\'", "courier","\'size=\'", "4","\' >", "T", "</font>", "<br/>",
						 
						 "Palette color 2:", '&nbsp;', '&nbsp;',
						 "<font color=\'", "#e41a1c","\' face=\'", "courier","\'size=\'", "4","\' >", "A", "</font>", 
						 "<font color=\'", "#377eb8","\' face=\'", "courier","\'size=\'", "4","\' >", "C", "</font>", 
						 "<font color=\'", "#984ea3","\' face=\'", "courier","\'size=\'", "4","\' >", "G", "</font>", 
						 "<font color=\'", "#ff7f00","\' face=\'", "courier","\'size=\'", "4","\' >", "T", "</font>", "<br/>",
						 				 
						 "Palette color 3:", '&nbsp;', '&nbsp;',
						 "<font color=\'", "#17301C","\' face=\'", "courier","\'size=\'", "4","\' >", "A", "</font>", 
						 "<font color=\'", "#7F0799","\' face=\'", "courier","\'size=\'", "4","\' >", "C", "</font>", 
						 "<font color=\'", "#4F86C6","\' face=\'", "courier","\'size=\'", "4","\' >", "G", "</font>", 
						 "<font color=\'", "#F34213","\' face=\'", "courier","\'size=\'", "4","\' >", "T", "</font>", "<br/>",
						 
						 "Palette color 4:", '&nbsp;', '&nbsp;',
						 "<font color=\'", "#86007D","\' face=\'", "courier","\'size=\'", "4","\' >", "A", "</font>", 
						 "<font color=\'", "#008018","\' face=\'", "courier","\'size=\'", "4","\' >", "C", "</font>", 
						 "<font color=\'", "#FF0018","\' face=\'", "courier","\'size=\'", "4","\' >", "G", "</font>", 
						 "<font color=\'", "#0000F9","\' face=\'", "courier","\'size=\'", "4","\' >", "T", "</font>", "<br/>",
						 
				"<b/>"
				),				
		 sep = "")
		)
})

output$downloadTablita <- downloadHandler(
	filename = function(){"DMC_Table.html"},
	content = function(fname) {
		write_file(frasesita(), fname)
	}
)

observeEvent(frasesita() != NULL, {
	shinyjs::toggle("downloadTablita")
})
