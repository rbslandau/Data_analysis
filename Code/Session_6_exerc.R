############################
# R exercise Session 6	   #
############################	
# Ralf B. Schäfer, 23.12.2018

##############################
# Preparation for Exercise   #
##############################

# Read presence absence data for the Bradypus (column: pa) and environmental variables
# see http://www.worldclim.org/bioclim for more information on the individual environmental variables

pa_data <- read.csv("https://www.uni-koblenz-landau.de/en/campus-landau/faculty7/environmental-sciences/landscape-ecology/teaching/envtrain.csv/at_download/file")

## Check data
head(pa_data)
str(pa_data)

# Convert biome to factor
pa_data$biome <- factor(pa_data$biome)


#############################################################################
# Exercise: Evaluate which environmental variables are most important 		#
# for the occurence of the Bradypus?										#
# Model the presence - absence as response and use the other variables		#
# as predictors. Select a method of your choice and run a complete 			#
# statistical modelling including variable selection	 and model diagnosis.#
# Plot nad interpret the model with effect plots and, if applicable,		#
# determine the variable importance for a final model that you select.		#
#############################################################################

