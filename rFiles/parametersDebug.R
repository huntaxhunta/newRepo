
#source("SydneyData.R")
source("mitigation.R")


parameters = list(
    days = 40, # days for analysis
    ticksPerDay = 4, # number of ticks used for each day

    ## Mitigation over time. M must be the length of t
    ##M = c(seq(from = 1, to = 0.6, length.out = 60), rep(0.6, length(t) - 60)),
    ##M = approxfun(c(0, 29, 60, 760), c(1, 1, 0.6, 0.6)),
    ## choose moderate or strong mitigation
    M = mitigationFunction("moderate"),
    ##M = mitigationFunction("strong"),
    ##M = mstrong,

    R0 = 2, # average number of secondary infections
    epsilon = 0, # effect of seasonal variation
    tmax = as.numeric(as.Date("2020/07/01") - as.Date("2020/02/01")), # day of year of peak transmission from day 1

    ICUbeds = 800, # number of ICU beds available
    ICUbedsFaFactor = 1, # multiple for fa when C is over bed limit
    
    tl = 1, # days from infection to infectionness
    ti = 1, # days from infection to recover or ill
    th = 1, # hospital days (from ill to recover or critical)
    tc = 1, # days from critical to die or stable
    
    age = list(
        age0 = list(
            zetaa = 1, # degree of isolation from rest of population
                       # (0 full isolation, 1 no isolation)
            ma = 1, # fraction of infections to recovered (not hospital)
            fa = 0, # fraction of critical to fatal infections
            ca = 0  # fraction of hospital to critical infections
            ),
        age1 = list(
            zetaa = 1,
            ma = 1,
            fa = 0,
            ca = 0
            ),
        age2 = list(
            zetaa = 1,
            ma = 1,
            fa = 0,
            ca = 0
            ),
        age3 = list(
            zetaa = 1,
            ma = 1,
            fa = 0,
            ca = 0
            ),
        age4 = list(
            zetaa = 1,
            ma = 1,
            fa = 0,
            ca = 0
            ),
        age5 = list(
            zetaa = 1,
            ma = 1,
            fa = 0,
            ca = 0
            ),
        age6 = list(
            zetaa = 1,
            ma = 1,
            fa = 0,
            ca = 0
            ),
        age7 = list(
            zetaa = 1,
            ma = 1,
            fa = 0,
            ca = 0
            ),
        age8 = list(
            zetaa = 1,
            ma = 1,
            fa = 0,
            ca = 0
            )
        )
    )

## the initial numbers should be counts of the population
## using numbers from https://www1.health.gov.au/internet/main/publishing.nsf/Content/1D03BCB527F40C8BCA258503000302EB/$File/covid_19_australia_epidemiology_report_7_reporting_week_ending_19_00_aedt_14_march_2020.pdf
## numbers halved to convert Australian data to Sydney.

populationAge = 1000
initCount = c(
    # age group 0-9
    S0 = populationAge,
    E0 = 0,
    I0 = 0,
    H0 = 0,
    C0 = 0,
    R0 = 0,
    D0 = 0,
    # age group 10-19
    S1 = populationAge,
    E1 = 0,
    I1 = 0,
    H1 = 0,
    C1 = 0,
    R1 = 0,
    D1 = 0,
    # age group 20-29
    S2 = populationAge,
    E2 = 0,
    I2 = 0,
    H2 = 0,
    C2 = 0,
    R2 = 0,
    D2 = 0,
    # age group 30-39
    S3 = populationAge,
    E3 = 0,
    I3 = 0,
    H3 = 0,
    C3 = 0,
    R3 = 0,
    D3 = 0,
    # age group 40-49
    S4 = populationAge,
    E4 = 0,
    I4 = 0,
    H4 = 0,
    C4 = 0,
    R4 = 0,
    D4 = 0,
    # age group 50-59
    S5 = populationAge,
    E5 = 35,
    I5 = 15,
    H5 = 0,
    C5 = 0,
    R5 = 0,
    D5 = 0,
    # age group 60-69
    S6 = populationAge,
    E6 = 0,
    I6 = 0,
    H6 = 0,
    C6 = 0,
    R6 = 0,
    D6 = 0,
    # age group 70-79
    S7 = populationAge,
    E7 = 0,
    I7 = 0,
    H7 = 0,
    C7 = 0,
    R7 = 0,
    D7 = 0,
    # age group 80+
    S8 = populationAge,
    E8 = 0,
    I8 = 0,
    H8 = 0,
    C8 = 0,
    R8 = 0,
    D8 = 0
    )

# number of ticks for analysis, starting from init
t = seq(from = 0, to = parameters$days, by = 1/parameters$ticksPerDay) 
d = as.Date(t, origin = "2020/02/01") # use dates instead of day counts.

