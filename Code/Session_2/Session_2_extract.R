## ----setup, include=FALSE, context = "setup"-----------------------------
library(learnr)
library(sandwich)
library(lmtest)
library(vegan)
data("varechem") 
knitr::opts_chunk$set(echo = FALSE)

## ----data, echo = TRUE, include = TRUE-----------------------------------
data("varechem")

## ----data_inspec, exercise = TRUE----------------------------------------
?varechem
head()

## ----linmod, echo = TRUE, include = TRUE, context = "setup"--------------
mod_1 <- lm(S ~ K, data = varechem)

## ----linmod_plot, echo = TRUE, include = TRUE----------------------------
par(cex = 1.4, las = 1)
plot(S ~ K, data = varechem, ylab = "S mg/kg", xlab = "K mg/kg")
abline(mod_1, lwd = 2)

## ----linmod_sum, echo = TRUE, include = TRUE-----------------------------
summary.lm(mod_1)

## ----matrix_mult-solution------------------------------------------------
# Create vector of 1s as intercept term 
inter <- rep(1, nrow(varechem))
inter
#  Combine intercept term with values from X (K)
full <- cbind(inter, varechem$K)
full

# Implement the equation for the calculation of b in R:
betas <- solve(t(full) %*% full) %*% (t(full) %*% varechem$S)
betas

## ----matrix_mult_2, exercise = TRUE--------------------------------------
coef(mod_1)

## ----linmod_intervals, exercise=TRUE, exercise.eval = TRUE, exercise.lines = 4----
ci <- predict(mod_1, interval = "confidence", level = 0.95)
pi <- predict(mod_1, interval = "prediction", level = 0.95)

## ----linmod_int_plot, echo = TRUE, include = TRUE------------------------
par(las = 1, cex = 1.8, mar = c(5,5,1,1))
plot(S ~ K, data = varechem, ylab = expression(paste("S (mg ", kg^-1,")")), xlab = expression(paste("K (mg ", kg^-1,")")))
abline(mod_1, lwd = 2)
lines(sort(varechem$K), ci[order(varechem$K) ,2], lty = 2, col = 'blue', lwd = 2)
lines(sort(varechem$K), ci[order(varechem$K) ,3], lty = 2, col = 'blue', lwd = 2)
lines(sort(varechem$K), pi[order(varechem$K) ,2], lty = 2, col = 'red', lwd = 2)
lines(sort(varechem$K), pi[order(varechem$K) ,3], lty = 2, col = 'red', lwd = 2)

## ----intervals_exer-hint-2-----------------------------------------------
ci2 <- predict(mod_1, interval = "confidence", level = 0.68)
par(las = 1, cex = 1.8, mar = c(5,5,1,1))
plot(S ~ K, data = varechem, ylab = expression(paste("S (mg ", kg^-1,")")), xlab = expression(paste("K (mg ", kg^-1,")")))
abline(mod_1, lwd = 2)
lines(sort(varechem$K), ci2[order(varechem$K) ,2], lty = 2, col = 'blue', lwd = 2)
lines(sort(varechem$K), ci2[order(varechem$K) ,3], lty = 2, col = 'blue', lwd = 2)

## ----summary_linmod, echo = TRUE, include = TRUE-------------------------
summary(mod_1)

## ----anova_linmod, echo = TRUE, include = TRUE---------------------------
anova(mod_1)

## ----linmod_diag_general, echo = TRUE, include = TRUE, eval = FALSE------
## par(mfrow = c(1, 4))
## plot(mod_1)

## ----linmod_diag_qq, echo = TRUE, include = TRUE-------------------------
par(mfrow = c(1, 1))
plot(mod_1, which = 2)

## ----linmod_diag_qq2, echo = TRUE, include = TRUE------------------------
library(DAAG)
qreference(rstandard(mod_1), nrep = 8, xlab = "Theoretical Quantiles")

## ----linmod_diag_assum, echo = TRUE, include = TRUE----------------------
par(mfrow = c(1,2))
plot(mod_1, which = c(1,3))

## ----setup_2, include = FALSE, context = "setup"-------------------------
set.seed(568)  # this makes the example exactly reproducible
# define parameters
n_start <- rep(1:100, 2)
n <- sort(n_start)
b0 <- 0
b1 <- 1
sigma2_a <- n^1.5
sigma2_b <- n^3
err_l <- rnorm(n, mean = 0, sd = sqrt(sigma2_a))
err_h <- rnorm(n, mean = 0, sd = sqrt(sigma2_b))
err_n <- rnorm(n, mean = 0, sd = 2)  
# set up different models
y_l   <- b0 + b1 * n + err_l
y_h   <- b0 + b1 * n + err_h
y_n   <- b0 + b1 * n + err_n
y_nl1 <- b1 * n + 0.5 * n^2 -0.04 * n^3 + err_n
y_nl2 <- b1 * n + 0.5 * n^2 -0.005 * n^3 + err_n
# model with linear model
mod_incvar <- lm(y_l ~ n)
mod_h <- lm(y_h ~ n)
mod_n <- lm(y_n ~ n)
mod_nl1 <- lm(y_nl1 ~ n)
mod_nl2 <- lm(y_nl2 ~ n)

