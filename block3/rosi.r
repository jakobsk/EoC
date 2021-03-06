# Run this after running `risk`

riskMitigated <- 0.996
solutionCost <- 56

rosi <- risk * riskMitigated
rosi <- rosi - solutionCost
rosi <- rosi / solutionCost

plot(ecdf(rosi),
	 main="Cumulative probability of ROSI",
	 xlab="ROSI",
	 ylab="Cumulative probability")
abline(v=mean(rosi), col="lightgray")
