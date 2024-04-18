tab_files <- list.files(path = "tabs/ui/Identifier", full.names = T)
suppressMessages(lapply(tab_files, source))

Identifier <- tabPanel(title = "Tax. Verif./Ident. with DMCs", 
	value = "Identifier",
	hr(),
	HTML("<h3><b>Taxonomic verification and identification using DMCs for aligned and unaligned sequences</b></h3>"),
	tabsetPanel(
		Unaligned,
		Aligned,
		AlignmentFree
	)
)
