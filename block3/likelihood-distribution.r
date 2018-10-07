library(fitdistrplus)
library(plyr)

# Import
spamhaus <- read.csv("spamhaus.csv")

# Preprocess
spamhaus$Diagnostic <- as.character(spamhaus$Diagnostic)
spamhaus <- spamhaus[(complete.cases(spamhaus)),]
spamhaus <- spamhaus[(spamhaus$Diagnostic == "BOT gamut"),]

spamhausVN <- spamhaus[(spamhaus$Country == "VN"),]
spamhausVN$Date <- as.Date(as.POSIXct(as.integer(spamhausVN$time_t), origin="1970-01-01"))

# Plot normal distribution
dailyInfections <- count(spamhausVN, c("Date"))
plot(density(dailyInfections$freq),
	 main="Expected number of infected machines per day",
	 xlab="Number of infected machines",
	 ylab="Density")

likelihoodDist <- fitdist(dailyInfections$freq, "norm")
likelihoodDist$sd <- likelihoodDist$sd * 365 # Days per year
likelihoodDist$sd <- likelihoodDist$sd / 64000000 # Number of machines

likelihoodVN = data.frame()[0:(ceiling(0.1 / 0.000001)), ];
likelihoodVN$infections = seq(from=0, to=0.1, by=0.000001)
likelihoodVN$density <- dnorm(likelihoodVN$infections, mean=likelihoodDist$sd[["mean"]], sd=likelihoodDist$sd[["sd"]])

plot(likelihoodVN$infections,
	 likelihoodVN$density,
	 type="l",
	 main="Expected ratio of newly infected machines per year",
	 xlab="Ratio of newly infected machines",
	 ylab="Density")
