# Run this after running `risk`

riskMitigated <- 0.99
solutionCost <- 112

rosi <- risk * riskMitigated
rosi <- rosi - solutionCost
rosi <- rosi / solutionCost

plot(ecdf(rosi))
