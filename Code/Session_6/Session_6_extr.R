## ----load_data, include = TRUE, echo = TRUE, purl = TRUE-----------------
library(DAAG)
# display first rows
head(frogs)

## ----gen_response, include = TRUE, echo = TRUE, purl = TRUE--------------
# generate response with error
resp <- -15 + 0.1* frogs$avrain + rnorm(length(frogs$avrain), sd = 2)

## ----rel_resp_avrain, include = TRUE, echo = TRUE, purl = TRUE-----------
library(xkcd)
library(extrafont)
library(ggplot2)
# create plot
p <- ggplot() + geom_point(aes(x = frogs$avrain, y = resp), color='blue') + 
    theme(text = element_text(size = 20, family = "xkcd")) + xlab("Average rain in spring") + ylab ("Response") +
    geom_smooth(method = "lm", aes(x = frogs$avrain, y = resp))
p

## ----logit_avrain, include = TRUE, echo = TRUE, purl = TRUE--------------
# convert response to probability
pr <- exp(resp) / ( 1 + exp(resp))
# use probabilities to sample from distribution
resp_obs <- rbinom(length(frogs$avrain), 1, pr)

# fit linear model and extract fitted values
lm_mod  <- lm(resp ~ frogs$avrain)
fit_values <- fitted(lm_mod)
# convert fitted values to fitted probabilities using logit
pr_fit <- exp(fit_values) / ( 1 + exp(fit_values))
# plot model
p2 <- ggplot() + geom_point(aes(x = frogs$avrain, y = resp_obs), color='blue') + geom_line(aes(x = frogs$avrain, y = pr_fit), color='blue') + 
    theme(text = element_text(size = 20, family = "xkcd")) + xlab("Average rain in spring") + ylab ("Transformed response")
p2

## ----spm_code, include = TRUE, echo = TRUE, eval = FALSE-----------------
## library(car)
## spm(frogs[, c(4:10)])

## ----trans_check, exercise = TRUE, eval = FALSE--------------------------
## par(mfrow = c(1, 3))
## for (nam in c("distance", "NoOfPools")) {
##   y <- frogs[, nam]
##   plot(density(y), main = "", xlab = nam)
##   plot(density(sqrt(y)), main = "", xlab = nam)
##   plot(density(log(y)), main = "", xlab = nam)
## }

## ----transformation,  include = TRUE, echo = TRUE, purl = TRUE, context = "setup"----
# log transformation of NoOfPools and distance,
logNoPools <- log(frogs$NoOfPools)
logdistance <- log(frogs$distance)
# create easily accessible data sets
predictors <- data.frame(frogs[ , c(4, 7:10)], logNoPools, logdistance)
resp_frogs <- frogs$pres.abs

## ----coll_check, include = TRUE, echo = TRUE, eval = FALSE---------------
## spm(predictors)

## ----vif,  include = TRUE, echo = TRUE, purl = TRUE----------------------
frog.glm <- glm(resp_frogs ~ ., family = binomial(link = "logit"),
                data = predictors, na.action = "na.fail")
vif(frog.glm)

## ----vif_recalc,  include = TRUE, echo = TRUE, purl = TRUE---------------
frog.glm2 <- glm(resp_frogs ~ logNoPools + logdistance + NoOfSites + avrain + I(meanmin + meanmax),
                family = binomial(link = "logit"), data = predictors, na.action = "na.fail")
vif(frog.glm2)

## ----Wald_select1,  include = TRUE, echo = TRUE, purl = TRUE-------------
summary(frog.glm2)

## ----Wald_select2,  include = TRUE, echo = TRUE, purl = TRUE-------------
frog.glm3 <- update(frog.glm2, ~ . - NoOfSites)
summary(frog.glm3)

## ----LRT_1,  include = TRUE, echo = TRUE, purl = TRUE--------------------
anova(frog.glm3, frog.glm2, test = "Chisq")

## ----likelihood_manual,  include = TRUE, echo = TRUE, purl = TRUE--------
LL1 <- logLik(frog.glm2)
LL2 <- logLik(frog.glm3)

