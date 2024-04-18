tab_files <- list.files(path = "tabs/ui/Search", full.names = T)
suppressMessages(lapply(tab_files, source))

Search <- tabPanel(title = "Find DMCs", 
	value = "Search",
	hr(),
	HTML("<h3><b>Find Diagnostic Molecular Combinations (DMCs)</b></h3>"),
	tabsetPanel(
		Search
	)
)
