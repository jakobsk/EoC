library(ggplot2)
library(scales)
library(ggthemes)
library(plyr)

# Select the amount of 'top' countries/botnets to visualise
countries_n <- 10
botnets_n <- 20

# Import
spamhaus <- read.csv("spamhaus.csv")

## Sanitise
diag_filter <- as.character(spamhaus$Diagnostic)
spamhaus <- spamhaus[(startsWith(diag_filter, "BOT")),]
spamhaus <- spamhaus[(spamhaus$Country != "" & spamhaus$Country != "??"),]

# Calculate frequencies for each country + bot combination omitting non-existant combinations
frequencies <- count(spamhaus, c("Country", "Diagnostic"))

# Get top N infection countries as a selection for this visualisation
country_stats <- count(spamhaus, c("Country"))
countries_ordered <- country_stats[order(-country_stats$freq),]
top_n_countries <- head(countries_ordered, countries_n)$Country

# Get top N botnets as a selection for this visualisation
botnet_stats <- count(spamhaus, c("Diagnostic"))
botnets_ordered <- botnet_stats[order(-botnet_stats$freq),]
top_n_botnets <- head(botnets_ordered, botnets_n)$Diagnostic

frequencies_top_n <- frequencies[frequencies$Diagnostic %in% top_n_botnets & frequencies$Country %in% top_n_countries,]
frequencies_top_n <- frequencies_top_n[order(frequencies_top_n$Country, -frequencies_top_n$freq),]


plot_freq <- (
  ggplot(frequencies_top_n, aes(Country, freq, fill = factor(x = Diagnostic, levels = top_n_botnets))) 
  + geom_bar(position = "fill", stat = "identity") 
  + scale_y_continuous(label = percent)
  + ggtitle(paste0("Infections between top ", botnets_n, " botnets in ", countries_n , " countries (%)"), subtitle = "Botnets ordered by total size (descending)")
  + labs(y="Infections (%)", fill = "Botnet")
  + theme_few()
  + scale_fill_manual(
    values=c(
      "#3366CC", "#DC3912", "#FF9900", "#109618", "#990099", "#0099C6", "#DD4477", "#66AA00", "#B82E2E", "#316395",
      "#994499", "#22AA99", "#AAAA11", "#6633CC", "#E67300", "#8B0707", "#651067", "#329262", "#5574A6", "#3B3EAC"
    ) # TODO: Add more colours if someone feels like it
  )
)

print(plot_freq)
