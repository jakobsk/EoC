# Import
spamhaus <- read.csv("spamhaus.csv")
countries <- read.csv("countries.csv")

# Preprocess
spamhaus$Diagnostic <- as.character(spamhaus$Diagnostic)
spamhaus <- spamhaus[(startsWith(spamhaus$Diagnostic, "BOT")),]
spamhaus <- spamhaus[(spamhaus$Country != "" & spamhaus$Country != "??"),]

countries <- countries[c("Symbol", "Internet.users")]
colnames(countries) <- c("Country", "InternetUsers")
countries <- countries[(countries$Country != "--" & countries$InternetUsers != "n/a"),]
countries$InternetUsers <- as.numeric(countries$InternetUsers)

# Infections per country
infectionsPerCountry <- count(spamhaus, c("Country"))
colnames(infectionsPerCountry)[2] <- "Infections"
infectionsPerCountry$Infections <- as.numeric(infectionsPerCountry$Infections)
infectionsPerCountry <- merge(infectionsPerCountry, countries, by="Country")

# Infection rate
infectionsPerCountry$InfectionRate <- infectionsPerCountry$Infections / infectionsPerCountry$InternetUsers
infectionsPerCountry$Infections <- NULL
infectionsPerCountry$InternetUsers <- NULL

# Plot
## TODO
