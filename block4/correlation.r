library(plyr)
library(car)


# Define custom utility functions
fton <- function(f) suppressWarnings(as.numeric(as.character(f)))
cor2 <- function(a, b) c(cor(a, b, method="p"), cor(a, b, method="k"), cor(a, b, method="s"))
sym_diff <- function(a, b) setdiff(union(a, b), intersect(a, b))
set_diff <- function(a, b) setdiff(union(a, b), b)



# Read baseline datasets
## Spamhaus
spamhaus <- read.csv("spamhaus.csv")

spamhaus$Diagnostic <- as.character(spamhaus$Diagnostic)
spamhaus <- spamhaus[(complete.cases(spamhaus)),]
spamhaus <- spamhaus[(spamhaus$Diagnostic == "BOT gamut"),]
spamhaus <- spamhaus[(spamhaus$Country != "??"),]

## Countries
countries <- read.csv("countries.csv")
countries$Size <- fton(countries$Size)
countries$Population <- fton(countries$Population)
countries$InternetUsers <- fton(countries$InternetUsers)

countries <- countries[(complete.cases(countries)),]
countries <- countries[(countries$Symbol != "--"),]

## Derive infection rate
infections <- count(spamhaus, "Country")
colnames(infections) <- c("Symbol", "InfectionCount")

countries <- merge(countries, infections, by="Symbol")
countries$InfectionRate <- countries$InfectionCount / countries$InternetUsers

countries <- countries[, c("Symbol", "Country", "InfectionRate")]



# Read factor datasets
## Computers per Capita (CpC)
cpc <- read.csv("cpc.csv")
cpc$Computers.per.Capita <- fton(cpc$Computers.per.Capita)

## Computer Science Paper Ratio (CSPR)
cspr <- read.csv("cspr.csv")
cspr$Papers <- fton(cspr$Papers)
cspr$Computer.Science.Papers <- fton(cspr$Computer.Science.Papers)
cspr$Computer.Science.Paper.Ratio <- cspr$Papers / cspr$Computer.Science.Papers
cspr <- cspr[, c("Country", "Computer.Science.Paper.Ratio")]

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



# Merge datasets
factors <- countries
# factors <- merge(factors, cpc, by="Country")
factors <- merge(factors, cspr, by="Country")
# factors <- merge(factors, gdppc, by="Country")
factors <- merge(factors, idi, by="Country")
# factors <- merge(factors, gci, by="Country")
# factors <- merge(factors, techi, by="Country")
# factors <- merge(factors, teri, by="Country")
factors <- merge(factors, yur, by="Country")

factors$Country <- NULL
factors$Symbol <- NULL



# Analyse
## Correlation
scatterplotMatrix(factors)
factorCor <- cor(factors)

## Linear model
infectionModel <- lm(factors$InfectionRate ~
	# + factors$Computers.per.Capita
	+ factors$Computer.Science.Paper.Ratio
	# + factors$Global.Cybersecurity.Index
	# + factors$GDP.per.Capita
	+ factors$ICT.Development.Index
	# + factors$Technology.Index
	# + factors$Terrorism.Index
	+ factors$Youth.Unemployment.Rate
	, factors
)
summary(infectionModel)
