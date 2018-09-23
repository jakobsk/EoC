# Import/preprocess
spamhaus <- read.csv("spamhaus.csv")
spamhaus$Diagnostic <- as.character(spamhaus$Diagnostic)
spamhaus <- spamhaus[(startsWith(spamhaus$Diagnostic, "BOT")),]
spamhaus <- spamhaus[(spamhaus$Country != "" & spamhaus$Country != "??"),]

countries <- read.csv("countries.csv")
countries <- countries[c("Symbol", "InternetUsers")]
colnames(countries)[1] <- "Country"
countries <- countries[(countries$Country != "--" & countries$InternetUsers != "n/a"),]
countries$InternetUsers <- as.numeric(as.character(countries$InternetUsers))
countries <- countries[(countries$InternetUsers > 1000),]

# Infections per country
infectionsPerCountry <- count(spamhaus, c("Country"))
colnames(infectionsPerCountry)[2] <- "Infections"
infectionsPerCountry$Infections <- as.numeric(as.character(infectionsPerCountry$Infections))
infectionsPerCountry <- merge(infectionsPerCountry, countries, by="Country")

# Infection rate
infectionsPerCountry$InfectionRate <- infectionsPerCountry$Infections / infectionsPerCountry$InternetUsers
infectionsPerCountry$Infections <- NULL
infectionsPerCountry$InternetUsers <- NULL

# Plot
## TODO
