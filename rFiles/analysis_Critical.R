#!/usr/bin/R
# Laurence Park (2020)
#

##source("parametersSydney.R")
#source("parametersWeb.R")
##source("parametersDebug.R")
#source("parametersImperiaReport.R")
#source("epiModel_SEIHCRD.R")

source("parametersImperiaReportSEICHORD.R")
source("epiModel_SEICHORD.R")

#solCounts = lsoda(initCount, t, seihcrd_ode, parameters, verbose = TRUE)
##solCounts = euler(initCount, t, seihcrd_ode, parameters)
##solCounts = generateCurves(initCount, parameters, t)
#solComb = computeCombinedAge(solCounts)


##-----------------------------------------------------
## Number of ICU beds needed.

criticalForR0 = function(R0, initCount, t, parameters) {

    ##initProp = initCount/populationSize
    
    parameters$R0 = R0    

    ##parameters$ticksPerDay = 4
    ##solCounts = euler(initCount, t, seihcrd_ode, parameters)

    solCounts = lsoda(initCount, t, seihcrd_ode, parameters)

    ##solCounts = rk4(initCount, t, seihcrd_ode, parameters)

    solComb = computeCombinedAge(solCounts)
    return(solComb$C + solComb$O)
}

## find the point where the curve crosses the threshold of 800
crossThresholdPoint = function(Cset, d) {
    which(Cset > 800)[1]
}

criticalPlot = function(Cset, R0set, t, d, main, logy = "") {
    
    plot(1:length(t), Cset[[length(Cset)]], type = "l", ylab = "Count", xlab = "",
         log = logy, main = main,
         xaxt = "n",
         ylim = c(1, max(sapply(Cset, max))))
    datePos = seq(from = 1, to = length(t), by = 90)
    axis(side=1, at=datePos, labels=strftime(d[datePos], format="%d-%m-%Y"),
         cex.axis=0.8, las = 2) 
    for (a in 1:length(Cset)) {
        lines(1:length(t), Cset[[a]], col = a)
    }
    abline(h = 800, lty = 3)
    abline(v = crossThresh, lty = 3)
    text(crossThresh-10,2,strftime(d[crossThresh], format="%d-%m-%Y"),
         srt=90, cex = 0.8, col = "#000000") 
    legend("topright", paste("R0 =", rev(R0set)), col = length(Cset):1, lty = 1)

}


pdf("epiSEIHCRD_CriticalR0.pdf", width = 16, height = 8)
par(mfrow = c(1,2))

parameters$M = mitigationFunction("moderate2")
R0set = seq(from = 1.95, to = 2.95, by = 0.2)
Cset = lapply(R0set, criticalForR0, initCount, t, parameters)
crossThresh = sapply(Cset, crossThresholdPoint, d)

criticalPlot(Cset, R0set, t, d, main = "Critical Count for given R0 (Moderate Mitigation)", logy = "")

parameters$M = mitigationFunction("strong2")
R0set = seq(from = 1.95, to = 2.95, by = 0.2)
Cset = lapply(R0set, criticalForR0, initCount, t, parameters)
crossThresh = sapply(Cset, crossThresholdPoint, d)

criticalPlot(Cset, R0set, t, d, main = "Critical Count for given R0 (Strong Mitigation)", logy = "")

dev.off()







