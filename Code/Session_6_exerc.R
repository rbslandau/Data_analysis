###############################
# R exercise Session 6	& 7   #
###############################	
# Ralf B. Schäfer, 20.12.2019

#############################################################################
# Exercise: Climate change influences the distribution of species. To 		#
# predict potential changes in the distribution requires knowledge on the   #
# relationship between the occurrence and climatic variables. In this 		#
# exercise we aim to identify the most important climatic variables that 	#
# determine the distribution of three-toed sloths, in particular of 		#
# Bradypus variegatus that occurs in Central and South America. 			#
# First, we retrieve the data.												#
#############################################################################



##############################
# Preparation for Exercise   #
##############################

# Read data set that consists of presence absence data for the Bradypus (column: pa), 
# which has been taken from https://www.gbif.org, and climatic variables.
# See http://www.worldclim.org/bioclim to get an idea of the meaning of the individual climatic variables

pa_data <- read.csv("https://www.uni-koblenz-landau.de/en/campus-landau/faculty7/environmental-sciences/landscape-ecology/teaching/envtrain.csv/at_download/file")

## Check data
head(pa_data)
str(pa_data)

# Convert variable biome to factor
pa_data$biome <- factor(pa_data$biome)


#############################################################################
Evaluate which environmental variables are most important 		#
# for the occurence of the Bradypus?										#
# Model the presence - absence as response and use the other variables		#
# as predictors. Select a method of your choice and run a complete 			#
# statistical modelling including variable selection	 and model diagnosis.#
# Plot nad interpret the model with effect plots and, if applicable,		#
# determine the variable importance for a final model that you select.		#
#############################################################################
