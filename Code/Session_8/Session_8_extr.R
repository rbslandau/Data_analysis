## ----setup, include = FALSE, purl = TRUE---------------------------------
knitr::opts_chunk$set(echo = FALSE)
library(vegan)
library(learnr)
library(ggplot2)
library(GGally)
lowerFn <- function(data, mapping, method = "lm", ...) {
  p <- ggplot(data = data, mapping = mapping) +
    geom_point(colour = "blue") +
    geom_smooth(method = method, color = "red", ...)
  p
}
data("varechem")
# setup species with unimodal gradient
hss <- c(1, 2, 4, 7, 8, 7, 4, 2, 1)
# unimodal gradient
spec1 <- c(hss, rep(0, 10)) #
spec2 <- c(rep(0, 5), hss, rep(0, 5))
spec3 <- c(rep(0, 10), hss)
data <- cbind(spec1, spec2, spec3)
# create data.frame
species_dat <- data.frame(data)






## ----load_data, include = TRUE, echo = TRUE, purl = TRUE-----------------
library(vegan)
# load data
data(varechem)






## ----data_mult_normality, include = TRUE, eval = TRUE, echo = TRUE, purl = TRUE----
library(mvoutlier)
par(mfrow = c(1, 2), las = 1)
chisq.plot(varechem, quan = 1, ask = FALSE)


## ----data_callin_code, include = TRUE, echo = TRUE, eval = FALSE---------
## library(ggplot2)
## library(GGally)
## # We define a function to change the colour of points and lines (otherwise both are black)
## lowerFn <- function(data, mapping, method = "lm", ...) {
##   p <- ggplot(data = data, mapping = mapping) +
##               geom_point(colour = "blue") +
##               geom_smooth(method = method, color = "red", ...)
##   p
##   }
## # Run ggpairs()
## ggpairs(varechem, lower = list(continuous = wrap(lowerFn, method = "lm")),
##                     diag = list(continuous = wrap("densityDiag", colour = "blue")),
##                     upper = list(continuous = wrap("cor", size = 10)))





## ----species_data_generation, include = TRUE, eval = TRUE, echo = TRUE, purl = TRUE----
# setup species with unimodal gradient
hss <- c(1, 2, 4, 7, 8, 7, 4, 2, 1)
# unimodal gradient
spec1 <- c(hss, rep(0, 10)) #
spec2 <- c(rep(0, 5), hss, rep(0, 5))
spec3 <- c(rep(0, 10), hss)
data <- cbind(spec1, spec2, spec3)
# create data.frame
species_dat <- data.frame(data)
# display species distribution along sites
par(las = 1)
plot(spec1, col = "blue", type = "o", ylab = "Species abundance", xlab = "Site", main = "Three species against environmental gradient")
points(spec2, col = "red")
lines(spec2, col = "red")
points(spec3, col = "magenta")
lines(spec3, col = "magenta")


## ----specdat_mult_normality, include = TRUE, eval = TRUE, echo = TRUE, purl = TRUE----
library(mvoutlier)
par(mfrow = c(1, 2), las = 1)
chisq.plot(species_dat, quan = 1, ask = FALSE)
# add information on data
mtext("Species data")
# plot soil data again
chisq.plot(varechem, quan = 1, ask = FALSE)
mtext( "Soil data")


## ----specdat_pairs, include = TRUE, eval = TRUE, echo = TRUE, purl = TRUE----
ggpairs(species_dat, lower = list(continuous = wrap(lowerFn, method = "lm")),
                    diag = list(continuous = wrap("densityDiag", colour = "blue")),
                    upper = list(continuous = wrap("cor", size = 10)))




## ----soil_standard, include = TRUE, eval = TRUE, echo = TRUE, purl = TRUE----
soil_scaled <- scale(varechem)
# convert to data.frame
soil_scaled_df <- data.frame(soil_scaled)







## ----pca_soil, include = TRUE, eval = TRUE, echo = TRUE, purl = TRUE-----
va_pca <- rda(soil_scaled_df)
summary(va_pca, display = NULL)




## ----pca_extract_evs, include = TRUE, eval = TRUE, echo = TRUE, purl = TRUE----
ev <- va_pca$CA$eig
# calculate the sum of eigenvalues
sum(ev)
# confirms that the total variance is preserved in the eigenvalues




