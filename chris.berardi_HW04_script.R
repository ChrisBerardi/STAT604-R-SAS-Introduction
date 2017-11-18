#chris.berardi_HW04_console.pdf
#Created by: Chris Berardi
#Creation Date: 6/5/15
#Purpose: Solution to Assignment 4 for Stat604, Summer 2015
#Last Executed: 6/7/15

#Part 1: display system time and date
Sys.time()
#Housekeeping, display workspace and clear it
ls()
rm(list=ls())

#Part 2: Load in the workspace from eCampus
load("C:\\Users\\Saistout\\Desktop\\604 Stuff\\homework\\HW04.RData")
#Show the content of the workspace, display its strucutre and summarize
ls()
str(drought)
summary(drought)

#Part 3a,b:Load the US_Fips.csv file, the show its structure, then allow columns to be used
#by column name
{US_Fips <- read.csv("C:\\Users\\Saistout\\Desktop\\604 Stuff\\homework\\US_Fips.csv",
head=TRUE, sep=",", colClasses="character")}
str(US_Fips)
attach(US_Fips)

#3c Create a new column named FIPS that concatenates state and county FIPS
FIPS <- paste(State.FIPS.Code, County.FIPS.Code, sep="")

#Part 4: Create Truth mask of Texas Counties
Texas_County_Indicies <- US_Fips[,1]=="TX" & US_Fips[,7] == "County"
#Use mask to select state, GU name and FIPS or Texas Counties
{Texas_County_FIPS <- data.frame(US_Fips[Texas_County_Indicies,c(1,6)],
FIPS[Texas_County_Indicies])}
#remove unneeded objects
rm(Texas_County_Indicies)
#4a,b Display strucutre, detach data
str(Texas_County_FIPS)
detach(US_Fips)
#Remove the annoying .Texas_County_Indicies from the 3rd Column Name
names(Texas_County_FIPS) <- sub(".Texas_County_Indicies.", "", names(Texas_County_FIPS))
#Rename First two Columns to State and County
names(Texas_County_FIPS) <- sub(".Abbreviation", "", names(Texas_County_FIPS))
(names(Texas_County_FIPS) <- sub("GU.Name", "County", names(Texas_County_FIPS)))

#Part 5: Create Data Frame of Texas_County_FIPS and the Drought Data
(Texas_County_FIPS_Drought <- merge(Texas_County_FIPS, drought, all=TRUE))
summary(Texas_County_FIPS_Drought)

#Part 6: Add columns for county area under each drough condition
NoneArea <- Texas_County_FIPS_Drought$CountyArea[]*Texas_County_FIPS_Drought$None[]
Texas_County_FIPS_Drought[,12] <- NoneArea/100 #100% is 100 in data, not 1

D0Area <- Texas_County_FIPS_Drought$CountyArea[]*Texas_County_FIPS_Drought$D0[]
Texas_County_FIPS_Drought[,13] <- D0Area/100

D1Area <- Texas_County_FIPS_Drought$CountyArea[]*Texas_County_FIPS_Drought$D1[]
Texas_County_FIPS_Drought[,14] <- D1Area/100

D2Area <- Texas_County_FIPS_Drought$CountyArea[]*Texas_County_FIPS_Drought$D2[]
Texas_County_FIPS_Drought[,15] <- D2Area/100

D3Area <- Texas_County_FIPS_Drought$CountyArea[]*Texas_County_FIPS_Drought$D3[]
Texas_County_FIPS_Drought[,16] <- D3Area/100

D4Area <- Texas_County_FIPS_Drought$CountyArea[]*Texas_County_FIPS_Drought$D4[]
Texas_County_FIPS_Drought[,17] <- D4Area/100

rm(NoneArea, D0Area, D1Area, D2Area, D3Area, D4Area) #remove unneeded objects

#Rename Columns to Something more meaningful
names(Texas_County_FIPS_Drought) <- sub("V12", "None Area", names(Texas_County_FIPS_Drought))
names(Texas_County_FIPS_Drought) <- sub("V13", "D0 Area", names(Texas_County_FIPS_Drought))
names(Texas_County_FIPS_Drought) <- sub("V14", "D1 Area", names(Texas_County_FIPS_Drought))
names(Texas_County_FIPS_Drought) <- sub("V15", "D2 Area", names(Texas_County_FIPS_Drought))
names(Texas_County_FIPS_Drought) <- sub("V16", "D3 Area", names(Texas_County_FIPS_Drought))
names(Texas_County_FIPS_Drought) <- sub("V17", "D4 Area", names(Texas_County_FIPS_Drought))

#Display the function and its structure
Texas_County_FIPS_Drought
str(Texas_County_FIPS_Drought)

#Use ColSums to Display total area for each drought type, then use apply
(colSums(Texas_County_FIPS_Drought[,12:17], na.rm=TRUE))
apply(Texas_County_FIPS_Drought[12:17], 2, sum, na.rm=TRUE)

#Part 7: Display a List of County Names and D1 Areas from Highest to Lowest
D1AreaOrder <- order(Texas_County_FIPS_Drought[,14], decreasing = TRUE)
Texas_County_FIPS_Drought[D1AreaOrder, c(3,14)]
rm(D1AreaOrder)

#Part 8: Display a list of County Names and None for top ten counties
NoneOrder <-  order(Texas_County_FIPS_Drought[,6], decreasing = TRUE)
Texas_County_FIPS_Drought[NoneOrder[1:10], c(3,6)]
rm(NoneOrder)

#Part 9: Display list of County Names whose D0 value is less than 100 but exists
D0Order <- order(Texas_County_FIPS_Drought[,7], na.last=NA, decreasing = TRUE)
D0Existing <- Texas_County_FIPS_Drought[D0Order,c(3,7)]
D0Not100 <- D0Existing[,2] < 100 
sort(D0Existing[D0Not100,1], decreasing=FALSE) #put it back into alphbetical order
rm(D0Order, D0Exist, D0Not100)

#Part 10: Display all data for counties whose name begins with a B
BCounties <- grepl("^B", Texas_County_FIPS_Drought[,3])
(Texas_County_FIPS_Drought[BCounties,])
rm(BCounties)

#Part 11:
ls()

#Part 12:
rm(drought, US_Fips, FIPS, Texas_County_FIPS)

#Part 13:
save.image("C:\\Users\\Saistout\\Desktop\\604 Stuff\\homework\\HW05.RData")
