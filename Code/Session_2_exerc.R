############################
# R exercise Session 2	   #
############################	
# Ralf B. Schäfer, 11.11.2019

##############################
# Preparation for Exercise   #
##############################

# We load data from the university website
read.table("http://www.uni-koblenz-landau.de/en/campus-landau/faculty7/environmental-sciences/landscape-ecology/Teaching/possum.csv")
# Formatting does not look good

# We have to specify different options:
# header = TRUE
# sep (for separator) = ";"
# dec (for decimal point) = "."
# We also omit the row.names.
# See ?read.table for the various options
pos_dat <- read.table(url("http://www.uni-koblenz-landau.de/en/campus-landau/faculty7/environmental-sciences/landscape-ecology/Teaching/possum.csv"), dec = ".", sep = ";", header = TRUE, row.names = NULL)
close(url("http://www.uni-koblenz-landau.de/en/campus-landau/faculty7/environmental-sciences/landscape-ecology/Teaching/possum.csv"))

pos_dat
# looks ok
head(pos_dat)
# first 6 rows (for long data.frames)
str(pos_dat)
# structure of object (data.frame with 14 variables and 104 rows, also class of variables)

###########################################
# file information
###########################################

# This file was taken from the DAAG package which is maintained by John Maindonald
# and W. John Braun and contains information on possums that were published in:
#
# Lindenmayer, D. B., Viggers, K. L., Cunningham, R. B., and Donnelly, C. F. 1995.
# Morphological variation among columns of the mountain brushtail possum,
# Trichosurus caninus Ogilby (Phalangeridae: Marsupiala).
# Australian Journal of Zoology 43: 449-458
#
# You can find more details on the variables in the DAAD package (if installed):
# library(DAAG)
# data(possum)
# ?possum

# You should save the file for later use on your local hard drive
save(pos_dat, file = "Possum.Rdata")
# The file will be saved in your current working directory (run getwd())
# If you start a new session you can just load the saved data with:
# load("Possum.Rdata")
# (assuming that you have set the working directory to the directory with the file)

# Finally, you could conventionally download the file to your local harddrive and read it from there:
# read.csv2("/Users/ralfs/Downloads/Possum.csv")
# would also work if adjusted to your path
# read.csv and read.csv2 are different functions for reading data frames
# that have predefined options for csv files
# The most general function is read.table, were you have to define the format of your data
# (header, separator, decimal point, ...)


#################################################################
# Exercise: Chasing possums can be laborious.   				#
# An easy way would be to predict their length from footprints.	#
# Would you recommend to predict the total length of the possum #
# from traces of their 	feet in the snow?   					#
# And is an invasive measurement of the skull width necessary   #
# or can it be approximated with the head length?				#
# Identify the type of research question, create linear 		#
# regression models and run complete model diagnostics			#
#################################################################
