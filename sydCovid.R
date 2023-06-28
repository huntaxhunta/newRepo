library(ggplot2)

# load data
covid <- read.csv("epiSEIHCRD_combAge.csv") 

# change the date format 
covid$date <- as.Date(covid$t, origin = "2020-03-01")

# Subset the data by time frame
julyDec <- subset(covid, date > "2020-07-01" & date < "2020-12-31")

#Plot the data

g <- ggplot(julyDec) +
	  geom_line(aes(date, H, col = "red")) +
	  geom_line(aes(date, C, col = "Critical")) +
	  geom_line(aes(date, D, col = "dead")) +
	  scale_y_sqrt() +
	  scale_x_date(breaks = "month",date_minor_breaks = "week",
		      date_labels = "%B") +
	  labs(title = "hostpital bed between July and December",
		        x = "date", y = "Hospital bed count")


print(g)
