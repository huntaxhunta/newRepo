#!/usr/bin/R
# Laurence Park (2020)
#

##source("parametersSydney.R")
#source("parametersWeb.R")
#source("parametersDebug.R")
#source("epiModel_SEIHCRD.R")

source("parametersImperiaReportSEICHORD.R")
source("epiModel_SEICHORD.R")

parameters$M = mitigationFunction("moderate2")
##solCounts = generateCurves(initCount, parameters)
solCounts = lsoda(initCount, t, seihcrd_ode, parameters)
solComb = computeCombinedAge(solCounts)

ageGroupNames = paste(seq(from = 0, by = 10, to = 80), "-", seq(from = 9, by = 10, to = 89))
ageGroupNames[9] = "80+"

plotAgeGroup = function(solCount, ageGroup, ageGroupNames, parameters) {

    t = solCount[,1]
    plot(d, solCount[,2 + ageGroup*8], type="l", col="blue",
         ylim = c(1, max(solCount[,2:9 + ageGroup*8])),
         ylab="Population", xlab = "Days", log = "y",
         main = paste("Age range", ageGroupNames[ageGroup+1]))
    lines(d, solCount[,3 + ageGroup*8], col="orange")
    lines(d, solCount[,4 + ageGroup*8], col="red")
    lines(d, solCount[,5 + ageGroup*8], col="brown")
    lines(d, solCount[,6 + ageGroup*8], col="green")
    lines(d, solCount[,7 + ageGroup*8], col="purple")
    lines(d, solCount[,8 + ageGroup*8], col="black")
    lines(d, solCount[,9 + ageGroup*8], col="yellow")  
    abline(h = parameters$ICUbeds, lty = 3)
    legend("topright", legend=c("S","E","I","H","C","O","R","D"),
           col=c("blue","orange","red","brown","green","yellow","purple","black"),
           lty = 1, cex = 0.8)
}

plotCombined = function(solComb, populations, ...) {

    plot(solComb$t, solComb$S, type="l", col="blue",
         ylim = c(1, max(solComb[,-1])),
         ylab="Population", xlab = "Days",
         main = "Sydney Population: Combined Ages", ...)
    lines(solComb$t, solComb$E, col="orange")
    lines(solComb$t, solComb$I, col="red")
    lines(solComb$t, solComb$H, col="brown")
    lines(solComb$t, solComb$C, col="green")
    lines(solComb$t, solComb$R, col="purple")
    lines(solComb$t, solComb$D, col="black")
    lines(solComb$t, solComb$O, col="yellow")  
    abline(h = parameters$ICUbeds, lty = 3)
    legend("topright", legend=c("S","E","I","H","C","O","R","D"),
           col=c("blue","orange","red","brown","green","yellow","purple","black"),
           lty = 1, cex = 0.8)
}


## Plot for each age
pdf("epiSEIHCRDlog.pdf", width = 10, height = 10)
par(mfrow = c(3,3))
for (ageGroup in 0:8) {
    plotAgeGroup(solCounts, ageGroup = ageGroup, ageGroupNames, parameters)
}
dev.off()

## Plot for all ages combined
pdf("epiSEICHORD_allAges.pdf", width = 7, height = 5)
par(mfrow = c(1,1))
plotCombined(solComb, sydneyPopulationAge2020, log = "y")
dev.off()
