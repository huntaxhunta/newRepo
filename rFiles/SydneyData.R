
## https://quickstats.censusdata.abs.gov.au/census_services/getproduct/census/2016/quickstat/1GSYD?opendocument

#sydneyAgeProportions = c(0.128, 0.118, 0.15, 0.155, 0.138, 0.121, 0.094, 0.057, 0.038)

sydneyAgePopulation2016 = c(
310173 + 309236,
280892 + 288362,
340737 + 381451,
392950 + 355460,
340580 + 321762,
305817 + 281558,
242452 + 213531,
158961 + 118061,
85988 + 96022)

sydneyAgeProportions2016 = sydneyAgePopulation2016/sum(sydneyAgePopulation2016)

## https://en.wikipedia.org/wiki/Demographics_of_Sydney
sydneyPopulation2020 = 5500000

## estimate the spread in population using 2016 distribution
sydneyPopulationAge2020 = sydneyAgeProportions2016 * sydneyPopulation2020
names(sydneyPopulationAge2020) = paste("age", 0:8, sep = "")

## https://www1.health.gov.au/internet/main/publishing.nsf/Content/novel_coronavirus_2019_ncov_weekly_epidemiology_reports_australia_2020.htm


sydneyAgeWebDistribution2020 = c(
    0.129764198143019,
    0.12276448002665424,
    0.13237130804202873,
    0.145818153525718,
    0.12965004076096973,
    0.1218724759689103,
    0.10396859060221607,
    0.07240727055856411,
    0.04138348237191981)

sydneyAgeWebPopulation2020 = sydneyAgeWebDistribution2020*sydneyPopulation2020
names(sydneyAgeWebPopulation2020) = paste("age", 0:8, sep = "")
