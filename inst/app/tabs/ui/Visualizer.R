tab_files <- list.files(path = "tabs/ui/Visualizer", full.names = T)
suppressMessages(lapply(tab_files, source))

Visualizer <- tabPanel(title = "Visualizer", 
	value = "Visualizer",
	hr(),
	HTML("<h3><b>Visualization of DMCs</b></h3>"),
	tabsetPanel(
		Visual,
		TempVisual
	)
)
