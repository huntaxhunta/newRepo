#!/usr/bin/R

# mitigation functions to use in parameters
mitigationFunction = function(type) {
    
    ystrong = c(1.0, 0.7, 0.4, 0.4, 0.4, 0.4, 0.4, 0.4, 0.45, 0.45)
    ymoderate = c(1.0, 0.8, 0.7, 0.6, 0.6, 0.6, 0.6, 0.6, 0.6, 0.6)
    ydebug = rep(1, length(ystrong))
    x <- seq(0, 182, along.with = ystrong)
    
    ystrong2 = c(1, 1, 0.45)
    ymoderate2 = c(1, 1, 0.6)
    x2 = c(0, 30, 60)

    if (type == "strong") {
        return(approxfun(x, ystrong, rule=1:2))
    }
    if (type == "moderate") {
        return(approxfun(x, ymoderate, rule=1:2))
    }
    if (type == "debug") {
        return(approxfun(x, ydebug, rule=1:2))
    }

    if (type == "strong2") {
        return(approxfun(x2, ystrong2, rule=1:2))
    }
    if (type == "moderate2") {
        return(approxfun(x2, ymoderate2, rule=1:2))
    }

}

