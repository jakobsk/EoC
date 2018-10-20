library(plyr)
library(car)

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
# spamhaus <- spamhaus[(startsWith(spamhaus$Diagnostic, "BOT")),]
spamhaus <- spamhaus[(spamhaus$Country != "??"),]

## Computers per Capita (CpC)
cpc <- read.csv("cpc.csv")
cpc$Computers.per.Capita <- fton(cpc$Computers.per.Capita)

## Ratio of Computer Science Papers (CSPR)
cspr <- read.csv("cspr.csv")
cspr$Papers <- fton(cspr$Papers)
cspr$Computer.Science.papers <- fton(cspr$Computer.Science.papers)
cspr$Computer.Science.papers.ratio <- cspr$Papers / cspr$Computer.Science.papers
cspr$Papers <- NULL
cspr$Computer.Science.papers <- NULL

## Global Cybersecurity Index (GCI)
gci <- read.csv("gci.csv")
gci$Global.Cybersecurity.Index <- fton(gci$Global.Cybersecurity.Index)

## GDP per Capita (GDPpC)
gdppc <- read.csv("gdppc.csv")
gdppc$GDP.per.Capita <- fton(gdppc$GDP.per.Capita)

## ICT Development Index (IDI)
idi <- read.csv("idi.csv")
idi$ICT.Development.Index <- fton(idi$ICT.Development.Index)

## Technology Index (TechI)
techi <- read.csv("techi.csv")
techi$Technology.Index <- fton(techi$Technology.Index)

## Terrorism Index (TerI)
teri <- read.csv("teri.csv")
teri$Terrorism.Index <- fton(teri$Terrorism.Index)

## Youth Unemployment Rate (YUR)
yur <- read.csv("yur.csv")
yur$Youth.Unemployment.Rate <- fton(yur$Youth.Unemployment.Rate)

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
countries <- merge(countries, cpc, by="Country")
countries <- merge(countries, cspr, by="Country")
countries <- merge(countries, gdppc, by="Country")
countries <- merge(countries, idi, by="Country")
countries <- merge(countries, gci, by="Country")
countries <- merge(countries, techi, by="Country")
countries <- merge(countries, teri, by="Country")
countries <- merge(countries, yur, by="Country")

countries <- merge(countries, infections, by="Symbol")

# Derive
countries$InfectionRate <- countries$InfectionCount / countries$InternetUsers
countries$InfectionCount <- NULL

# Retain only relevant columns
countries <- countries[,c(
	"Computers.per.Capita", "Computer.Science.Paper.Ratio", "Global.Cybersecurity.Index", "GDP.per.Capita", "ICT.Development.Index",
	"Technology.Index", "Terrorism.Index", "Youth.Unemployment.Rate")]

scatterplotMatrix(countries)
