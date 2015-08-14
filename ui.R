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
                tabPanel("My Team", dataTableOutput("myteam")),
                tabPanel("Other Teams", dataTableOutput("otherteams")),
                tabPanel("Available", dataTableOutput("available")),
                tabPanel("Documentation",
                    h2("Introduction", textOutput("documentation")),
                    p("The purpose of this app is to help you keep track of the best available players
                      during your offline fantasy football draft by allowing you to sort and search
                      the top players and remove them from the board when they are drafted."), hr(),
                    h2("View Player Stats"),
                    p("Use the tabs at the top of this panel to view players according to their draft status:",
                      strong("My Team, Other Teams, Available."), "This will show detailed, sortable
                      information about players such as their overall rank, bye week, projected stats,
                      and average draft position (adp)."), hr(),
                    h2("Updating The Draft Board"),
                    p("Following the instructions below, use the panel on the left to find players
                      and add them to your team or an opponent's team as they are drafted."),
                    h3("Select Position"),
                    p("Select a position to filter by (or use 'ALL' to view all players)."),
                    h3("Search"),
                    p("Use the search box to search for specific players by name or team abbreviation.
                      Enter a number between 4 and 11 to exclude players with that bye week."),
                    h3("Choose An Action"),
                    p("Use the radio buttons to select an action to perform.",
                      strong("You must do this before clicking a player.")),
                    p(strong("Draft To My Team"), " moves a player from the draft board to your team."),
                    p(strong("Draft To Other Team"), " moves a player from the draft board to an
                      opponent's team."),
                    p(strong("Undraft (return to draft pool)"), " allows you to select a player who
                      has already been drafted and return him to the draft pool."),
                    h3("Choose A Player"),
                    p("Click on a player in the selection box to perform the desired action. Make
                      sure you have selected the appropriate action",  em("before"), "choosing a player.
                      If you make a mistake, use the 'Undraft' button to return a player to the board."), hr(),
                    h2("Download My Team"),
                    p("When your draft is finished, click the 'Download' button to save your team to
                      your computer. This is a .csv file for viewing in a spreadsheet program."), hr(), br()
                ),
                id = "tabby",
                selected = "Documentation"
            ),
            width = 9
        )
    )
))