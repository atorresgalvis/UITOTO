shinyUI(
  fluidPage(
    ##-- Favicon ----
    tags$head(
      tags$link(rel = "shortcut icon", href = "img/mfnLogo.jpg"),
      #-- biblio js ----
      tags$link(rel="stylesheet", type = "text/css",
                href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"),
      tags$link(rel="stylesheet", type = "text/css",
                href = "https://fonts.googleapis.com/css?family=Open+Sans|Source+Sans+Pro")
    ),
    ##-- Logo ----
    list(tags$head(HTML('<link rel="icon", href="img/mfnLogo.jpg",
                        type="image/png" />'))),
    div(style="padding: 1px 0px; width: '100%'",
        titlePanel(
          title="", windowTitle = "UITOTO: Molecular Diagnoses"
        )
    ),
    ##-- Header ----
    navbarPage(title = div(img(src="img/mfnLogo.jpg",
                               height = "80px"), style = "padding-left:10px;"),
               id = "navbar",
               selected = "home",
               theme = "styles.css", 
               fluid = T,
               ##-- Abas ----
               home,
               Search,
               Identifier,
               Visualizer
    ),
    ##-- Footer ----
    div(class = "footer",
        includeHTML("html/footer.html")
    )
  )
)
