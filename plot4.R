library(dplyr)

#Read NEI and SCC data files
#nei <- readRDS("summarySCC_PM25.rds")
#scc <- readRDS("Source_Classification_Code.rds")

#Select only the SCC and EI.Sector columns, which will be used for filtering
#the data, from scc and merge the result with nei
scc_sector <- select(scc, SCC, EI.Sector)
nei_scc <- merge(nei, scc_sector, by = "SCC")

#Filter the data for getting only the observations where EI.Sector contains
#both "Fuel comb" (for combustion) and "Coal"
coal_comb <- subset(nei_scc, grepl("Fuel Comb", EI.Sector) & grepl("Coal", EI.Sector))

#Compute total emissions for each year
totals <- with(coal_comb, tapply(Emissions, year, sum, na.rm = TRUE))

#Open png device
png("plot4.png")

#Adjust margins and label position
par(mar = c(4,8,2,1), mgp = c(6, 1, 0))

#Plot and annotate
plot(totals, pch = 19, xaxt = "n", las=1, ylab = "Total Emissions (tons)", main = "PM2.5 Emissions from Coal Combustion")
lines(totals)
axis(1, at = 1:4, labels = names(totals))

#Close device
dev.off()