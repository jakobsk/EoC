library(plyr)

# Import
spamhaus <- read.csv("spamhaus.csv")

# Preprocess
spamhaus$Diagnostic <- as.character(spamhaus$Diagnostic)
spamhaus <- spamhaus[(startsWith(spamhaus$Diagnostic, "BOT")),]
spamhaus <- spamhaus[(spamhaus$ASN != "AS?"),]

# IPs per allocation
ipsPerAllocation <- count(spamhaus, c("Country", "ASN", "Allocation"))
colnames(ipsPerAllocation)[4] <- "IPs"

# Allocation block size
ipsPerAllocation$AllocationSize <- regmatches(ipsPerAllocation$Allocation, regexpr("/.*", ipsPerAllocation$Allocation))
ipsPerAllocation$AllocationSize <- regmatches(ipsPerAllocation$AllocationSize, regexpr("[^/]+", ipsPerAllocation$AllocationSize))
ipsPerAllocation$AllocationSize <- as.numeric(as.character(ipsPerAllocation$AllocationSize))
ipsPerAllocation$AllocationSize <- 2^(32 - ipsPerAllocation$AllocationSize)
ipsPerAllocation$Allocation <- NULL

# Sum size and IPs per ASN
asnRates <- aggregate(. ~ Country+ASN, ipsPerAllocation, sum)
asnRates$ASN <- NULL

# Plot
plot(asnRates$AllocationSize, asnRates$IPs, xlab="Number of allocations", ylab="Amount of infections", main="AS infections by size", log="xy")
