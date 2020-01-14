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
# which has been taken from https://www.gbif.org, and climatic variables, taken from http://www.worldclim.org.
# See http://www.worldclim.org/bioclim regarding the meaning of the individual climatic variables

pa_data <- read.csv("https://raw.githubusercontent.com/rbslandau/Data_analysis/master/Data/envtrain.csv")

## Check data
head(pa_data)
str(pa_data)

# Convert variable biome to factor
pa_data$biome <- factor(pa_data$biome)


#############################################################################
# Identify the climatic variable(s) that is/are most important for the 		#
# occurence of the Bradypus!												#
# (1) Use a GLM to model the presence - absence as response variable and    #
# theclimatic variables as explanatory variables. Select a method of your   #
# for model selection and run a model diagnosis afterwards.					#
# Plot and interpret the model with effect plots.							#
# (2) Repeat the same analysis using a CART (optional: Random Forest). 		#
# Compare the results and the prediction accuracy of both models.			#
#############################################################################
