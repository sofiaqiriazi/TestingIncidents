# package (which generally comes preloaded).
library(datasets)
source("http://goo.gl/w64gfp")
library(magrittr)
library(XML)
library(reshape)
library(gsheet)
# Use the google spreadsheet
incidents <- "https://drive.google.com/open?id=1VX3XeVXzDWWhcb36jik3k9Whq_gnELw_07L21L_QmnE"
arrivals <- "https://drive.google.com/open?id=1HoMZooolfAAlEzyFhWhxxmzcpDqQu_WdBCT7v0o4X-Y"
departures <- "https://drive.google.com/open?id=1jbwk2rzuq86RVQs0_Jcr_34DLFgdun1ctKc6y5kj_9I"

acled <- gsheet2text(incidents)
acled.long <- read.csv(text=acled)

arrs <-gsheet2text(arrivals)
arrs.long <- read.csv(text=arrs)

deps <-gsheet2text(departures)
deps.long <-read.csv(text=deps)


acled.long$Date <- as.Date(acled.long$Date, format="%m/%d/%Y")
arrs.long$Date <- as.Date(arrs.long$Date, format="%m/%d/%Y")
deps.long$Date <- as.Date(deps.long$Date, format="%m/%d/%Y")

# Force columns to be text
acled.long[,2:ncol(acled.long)] <- sapply(acled.long[,2:ncol(acled.long)], as.numeric)
arrs.long[,2:ncol(arrs.long)] <- sapply(arrs.long[,2:ncol(arrs.long)], as.numeric)
deps.long[,2:ncol(deps.long)] <- sapply(deps.long[,2:ncol(deps.long)], as.numeric)

# Define a server for the Shiny app
function(input, output) {
  
  # Fill in the spot we created for a plot
  output$IncidentPlot <- renderPlot({
    
    
    my_vector = c(acled.long[ 1:(input$days),input$region])
    names(my_vector) = c(acled.long[1:(input$days),"Date"])
    # Render a barplot
    barplot(my_vector,
            ylab="Number of days",
            xlab="Incidents")
  })
  
  output$ArrivalsPlot <- renderPlot({
    
    reg <- paste(strsplit(input$region, "_")[[1]][1],"Arrival",sep="_")
    arrivals_vector = c(arrs.long[ 1:input$days, reg ])
    names(arrivals_vector) = c(arrs.long[1:input$days,"Date"])
    
    barplot(arrivals_vector,
            ylab = "Date",
            xlab = "Arrivals")
    
  })
  
  output$DeparturesPlot <- renderPlot({
    
    departures_vector = c(deps.long[ 1:(input$days),strsplit(input$region, "_")[[1]][1]])
    names(departures_vector) = c(deps.long[1:(input$days),"Date"])
    
    barplot(departures_vector,
            ylab = "Date",
            xlab = "Departures")
    
  })
} 
