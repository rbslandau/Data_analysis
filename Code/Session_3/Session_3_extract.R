## ----setup, include=FALSE------------------------------------------------
library(learnr)
knitr::opts_chunk$set(echo = FALSE)

## ----load-data, echo = FALSE, include = FALSE, context = "setup"---------
pos_dat <- read.table(url("http://www.uni-koblenz-landau.de/en/campus-landau/faculty7/environmental-sciences/landscape-ecology/Teaching/possum.csv"), dec = ".", sep = ";", header = TRUE, row.names = NULL)

## ----beanplot, exercise = TRUE, exercise.eval = TRUE---------------------
library(beanplot)


## ----beanplot-hint-2-----------------------------------------------------
mean_pops <- tapply(pos_dat$totlngth, pos_dat$Pop, mean)
totlngth_sub <- pos_dat$totlngth - mean_pops[pos_dat$Pop]
beanplot(totlngth_sub ~ Pop, data = pos_dat, las = 1, cex.lab = 1.3,
ylab = "Distance to mean [cm]", xlab = "Possum population")

## ----explore-sd, echo = TRUE, include = TRUE-----------------------------
summary(pos_dat$Pop)
# Calculate standard deviation for each population
sd_pops <- tapply(pos_dat$totlngth, pos_dat$Pop, sd)
sd_pops
# Calculate ratio
sd_pops[2]/sd_pops[1]

## ----t_test_normaldist, echo = TRUE, include = TRUE----------------------
qqnorm(pos_dat$totlngth[pos_dat$Pop == "other" ], datax = TRUE)

## ----normaldist_ref-solution---------------------------------------------
library(DAAG)
# set seed to make example reproducible
set.seed(999)
qreference(pos_dat$totlngth[pos_dat$Pop == "other" ], nrep = 8)

## ----normaldist-exec2-solution-------------------------------------------
qqnorm(pos_dat$totlngth[pos_dat$Pop == "Vic" ], datax = TRUE)
# set seed to make example reproducible
set.seed(999)
qreference(pos_dat$totlngth[pos_dat$Pop == "Vic" ], nrep = 8)

## ----normdist-altern, echo = TRUE, include = TRUE, context = "setup"-----
set.seed(1246)
# Set position of the real plot in a 3x3 panel
s <- sample(1:12, size = 1)
par(mfrow = c(2, 3))
# Plotting will be rowwise, i.e. by row
for (i in 1:12) {
    if (i == s) {
        # the real plot
        qqnorm(pos_dat$totlngth[pos_dat$Pop == "Vic" ])
        qqline(pos_dat$totlngth[pos_dat$Pop == "Vic" ])
    } else {
        # draw values from normal distribution
        samp_dat <- rnorm(n = length(pos_dat$totlngth[pos_dat$Pop == "Vic" ]),
                   mean = mean(pos_dat$totlngth[pos_dat$Pop == "Vic" ]),
                   sd = sd(pos_dat$totlngth[pos_dat$Pop == "Vic" ]))
        qqnorm(samp_dat)
        qqline(samp_dat)
    }
}

## ----normaldist-exec3-solution-------------------------------------------
s

## ----extra_sect-shapiro, echo = TRUE, include = TRUE---------------------
# Set seed for random number generator. This makes the example reproducible
set.seed(3300)
# We draw 15 observations from a binomial distribution
# with each of 5 trials and the probability of success is 0.6
x <- rbinom(15, 5, 0.6)
# We use the so-called Shapiro-Wilk test of normal distribution.
shapiro.test(x)

## ----extra_sect-shapiro_2, echo = TRUE, include = TRUE-------------------
qreference(x, nrep = 8)

## ----t-test, echo = TRUE, include = TRUE---------------------------------
t.test(totlngth ~ Pop, var.equal = TRUE, data = pos_dat)

## ----mean_function, echo = TRUE, include = TRUE, context = "setup"-------
meanDif <- function(data, group) {
  mean(data[group == "other"]) - mean(data[group == "Vic"]) 
}

## ----perm_prep, echo = TRUE, include = TRUE, context = "setup"-----------
perm_vec <- numeric(length = 10000)
N <- nrow(pos_dat)

