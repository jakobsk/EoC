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
daily <- count(spamhausVN, c("Date"))
plot(density(daily$freq))
