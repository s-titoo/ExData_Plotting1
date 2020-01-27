# read the file
fileName <- "household_power_consumption.txt"
powerCons <- read.table(fileName, sep = ";", header =TRUE)

# transform date (1)
powerCons$Date_Time <- paste(powerCons$Date, powerCons$Time, sep = " ")
powerCons$Date <- as.Date(powerCons$Date, format = "%d/%m/%Y")

# subset data
datesSubset <- as.Date(c("2007-02-01", "2007-02-02"))
powerCons <- powerCons[powerCons$Date %in% datesSubset, ]

# transform date (2)
powerCons$Date_Time <- strptime(powerCons$Date_Time, format = "%d/%m/%Y %H:%M:%S")

# recode NAs (we actually have none)
for(i in 3:9) {
    powerCons[, i][powerCons[, i] == "?"] <- NA
    powerCons[, i] <- as.numeric(as.character(powerCons[, i]))
}

# do some data cleaning/formatting
drops <- c("Time")
powerCons <- powerCons[, !(names(powerCons) %in% drops)]
powerCons <- powerCons[, c(1, 9, 2:8)]
rm(drops, fileName, datesSubset, i)

# making plot 1
png(filename = "plot1.png", width = 480, height = 480)
hist(powerCons$Global_active_power,
     col = "red", main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)")
dev.off()