# Run this after running `likelihood-distribution` and `impact-distribution`

risk <- sample(impactVN$x, 100000, prob=impactVN$y, replace=TRUE) * sample(likelihoodVN$x, 100000, prob=likelihoodVN$y, replace=TRUE)
risk <- risk[(risk >= 0)]

plot(density(risk),
	 main="Expected risk of infection",
	 xlab="Cost in million $",
	 ylab="Density")
