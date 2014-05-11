

# Download data to tempfile
temp <- tempfile()
download.file("http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", temp)

# unzip and load data to R
# we only need data from 2007-02-01 and 2007-02-02
# -> read only first column to determine which rows to load
data <- read.table(unz(temp, "household_power_consumption.txt"), sep=';', header=T, stringsAsFactors=F, na.strings='?', colClasses=c('character', rep('NULL', 8)))
rows <- which(is.element(data$Date, c('1/2/2007', '2/2/2007')))
data <- read.table(unz(temp, "household_power_consumption.txt"), sep=';', header=F, stringsAsFactors=F, na.strings='?', skip=min(rows), nrows=length(rows))
colnames(data) <- read.table(unz(temp, "household_power_consumption.txt"), sep=';', header=F, stringsAsFactors=F, nrows=1)
unlink(temp)

# Plot 4

data$DateTime <- strptime(paste(data$Date, data$Time, sep=' '), format='%d/%m/%Y %H:%M:%S')

# temporary set local to UK
loc <- Sys.getlocale("LC_TIME")
Sys.setlocale("LC_TIME", "C")

png(filename='plot4.png', width=480, height=480)

par(mfrow=c(2,2))
plot(data$DateTime, data$Global_active_power, ylab='Global Active Power', type='l', xlab='')

plot(data$DateTime, data$Voltage, ylab='Voltage', type='l', xlab='datetime')

plot(data$DateTime, data$Sub_metering_1, ylab='Energy sub metering', type='l', xlab='')
lines(data$DateTime, data$Sub_metering_2, type='l', col='red')
lines(data$DateTime, data$Sub_metering_3, type='l', col='blue')
legend('topright', legend=c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'), col=c('black', 'red', 'blue'), lwd=1, bty='n')

plot(data$DateTime, data$Global_reactive_power, ylab='Global_reactive_power', type='l', xlab='datetime')

dev.off()

Sys.setlocale("LC_TIME", loc)