library(plyr)

fton <- function(f) suppressWarnings(as.numeric(as.character(f)))
cor2 <- function(a, b) c(cor(a, b, method="p"), cor(a, b, method="k"), cor(a, b, method="s"))

# Preprocess
## Spamhaus
spamhaus <- read.csv("spamhaus")

spamhaus$Diagnostic <- as.character(spamhaus$Diagnostic)
spamhaus <- spamhaus[(complete.cases(spamhaus)),]
spamhaus <- spamhaus[(spamhaus$Diagnostic == "BOT gamut"),]
spamhaus <- spamhaus[(spamhaus$Country != "??"),]

## GDP per capita
gdppc <- read.csv("gdppc.csv")
gdppc$GDP.per.capita <- fton(gdppc$GDP.per.capita)

## Countries
countries <- read.csv("countries.csv")
countries$Size <- fton(countries$Size)
countries$Population <- fton(countries$Population)
countries$InternetUsers <- fton(countries$InternetUsers)

countries$Date <- NULL
countries$InternetPenetration <- NULL

countries <- countries[(complete.cases(countries)),]
countries <- countries[(countries$Symbol != "--"),]


# Calculate number of infections per country
infections <- count(spamhaus, "Country")
colnames(infections) <- c("Symbol", "InfectionCount")


# Merge datasets
countries <- merge(countries, gdppc, by="Country")
countries <- merge(countries, infections, by="Symbol")

# Derive
countries$InfectionRate <- countries$InfectionCount / countries$InternetUsers
countries$InfectionCount <- NULL


# Find correlation
cor <- cor2(countries$InfectionRate, countries$GDP.per.capita)
