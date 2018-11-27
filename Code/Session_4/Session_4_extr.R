## ----data_imp, echo = TRUE, include = TRUE, context = "setup"------------
omb_dat <- read.csv("https://raw.githubusercontent.com/rbslandau/Function_div/master/omb.csv", sep = "", header = TRUE, as.is = TRUE)
# create categorical predictor from sampling site codes
omb_dat$Land_type <- substr(omb_dat$Sites, start = 1, stop = 1)
# quick look at dataframe
head(omb_dat)
# plot data 
library(beanplot)
par(cex = 1.3, las = 1)
beanplot(OMB ~ Land_type, data = omb_dat, 
         ylab = expression(italic("k")["inv"]), 
         xlab = "Land use type")

## ----two_level_preprocess, echo = TRUE, include = TRUE, message = FALSE, context = "setup"----
library(dplyr)
omb_two <- omb_dat %>% filter(Land_type == "A" | Land_type == "F")

## ----two_level_lm, echo = TRUE, include = TRUE, context = "setup"--------
mod_omb <- lm(OMB ~ Land_type, data = omb_two)
# show results
summary(mod_omb)
# Compare to the output of a t-test
t.test(OMB ~ Land_type, data = omb_two, var.equal = TRUE)

## ----two_level_fitted, echo = TRUE, include = TRUE-----------------------
fitted(mod_omb)

## ----two_level_fitted_calc, echo = TRUE, include = TRUE------------------
calc_obs <- fitted(mod_omb) + residuals(mod_omb)
# print beside original observations
print(cbind(omb_two$OMB, calc_obs))

## ----se_illustrated, echo = TRUE, include = TRUE-------------------------
# extract matrix X
X <- model.matrix(mod_omb)
# extract RMSE
rmse <- sigma(mod_omb)
# matrix operations
X_ops <- sqrt(diag(solve(t(X) %*% X)))
rmse * X_ops
# Matches with Std. Error from summary function
summary(mod_omb)

## ----exercise-fitmod-solution--------------------------------------------
mod_omb2 <- lm(OMB ~ Land_type, data = omb_dat)

## ----summary_mod_omb, echo = TRUE, include = TRUE------------------------
summary(mod_omb2)

## ----anova-mod, echo = TRUE, include = TRUE, context = "setup"-----------
mod_aov <- aov(OMB ~ Land_type, data = omb_dat)
summary(mod_aov)
# compare anova output to regression output 
summary(mod_omb2)

## ----anova-summary, echo = TRUE, include = TRUE--------------------------
summary.lm(mod_aov)

## ----anova-summary-comp, echo = TRUE, include = TRUE---------------------
summary(mod_omb2)

## ----model_check, echo = TRUE, include = TRUE----------------------------
par(mfrow = c(1,2))
plot(mod_aov, which = c(1,3))

## ----anova_variance_residuals, include= TRUE, echo = TRUE----------------
par(cex = 1.3, las = 1)
beanplot(residuals(mod_aov) ~ omb_dat$Land_type, 
         ylab = "Residual", 
         xlab = "Land use type")

## ----anova_normdist, include= TRUE, echo = TRUE--------------------------
library(DAAG)
# set seed to make example reproducible
set.seed(999)
qreference(residuals(mod_aov), nrep = 8)

## ----summary2_mod_omb, echo = TRUE, include = TRUE-----------------------
summary(mod_omb2)

## ----level_sort, include= TRUE, echo = TRUE, context = "setup"-----------
# Land_type currently is a character vector
str(omb_dat)
# A character vector is automatically converted to a factor when entered into a linear model
# To change the order of the levels, we need to convert the character vector to a factor
land_fac <- factor(omb_dat$Land_type)
levels(land_fac)

## ----contrast_1, echo = TRUE, include = TRUE-----------------------------
contrasts(land_fac)

## ----contrast_matrix, echo = TRUE, include = TRUE, context = "setup"-----
cont_matrix <- cbind(c(1,1,1,1), contrasts(land_fac))
cont_matrix

## ----contrast_inverse, echo = TRUE, include = TRUE, context = "setup"----
solve(cont_matrix)

## ----mod_omb_corrp, echo = TRUE, include = TRUE, context = "setup"-------
# Remember the original p-values
summary(mod_omb2)
# extract p-values for pairwise comparisons
summary(mod_omb2)$coefficients
# given in rows 2-4 of fourth column
p_vals <- summary(mod_omb2)$coefficients[ 2:4,4]
p.adjust(p_vals, method = "bonferroni")

## ----mod_omb_padj2, echo = TRUE, include = TRUE--------------------------
p.adjust(p_vals, method = "fdr")

## ----p_adj, echo = TRUE, include = TRUE----------------------------------
# we create a set of p-values:
p_values <- c(0.0001, 0.0001, 0.005, 0.01, 0.02, 0.04, 0.1, 0.5, 0.5, 0.8, 0.9, 0.9)
p.adjust(p_values, method = "fdr")
# compare to bonferroni correction
p.adjust(p_values, method = "bonferroni")

