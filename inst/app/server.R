shinyServer(function(input, output, session){
  ##-- HOME ----
  source("tabs/server/home.R", local = TRUE)
  ##-- OpDMC ----
  source("tabs/server/Search/UITOTObasic.R", local = TRUE)
  ##-- Identifier ----
  source("tabs/server/Identifier/Aligned.R", local = TRUE)
  source("tabs/server/Identifier/Unaligned.R", local = TRUE)
  source("tabs/server/Identifier/AlignmentFree.R", local = TRUE)
  ##-- Visualizer ----
  source("tabs/server/Visualizer/Visual.R", local = TRUE)
  source("tabs/server/Visualizer/TempVisual.R", local = TRUE)
})