## ----pca_sum_criterion, include = TRUE, eval = TRUE, echo = TRUE, purl = TRUE----
# set alpha as sum criterion
alpha <- 0.9
# extract the cumulative proportion of explained variance from object
cum_prop_var <- summary(va_pca)$cont$importance[3, ]
# check how many components are required
cum_prop_var > alpha
# or even more automated
ncol(soil_scaled_df) - sum(cum_prop_var > alpha) +1


## ----pca_screeplot, include = TRUE, eval = TRUE, echo = TRUE, purl = TRUE----
screeplot(va_pca, type = "lines")


## ----pca_brokenstick, include = TRUE, eval = TRUE, echo = TRUE, purl = TRUE----
screeplot(va_pca, type = "lines", bstick = TRUE)


## ----pca_rowcrossvalid, include = TRUE, eval = TRUE, echo = TRUE, purl = TRUE----
library(chemometrics)
pca_cv <- pcaCV(soil_scaled_df, center = FALSE, scale = FALSE, segments = 5, plot.opt = TRUE)


## ----NA_added, include = TRUE, eval = TRUE, echo = TRUE, purl = TRUE-----
# add a random NA value
# determine row
set.seed(2019)
row_val <- sample(1:nrow(soil_scaled_df), size = 1)
# determine column
set.seed(2019)
col_val <- sample(1:ncol(soil_scaled_df), size = 1)
# set to NA after creating a copy of the dataframe
soil_scaled_dfna <- soil_scaled_df
soil_scaled_dfna[row_val, col_val] <- NA


## ----pca_ekcv, include = TRUE, eval = TRUE, echo = TRUE, purl = TRUE-----
library(missMDA)
# make example reproducible
set.seed(1001) 
estim_ncpPCA(soil_scaled_dfna, method.cv = "Kfold", pNA = 0.20, ncp.max = 8, verbose = FALSE)


## ----pca_gcv, include = TRUE, eval = TRUE, echo = TRUE, purl = TRUE------
# for details
library(missMDA)
# make example reproducible
set.seed(100) 
estim_ncpPCA(soil_scaled_dfna, method.cv = "gcv", ncp.max = 8, verbose = FALSE)


## ----broken_stick_sim, include = TRUE, eval = TRUE, echo = TRUE, purl = TRUE----
# set maximum number of pieces
p <- 2
# create vector to store simulation results
vec_l <- c(1:10000)
# means that simulation is repeated 10000 times
# we obtain 10000 values for l
# set seed for reproducible example
set.seed(2019)
# create loop
for (i in 1:length(vec_l)) # loop runs vec_l times
      {
          y <- runif(p - 1) # sample from uniform distribution between p-1 = 1 and 0
          # save value after identifying longest piece
         vec_l[i] <- ifelse(y >= 0.5, y, 1 - y)
      }








## ----pca_biplot_code, include = TRUE, echo = TRUE, eval = FALSE----------
## biplot(va_pca, scaling = 3, display = c("sp", "site"), cex = 1.2)







## ----pca_outlier_diag, include = TRUE, eval = TRUE, echo = TRUE, purl = TRUE----
# run PCA
soil_pca_princ <- princomp(soil_scaled_df)
# set plotting parameters, see ?par
par(mfrow = c(1, 2), cex = 2)
# run function
library(chemometrics)
pcaDiagplot(soil_scaled_df, soil_pca_princ, a = 2)


## ----pca_biplot_sc1, include = TRUE, echo = TRUE, eval = FALSE-----------
## biplot(va_pca, scaling = 1, display = c("sp", "site"), main = "Scaling 1: Distance biplot")





## ----pca_biplot_sc2, include = TRUE, echo = TRUE, eval = FALSE-----------
## biplot(va_pca, scaling = 2, display = c("sp", "site"), main = "Scaling 2: Correlation biplot")





## ----pca_biplot_sc3, include = TRUE, echo = TRUE, eval = FALSE-----------
## biplot(va_pca, scaling = 3, display = c("sp", "site"), main = "Scaling 3: Symmetric biplot")





## ----load_iris, include = TRUE, echo = TRUE, eval = TRUE-----------------
data(iris)
# we take a random subsample of the data to enhance readability of the plots
set.seed(2019)
samp_vec <- sample(1:nrow(iris), 80)
# use sample vector for extraction
# remove column containing species information
iris_sub <- iris[samp_vec, 1:4]
# run PCA
iris_pca <- rda(iris_sub, scale = TRUE)
summary(iris_pca, display = NULL)


## ----pca_biplot_sc1_iris, include = TRUE, echo = TRUE, eval = FALSE------
## biplot(iris_pca, scaling = 1, display = c("sp", "site"), main = "Scaling 1: Distance biplot")





