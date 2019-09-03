library(dplyr)

#Read NEI and SCC data files
nei <- readRDS("summarySCC_PM25.rds")
scc <- readRDS("Source_Classification_Code.rds")

#Subset Baltimore data
baltimore <- subset(nei, fips=="24510")

#Select only the SCC and EI.Sector columns, which will be used for filtering
#the data, from scc and merge the result with baltimore
scc_sector <- select(scc, SCC, EI.Sector)
balt_scc <- merge(baltimore, scc_sector, by = "SCC")

#Filter the data for getting only the observations where EI.Sector contains
#both "Mobile" and "Vehicles"
vehicles <- subset(balt_scc, grepl("Mobile", EI.Sector) & grepl("Vehicles", EI.Sector))

#Compute total emissions for each year
totals <- with(vehicles, tapply(Emissions, year, sum, na.rm = TRUE))

#Open png device
png("plot5.png")

#Adjust margins and label position
par(mar = c(4,6,4,1), mgp = c(4, 1, 0))

#Plot and annotate
plot(totals, pch = 19, xaxt = "n", las=1, ylab = "Total Emissions (tons)", main = "PM2.5 Emissions from Motor Vehicles\n in Baltimore City")
lines(totals)
axis(1, at = 1:4, labels = names(totals))

#Close device
dev.off()