## ----likelihood_manual_2,  include = TRUE, echo = TRUE, purl = TRUE------
# calculate difference
-2*(LL2-LL1)
# compare to chi-square distribution
pchisq(-2*(LL2-LL1), df = 1, lower.tail=FALSE)

## ----drop1_LRT,  include = TRUE, echo = TRUE, purl = TRUE----------------
drop1(frog.glm3, test = "Chisq")

## ----sequ_LRT,  include = TRUE, echo = TRUE, purl = TRUE-----------------
anova(frog.glm3, test = "Chisq")

## ----typetwo_LRT,  include = TRUE, echo = TRUE, purl = TRUE--------------
library(car)
Anova(frog.glm3)

## ----information_theoretic,  include = TRUE, echo = TRUE, purl = TRUE----
# calculation of AIC
AIC(frog.glm2)
AIC(frog.glm3)
# calculation of BIC
BIC(frog.glm2)
BIC(frog.glm3)
# calculation of drop1 for AIC
drop1(frog.glm3)
# calculation of drop1 for BIC
# requires sample size n
samp_size_n <- nrow(predictors)
drop1(frog.glm3, k = log(samp_size_n))

## ----lasso_glm_1, include = TRUE, echo = TRUE, context = "data"----------
library(dplyr)
# add combined variable
predictors_new <- predictors %>%
              mutate(mean_maxmin = meanmin + meanmax)
# remove collinear variables
drop_cols <- c("altitude", "meanmin", "meanmax")
predictors_lasso <- predictors_new %>% 
                               select(-one_of(drop_cols))

## ----lasso_glm_2, include = TRUE, echo = TRUE----------------------------
library(glmnet)
# fit model with lasso, requires predictors as matrix
# and response as vector
lasso_mod <- glmnet(x = as.matrix(predictors_lasso), y = resp_frogs, family = "binomial")
par(cex = 1.2)
plot(lasso_mod, label = TRUE, xvar = "lambda")

## ----lasso_plot_dev, include = TRUE, echo = TRUE-------------------------
plot(lasso_mod, label = TRUE, xvar = "dev")

## ----deviance_expl, include = TRUE, echo = TRUE--------------------------
library(modEvA)
Dsquared(frog.glm3)

## ----lasso_cv, include = TRUE, echo = TRUE-------------------------------
# set seed to make reproducible
set.seed(222)
cvfit <- cv.glmnet(x = as.matrix(predictors_lasso), y = resp_frogs, family = "binomial")
plot(cvfit)

## ----lasso_coefs, include = TRUE, echo = TRUE----------------------------
coef(cvfit, s = "lambda.min")
coef(cvfit, s = "lambda.1se")

## ----summary_disp, include = TRUE, echo = TRUE---------------------------
summary(frog.glm3)

## ----residuals_disp, include = TRUE, echo = TRUE-------------------------
# extract residuals
pearson_resid <- residuals(frog.glm, type = "pearson")
# calculate sum of squared residuals
sum_square_resid <- sum(pearson_resid^2)
# divide by degrees of freedom
sum_square_resid/df.residual(frog.glm)

## ----dharma_disp, include = TRUE, echo = TRUE----------------------------
library(DHARMa)
sim_glm3 <- simulateResiduals(frog.glm3)
# plot residuals
plot(sim_glm3)
# statistical test
testDispersion(sim_glm3)

## ----dharma_disp_simul, include = TRUE, echo = TRUE---------------------------- 
# load library
library(DHARMa)
# Create overdispersed data using a function in the package
Overdisp_data <- createData(sampleSize = 200, overdispersion = 2.5, family = poisson())
# Fit GLM
Overdisp_mod <- glm(observedResponse ~ Environment1 , family = "poisson", data = Overdisp_data)
# Simulate residuals
Simul_output <- simulateResiduals(fittedModel = Overdisp_mod)
# Diagnostic plots
plot(Simul_output)
# statistical test
testDispersion(Simul_output)

## ----residual_plot_per_component, include = TRUE, echo = TRUE------------
plotResiduals(sim_glm3, form = predictors_lasso$logNoPools)
plotResiduals(sim_glm3, form = predictors_lasso$logdistance)
plotResiduals(sim_glm3, form = predictors_lasso$avrain)
plotResiduals(sim_glm3, form = predictors_lasso$mean_maxmin)

