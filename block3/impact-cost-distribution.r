# Makes plot of the distribution of how much an gamut infection is going to cost the average person 
x <- seq(from=0, to=22, by=0.25)
dens <- dnorm(x, mean=11, sd=2)
plot(x, dens, type="l", ylab = "Density", xlab = "Cost in $", main="Distribution of costs being on a blocklist")

# Same plot, but now applied to the 64M internet users in vietnam
x <- seq(from=0, to=1200, by=1)
dens <- dnorm(x, mean=704, sd=128)
plot(x, dens, type="l", ylab = "Density", xlab = "Cost in million $", main="Impact distribution for Vietnam")