## ----pca_biplot_sc2_iris, include = TRUE, echo = TRUE, eval = FALSE------
## biplot(iris_pca, scaling = 2, display = c("sp", "site"), main = "Scaling 2: Correlation biplot")







## ----loadings, include = TRUE, echo = TRUE, eval = TRUE------------------
# Extract and display loadings
(loadings_pca <- va_pca$CA$v)




## ----loadings-2, include = TRUE, echo = TRUE, eval = TRUE----------------
(ident_mat <- loadings_pca %*% t(loadings_pca))


## ----loadings-3-rounding, include = TRUE, echo = TRUE, eval = TRUE-------
round(ident_mat)


## ----loadings-4-corr_loadings, include = TRUE, echo = TRUE, eval = TRUE----
# extract and display square root of eigenvalues
sdev <- sqrt(va_pca$CA$eig)
sdev
# we have to transpose the matrix to obtain the correct result
cor_loadings <- t(loadings_pca) * sdev
cor_loadings


## ----loadings-5-corr_loadings, include = TRUE, echo = TRUE, eval = TRUE----
# we transpose the correlation loadings to have the same format as the result from the correlation below
t(cor_loadings)

# prepare choice of components
num_col_soilsdata <- ncol(varechem)
# create vector with all columns identified by their number
(col_vec_pca <- 1:num_col_soilsdata)
# run scores function from vegan package
pca_scores <- vegan::scores(va_pca, disp = "sites", choices = col_vec_pca, scaling = 0)
# calculate correlation coefficients between (scaled) soil data and the principal components
cor(scale(varechem), pca_scores)




## ----spca-1, include = TRUE, echo = TRUE, eval = TRUE--------------------
library(pcaPP)
# set k.max as the max number of considered sparse PCs
k.max <- 2
# run function
oTPO <- opt.TPO(scale(varechem), k.max = k.max, method = "sd")


## ----spca-2, include = TRUE, echo = TRUE, eval = TRUE--------------------
plot(oTPO, k = 1)


## ----spca-3, include = TRUE, echo = TRUE, eval = TRUE--------------------
# use optimized lambdas to compute sparsePCA
spc <- sPCAgrid(scale(varechem), k = k.max, lambda = oTPO$pc.noord$lambda, method = "sd")
summary(spc, loadings = TRUE)


## ----spca-3-eigenvals, include = TRUE, echo = TRUE, eval = TRUE----------
spc$sdev^2




## ----spca-4-corrloadings, include = TRUE, echo = TRUE, eval = TRUE-------
# first extract loadings
spc_load <- spc$loadings[]
# transpose loading matrix and multiply with square root of eigenvalues (equivalent to standard deviation)
(spca_corr_load <- t(spc$loadings[]) * spc$sdev)
# enhance readability
t(spca_corr_load)


## ----spca-5-plot, include = TRUE, echo = TRUE, eval = TRUE---------------
biplot(spc, cex = 0.6)


## ----pca-reg-1, include = TRUE, echo = TRUE, eval = TRUE-----------------
# create index for all PCs, number of PCs equals number of variables in original dataset
pca_index <- c(1:ncol(varechem))
# extract scores
pc_scores_reg <- vegan::scores(va_pca, display = "sites", choices = pca_index, scaling = 0)


## ----pca-reg-2, include = TRUE, echo = TRUE, eval = TRUE-----------------
vegan::scores(spc, display = "sites", scaling = 0)
# same as:
spc$scores


## ----pca-fail1, include = TRUE, echo = TRUE, eval = TRUE-----------------
pca_specdat <- rda(species_dat)


## ----pca-fail_biplot_code, include = TRUE, echo = TRUE, eval = FALSE-----
## biplot(pca_specdat, scaling = 3, display = c("sp", "site"), cex = 1.8)



## ----pca-fail2, include = TRUE, echo = TRUE, eval = TRUE-----------------
pca_specdat$CA$v


## ----pca-fail3, include = TRUE, echo = TRUE, eval = TRUE-----------------
summary(pca_specdat, display = NULL)


## ----pca-hell1, include = TRUE, echo = TRUE, eval = TRUE-----------------
# Apply hellinger transformation
spec_hell <- decostand(species_dat, method = "hellinger")
# Run PCA
pca_spec_hell <- rda(spec_hell)


## ----pca-hell2, include = TRUE, echo = TRUE, eval = FALSE----------------
## # Biplot
## biplot(pca_spec_hell, scaling = 3, display = c("sp", "site"), cex = 1.8)

