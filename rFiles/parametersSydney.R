
source("SydneyData.R")
source("mitigation.R")

parameters = list(
    days = 540, # days for analysis
    ticksPerDay = 4, # number of ticks used for each day

    ## Mitigation over time. M must be the length of t
    ##M = c(seq(from = 1, to = 0.6, length.out = 60), rep(0.6, length(t) - 60)),
    ##M = approxfun(c(0, 60, 760), c(1, 0.6, 0.6)),
    M = approxfun(c(0, 29, 60, 760), c(1, 1, 0.6, 0.6)),
    R0 = 2.4, # average number of secondary infections
    epsilon = 0.1, # effect of seasonal variation
    tmax = 90, # day of year of peak transmission from day 1
    
    tl = 6, # days from infection to infectionness
    ti = 4, # days from infection to recover or ill
    th = 5, # hospital days (from ill to recover or critical)
    tc = 9, # days from critical to die or stable
    
    age = list(
        age0 = list(
            zetaa = 1, # degree of isolation from rest of population
                       # (0 full isolation, 1 no isolation)
            ma = 0.99, # fraction of infections to recovered (not hospital)
            fa = 0.3, # fraction of critical to fatal infections
            ca = 0.05  # fraction of hospital to critical infections
            ),
        age1 = list(
            zetaa = 1,
            ma = 0.97,
            fa = 0.3,
            ca = 0.1
            ),
        age2 = list(
            zetaa = 1,
            ma = 0.97,
            fa = 0.3,
            ca = 0.1
            ),
        age3 = list(
            zetaa = 1,
            ma = 0.97,
            fa = 0.3,
            ca = 0.15
            ),
        age4 = list(
            zetaa = 1,
            ma = 0.94,
            fa = 0.3,
            ca = 0.2
            ),
        age5 = list(
            zetaa = 1,
            ma = 0.9,
            fa = 0.4,
            ca = 0.25
            ),
        age6 = list(
            zetaa = 1,
            ma = 0.75,
            fa = 0.4,
            ca = 0.35
            ),
        age7 = list(
            zetaa = 1,
            ma = 0.65,
            fa = 0.5,
            ca = 0.45
            ),
        age8 = list(
            zetaa = 1,
            ma = 0.5,
            fa = 0.5,
            ca = 0.55
            )
        )
    )

## the initial numbers should be counts of the population
## using numbers from https://www1.health.gov.au/internet/main/publishing.nsf/Content/1D03BCB527F40C8BCA258503000302EB/$File/covid_19_australia_epidemiology_report_7_reporting_week_ending_19_00_aedt_14_march_2020.pdf
## numbers halved to convert Australian data to Sydney.

initCount = c(
    # age group 0-9
    S0 = sydneyPopulationAge2020["age0"] - 2/2,
    E0 = 0,
    I0 = 0,
    H0 = 2/2,
    C0 = 0,
    R0 = 0,
    D0 = 0,
    # age group 10-19
    S1 = sydneyPopulationAge2020["age1"] - 3*4/2 - 4/2 - 3/2,
    E1 = 3*4/2,
    I1 = 4/2,
    H1 = 3/2,
    C1 = 0,
    R1 = 0,
    D1 = 0,
    # age group 20-29
    S2 = sydneyPopulationAge2020["age2"] - 3*13/2 - 26/2 - 10/2,
    E2 = 3*13/2,
    I2 = 26/2,
    H2 = 10/2,
    C2 = 0,
    R2 = 0,
    D2 = 0,
    # age group 30-39
    S3 = sydneyPopulationAge2020["age3"] - 3*22/2 - 22/2 - 18/2,
    E3 = 3*22/2,
    I3 = 22/2,
    H3 = 18/2,
    C3 = 0,
    R3 = 0,
    D3 = 0,
    # age group 40-49
    S4 = sydneyPopulationAge2020["age4"] - 3*24/2 - 24/2 - 10/2,
    E4 = 3*24/2,
    I4 = 24/2,
    H4 = 10/2,
    C4 = 0,
    R4 = 0,
    D4 = 0,
    # age group 50-59
    S5 = sydneyPopulationAge2020["age5"] - 3*31/2 - 31/2 - 14/2,
    E5 = 3*31/2,
    I5 = 31/2,
    H5 = 14/2,
    C5 = 0,
    R5 = 0,
    D5 = 0,
    # age group 60-69
    S6 = sydneyPopulationAge2020["age6"] - 3*25/2 - 25/2 - 14/2,
    E6 = 3*25/2,
    I6 = 25/2,
    H6 = 14/2,
    C6 = 0,
    R6 = 0,
    D6 = 0,
    # age group 70-79
    S7 = sydneyPopulationAge2020["age7"] - 3*12/2 - 12/2 - 4/2,
    E7 = 3*12/2,
    I7 = 12/2,
    H7 = 4/2,
    C7 = 0,
    R7 = 0,
    D7 = 0,
    # age group 80+
    S8 = sydneyPopulationAge2020["age8"] - 3*1/2 - 1/2 - 5/2,
    E8 = 3*1/2,
    I8 = 1/2,
    H8 = 5/2,
    C8 = 0,
    R8 = 0,
    D8 = 0
    )

# number of ticks for analysis, starting from init
t = seq(from = 0, to = parameters$days, by = 1/parameters$ticksPerDay) 
d = as.Date(t, origin = "2020/03/14") # use dates instead of day counts.
