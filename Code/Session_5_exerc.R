############################
# R exercise Session 5	   #
############################	
# Ralf B. Schäfer, 26.11.2018

##############################
# Preparation for Exercise   #
##############################

# We load data that is contained within an R package
# If you cannot access the data, install the package
# via: install.packages("HSAUR2")

data("USairpollution", package = "HSAUR2")
# See package information for details on the data set
head(USairpollution)

#############################################################################
# Exercise: For an effective environmental protection,						#
# you need to know causes of pollution.										#
# In this case study (using real world data), the aim is to identify		#	
# the variables exhibiting the highest explanatory power					#
# for the SO2 air concentrations.											#
# Model the SO2 concentration as response and use the other variables		#
# as predictors. Compare the results for the following methods:				#
# 1) manual model building based on hypotheses,								#
# 2) automatic backward model selection with BIC							#
# 3) LASSO																	#
# Also compare the regression coefficients from post-selection shrinkage 	#	
# for 1) or 2) with those from the LASSO. Finally, conduct model diagnosis	#
# and plot the model with effect plots and determine the variable importance#
# for a final model that you select.										#
#############################################################################

