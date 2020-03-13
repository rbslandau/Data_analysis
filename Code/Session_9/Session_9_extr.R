## ----setup, include=FALSE, context = "setup"--------------------------------------------------------------------------------------------------------------
library(learnr)
library(vegan)
library(dplyr)
knitr::opts_chunk$set(echo = FALSE)
# remove variables from chemical data
remove_vars <- c("Mn", "Mg", "P", "S", "Zn", "Fe")
data(varechem)
varechem_red <- varechem %>% select(-one_of(remove_vars))




## ----load_data, include = TRUE, echo = TRUE, purl = TRUE--------------------------------------------------------------------------------------------------
library(vegan)
# load chemical data
data(varechem)
# load vegetation data
data(varespec)
head(varespec)


## ----rare_spec, include = TRUE, echo = TRUE, purl = TRUE--------------------------------------------------------------------------------------------------
# transform data into presence-absence
varespec_pa <- decostand(varespec, "pa")
# calculate sum per species
vare_sum <- apply(varespec_pa, 2, sum)
# display number of occurrences in ascending order
sort(vare_sum)
# remove species that occur at less than 5 sites
varespec_fin <- varespec[ , !vare_sum < 5]


## ----mean_var, include = TRUE, echo = TRUE, purl = TRUE---------------------------------------------------------------------------------------------------
# calculate mean
vare_mean <- apply(varespec_fin, 2, mean)
# calculate variance
vare_var <- apply(varespec_fin, 2, var)
# plot on log scale
par(las = 1, cex = 1.5, mfrow = c(1,2))
plot(vare_mean, vare_var, log = "xy", xlab = "Mean", ylab = "Variance")


## ----dca_1, include = TRUE, echo = TRUE, purl = TRUE------------------------------------------------------------------------------------------------------
decorana(varespec_fin)


## ----dca_2, include = TRUE, echo = TRUE, purl = TRUE------------------------------------------------------------------------------------------------------
varespec_hel <- decostand(varespec_fin, "hellinger")
decorana(varespec_hel)


## ----remove_vars, include = TRUE, echo = TRUE, purl = TRUE------------------------------------------------------------------------------------------------
library(dplyr)
remove_vars <- c("Mn", "Mg", "P", "S", "Zn", "Fe")
varechem_red <- varechem %>% select(-one_of(remove_vars))


## ----data_callin_code, include = TRUE, echo = TRUE, eval = FALSE------------------------------------------------------------------------------------------
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
## ggpairs(varechem_red, lower = list(continuous = wrap(lowerFn, method = "lm")),
##                     diag = list(continuous = wrap("densityDiag", colour = "blue")),
##                     upper = list(continuous = wrap("cor", size = 10)))









## ----rda, include = TRUE, echo = TRUE, purl = TRUE--------------------------------------------------------------------------------------------------------
var_rda <- rda(varespec_hel ~ ., data = varechem_red)
summary(var_rda, display = NA)


## ----rda-rare, include = TRUE, echo = TRUE, purl = TRUE---------------------------------------------------------------------------------------------------
# We first need to Hellinger transform the data with rare taxa
varespec_raw_hel <- decostand(varespec, "hellinger")
# run RDA
var_rda_rare <- rda(varespec_raw_hel ~ ., data = varechem_red)
summary(var_rda_rare, display = NA)


## ----rda-test, include = TRUE, echo = TRUE, purl = TRUE---------------------------------------------------------------------------------------------------
# Global test of the RDA result
set.seed(2222)
anova.cca(var_rda, step = 1000)

# Tests of all canonical axes
set.seed(2222)
anova.cca(var_rda, by = "axis", step = 1000)


## ----rda_triplot_1, include = TRUE, echo = TRUE, eval = FALSE---------------------------------------------------------------------------------------------
## plot(var_rda, scaling = 1, main = "RDA scaling 1: Distance triplot", display = c("sp", "lc", "cn"))
## var.sc <- scores(var_rda, choices = 1:2, scaling = 1, display = c("sp"))
## arrows(0, 0, var.sc[ , 1], var.sc[ , 2], length = 0, lty = 1, col = "red")





## ----rda_triplot_2, include = TRUE, echo = TRUE, eval = FALSE---------------------------------------------------------------------------------------------
## plot(var_rda, main = "RDA scaling 2: Correlation triplot", display = c("sp", "lc", "cn"))
## var2.sc <- scores(var_rda, choices = 1:2, display = c("sp"))
## arrows(0, 0, var2.sc[ , 1], var2.sc[ , 2], length = 0, lty = 1, col = "red")





## ----rda-mod-selection, include = TRUE, echo = TRUE, purl = TRUE------------------------------------------------------------------------------------------
# Check R2 of model that is used for scope (full model)
RsquareAdj(var_rda)
# run stepwise forward algorithm
step_R2 <- ordiR2step(rda(varespec_hel ~ 1, data = varechem_red), scope = formula(var_rda))


