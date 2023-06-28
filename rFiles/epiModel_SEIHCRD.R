#!/usr/bin/R
# SEIHCRD Model as described in https://github.com/neherlab/covid19_scenarios/
# Laurence Park (2020)
#
# Note that the model parameters and initial values must be set for each
# specific case.



sigmoid = function(x, a = 1) {
    return(1/(1 + exp(-a*x)))
}


library("deSolve")

##source("parametersSydney.R")
#source("parametersWeb.R")


# Function to return derivatives of SEIHCRD model for given age group
seihcrd_age_ode = function(t, Y, par, ageGroup) {

    ## select proportions based on age
    S = Y[1 + 7*ageGroup]
    E = Y[2 + 7*ageGroup]
    I = Y[3 + 7*ageGroup]
    H = Y[4 + 7*ageGroup]
    C = Y[5 + 7*ageGroup]
    R = Y[6 + 7*ageGroup]
    D = Y[7 + 7*ageGroup]

    Iall = sum(Y[3 + 7*(0:8)]) # the set of I across all ages

    ## need ageGroup + 1, since ageGroup starts at 0
    beta = par$R0 * par$age[[ageGroup + 1]]$zetaa * par$M(t) *
        (1 + par$epsilon * cos(2 * pi * (t - par$tmax)))/par$ti


    N = sum(Y);
    
    ## modify fa to be dependent on the number of ICU beds
    Csum = sum(Y[5 + 7*(0:ageGroup)]) # the set of C up to current age
    fam = par$age[[ageGroup + 1]]$fa
    fa = par$age[[ageGroup + 1]]$fa

    ## multiply risk, then convert to probability
    far = par$ICUbedsFaFactor*fa/(1 - fa)
    far = far/(far + 1)
    
    if (Csum > par$ICUbeds) {
        ## double rate for those counts over bed threshold
        fam = (par$ICUbeds*fa + (Csum - par$ICUbeds)*far)/Csum
    }

    dYdt = vector(length = 7)

    dYdt[1] = -beta*S*Iall/N
    dYdt[2] = beta*S*Iall/N - E/par$tl
    dYdt[3] = E/par$tl - I/par$ti
    dYdt[4] = (1 - par$age[[ageGroup + 1]]$ma) * I/par$ti +
        (1 - fam) * C/par$tc - H/par$th
    dYdt[5] = par$age[[ageGroup + 1]]$ca * H/par$th - C/par$tc
    dYdt[6] = par$age[[ageGroup + 1]]$ma * I/par$ti +
        (1 - par$age[[ageGroup + 1]]$ca) * H/par$th
    dYdt[7] = fam * C/par$tc
    
  return(dYdt)
}

seihcrd_ode = function(t, Y, par) {

    ## compute gradients for all age groups
    dYdt0 = seihcrd_age_ode(t, Y, par, ageGroup = 0)
    dYdt1 = seihcrd_age_ode(t, Y, par, ageGroup = 1)
    dYdt2 = seihcrd_age_ode(t, Y, par, ageGroup = 2)
    dYdt3 = seihcrd_age_ode(t, Y, par, ageGroup = 3)
    dYdt4 = seihcrd_age_ode(t, Y, par, ageGroup = 4)
    dYdt5 = seihcrd_age_ode(t, Y, par, ageGroup = 5)
    dYdt6 = seihcrd_age_ode(t, Y, par, ageGroup = 6)
    dYdt7 = seihcrd_age_ode(t, Y, par, ageGroup = 7)
    dYdt8 = seihcrd_age_ode(t, Y, par, ageGroup = 8)
  
    return(list(c(dYdt0, dYdt1, dYdt2, dYdt3, dYdt4, dYdt5, dYdt6, dYdt7, dYdt8)))
}

computeCounts = function(sol, population) {
    solCount = sol
    solCount[,-1] = solCount[,-1] * population
    return(solCount)
}

## compute counts with marginalised age
computeCombinedAge = function(solCount) {
    solComb = data.frame(
        t = solCount[,1],
        S = rowSums(solCount[, 2 + 0:8*7]),
        E = rowSums(solCount[, 3 + 0:8*7]),
        I = rowSums(solCount[, 4 + 0:8*7]),
        H = rowSums(solCount[, 5 + 0:8*7]),
        C = rowSums(solCount[, 6 + 0:8*7]),
        R = rowSums(solCount[, 7 + 0:8*7]),
        D = rowSums(solCount[, 8 + 0:8*7])
        )
    return(solComb)
}


generateCurves = function(initCount, parameters, t) {
    #N = sum(initCount)
    #initProp = initCount/N
    ##initCondProp = initCount/rep(sydneyPopulationAge2020, each = 7)

    ## solve the set of equations
    ##sol = lsoda(initProp, t, seihcrd_ode, parameters)
    sol = lsoda(initCount, t, seihcrd_ode, parameters)
    ##sol = euler(initProp, t, seihcrd_ode, parameters)

    #solCounts = computeCounts(sol, sum(initCount))
    return(sol)
}

#solCounts = generateCurves(initCount, parameters)
#solComb = computeCombinedAge(solCounts)


#write.csv(solComb, file = "epiSEIHCRD_combAge.csv", row.names = FALSE)





