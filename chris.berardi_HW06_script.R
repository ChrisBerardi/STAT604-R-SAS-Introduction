#chris.berardi_HW05_console.pdf
#Created by: Chris Berardi
#Creation Date: 6/19/15
#Purpose: Solution to Assignment 6 for Stat604, Summer 2015
#Last Executed: 6/20/15

# display system time and date
Sys.time()
#Housekeeping, display workspace and clear it
ls()
rm(list=ls())

# 1open the pdf output device and give correct sizes
pdf(file = "C:\\Users\\Saistout\\Desktop\\604 Stuff\\homework\\chris.berardi_HW06_graphics.pdf", 8.5, 11)

#2 Use the formula given to simulate 10000 values
Moving_Average<-cbind(rep(1,10000),rep(1,10000)) #create vector of apropriate size to seed up loop

set.seed(61415) #set seed to generate consistent values
Omega <- rnorm(10000) #generate values from a normal distribution
	for ( i in 2:10000){
	Moving_Average[i,1] <- i
	Moving_Average[i,2] <-  2+Omega[i]-.33*Omega[i-1]+.66*Moving_Average[i-1,2]
	}
rm(i,Omega) #clean up after loop
#plot last 1000 values
Moving_Average_Last <- cbind(seq(1:1000),Moving_Average[9001:10000,2]) 
{plot(Moving_Average_Last[,1], Moving_Average_Last[,2], type="l",
xlab = "1:1000", ylab = "Moving Average")}
rm(Moving_Average_Last, Moving_Average) #clean up

#3 Create Moving Average Function
MA <-function(alpha_in, beta_in, set_seed=61415, num_simulate = 10000, num_graph = 1000){
	Moving_Average<-cbind(rep(1,num_simulate),rep(1,num_simulate))
	set.seed(set_seed)
	Omega <- rnorm(num_simulate)
		for ( i in 2:num_simulate){
		Moving_Average[i,1] <- i
		Moving_Average[i,2] <- 2+Omega[i]-alpha_in*Omega[i-1]+beta_in*Moving_Average[i-1,2]
		}
	rm(i,Omega) #clean up after loop
	#plot last num_graph values
	lower_bound <- num_simulate-num_graph+1 #create object to simplify graphing matrix
	Moving_Average_Last <- cbind(seq(1:num_graph),Moving_Average[lower_bound:num_simulate,2])
	rm(lower_bound) #clean up
	{plot(Moving_Average_Last[,1], Moving_Average_Last[,2], type="l",
	xlab = bquote(paste(alpha==.(alpha_in), "    ", beta==.(beta_in))),
	ylab = "Moving Average",
	main = expression(paste("Plot of ", X[n]==2+omega[n]-alpha, omega[n-1]+beta, X[n-1])),
	mar = c(5,4,2,0))}
	rm(Moving_Average_Last, Moving_Average) #clean up
}
#4,5 Set up the correct margins and call the function twice
#Set up two rows of plots on one page, overall margins
par(mfrow=c(2,1), omi=c(1,1.5,1,0.5))
MA(.33,.66)
MA(.1, .7, num_simulate=1000, num_graph= 500)

#6 Write the System time on the outer margin on the left
mtext(paste(Sys.time()), side=1, outer=TRUE, adj=0)

dev.off() #close graphics
