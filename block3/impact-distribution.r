# Makes plot of the distribution of how much an gamut infection is going to cost the average person 
impactMean = 74
impactSd = 2
millionUsers = 64

impactPerson = density(rnorm(10000, mean=impactMean, sd=impactSd))
plot(impactPerson, type="l", ylab = "Density", xlab = "Cost in $", main="Distribution of costs being on a blocklist")

# Same plot, but now applied to the 64M internet users in vietnam
impactVN = density(rnorm(10000, mean=(impactMean * millionUsers), sd=(impactSd * millionUsers)))
plot(impactVN, type="l", ylab = "Density", xlab = "Cost in million $", main="Impact distribution for Vietnam")
