## ----load_data, include = TRUE, echo = TRUE, purl = TRUE, context = "setup"--------------------------------------
data_oc <- read.csv("https://raw.githubusercontent.com/rbslandau/Data_analysis/master/Data/OstraMRegS400JB.txt", sep = "\t")





## ----data_range_summ, include = TRUE, echo = TRUE, purl = TRUE---------------------------------------------------
summary(data_oc2)


## ----data_range_hist, include = TRUE, echo = TRUE, purl = TRUE---------------------------------------------------
par(mfrow = c(1, 3))
hist(data_oc2$DP)
hist(data_oc2$RC)
hist(data_oc2$BT)
hist(data_oc2$SA)
hist(data_oc2$SP)
hist(data_oc2$IC)
hist(data_oc2$P)
hist(data_oc2$LAT)
hist(data_oc2$LON)


## ----data_range_hist3, include = TRUE, echo = TRUE, purl = TRUE--------------------------------------------------
hist(log10(data_oc2$DP))


## ----add_variable, include = TRUE, echo = TRUE, context = "setup"------------------------------------------------
data_oc2$DPlog <- log10(data_oc$DP)




## ----remove_vars2, include = TRUE, echo = TRUE, context = "setup"------------------------------------------------
data_check <- data_oc2[ , !names(data_oc2) %in% c("E100", "DP", "SR")]

## ----data_callin_code, include = TRUE, echo = TRUE, eval = FALSE-------------------------------------------------
## library(ggplot2)
## library(GGally)
## # We define a function to change the colour of points and lines (otherwise both are black)
## lowerFn <- function(data, mapping, method = "lm", ...) {
##   p <- ggplot(data = data, mapping = mapping) +
##               geom_point(colour = "blue") +
##               geom_smooth(method = method, color = "red", ...)
##   p
## }
## # Run ggpairs()
## ggpairs(data_check, lower = list(continuous = wrap(lowerFn, method = "lm")),
##                     diag = list(continuous = wrap("densityDiag", colour = "blue")),
##                     upper = list(continuous = wrap("cor", size = 10)))







## ----vif_prep, include = TRUE, echo = TRUE-----------------------------------------------------------------------
mod_vif <- lm(data_oc2$E100 ~ ., data = data_check)


## ----vif_calc, include = TRUE, echo = TRUE-----------------------------------------------------------------------
library(car)
vif(mod_vif)


## ----vif_proof, include = TRUE, echo = TRUE----------------------------------------------------------------------
mod_vifb <- lm(data_check$IC ~ ., data = data_check[ , names(data_check) != "IC"])
r2 <- summary.lm(mod_vifb)$r.squared
1 / (1 - r2)





## ----sample_size, include = TRUE, echo = TRUE--------------------------------------------------------------------
library(Hmisc)
describe(data_env)




## ----full_mod, include = TRUE, echo = TRUE, context = "setup"----------------------------------------------------
mod_1 <- lm(data_oc2$E100 ~ . + BT:SP, data = data_env, na.action = "na.fail")
summary(mod_1)


## ----full_mod_wo_inter, include = TRUE, echo = TRUE--------------------------------------------------------------
mod_1_wointer <- update(mod_1, . ~ . -1)
summary(mod_1_wointer)




## ----full_mod_outputanova, include = TRUE, echo = TRUE-----------------------------------------------------------
library(car)
Anova(mod_1, type = 2)




## ----all_mods, include = TRUE, echo = TRUE-----------------------------------------------------------------------
library(MuMIn)
allmodels <- dredge(mod_1, extra = "R^2")
print(allmodels)


## ----extr_top_mod, include = TRUE, echo = TRUE-------------------------------------------------------------------
topmod <- get.models(allmodels, subset = 1)
print(topmod)


## ----model_avg_mod, include = TRUE, echo = TRUE------------------------------------------------------------------
library(MuMIn)
avg_model <- model.avg(allmodels, subset = delta < 2, fit = TRUE)
summary(avg_model)


## ----recalc_models, include = TRUE, echo = TRUE------------------------------------------------------------------
allmodels2 <- dredge(mod_1, extra = "R^2", rank = "BIC")
avg_model_bic <- model.avg(allmodels2, subset = delta < 2, fit = TRUE)
summary(avg_model_bic)





## ----model_avg_accuracy_meas, include = TRUE, echo = TRUE--------------------------------------------------------
fit_y <-  predict(avg_model)
res_ssq_avg <- sum((data_oc2$E100 - fit_y) ^ 2)
tot_ssq_avg <- sum((data_oc2$E100 - mean(data_oc2$E100)) ^ 2)
# Based on the residual sum of squares and the total sum of squares we can compute the R^2:
1 - res_ssq_avg / tot_ssq_avg








## ----stepwise_mod1, include = TRUE, echo = TRUE, context = "setup"-----------------------------------------------
summary(mod_1)
# Remove interaction
mod_2 <- update(mod_1, ~. - BT:SP)
# Check model
summary(mod_2)


## ----stepwise_mod2, include = TRUE, echo = TRUE------------------------------------------------------------------
# Regression output
summary(mod_2)
# Anova Type 2 output
Anova(mod_2, type = 2)
# Output of partial F-test
mod_3 <- update(mod_2, ~. - LAT)
anova(mod_2, mod_3)
# Output of drop1
drop1(mod_2, test = "F")





## ----stepwise_mod_anova, include = TRUE, echo = TRUE-------------------------------------------------------------
anova(mod_1, mod_3)





## ----stepwise_inform_theoretic, include = TRUE, echo = TRUE------------------------------------------------------
# Calculation of AIC
AIC(mod_1)
AIC(mod_2)
# Calculation of BIC
BIC(mod_1)
BIC(mod_2)
# Calculation of corrected AIC
library(MuMIn)
AICc(mod_1)
AICc(mod_2)





