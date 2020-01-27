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

# making plot 4
png(filename = "plot4.png", width = 480, height = 480)
par(mfcol = c(2,2))
plot(powerCons$Date_Time, powerCons$Global_active_power,
     type = "l", xlab = "",
     ylab = "Global Active Power")
plot(powerCons$Date_Time, powerCons$Sub_metering_1,
     type = "l", xlab = "",
     ylab = "Energy sub metering")
points(powerCons$Date_Time, powerCons$Sub_metering_2,
     type = "l", col = "red")
points(powerCons$Date_Time, powerCons$Sub_metering_3,
     type = "l", col = "blue")
legend("topright", legend = names(powerCons[, 7:9]),
     col = c("black", "red", "blue"), bty = "n", lty = 1)
plot(powerCons$Date_Time, powerCons$Voltage, type = "l", 
     xlab = "datetime", ylab = "Voltage")
plot(powerCons$Date_Time, powerCons$Global_reactive_power, 
     type = "l", xlab = "datetime", ylab = "Global_reactive_power")
dev.off()