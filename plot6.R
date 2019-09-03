library(dplyr)

#Read NEI and SCC data files
nei <- readRDS("summarySCC_PM25.rds")
scc <- readRDS("Source_Classification_Code.rds")

#Subset Baltimore and Los Angeles data
baltimore <- subset(nei, fips=="24510")
los_angeles <- subset(nei, fips=="06037")

#Select only the SCC and EI.Sector columns, which will be used for filtering
#the data, from scc and merge the result with baltimore and los_angeles
scc_sector <- select(scc, SCC, EI.Sector)
balt_scc <- merge(baltimore, scc_sector, by = "SCC")
la_scc <- merge(los_angeles, scc_sector, by = "SCC")

#Filter the data for getting only the observations where EI.Sector contains
#both "Mobile" and "Vehicles"
vehicles_balt <- subset(balt_scc, grepl("Mobile", EI.Sector) & grepl("Vehicles", EI.Sector))
vehicles_la <- subset(la_scc, grepl("Mobile", EI.Sector) & grepl("Vehicles", EI.Sector))

#Compute total emissions for each year
totals_balt <- with(vehicles_balt, tapply(Emissions, year, sum, na.rm = TRUE))
totals_la <- with(vehicles_la, tapply(Emissions, year, sum, na.rm = TRUE))

#Open png device
png("plot6.png")

#Normalize the range of values for the y axis
rng <- range(totals_balt, totals_la, na.rm = TRUE)

#Adjust parameters
par(mfrow=c(1,2), mar = c(4,6,3,1), mgp = c(4, 1, 0), oma = c(0, 0, 2, 0))

#Plot and annotate
plot(totals_balt, pch = 19, xaxt = "n", las=1, ylim = rng, ylab = "Total Emissions (tons)", main = "Baltimore City")
lines(totals_balt)
axis(1, at = 1:4, labels = names(totals_balt))

plot(totals_la, pch = 19, xaxt = "n", las=1, ylim = rng, ylab = "Total Emissions (tons)", main = "Los Angeles County")
lines(totals_la)
axis(1, at = 1:4, labels = names(totals_la))

mtext("PM2.5 Total Emissions from Motor Vehicles", outer = TRUE, cex = 1.5)

#Close device
dev.off()