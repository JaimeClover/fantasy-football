setwd('~/Desktop/projects/shiny/fantasy')
source('helpers.R')
rankings <- getRankings2()
saveRDS(rankings, 'data/players.RDS')