library(ggplot2)
library(dplyr)
library(tidyr)

#Read NEI data file
nei <- readRDS("summarySCC_PM25.rds")

#Subset and compute total emissions for each year
baltimore <- subset(nei, fips=="24510")
type_totals <- with(baltimore, tapply(Emissions, list(year, type), sum, na.rm = TRUE))

#Convert table with totals to data frame
type_totals <- as.data.frame(type_totals)
names(type_totals) <- make.names(names(type_totals))
type_totals <- type_totals %>% 
    tibble::rownames_to_column("Year") %>%
    gather(Type, Emissions, -Year)

#Open png device
png("plot3.png")

#Plot
g <- ggplot(type_totals, aes(Year, Emissions, group = 1))
g <- g + geom_line() + geom_point() + facet_grid(. ~ Type)
g <- g + ggtitle("PM2.5 Total Emissions in Baltimore City by Source Type") + theme(plot.title = element_text(hjust = 0.5)) + ylab("Total Emissions (tons)")
print(g)

#Close device
dev.off()