## ----permutation, echo = TRUE, include = TRUE, context = "setup"---------
library(permute)
# Make reproducible through setting a seed
set.seed(999)
for (i in seq_len(length(perm_vec) - 1)) # Loop runs 9999 times
{
  perm <- shuffle(N)
  perm_vec[i] <- with(pos_dat, meanDif(totlngth, Pop[perm]))
}

## ----permutation_add, echo = TRUE, include = TRUE, context = "setup"-----
perm_vec[10000] <- with(pos_dat, meanDif(totlngth, Pop))

## ----permutation_plot, echo = TRUE, include = TRUE-----------------------
par(cex = 1.2, mfrow = c(1, 1))
hist(perm_vec, breaks = 20, xlab = "Mean difference of possum populations")
rug(perm_vec[10000], col = "red", lwd = 2, ticksize = 0.5)

## ----permutation_pvalue, exercise = TRUE, exercise.eval = TRUE-----------
Dbig2 <- sum(abs(perm_vec) >= abs(perm_vec[10000]))
Dbig2 / length(perm_vec)

## ----permutation_direct, echo = TRUE, include = TRUE---------------------
library(DAAG)
with(pos_dat, twot.permutation(totlngth[Pop == "other"], totlngth[Pop == "Vic"], nsim=9999, plotit = FALSE))

## ----bootstr_mean, echo = TRUE, include = TRUE---------------------------
library(boot)
# Set up boot function
boot_samp1 <- boot(
 data = pos_dat[pos_dat$Pop == "Vic", "totlngth"],
 statistic = function(x, i) {
                            mean(x[i]) 
                            }, 
 # x refers to the data, i to indices (see help of boot)
 R = 10000, # number of bootstrap replicates
 parallel = "multicore", ncpus = 8
 # on Windows OS set parallel ="no" and remove "ncpus = 8"
)
# Plot distribution of bootstrapped statistic and a QQ plot
plot(boot_samp1)
# Plot a frequency plot of the bootstrapped statistic
par(cex = 1.4)
hist(boot_samp1$t, breaks = 100, main = "", xlab = "t*")

## ----bootstr_confint, echo = TRUE, include = TRUE------------------------
(cis <- boot.ci(boot_samp1, type = "bca"))

## ----bootstr_confint_plot, echo = TRUE, include = TRUE-------------------
par(cex = 1.4)
hist(boot_samp1$t, breaks = 100, main = "", xlab = "t*")
lines(x = c(cis$bca[4], cis$bca[5]), y = c(300, 300), col = "red", lwd = 2)
mtext(text = c("95% Confidence interval"), side = 3, col = "red", cex = 1.2)

## ----linmod_prep, echo = FALSE, include = FALSE--------------------------
library(vegan)
data("varechem")
mod_1 <- lm(S ~ K, data = varechem)

## ----linmod_exer, exercise = TRUE----------------------------------------


## ----boot_resid, echo = TRUE, include = TRUE-----------------------------
library(car)
# Make example reproducable
set.seed(30)
boot_mod_res <- Boot(mod_1, f = coef, R = 9999, method = c("residual"))
# see help of the Boot function for explanation
confint(boot_mod_res, level = .95, type = "bca")
confint(mod_1)

## ----boot_case, echo = TRUE, include = TRUE------------------------------
set.seed(30)
boot_mod_case <- Boot(mod_1, f = coef, R = 9999, method = c("case"))
confint(boot_mod_case, level = .95, type = "bca")
confint(boot_mod_res, level = .95, type = "bca")
confint(mod_1)

## ----crossv, echo = TRUE, include = TRUE---------------------------------
library(caret)
set.seed(111) # Make reproducible
# Define training control
train.control <- trainControl(method = "cv", 
                              number = 5)
# number gives the k in k-fold cross-validation
# Train the model
model_cv <- train(S ~ K, data = varechem, method = "lm",
               trControl = train.control)
# Summarize the results
print(model_cv)

## ----crossv_MSPE, echo = TRUE, include = TRUE----------------------------
library(DAAG)
# m gives the k in k-fold cross-validation
# seed is an internal set.seed argument
# plotit = FALSE suppresses automatic plotting
cv.lm(data = varechem, form.lm = formula(S ~ K), m = 5, seed = 30, plotit = FALSE)

## ----mod1_MSPE, echo = TRUE, include = TRUE------------------------------
mean(resid(mod_1)^2)