## ----manual_calc_AICc, include = TRUE, echo = TRUE---------------------------------------------------------------
# extract number of parameters and add 1 for the estimated variance
p <- length(mod_1$coefficients) + 1
# extract sample size
n <- nrow(data_env)
# calculate corrected AIC:
AIC(mod_1) + 2 * p * (p + 1) / (n - p - 1)

# Same as
library(MuMIn)
AICc(mod_1)


## ----auto_modelling, include = TRUE, echo = TRUE-----------------------------------------------------------------
# fit intercept-only nullmodel: no variables, only mean
nullmodel <- lm(data_oc2$E100 ~ 1, data = data_env)
# start stepwise algorithm
step(object = mod_1, scope = list(upper = mod_1, lower = nullmodel), direction = "backward", trace = 100, k = log(n))


## ----auto_modelling2, include = TRUE, echo = TRUE----------------------------------------------------------------
step(
  nullmodel, direction = "forward", trace = 100,
  scope = list(upper = mod_1, lower = nullmodel), k = log(n)
)









## ----rela_impo, include = TRUE, echo = TRUE----------------------------------------------------------------------
library(relaimpo)
pred_imp_lmg <- calc.relimp(mod_2, type = c("lmg"), rela = TRUE)
pred_imp_beta <- calc.relimp(mod_2, type = c("betasq"), rela = TRUE)
plot(pred_imp_lmg, main = "")
plot(pred_imp_beta, main = "")


## ----rela_hierpart, include = TRUE, echo = TRUE------------------------------------------------------------------
library(hier.part)
hier.part(y = data_oc2$E100, xcan = data_env, gof = "Rsqu")




## ----shrink_prep, include = TRUE, echo = TRUE--------------------------------------------------------------------
mod_5_s <- lm(data_oc2$E100 ~ BT + SP + P + LON + DPlog, data = data_env, x = TRUE, y = TRUE)


## ----shrink_conduc, include = TRUE, echo = TRUE------------------------------------------------------------------
library(shrink)
# global shrinkage
shrink_res1 <- shrink(mod_5_s, type = "global")
shrink_res1
# reproduce results manually
coef(mod_5_s)[-1] * shrink_res1$ShrinkageFactors
# note that the intercept is removed because the intercept requires no shrinkage

# parameterwise shrinkage
shrink_res2 <- shrink(mod_5_s, type = "parameterwise")
shrink_res2




## ----lasso_1, include = TRUE, echo = TRUE------------------------------------------------------------------------
library(glmnet)
# fit model with lasso, requires predictors as matrix
# and response as vector
lasso_mod <- glmnet(x = as.matrix(data_env), y = data_oc2$E100)
plot(lasso_mod, label = TRUE)


## ----lasso_2, include = TRUE, echo = TRUE------------------------------------------------------------------------
plot(lasso_mod, label = TRUE, xvar = "lambda")
plot(lasso_mod, label = TRUE, xvar = "dev")


## ----lasso_cv, include = TRUE, echo = TRUE-----------------------------------------------------------------------
# set seed to make reproducible
set.seed(111)
cvfit <- cv.glmnet(as.matrix(data_env), data_oc2$E100)
plot(cvfit)


## ----lasso_extract, include = TRUE, echo = TRUE------------------------------------------------------------------
# extract lambdas
cvfit$lambda.min
cvfit$lambda.1se
# extract regression coefficients
coef(cvfit, s = "lambda.min")
coef(cvfit, s = "lambda.1se")


## ----lasso_extract_zero, include = TRUE, echo = TRUE-------------------------------------------------------------
coef(cvfit, s = 1)


## ----lasso_stabsel, include = TRUE, echo = TRUE------------------------------------------------------------------
library(stabs)
## make reproducible
set.seed(1204)
(stab.lasso <- stabsel(x = as.matrix(data_env), y = data_oc2$E100,
                       fitfun = glmnet.lasso, cutoff = 0.70, PFER = 1))
# plot estimate for selection probability
plot(stab.lasso, main = "Lasso")



## ----mod_vis_pedagog, include = TRUE, echo = TRUE----------------------------------------------------------------
library(car)
mcPlots(mod_2, ~SP, overlaid = FALSE)


## ----mod_vis_effects, include = TRUE, echo = TRUE----------------------------------------------------------------
library(effects)
plot(predictorEffects(mod = mod_5_s, predictor = "SP"), ylab = "Rarefied richness (100 ind.)")
plot(predictorEffects(mod = mod_5_s, predictor = "BT"), ylab = "Rarefied richness (100 ind.)")
plot(predictorEffects(mod = mod_5_s, predictor = "DPlog"), ylab = "Rarefied richness (100 ind.)")


## ----select_inf, include = TRUE, echo = TRUE---------------------------------------------------------------------
# load library for functions
library(selectiveInference)
# fit model
# the function requires that the object with the predictors is of class matrix
# and the response should be of class vector
fs_model <- fs(as.matrix(data_env), data_oc2$E100)
# we plot the model
plot(fs_model)
# Displays change in coefficients over stepwise process
# inference for model
fsInf(fs_model)


## ----select_inf_names, include = TRUE, echo = TRUE---------------------------------------------------------------
names(data_env)


## ----select_inf_final, include = TRUE, echo = TRUE---------------------------------------------------------------
coef(fs_model, s = 4)


## ----bootstrapping_BIC, include = TRUE, echo = TRUE--------------------------------------------------------------
library(bootStepAIC)
# set seed to make analysis reproducible
set.seed(111)
# See help for details on function
# as before k can be used to select BIC
boot.stepAIC(object = mod_1, data = data_env, k = log(n), direction = "backward")