## ----linmod_assum_test1, include = TRUE, echo = FALSE--------------------
par(mfrow = c(1,3))
plot(mod_incvar, which = c(1:3))

## ----linmod_assum_test2, include = TRUE, echo = FALSE--------------------
par(mfrow = c(1,3))
plot(mod_n, which = c(1:3))

## ----linmod_assum_test3, include = TRUE, echo = FALSE--------------------
par(mfrow = c(1,3))
plot(mod_h, which = c(1:3))

## ----linmod_assum_test4, include = TRUE, echo = FALSE--------------------
par(mfrow = c(1,3))
plot(mod_nl1, which = c(1:3))

## ----linmod_assum_test5, include = TRUE, echo = FALSE--------------------
par(mfrow = c(1,3))
plot(mod_nl2, which = c(1:3))

## ----linmod_hetero1, include = TRUE, echo = TRUE-------------------------
plot(y_l ~ n, xlab = "Explanatory variable", ylab = "Response", las = 1)
abline(mod_incvar)
par(mfrow = c(1,3))
plot(mod_incvar, which = c(1:3))

## ----linmod_hetero2, include = TRUE, echo = TRUE, context = "setup"------
library(sandwich)
library(lmtest)
# Calculate variance covariance matrix
corse_lm <- vcovHC(mod_incvar)
# Compare original and corrected standard errors
coeftest(mod_incvar)
coeftest(mod_incvar, vcov = corse_lm)

## ----heterosc_exer-solution----------------------------------------------
coeftest(mod_incvar, vcov = corse_lm)
summary(mod_incvar)

## ----linmod_nonlin1, include = TRUE, echo = TRUE-------------------------
mod_nl1 <- lm(y_nl1 ~ n)
plot(y_nl1 ~ n, xlab = "Explanatory variable", ylab = "Response", las = 1)
abline(mod_nl1, lwd = 2, col = "red")
par(mfrow = c(1,3))
plot(mod_nl1, which = c(1:3))
summary(mod_nl1)

## ----linmod_nonlin2, exercise = TRUE-------------------------------------
mod_nl1b <- lm(y_nl1 ~ n + I(n^2))
plot(y_nl1 ~ n, xlab = "Explanatory variable", ylab = "Response", las = 1)
# Extract fitted values
fit_nl1 <- predict(mod_nl1b)
# Plot
lines(n, fit_nl1, lwd = 2, col = "red")
par(mfrow = c(1,3))
plot(mod_nl1b, which = c(1:3))
summary(mod_nl1b)

## ----linmod_nonlin3-solution---------------------------------------------
mod_nl1c <- lm(y_nl1 ~ n + I(n^2) + I(n^3))
plot(y_nl1 ~ n, xlab = "Explanatory variable", ylab = "Response", las = 1)
# Extract fitted values
fit_nl2 <- predict(mod_nl1c)
# Plot
lines(n, fit_nl2, lwd = 2, col = "red")
par(mfrow = c(1,3))
plot(mod_nl1c, which = c(1:3))
summary(mod_nl1c)

## ----nonlin_corr, include = TRUE, echo = TRUE----------------------------
cor(n, n^2)

## ----linmod_cook, include = TRUE, echo = TRUE----------------------------
plot(mod_1, which = 5)

## ----linmod_all, include = TRUE, echo = TRUE-----------------------------
par(mfrow = c(1, 3))
plot(mod_1)

## ----linmod_dfbetas, include = TRUE, echo = TRUE-------------------------
# First display original coefficients
coef(mod_1)
# Inspect change in coefficients when removing the respective observation
dfbeta(mod_1)

## ----linmod_incvareaveout, include = TRUE, echo = TRUE, context = "setup"----
rem_obs <- which(rownames(varechem) == "9") 
mod_2 <- lm(S ~ K, data = varechem[-rem_obs, ])

## ----linmod_incvareaveout_exerc, exercise = TRUE-------------------------
# Plot without observation
plot(S ~ K, data = varechem[-rem_obs, ])
# Add point in different colour
points(varechem$K[rem_obs], varechem$S[rem_obs], col = "red")
# Plot both models
abline()
abline()
# Compare summaries
summary()
summary()
# The difference between the coefficients is reported with dfbeta
dfbeta(mod_1)[rem_obs, ]

## ----linmod_outputform, echo = TRUE, include = TRUE----------------------
library(sjPlot)
tab_model(mod_1)

