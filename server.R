library(shiny)

shinyServer(
    function(input, output, session) {
        players <- readRDS('data/players.RDS')
        newstatus <- reactive({
            if (input$type == "Draft To My Team") {
                return("My Team")
            } else if (input$type == "Draft To Other Team") {
                return("Drafted")
            }
            return("Available")
        })
        
        searchavailable <- reactive({
            if (input$search == "1") {
                return(TRUE)
            }
            numer <- as.numeric(input$search)
            if (!is.na(numer) & numer > 0 & numer < 18){
                return(!grepl(input$search, as.character(players$bye)))
            } else {
                return(grepl(tolower(input$search), tolower(players$player)) |
                       grepl(tolower(input$search), tolower(players$team)))
            }
        })
        
        searchteams <- reactive({
            numer <- as.numeric(input$search)
            if (!is.na(numer)){
                return(TRUE)
            } else {
                return(grepl(tolower(input$search), tolower(players$player)) |
                       grepl(tolower(input$search), tolower(players$team)))
            }
        })
        output$myteam <- renderDataTable({
            newstat <- newstatus()
            if (newstat %in% c("My Team", "Drafted")){
                filt <- "Available"
            } else if (newstat == "Available") {
                filt <- c("My Team", "Drafted")
            }
            players[players$player == input$selectedPlayer, "status"] <<- newstat
            data <- subset(players, status == "My Team" & (pos %in% strsplit(input$position, '/')[[1]] |
                               input$position == "ALL") & searchteams())
            observe(updateSelectInput(session, "selectedPlayer", label="Choose a player",
                                  choices = players$player[players$status %in% filt &
                                                           (players$pos %in% strsplit(input$position, '/')[[1]] |
                                                            input$position == "ALL") & searchavailable()]))
            data[,-ncol(data)]
        }, 
        options = list(
            paging = FALSE,
            searching = FALSE
        ))
        output$otherteams <- renderDataTable({
            newstat <- newstatus()
            if (newstat %in% c("My Team", "Drafted")){
                filt <- "Available"
            } else if (newstat == "Available") {
                filt <- c("My Team", "Drafted")
            }
            players[players$player == input$selectedPlayer, "status"] <<- newstat
            data <- subset(players, status == "Drafted" & (pos %in% strsplit(input$position, '/')[[1]] |
                                input$position == "ALL") & searchteams())
            observe(updateSelectInput(session, "selectedPlayer", label="Choose a player",
                                      choices = players$player[players$status %in% filt &
                                                               (players$pos %in% strsplit(input$position, '/')[[1]] |
                                                                input$position == "ALL")  & searchavailable()]))
            data[,-ncol(data)]
        }, 
        options = list(
            lengthMenu = list(c(10, 25, 50, 100, -1), c('10', '25', '50', '100', 'All')),
            pageLength = 25,
            searching = FALSE
        ))
       
        output$available <- renderDataTable({
            newstat <- newstatus()
            if (newstat %in% c("My Team", "Drafted")){
                filt <- "Available"
            } else if (newstat == "Available") {
                filt <- c("My Team", "Drafted")
            } else {
                filt <- "Available"
            }
            players[players$player == input$selectedPlayer, "status"] <<- newstatus()
            data <- subset(players, status == "Available" & (pos %in% strsplit(input$position, '/')[[1]] |
                                input$position == "ALL") & searchavailable())
            observe(updateSelectInput(session, "selectedPlayer", label="Choose a player",
                                      choices = players$player[players$status %in% filt &
                                                               (players$pos %in% strsplit(input$position, '/')[[1]] |
                                                                input$position == "ALL")  & searchavailable()]))
            
            data[,-ncol(data)]
        }, 
            options = list(
                lengthMenu = list(c(10, 25, 50, 100, -1), c('10', '25', '50', '100', 'All')),
                pageLength = 25,
                searching = FALSE
            )
        )
        output$documentation <- renderText({
            newstat <- newstatus()
            if (newstat %in% c("My Team", "Drafted")){
                filt <- "Available"
            } else if (newstat == "Available") {
                filt <- c("My Team", "Drafted")
            }
            players[players$player == input$selectedPlayer, "status"] <<- newstatus()
            observe(updateSelectInput(session, "selectedPlayer", label="Choose a player",
                                      choices = players$player[players$status %in% filt &
                                                                   (players$pos %in% strsplit(input$position, '/')[[1]] |
                                                                        input$position == "ALL")  & searchavailable()]))
            ""
        })
        selected <- reactive({
            if (length(input$selectedPlayer) > 0) {
                paste("moving", input$selectedPlayer, "to", newstatus(), "...")
            } else {
                "status: waiting for next pick..."
            }
        })
        
        output$message <- renderText({
            selected()
        })
        output$downloadData <- downloadHandler(
            filename = function() {
                "my-fantasy-team-2015.csv"
            },
            content = function(file) {
                write.csv(players[players$status == 'My Team', -ncol(players)], file, row.names = FALSE)
            }
        )
    }
)
