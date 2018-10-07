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

# Plot likelihood
dailyInfections <- count(spamhausVN, c("Date"))
dailyInfectionsMax <- max(dailyInfections$freq) * 365

likelihoodDist <- fitdist(dailyInfections$freq, "norm")
likelihoodVN = data.frame()[1:ceiling((dailyInfectionsMax + 1) / 100), ];
likelihoodVN$infections = seq(from=0, to=dailyInfectionsMax, by=100)
likelihoodVN$density <- dnorm(likelihoodVN$infections, mean=likelihoodDist$sd[["mean"]] * 365, sd=likelihoodDist$sd[["sd"]] * 365)
likelihoodVN <- likelihoodVN[(likelihoodVN$density > 1e-10),]

plot(likelihoodVN$infections,
	 likelihoodVN$density,
	 type="l",
	 main="Expected number of infected machines per year",
	 xlab="Number of infected machines",
	 ylab="Density")
