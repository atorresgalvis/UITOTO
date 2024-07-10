observeEvent(input$Search,{
  updateTabsetPanel(session = session, inputId = "navbar", selected = "Search")
})
observeEvent(input$Identifier,{
  updateTabsetPanel(session = session, inputId = "navbar", selected = "Identifier")
})
observeEvent(input$Visualizer,{
  updateTabsetPanel(session = session, inputId = "navbar", selected = "Visualizer")
})
observeEvent(input$Presentation,{
  showModal(
    modalDialog(
      size = "l",
      title = "Presentation slides",
      tags$iframe(style = "height:400px; width:100%; scrolling = yes", src = "pdf/PreUITOTO.pdf"),
      footer = tagList(modalButton("Close"))
    ))
})
output$outpt_title <- renderText({
	paste0("<h1><center><b>",
		paste0("<b>UITOTO: </b>"), 
		paste0("<font color=\"#91bd0d\">",'U', "</font>"),
		paste0("ser "),
		paste0("<font color=\"#91bd0d\">",'I', "</font>"),
		paste0("n"),
		paste0("<font color=\"#91bd0d\">",'T', "</font>"),
		paste0("erface for "),
		paste0("<font color=\"#91bd0d\">",'O', "</font>"),
		paste0("ptimal molecular diagnoses in high-throughput "),
		paste0("<font color=\"#91bd0d\">",'T', "</font>"),
		paste0("ax"),
		paste0("<font color=\"#91bd0d\">",'O', "</font>"),
		paste0("nomy"),
		"</b></center></h1>" 
	)
})
