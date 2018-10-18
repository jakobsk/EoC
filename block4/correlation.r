library(plyr)

fton <- function(f) suppressWarnings(as.numeric(as.character(f)))
cor2 <- function(a, b) c(cor(a, b, method="p"), cor(a, b, method="k"), cor(a, b, method="s"))
sym_diff <- function(a, b) setdiff(union(a, b), intersect(a, b))
set_diff <- function(a, b) setdiff(union(a, b), b)

# Preprocess
## Spamhaus
spamhaus <- read.csv("spamhaus")

spamhaus$Diagnostic <- as.character(spamhaus$Diagnostic)
spamhaus <- spamhaus[(complete.cases(spamhaus)),]
spamhaus <- spamhaus[(spamhaus$Diagnostic == "BOT gamut"),]
spamhaus <- spamhaus[(spamhaus$Country != "??"),]

## Computers per capita
cpp <- read.csv("cpp.csv")
cpp$Computers.per.Capita <- fton(cpp$Computers.per.Capita)

## GDP per capita
gdppc <- read.csv("gdppc.csv")
gdppc$GDP.per.capita <- fton(gdppc$GDP.per.capita)

## Global Cybersecurity Index
gci <- read.csv("gci.csv")
gci$GCI <- fton(gci$GCI)

## IDI
idi <- read.csv("idi.csv")
idi$IDI <- fton(idi$IDI)

## Median income
mi <- read.csv("medianincome.csv")
mi$Median.household.income <- fton(mi$Median.household.income)
mi$Median.per.capita.income <- fton(mi$Median.per.capita.income)

## Papers per country
ppc <- read.csv("ppc.csv")
ppc$Papers <- fton(ppc$Papers)
ppc$Computer.Science.papers <- fton(ppc$Computer.Science.papers)
ppc$Computer.Science.papers.ratio <- ppc$Papers / ppc$Computer.Science.papers
ppc$Papers <- NULL
ppc$Computer.Science.papers <- NULL

## Technology index
ti <- read.csv("techindex.csv")
ti$Technology.Index <- fton(ti$Technology.Index)

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
countries <- merge(countries, cpp, by="Country")
countries <- merge(countries, gdppc, by="Country")
countries <- merge(countries, gci, by="Country")
countries <- merge(countries, idi, by="Country")
countries <- merge(countries, ppc, by="Country")
countries <- merge(countries, ti, by="Country")

countries <- merge(countries, mi, by="Symbol")
countries <- merge(countries, infections, by="Symbol")

# Derive
countries$InfectionRate <- countries$InfectionCount / countries$InternetUsers
countries$InfectionCount <- NULL

# Retain only relevant columns
countries <- countries[,c(
	"Computers.per.Capita", "GDP.per.capita", "GCI", "IDI",
	"Computer.Science.papers.ratio", "Technology.Index", "Median.household.income",
	"Median.per.capita.income", "InfectionRate")]
