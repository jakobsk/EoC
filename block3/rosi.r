# Run this after running `risk`

riskMitigated <- 0.1575
solutionCost <- 112

rosi <- risk * riskMitigated
rosi <- rosi - solutionCost
rosi <- rosi / solutionCost

plot(density(rosi))
