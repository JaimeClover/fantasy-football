library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    titlePanel("2015 Fantasy Football Interactive Cheat Sheet"),
    sidebarLayout(
        sidebarPanel(
            selectInput("position", label = "Select Position",
                        choices = list("ALL", "QB", "RB", "WR", "RB/WR", "TE", "DST", "K"),
                        selected = "ALL"),
            div(style = "display:inline-block", textInput("search", label = NULL)),
            div(style = "display:inline-block", img(src = "search-glass.png", height=20, width=20)),
            radioButtons("type", label = "Choose an action:",
                         choices = list("Draft To My Team", "Draft To Other Team",
                                        "Undraft (return to draft pool)")),
            selectInput("selectedPlayer", label = "Choose a player",
                         choices = NULL, selectize=FALSE, size=10),
            p(em('player rankings updated 8/13/15')),
            downloadButton('downloadData', 'Download My Team'),
            br(), br(),
            div(textOutput("message"), style = "color:red"),
            width = 3
        ),
        mainPanel(
            tabsetPanel(
                tabPanel("My Team", tableOutput("myteam")),
                tabPanel("Other Teams", tableOutput("otherteams")),
                tabPanel("Available", tableOutput("available")),
                tabPanel("Documentation",
                    h3("Introduction", textOutput("documentation")),
                    p("The purpose of this app is to help you keep track of the best available players
                      during your offline fantasy football draft by allowing you to sort and search
                      the top players and remove them from the board when they are drafted."),
                    h3("Sort Players"),
                    p("* Select a position to filter by (or use 'ALL' to view all players)."),
                    p("* Use the search box to search for a specific player by name or team abbreviation.
                      Enter a number between 4 and 11 to exclude players with that bye week."),
                    h3("Choose An Action"),
                    p("Use the radio buttons to select an action to perform.",
                      strong("You must do this before clicking a player.")),
                    p(strong("Draft To My Team"), " removes a player from the draft board and
                      adds him to your team."),
                    p(strong("Draft To Other Team"), " removes a player from the draft board and
                      adds him to an opponent's team."),
                    p(strong("Undraft (return to draft pool)"), " allows you to select a player who
                      has already been drafted and return him to the draft pool."),
                    h3("Choose A Player"),
                    p("Click on a player in the selection box to perform the desired action. Make
                      sure you have selected the appropriate action",  em("before"), "choosing a player.
                      If you make a mistake, use the 'Undraft' button to return a player to the board."),
                    h3("View Player Stats"),
                    p("Use the tabs at the top of the page to view players according to their draft status:",
                      strong("My Team, Other Teams, Available."), "This will show more detailed information about
                      players such as their overall rank, bye week, projected stats, and average draft
                      position (adp)."),
                    h3("Download My Team"),
                    p("When your draft is finished, click the 'Download' button to save your team to
                      your computer. This is a .csv file for viewing in a spreadsheet program.")
                ),
                id = "tabby",
                selected = "Documentation"
            ),
            width = 9
        )
    )
))