## ----rda_triplot_3, include = TRUE, echo = TRUE, eval = FALSE---------------------------------------------------------------------------------------------
## plot(step_R2, scaling = 1, main = "RDA scaling 1: Distance triplot", display = c("sp", "lc", "cn"))
## var.sc <- scores(step_R2, choices = 1:2, scaling = 1, display = c("sp"))
## arrows(0, 0, var.sc[ , 1], var.sc[ , 2], length = 0, lty = 1, col = "red")







## ----rda-partial, include = TRUE, echo = TRUE, purl = TRUE------------------------------------------------------------------------------------------------
var_rda_partial <- rda(varespec_hel ~ Al + Condition(N + K + Ca), data = varechem_red)






## ----prc-inspect, include = TRUE, echo = TRUE, purl = TRUE------------------------------------------------------------------------------------------------
library(vegan)
data(pyrifos)
head(pyrifos[ , c(1:15)])
summary(pyrifos[ , c(1:15)])


## ----prc-prep, include = TRUE, echo = TRUE, purl = TRUE---------------------------------------------------------------------------------------------------
ditch <- gl(12, 1, length = 132)
week <- gl(11, 12, labels = c(-4, -1, 0.1, 1, 2, 4, 8, 12, 15, 19, 24))
# negative week means pre-treatment
conc <- factor(rep(c(0.1, 0, 0, 0.9, 0, 44, 6, 0.1, 44, 0.9, 0, 6), 11))


## ----prc-prep-rare, include = TRUE, echo = TRUE, purl = TRUE----------------------------------------------------------------------------------------------
# transform data into presence-absence
pyrifos_pa <- decostand(pyrifos, "pa")
# calculate sum per species
pyri_sum <- apply(pyrifos_pa, 2, sum)
# remove species that occur less than 11 sites
pyrifos_fin <- pyrifos[ , !pyri_sum < 11]


## ----prc-run, include = TRUE, echo = TRUE, purl = TRUE----------------------------------------------------------------------------------------------------
pyrifos_prc <- prc(response = pyrifos, treatment = conc, time = week) 
pyrifos_prc


## ----prc-plot, include = TRUE, echo = TRUE, purl = TRUE, eval = FALSE-------------------------------------------------------------------------------------
## # extract information for plotting, i.e. to limit plotting to species with higher scores
## pyrifos_prc_sum <- summary(pyrifos_prc, scaling = "species")
## # create plot
## par(cex = 1.7, mar = c(6,6,1,1))
## plot(pyrifos_prc, select = abs(pyrifos_prc_sum$sp) > 0.5,  lwd = 3, scaling = "species")







## ----matrix_gen, include = TRUE, echo = TRUE, purl = TRUE-------------------------------------------------------------------------------------------------
mat1 <- matrix(data = c(40, 5, 12, 0, 0, 40, 10, 1, 18, 15, 22, 3, 100, 5, 22, 16, 200, 50, 2, 1, 1, 0, 0, 0, 40, 10, 0, 0, 0, 20), nrow = 5, byrow = TRUE)
mat1 


## ----dist_eu, include = TRUE, echo = TRUE, purl = TRUE----------------------------------------------------------------------------------------------------
library(vegan)
# calculation of euclidean distance
eu_dist <- vegdist(mat1, method = "euclidean")
eu_dist


## ----dist_bray, include = TRUE, echo = TRUE, purl = TRUE--------------------------------------------------------------------------------------------------
br_dist <- vegdist(mat1, method = "bray")
br_dist




## ----nmds, include = TRUE, echo = TRUE, purl = TRUE-------------------------------------------------------------------------------------------------------
specnmds <- metaMDS(varespec_fin, k = 2)


## ----nmds_results, include = TRUE, echo = TRUE, purl = TRUE-----------------------------------------------------------------------------------------------
specnmds


## ----nmds_plot, include = TRUE, echo = TRUE, purl = TRUE, eval = FALSE------------------------------------------------------------------------------------
## par(cex = 1.5)
## plot(specnmds, type = "t")





## ----nmds_nice, include = TRUE, echo = TRUE, purl = TRUE, eval = FALSE------------------------------------------------------------------------------------
## sumcols <- colSums(varespec_fin)
## # calculate sum of columns, i.e. total abundance of species. If two species would be plotted
## # on top of each other in the ordination, select the species that has higher column sums.
## par(cex = 1.5)
## # preparation for plotting, create empty plot that will be manually filled
## plot(specnmds, dis = "sp", type = "n")
## orditorp(specnmds, display = "sp", priority = sumcols, col = "red", pcol = "black", pch = "+", cex = 0.8)
## # species scores are obtained by weighted averaging as for RDA (using WA scores)
## # add sites
## orditorp(specnmds, display = "sites", col = "blue", pcol = "lightblue", pch = "#", cex = 0.8)





