#Read NEI data file
nei <- readRDS("summarySCC_PM25.rds")

#Subset and compute total emissions for each year
baltimore <- subset(nei, fips=="24510")
totals <- with(baltimore, tapply(Emissions, year, sum, na.rm = TRUE))

#Open png device
png("plot2.png")

#Adjust margins and label position
par(mar = c(4,6,2,1), mgp = c(5, 1, 0))

#Plot and annotate
plot(totals, pch = 19, xaxt = "n", las=1, ylab = "Total Emissions (tons)", main = "PM2.5 Total Emissions in Baltimore City")
lines(totals)
axis(1, at = 1:4, labels = names(totals))

#Close device
dev.off()