## ----load-data-pos, echo = TRUE, include = TRUE, context = "setup"-------
pos_dat <- read.table(url("http://www.uni-koblenz-landau.de/en/campus-landau/faculty7/environmental-sciences/landscape-ecology/Teaching/possum.csv"), dec = ".", sep = ";", header = TRUE, row.names = NULL)
# look at observations across factor levels
xtabs(~ sex + Pop, data = pos_dat)

## ----lm-pos2, echo = TRUE, include = TRUE, context = "setup"-------------
pos_mod <- lm(totlngth ~ sex * Pop, data = pos_dat)
summary(pos_mod) # equivalent to summary.lm()
summary.aov(pos_mod)

## ----lm-anova, echo = TRUE, include = TRUE, context = "setup"------------
null_mod <- lm(totlngth ~ 1, data = pos_dat)
summary(null_mod)

## ----lm-anova2, echo = TRUE, include = TRUE------------------------------
anova(null_mod, pos_mod)
summary(pos_mod)

## ----anova_type3, echo = TRUE, include = TRUE, context = "setup"---------
library(car)
Anova(pos_mod, type = 3)
# compare to model with different sequence
pos_mod2 <- lm(totlngth ~ Pop * sex, data = pos_dat)
Anova(pos_mod2, type = 3)
# Set orthogonal contrasts
contrasts(pos_dat$Pop) <- contrasts(pos_dat$sex) <- "contr.sum"
# update models
pos_mod_ortho <- update(pos_mod)
pos_mod_ortho2 <- update(pos_mod2)
Anova(pos_mod_ortho, type = 3)
Anova(pos_mod_ortho2, type = 3)

## ----sjPlot, echo = TRUE, include = TRUE---------------------------------
library(sjPlot)
plot_model(pos_mod, type = "int", title = "", axis.title = c("Sex of possum", "Total lenght of possum in cm"), axis.lim = c(80,95), legend.title = "Population")

## ----interaction_plot, echo = TRUE, include = TRUE, purl = TRUE----------
library(png)
img <- readPNG('Riesch_etal_figs.png')
grid::grid.raster(img)

## ----interaction-data1, echo = TRUE, include = TRUE, context = "setup"----
# create data
data 	<- c(17,18,18,19,20, 17,18,18,19,20,17,18,18,19,20,70,75,77,80,71)
factor1 	<- c(rep("control", 5), rep("treated", 5), rep("control", 5), rep("treated", 5))
factor2 <- c(rep("low", 10), rep("high", 10))
dataset <- data.frame(data, factor1, factor2)
dataset$factor2 <- relevel(dataset$factor2, ref = "low")
# set orthogonal contrast for Type 3 ANOVA
xtabs(~ factor1 + factor2, data = dataset)
contrasts(dataset$factor1) <- contrasts(dataset$factor2) <- "contr.sum"

## ----interaction-modelfit1, echo = TRUE, include = TRUE------------------
mod <- lm(data ~ factor1*factor2, data = dataset)
summary.lm(mod)
plot_model(mod, type = "int", title = "", axis.title = c("Factor 1", "Response"), axis.lim = c(10,85), legend.title = "Factor 2")
Anova(mod, type = 2)
Anova(mod, type = 3)
summary.aov(mod)

## ----interaction-data2, echo = TRUE, include = TRUE, context = "setup"----
# create data sets
resp1 <- c(20:25, 25:30, 27:32, 70:75)
fact1 <- c(rep("Control", 12), rep("Treat", 12))
fact2 <- c(rep("Low", 6), rep("High", 6), rep("Low", 6), rep("High", 6))
data1 <- data.frame(resp1, fact1, fact2)
data1$fact2 <- relevel(data1$fact2, ref = "Low")
# set orthogonal contrast for Type 3 ANOVA
contrasts(data1$fact1) <- contrasts(data1$fact2) <- "contr.sum"
xtabs(~ fact1 + fact2, data = data1)

## ----interaction-modelfit2, echo = TRUE, include = TRUE------------------
mod1 <- lm(resp1 ~ fact1*fact2, data = data1)
summary.lm(mod1)
plot_model(mod1, type = "int", title = "", axis.title = c("Factor 1", "Response"), axis.lim = c(10,85), legend.title = "Factor 2")
Anova(mod1, type = 2)
Anova(mod1, type = 3)
summary.aov(mod1)

## ----ancova_1, echo = TRUE, include = TRUE-------------------------------
anc_mod <- lm(totlngth ~ sex * skullw, data = pos_dat)
summary.lm(anc_mod)
Anova(anc_mod, type = 2)
library(ggplot2)
pred <- predict(anc_mod)
ggplot(cbind(pos_dat, pred), aes(x = skullw, y = totlngth, colour = sex)) + 
  geom_line(aes(y = pred)) + geom_point() +
  xlab("Skull width (cm)") + ylab("Total lenght of possum in cm")

## ----ancova_2, echo = TRUE, include = TRUE-------------------------------
anc_mod2 <- update(anc_mod, .~. -sex:skullw)
summary.lm(anc_mod2)
Anova(anc_mod2, type = 2)
library(ggplot2)
pred2 <- predict(anc_mod2)
ggplot(cbind(pos_dat, pred2), aes(x = skullw, y = totlngth, colour = sex)) + 
  geom_line(aes(y = pred2)) + geom_point() +
  xlab("Skull width (cm)") + ylab("Total lenght of possum in cm")

