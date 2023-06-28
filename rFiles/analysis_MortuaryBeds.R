#!/usr/bin/R
# Laurence Park (2020)
#

##source("parametersSydney.R")
#source("parametersWeb.R")
#source("parametersDebug.R")
#source("parametersImperiaReport.R")
#source("epiModel_SEIHCRD.R")

source("parametersImperiaReportSEICHORD.R")
source("epiModel_SEICHORD.R")

#solCounts = lsoda(initCount, t, seihcrd_ode, parameters)
##solCounts = generateCurves(initCount, parameters, t)
#solComb = computeCombinedAge(solCounts)


##-----------------------------------------------------
## Number of mortuary beds needed.

## computeMortuaryBedDays = function(mortuaryBedDays, solComb) {
##     ##mortuaryBedDays = 3

##     M = nrow(solComb) # number of days
    
##     mortuaryBedsRequired = rep(0, M)
##     diffD = diff(solComb$D)

##     for (a in 1:mortuaryBedDays) {
##         mortuaryBedsRequired = mortuaryBedsRequired + c(rep(0, a), diffD[1:(M - a)])
##     }
##     return(mortuaryBedsRequired)
## }


computeMortuaryBedDays = function(D, parameters, mortuaryBedDays = 3) {
    ##mortuaryBedDays = 3
    ## make sure D counts are for each day
    
    M = length(D) # number of days

    # need to sum one time point for each day.
    ## window = seq(from = 1, by = parameters$ticksPerDay, length.out = mortuaryBedDays)

    mortuaryBedsRequired = rep(0, M)
    diffD = diff(D)

    ##for (a in 1:mortuaryBedDays) {
    for (a in 1:mortuaryBedDays) {
        mortuaryBedsRequired = mortuaryBedsRequired + c(rep(0, a), diffD[1:(M - a)])
    }
    return(mortuaryBedsRequired)
}



deceasedForR0 = function(R0, initCount, t, parameters) {

    ##initProp = initCount/populationSize
    
    parameters$R0 = R0    
    solCounts = lsoda(initCount, t, seihcrd_ode, parameters)
    ##sol = euler(initProp, t, seihcrd_ode, parameters)
    ##solCounts = computeCounts(sol, populationSize)
    solComb = computeCombinedAge(solCounts)
    return(solComb$D)
}


Ddays = function(D, t) {
    return(tapply(D, floor(t), mean))
}

mbPlot = function(MBset, R0set, parameters, t, d, main, logy = "") {

    plot(0:parameters$days, MBset[[1]], type = "l", ylab = "Count", xlab = "",
         log = "", main = main,
         xaxt = "n",
         ylim = c(1, max(sapply(MBset, max))))
    datePos = seq(from = 1, to = length(t), by = 90)
    ## fix dates!
    axis(side=1, at=datePos, labels=strftime(d[datePos], format="%d-%m-%Y"),
         cex.axis=0.8, las = 2) 
    for (a in 1:length(MBset)) {
        lines(0:parameters$days, MBset[[a]], col = a)
    }
    legend("topright", paste("R0 =", rev(R0set)), col = length(MBset):1, lty = 1)

}

pdf("epiSEIHCRD_MortuaryBedsR0.pdf", width = 16, height = 8)
par(mfrow = c(1,2))

parameters$M = mitigationFunction("moderate2")
##N = sum(initCount)
R0set = seq(from = 1.95, to = 2.95, by = 0.2)
Dset = lapply(R0set, deceasedForR0, initCount, t, parameters)
# convert time scale to days
DdaysSet = lapply(Dset, Ddays, t)
MBset = lapply(DdaysSet, computeMortuaryBedDays, parameters)
mbPlot(MBset, R0set, parameters, t, d, main = "Mortuary Beds Required for given R0 (Moderate Mitigation)", logy = "")


parameters$M = mitigationFunction("strong2")
R0set = seq(from = 1.95, to = 2.95, by = 0.2)
Dset = lapply(R0set, deceasedForR0, initCount, t, parameters)
# convert time scale to days
DdaysSet = lapply(Dset, Ddays, t)
MBset = lapply(DdaysSet, computeMortuaryBedDays, parameters)
mbPlot(MBset, R0set, parameters, t, d, main = "Mortuary Beds Required for given R0 (Strong Mitigation)", logy = "")

dev.off()







if (FALSE) {

abline(h = 800, lty = 3)
abline(v = crossThresh, lty = 3)
text(crossThresh-10,2,strftime(d[crossThresh], format="%d-%m-%Y"), srt=90, cex = 0.8,
     col = "#000000") 

plot(computeMortuaryBedDays(Dset[[6]]))

crossThresh = sapply(Cset, crossThresholdPoint, d)

deceased = lapply(1:5, deceasedForR0, solComb)
plot(t, mortuaryBedsRequired[[5]], type = "l", xlab = "Days",
     ylab = "Mortuary Beds Required", col = 5)
lines(t, mortuaryBedsRequired[[4]], col = 4)
lines(t, mortuaryBedsRequired[[3]], col = 3)
lines(t, mortuaryBedsRequired[[2]], col = 2)
lines(t, mortuaryBedsRequired[[1]], col = 1)
legend("topright", paste("Bed days:", 5:1), col = 5:1, lty = 1)

}
