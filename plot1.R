#Read NEI data file
nei <- readRDS("summarySCC_PM25.rds")

#Compute total emissions for each year
totals <- with(nei, tapply(Emissions, year, sum, na.rm = TRUE))

#Open png device
png("plot1.png")

#Adjust margins and label position
par(mar = c(4,8,2,1), mgp = c(6, 1, 0))

#Plot and annotate
plot(totals, pch = 19, xaxt = "n", las=1, ylab = "Total Emissions (tons)", main = "PM2.5 Total Emissions")
lines(totals)
axis(1, at = 1:4, labels = names(totals))

#Close device
dev.off()