## ----nmds_stress, include = TRUE, echo = TRUE, purl = TRUE, eval = FALSE----------------------------------------------------------------------------------
## stressplot(specnmds, main = "Shepard plot")





## ----nmds_goodness, include = TRUE, echo = TRUE, purl = TRUE, eval = FALSE--------------------------------------------------------------------------------
## # calculate goodness of fit per site
## good_site <- goodness(specnmds)
## par(cex = 2.5)
## plot(specnmds, type = "t", main = "Goodness of fit")
## points(specnmds, display = "sites", cex = 2*good_site/mean(good_site))





## ----nmds_3d, include = TRUE, echo = TRUE, purl = TRUE, eval = FALSE--------------------------------------------------------------------------------------
## library(vegan3d)
## # in case you need to install this library, run:
## # install.packages("vegan3d")
## # and then execute the function above
## 
## # 3d plot for a model object  with 3 dimensions nmds_3d
## ordirgl(nmds_3d, type = "t")








## ----pyrifos_backtrans, include = TRUE, echo = TRUE, purl = TRUE, eval = TRUE-----------------------------------------------------------------------------
pyrifos_t <- round((exp(pyrifos_fin) - 1)/10)


## ----pyrifos_mvglm_fit_1, include = TRUE, echo = TRUE, purl = TRUE, eval = TRUE---------------------------------------------------------------------------
library(mvabund)
# convert to mvabund object
pyrifos_mv <- mvabund(pyrifos_t)
# combine into dataframe
env <- data.frame(conc, week)
# fit GLMmv
mod_full <- manyglm(pyrifos_mv ~ conc + week + conc:week, data = env, family = "poisson")


## ----model_inspect_1, include = TRUE, echo = TRUE, purl = TRUE, eval = TRUE-------------------------------------------------------------------------------
plot(mod_full)


## ----pyrifos_mvglm_fit_2, include = TRUE, echo = TRUE, purl = TRUE, eval = TRUE---------------------------------------------------------------------------
# fit GLMmv
mod_full_nb <- manyglm(pyrifos_mv ~ conc + week + conc:week, data = env, family = "negative.binomial")
# inspect model
plot(mod_full_nb)


## ----mean_var_pyrifos, include = TRUE, echo = TRUE, purl = TRUE, eval = TRUE------------------------------------------------------------------------------
meanvar.plot(pyrifos_mv ~ conc)
abline(a = 0, b = 1, col = "green")


## ----permutations_GLMmv, include = TRUE, echo = TRUE, purl = TRUE, eval = TRUE----------------------------------------------------------------------------
# define permutation scheme
control <- how(within = Within(type = "none"), plots = Plots(strata = factor(ditch), type = "free"), nperm = 99)
# construct permutation matrix
set.seed(222)
permutations <- shuffleSet(nrow(pyrifos_t), control = control)
# show permutation matrix
permutations[1:10, 1:24]


## ----GLMmv_anova, include = TRUE, echo = TRUE, purl = TRUE, eval = TRUE-----------------------------------------------------------------------------------
# note that the function may run about 3 mins
aov_mglm <- anova(mod_full_nb, bootID = permutations, test = "LR", p.uni = "adjusted", rep.seed = TRUE)
aov_mglm$table


## ----GLMmv_example_access, include = TRUE, echo = TRUE, purl = TRUE, eval = FALSE-------------------------------------------------------------------------
## # access test statistics (deviance)
## aov_mglm$uni.test
## # access p-values
## aov_mglm$uni.p


## ----GLMmv_extract_uni, include = TRUE, echo = TRUE, purl = TRUE, eval = TRUE-----------------------------------------------------------------------------
# deviance of all taxa for treatment variable conc
aov_mglm$uni.test[ 2, ]
# deviance of top 10 taxa
(topt_GLMmv_conc <- sort(aov_mglm$uni.test[2, ], dec = TRUE)[1:10])
# compute fraction of total deviance from fitted model
# total deviance from model
total_dev_conc <- aov_mglm$table[2,3]
# calculate fraction
sum(topt_GLMmv_conc)/total_dev_conc


## ----GLMmv_mod_comp, include = TRUE, echo = TRUE, purl = TRUE, eval = TRUE--------------------------------------------------------------------------------
# fit reduced model
mod_reduced_nb <- manyglm(pyrifos_mv ~ week, data = env, family = "negative.binomial")
aov_mglm2 <- anova(mod_reduced_nb, mod_full_nb, bootID = permutations, p.uni = "adjusted", test = "LR", rep.seed = TRUE)

