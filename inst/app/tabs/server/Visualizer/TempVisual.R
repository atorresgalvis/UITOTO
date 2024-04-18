user_data <- reactive({
  if (is.null(input$Metrics1)) return(NULL)
  read.csv(input$Metrics1$datapath, header = TRUE)
})

output$MetricsPlot <- renderPlot({
  req(user_data())
  user_data <- data.frame(user_data())
  
  socks <- c("Recall","Precision","Specificity","Accuracy","F1Score")
  
  socks <- socks[c(input$Recall, input$Precision, input$Specificity, input$Accuracy, input$F1Score)]
  
	cuenta <- NULL
	for (i in 1:length(socks)) {
		user_data2 <- user_data[grepl(socks[i],colnames(user_data))]
		
		for (j in 1:dim(user_data2)[2]) {
			nomina <- sub(paste(socks[i], "_", sep=""), "", names(user_data2)[j])
			nomina <- sub("MnLen2_s", "_S", nomina); nomina <- sub("MnLen3_s", "_S", nomina); nomina <- sub("MnLen4_s", "_S", nomina)
			nomina <- sub("MnLen6_s", "_MnLen6S", nomina); nomina <- sub("MnLen10_s", "_MnLen10S", nomina)
			rango1 <- sum(user_data2[,j] > input$rangueiro1a & user_data2[,j] <= input$rangueiro1b, na.rm = T)  
			rango2 <- sum(user_data2[,j] > input$rangueiro2a & user_data2[,j] <= input$rangueiro2b, na.rm = T)
			rango3 <- sum(user_data2[,j] > input$rangueiro3a & user_data2[,j] <= input$rangueiro3b, na.rm = T)
			rango4 <- sum(user_data2[,j] > input$rangueiro4a & user_data2[,j] <= input$rangueiro4b, na.rm = T)
			rango5 <- sum(user_data2[,j] >= input$rangueiro5a & user_data2[,j] <= input$rangueiro5b, na.rm = T)
			
			PaCuenta <- data.frame(Range = c("Range 1", "Range 2", "Range 3", "Range 4", "Range 5"), 
								 Proportion = c(rango1, rango2, rango3, rango4, rango5),
                                 Method = rep(nomina, 5),
                                 Metric = rep(socks[i],5))
            cuenta <- rbind(cuenta, PaCuenta)                     
		}
	}
  
  cuenta$Method <- factor(cuenta$Method,
                levels = unique(cuenta$Method))

  cuenta$Metric <- factor(cuenta$Metric,
                levels = unique(cuenta$Metric))                
  
  ggplot(cuenta, aes(x = Method, y = Proportion, fill = Range)) +
    geom_col(position="fill", stat="identity") +
    facet_wrap(vars(Metric), nrow = 2) +
    theme_linedraw() +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
    scale_fill_brewer(palette=input$clorol) +
    theme(
		axis.title.x = element_text(size=14, face="bold", colour = "black"),
		axis.title.y = element_text(size=14, face="bold", colour = "black"),
		axis.text.x = element_text(size=10, face="bold", colour = "black"),
		axis.text.y = element_text(size=10, face="bold", colour = "black"),
		legend.title = element_text(size=14, face="bold", colour = "black"),
		legend.text = element_text(size=10, face="bold", colour = "black")
    )
})
