# Run this after running `likelihood-distribution` and `impact-distribution`

risk <- sample(impactVN$cost, 100000, prob=impactVN$density, replace=TRUE) * sample(likelihoodVN$infections, 100000, prob=likelihoodVN$density, replace=TRUE)
plot(density(risk),
	 main="Expected risk of infection",
	 xlab="Cost in million $",
	 ylab="Density")
