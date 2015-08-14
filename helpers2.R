www.fantasysharks.com/apps/Projections/SeasonProjections.php?pos=ALL

library(rvest)

getRankings <- function() {
    rankingsh <- html('http://www.fantasysharks.com/apps/Projections/SeasonProjections.php?pos=ALL')
    tables <- rankingsh %>% html_table(fill=TRUE)
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

table <- tables[[4]]
install.packages('dplyr')
library(dplyr)
table <- subset(table, Rank != 'Comp' & Rank != 'Rank')
head(table, 30)
sapply(table, class)
names <- strsplit(table$Name, ', ')
head(names)
newnames <- sapply(names, function(x) paste(x[2],x[1], sep=' '))
head(table)
first <- sapply(names, )
final <- data.frame(ADP = as.numeric(table$ADP), player = newnames, pos = table$Pos, team = table$Team,
                    bye = as.numeric(table$Bye), fantasyPts = as.numeric(table$FantasyPoints))

head(final)
final$status <- "Available"
final <- final[order(final$ADP),]
head(final)