## ----residual_plot_diag1, include = TRUE, echo = TRUE--------------------
plotResiduals(sim_glm3, form = frogs$distance)

## ----simul_quad_prep, include = TRUE, echo = TRUE------------------------
# define maximum and minimum of gradient and difference between possible values
seq_vals <- seq(from = -10, to = 10, by = 0.01)
# draw 50 samples from gradient -> random gradient
set.seed(222) # make example reproducible
x <- sample(seq_vals, size = 50, replace = TRUE)
# generate quadratic response and add random error
resp_new <-  0.1* x^2 - 0.1 * x -3 + rnorm(length(x), sd = 1)
# convert response to probability pi
prob_new <- exp(resp_new) / ( 1 + exp(resp_new))
# use pis to sample from binomial distribution
resp_obs_new <- rbinom(length(x), 1, prob_new)

## ----simul_quad, include = TRUE, echo = TRUE-----------------------------
# fit GLM
mod_quad <- glm(resp_obs_new ~ x, family = binomial(link = "logit"))
# simulate residuals
sim_quad_mod <- simulateResiduals(mod_quad)
# plot residuals
set.seed(111)
plot(sim_quad_mod)
# call summary
summary(mod_quad)

## ----rootogram, include = TRUE, echo = TRUE, eval = FALSE----------------
## install.packages("countreg", repos="http://R-Forge.R-project.org")
## library(countreg)
## rootogram(<glm.model>)

## ----cooks_leverage, include = TRUE, echo = TRUE, eval = TRUE------------
library(ggplot2)
library(ggfortify)
par(mfrow = c(1, 1))
autoplot(frog.glm3, which = 5)

## ----cooks_leverage_index, include = TRUE, echo = TRUE, eval = TRUE------
library(car)
influenceIndexPlot(frog.glm3, vars = c("Cook"), id = TRUE, grid = TRUE)
influenceIndexPlot(frog.glm3, vars = c("hat"), id = TRUE, grid = TRUE)

## ----comp_coeffs, include = TRUE, echo = TRUE, eval = TRUE---------------
# remove observations using subset
frog.glm3_red <- update(frog.glm3, subset = -c(77, 182))
compareCoefs(frog.glm3, frog.glm3_red)

## ----mod_vis_effects, include = TRUE, echo = TRUE------------------------
# calculate combined variable
meanmix <- frogs$meanmax + frogs$meanmin
# refit model
frog.glm3b <- glm(resp_frogs ~ logNoPools + logdistance + avrain + meanmix,
                 family = binomial(link = "logit"), data = predictors, na.action = "na.fail")
# create plots
library(effects)
plot(predictorEffects(frog.glm3b, predictor = ~ logNoPools), ylab = "Probability of occurrence")
plot(predictorEffects(frog.glm3b, predictor = ~ logdistance), ylab = "Probability of occurrence")
plot(predictorEffects(frog.glm3b, predictor = ~ avrain), ylab = "Probability of occurrence")
plot(predictorEffects(frog.glm3b, predictor = ~ meanmix), ylab = "Probability of occurrence")

## ----mod_vis_effects_scales, include = TRUE, echo = TRUE-----------------
plot(predictorEffects(frog.glm3b, predictor = ~ meanmix), axes=list(y=list(type="link", lab="logit scale, logit labels")))
plot(predictorEffects(frog.glm3b, predictor = ~ meanmix), axes=list(y=list(type="response", lab="response scale, probability labels")))

## ----mod_vis_effects_pr, include = TRUE, echo = TRUE---------------------
plot(predictorEffects(frog.glm3b, predictor = ~ meanmix, residuals = TRUE), ylab = "Logit of estimated probabilities", axes=list(y=list(type="link")))

## ----quadmod_vis_effects_pr, include = TRUE, echo = TRUE-----------------
plot(predictorEffects(mod_quad, residuals = TRUE), ylab = "Logit of estimated probabilities", axes=list(y=list(type="link")))

