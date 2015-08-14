library(rvest)

getRankings <- function() {
    rankingsh <- html('http://espn.go.com/fantasy/football/story/_/id/12866396/top-300-rankings-2015')
    tables <- rankingsh %>% html_table()
    table <- tables[[2]]
    final <- data.frame(rank = 1:nrow(table))
    namesPos <- sub("[0-9]+\\. ", "", table[[1]])
    final$player <- sub(", [A-Za-z]+", "", namesPos)
    final$team <- table$Team
    final$bye <- table$Bye
    final$pos <- sub("[0-9]+", "", table$PosRank)
    final$posRank <- sub("[A-Za-z]+", "", table$PosRank)
    final$status <- "Available"
    final
}

getRankings2 <- function(){
    rankingsh <- html('http://fantasydata.com/nfl-stats/nfl-fantasy-football-rankings-adp.aspx')
    rankingsh2 <- html('http://espn.go.com/fantasy/football/story/_/id/12866396/top-300-rankings-2015')
    tables <- rankingsh %>% html_table()
    table <- tables[[1]]
    tables2 <- rankingsh2 %>% html_table()
    table2 <- tables2[[2]]
    table$Player <- gsub("\\.", "", table$Player)
    final <- data.frame(rk = rep(NA, 300))
    namesPos <- sub("[0-9]+\\. ", "", table2[[1]])
    final$player <- sub(", [A-Za-z]+", "", namesPos)
    final[final$player == 'Steve Smith Sr.', 'player'] <- 'Steve Smith'
    final$player <- gsub("\\.", "", final$player)
    final$team <- table2$Team
    final$bye <- table2$Bye
    final$pos <- sub("[0-9]+", "", table2$PosRank)
    names(table) <- tolower(names(table))
    names(table)[11] <- "rushTD"
    names(table)[14] <- "recTD"
    final <- final[!(final$player %in% table$player),]
    for (name in names(table)[6:16]){
        final[[name]] <- NA
    }
    output <- rbind(table, final)
    output$status <- "Available"
    rownames(output) <- NULL
    output
}