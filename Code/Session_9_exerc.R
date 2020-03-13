###############################
# R exercise Session 9        #
###############################	
# Ralf B. Schäfer, 27.2.2020


# Exercise 1
#####################################################################################
# Sea level rise may affect the ecology of the Dutch coastal system.				#
# The Dutch governmental institute RIKZ therefore started a research project		#
# on the relationship between several abiotic environmental variables				#
# (e.g., sediment composition, slope of the beach) and the benthic fauna.			#
# The aim is to identify the main drivers of the benthic community composition.		#
# Use an RDA to find the explanatory variables that explain the community pattern.	#
#####################################################################################


##############################
# Preparation for Exercise   #
##############################
# We use the RIKZ data set (taken from Zuur et al. 2007).
# Conduct a complete RDA and evaluate how many RDA axes are required.

# Load data set
RIKZ <- read.table("https://www.uni-koblenz-landau.de/en/campus-landau/faculty7/environmental-sciences/landscape-ecology/teaching/RIKZ_data/at_download/file", header = TRUE)

# You need to extract the species data (Polychaeta, Crustacea, Mollusca, Insecta) as responses
# and the variables in the columns 9 to 15 as explanatory variables.
# Information on environmental variables:
# Exposure is an index that is composed of the following elements: wave action, length of the surf zone, 
# slope, grain size and the depth of the anaerobic layer.
# Salinity and temperature are classical parameters.
# NAP is the height of the sampling station relative to the mean tidal level, measured in meters.
# Penetrability: Habitat variable indicating resistance of ground, measured in N per cm2
# Grain size: Measured in mm
# Humus: constitutes the amount of organic material in %
# Chalk: constitutes the amount of chalk in %


# Exercise  2
#####################################################################################################
# a) Compute the Bray-Curtis, Euclidean and Jaccard dissimilarities/distances 						#
# for the matrix given below. What are the differences between the coefficients 					#
# regarding the relationship of the highest to lowest dissimilarity/distance? 						#
# What else do you observe? Use the function vegdist() to calculate dissimilarity/distance			#
# and check, which arguments you need to provide. Be careful when calculating Jaccard dissimilarity #
# (you need to set a further argument)!																#
#																									#
# b) How does standardisation of the data affect the results?										#
# Use decostand(yourmatrix, method="max") and recalculate the dissimilarities/distances.			#
# This will divide each observation by the maximum value of each variable (species).				#
#####################################################################################################

##############################
# Preparation for Exercise   #
##############################
library(vegan)
# We generate a matrix with 6 species observed at 5 sites
# that you should use to calculate some dissimilarity and distance measures
mat1 <- matrix(data = c(40, 5, 12, 0, 0, 40, 10, 1, 18, 15, 22, 3, 100, 5, 22, 16, 200, 50, 2, 1, 1, 0, 0, 0, 40, 10, 0, 0, 0, 20), nrow = 5, byrow = TRUE)
mat1


