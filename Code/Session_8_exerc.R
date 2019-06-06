############################
# R exercise Session 6	   #
############################	
# Ralf B. Schäfer, 6.6.2019

##############################
# Preparation for Exercise   #
##############################

library(chemometrics)
data(ash)

# The ash softening temperature (SOT) is an important variable to determine the characteristics of fuel. 
# Run a PCA for the ash data set. Make sure you remove the response variable (SOT)
# and the log-transformed variables before the PCA and decide yourself regarding transformations.
# Once you have run a PCA, answer the following questions:
# How much variance is captured when plotting the first two principal components in a biplot?
# Identify the number of meaningful PCs and check the intercorrelation of these axes.
# What do you observe?
# Which variables contribute most to the construction of the first axis? Compare these results to those of a sparse PCA.

# In the next step run a principal component regression (response: SOT, predictors: PCs) and compare the results to those from an ordinary multiple linear regression for this data set in terms of selected variables, interpretation and explained variance.

