# Makes plot of the distribution of how much an gamut infection is going to cost the average person 
impactMean = 11
impactSd = 2
millionUsers = 64

impactPerson = data.frame()[1:89, ]
impactPerson$cost = seq(from=0, to=22, by=0.25);
impactPerson$density = dnorm(impactPerson$cost, mean=impactMean, sd=impactSd);
plot(impactPerson$cost, impactPerson$density, type="l", ylab = "Density", xlab = "Cost in $", main="Distribution of costs being on a blocklist")

# Same plot, but now applied to the 64M internet users in vietnam
impactVN = data.frame()[1:1201, ];
impactVN$cost = seq(from=0, to=1200, by=1);
impactVN$density = dnorm(impactVN$cost, mean=(impactMean * millionUsers), sd=(impactSd * millionUsers));
plot(impactVN$cost, impactVN$density, type="l", ylab = "Density", xlab = "Cost in million $", main="Impact distribution for Vietnam")
