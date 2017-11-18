#chris.berardi_HW05_console.pdf
#Created by: Chris Berardi
#Creation Date: 6/10/15
#Purpose: Solution to Assignment 5 for Stat604, Summer 2015
#Last Executed: 6/11/15

#1: display system time and date
Sys.time()
#Housekeeping, display workspace and clear it
ls()
rm(list=ls())

#2: Load in fnep_precip.txt, replace -999 with NA and display summary
{precip <- read.delim("C:\\Users\\Saistout\\Desktop\\604 Stuff\\homework\\fnep_precip.txt",
header =TRUE, sep="\t", dec = ".", na.strings="-999")}
summary(precip)

#3 create data frame of only data from california
california_rows <- with(precip, grepl("CA-ST", ST.CD))
(california <- precip[california_rows,-1])
(with(california, min(ANNUAL, na.rm=TRUE)))
(with(california, max(ANNUAL, na.rm=TRUE)))
rm(california_rows)

#4 send all output to a pdf
pdf("C:\\Users\\Saistout\\Desktop\\604 Stuff\\homework\\chris.berardi_HW05_graphics.pdf")

#Create histogram of annual precipitations with breaks every 4 inches relabel as needed
{hist(california$ANNUAL, breaks= seq(4,48,4), 
main ="California Annual Precipitation Distribution", 
xlab = "Precipitation",
ylab = "Density", freq=FALSE)}

#5 Add red line to graph that shows normal distribtuion of annual precipitation
Xnd <- seq(0,50,.1)
Ynd <- dnorm(Xnd,mean=mean(california$ANNUAL, na.rm=TRUE), sd=sd(california$ANNUAL, na.rm=TRUE))
lines(Xnd, Ynd, col="red")
rm(Xnd, Ynd)

#6 Add in blue line at the mean annual precipitation
abline(v=mean(california$ANNUAL, na.rm=TRUE), col="blue")

#7 Plot april rain versus annual rain
{plot(california$APR, california$ANNUAL, col="lightgreen",pch=23,
bg = "lightgreen",
main = "California Precipitation Analysis",
xlab = "April Precipitation",
ylab = "Annual Precipitation")}

#8 Fit a line to this plot
abline(lm(california$ANNUAL~california$APR))

#9 Use function in imbed test showing date and time of creation in lower right corner
text(4,8, Sys.time())

#10 Create boxplot of California precipitation for all years by month
{boxplot(california[,2:13], col = "lightblue",
main = "California Historical vs. 2013 Precipitation by Month",
xlab = "Month", ylab = "Inches",
range = 0, ylim=c(0,15))}

#11 Show precipitation amount for 2013 for each month
year_2013 <- california$YEAR == 2013
rain_2013 <- california[year_2013,2:13]
points(c(1:12), rain_2013, col="blue", bg="blue", pch=16, cex=1.5)
rm(year_2013, rain_2013)

#close the device if I want to make the file
dev.off()


