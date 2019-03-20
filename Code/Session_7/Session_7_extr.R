## ----setup, include = FALSE, purl = TRUE---------------------------------
knitr::opts_chunk$set(echo = FALSE)
library(learnr)
library(DAAG)
library(rpart)
library(party)
library(partykit)
library(dplyr)
library(InformationValue)

## ----load_data, include = TRUE, echo = TRUE, purl = TRUE-----------------
library(DAAG)
# display first rows
head(frogs)

## ----data_prep, include = FALSE, eval = TRUE, echo = FALSE, purl = TRUE, context = "setup"----
library(dplyr)
frogs_new <- frogs %>% 
                 mutate(mean_av = meanmin + meanmax)
predictors <- frogs_new[ , c(5:8, 11)]
resp_frogs <- frogs$pres.abs

## ----fit_tree, include = TRUE, echo = TRUE, purl = TRUE, context = "setup"----
library(rpart)
set.seed(3333) # make example reproducible (cross-validation, which will be called later)
frog_tree <- rpart(resp_frogs ~ ., data = predictors, method = "class", control = rpart.control(minsplit = 10))

## ----plot_tree_large, include = TRUE, echo = TRUE, eval = TRUE, purl = TRUE----
par(cex = 1.2, mar = c(0, 0, 0, 0))
plot(frog_tree, margin = 0.05)
text(frog_tree)

## ----cross_val_tree, include = TRUE, echo = TRUE, purl = TRUE------------
plotcp(frog_tree)

## ----prune_tree, include = TRUE, echo = TRUE, purl = TRUE----------------
tree_pruned <- prune(frog_tree, cp = 0.031)
# plot result
par(cex = 1.1, mar = c(0, 0, 0, 0))
plot(tree_pruned, margin = 0.05)
text(tree_pruned)

## ----nicer_tree, include = TRUE, echo = TRUE, eval = TRUE, purl = TRUE----
par(cex = 1.1, mar = c(0, 0, 0, 0))
plot(tree_pruned, uniform = TRUE, branch = 0.35, margin = 0.05)
text(tree_pruned, pretty = 1, all = T, use.n = T, fancy = T)

## ----nicer_tree_2, include = TRUE, echo = TRUE, purl = TRUE--------------
library(rpart.plot)
prp(tree_pruned, type = 2, extra = 1)

## ----accurac_tree, include = TRUE, echo = TRUE, purl = TRUE--------------
printcp(tree_pruned)

## ----calc_predict_tree, include = TRUE, echo = TRUE, purl = TRUE---------
# predict response
pred_prunded <- predict(tree_pruned, type = "class")
# mean of logical test for equality of predicted and observed response
# if values match, returns 1, else 0 
# the mean is equivalent to dividing the number of matches by the number of comparisons
mean(pred_prunded == resp_frogs)
# 1 - mean yields to (estimate of) the error rate
1 - mean(pred_prunded == resp_frogs)

## ----transformation,  include = TRUE, echo = TRUE, purl = TRUE, context = "setup"----
# log transformation of NoOfPools and distance,
logNoPools <- log(frogs$NoOfPools)
logdistance <- log(frogs$distance)
# create easily accessible data set
mod_glm_dat <- data.frame(predictors[ , c(3:5)], logNoPools, logdistance, resp_frogs)

## ----GLM_predict,  include = TRUE, echo = TRUE, purl = TRUE--------------
pred_glm <- predict(frog.glm3, type = "response")

## ----GLM_predict_convert,  include = TRUE, echo = TRUE, purl = TRUE------
library(InformationValue)
misClassError(resp_frogs, pred_glm)

## ----GLM_poptimal_cutoff,  include = TRUE, echo = TRUE, purl = TRUE------
library(InformationValue)
optim_cut_glm <- optimalCutoff(resp_frogs, pred_glm)[1]
# optimal value is
optim_cut_glm
# compute related classification error
misClassError(resp_frogs, pred_glm, optim_cut_glm)

## ----GLM_cv_cutoff,  include = TRUE, echo = TRUE, purl = TRUE------------
library(boot)
# define cost function - see help of cv.glm
cost_func <- function(resp_frogs, pi = 0) mean(abs(resp_frogs-pi) > 0.5)
# set seed to make reproducible
set.seed(42)
cv.err <- cv.glm(mod_glm_dat, frog.glm3, cost = cost_func, K = 10)
cv.err$delta[1]

## ----class_tree_var_import,  include = TRUE, echo = TRUE, purl = TRUE----
tree_pruned$variable.importance

## ----class_tree_summary,  include = TRUE, echo = TRUE, purl = TRUE-------
summary(tree_pruned)

## ----load_data_2, include = TRUE, echo = TRUE, purl = TRUE, context = "setup"----
data_oc <- read.csv("http://datadryad.org/bitstream/handle/10255/dryad.39576/OstraMRegS400JB.txt?sequence=1", sep = "\t")
data_oc2 <- data_oc[ , !names(data_oc) %in% c("MDS1", "MDS2", "DCA1", "DCA2", "IC","SA", "SR")]

## ----reg_tree_fitting,  include = TRUE, echo = TRUE, purl = TRUE---------
# we set a seed to make the example reproducible.
set.seed(21)
reg_ostrac <- rpart(E100 ~ ., data = data_oc2, control = rpart.control(minsplit = 10))

## ----reg_tree_cp,  include = TRUE, echo = TRUE, purl = TRUE--------------
plotcp(reg_ostrac)

## ----prune_reg_tree,  include = TRUE, echo = TRUE, purl = TRUE-----------
ostrac_pruned <- prune(reg_ostrac, cp = 0.057)
# plot tree
library(rpart.plot)
prp(ostrac_pruned, type = 2, extra = 1)

## ----reg_tree_rsqplot,  include = TRUE, echo = TRUE, purl = TRUE---------
# two plots on one page 
par(mfrow=c(1,2))
rsq.rpart(ostrac_pruned) 

## ----reg_tree_rsq,  include = TRUE, echo = TRUE, purl = TRUE-------------
rsq_extr <- printcp(ostrac_pruned)
# extract rsquare values 
rsqu_1 <- 1-rsq_extr[, 3:4]
# adjust headers
colnames(rsqu_1) <- c("Rsquare", "Xval Rsquare")
rsqu_1

## ----cond_tree,  include = TRUE, echo = TRUE, eval = TRUE, purl = TRUE----
library(party)
library(partykit)
# convert response to factor
resp_frogfac <- as.factor(resp_frogs)
frog_ctree <- ctree(resp_frogfac ~ ., data = predictors, control = ctree_control(minsplit = 10))
plot(frog_ctree)

## ----cond_tree_predict,  include = TRUE, echo = TRUE, eval = TRUE, purl = TRUE----
print(frog_ctree)
pred_ctree <- predict(frog_ctree)
# calculation of error rate
1 - mean(pred_ctree == resp_frogs)

## ----cond_tree_table,  include = TRUE, echo = TRUE, eval = TRUE, purl = TRUE----
table(pred_ctree, resp_frogs)

## ----cond_regtree,  include = TRUE, echo = TRUE, eval = TRUE, purl = TRUE----
cit_ostrac <- ctree(E100 ~ ., data = data_oc2, control = ctree_control(minsplit = 10))

## ----cond_regtree_plot,  include = TRUE, echo = TRUE, eval = FALSE, purl = TRUE----
## plot(cit_ostrac)

## ----cond_regtree_print,  include = TRUE, echo = TRUE, eval = TRUE, purl = TRUE----
print(cit_ostrac)

## ----cit_crossval,  include = TRUE, echo = TRUE, eval = TRUE, purl = TRUE----
# load package
library(caret)
# set parameters for algorithm. See ?trainControl for details. 
fitControl <- trainControl(method = "cv", number = 10)
gridcont <- expand.grid(mincriterion = 0.95)

## ----cit_crossval_2,  include = TRUE, echo = TRUE, eval = TRUE, purl = TRUE----
# set seed for reproducibility
set.seed(2020)
fit.ctree2CV <- train(as.factor(pres.abs) ~ ., data = frogs_new[ , c(1, 5:8, 11)], method = 'ctree', trControl = fitControl, tuneGrid = gridcont)
print(fit.ctree2CV)

## ----cit_multi,  include = TRUE, echo = TRUE, eval = TRUE, purl = TRUE----
data("HuntingSpiders", package = "partykit")
# create formula
form_multtree <- formula(arct.lute + pard.lugu + zora.spin + pard.nigr + pard.pull + aulo.albi + troc.terr + alop.cune + pard.mont + alop.acce + alop.fabr + arct.peri ~ herbs + reft + moss + sand + twigs + water)
sptree <- ctree(form_multtree, data = HuntingSpiders, teststat = "max", minsplit = 5, pargs = GenzBretz(abseps = .1, releps = .1))

## ----cit_multi_plot,  include = TRUE, echo = TRUE, eval = FALSE, purl = TRUE----
## plot(sptree, terminal_panel = node_barplot)

## ----cit_multi_plot2,  include = TRUE, echo = TRUE, eval = FALSE, purl = TRUE----
##   plot(sptree)

## ----inst_mvpart,  include = TRUE, echo = TRUE, eval = FALSE, purl = TRUE----
## install.packages("devtools")
## # load package
## library(devtools)
## # install mvpart and extension package
## install_github("cran/mvpart", force = TRUE)
## install_github("cran/MVPARTwrap",  force = TRUE)

## ----mvtree_prep,  include = TRUE, echo = TRUE, eval = TRUE, purl = TRUE----
# extract spider data
spider_init <- HuntingSpiders[ , 1:12]
# convert to matrix
spiders <- data.matrix(spider_init)
# extract environmental variables
env_vars  <- HuntingSpiders[ , 13:18]

## ----mvtree_result,  include = TRUE, echo = TRUE, eval = TRUE, purl = TRUE, context = "setup"----
library(mvpart)
# set graphic parameter to avoid cluttered plot
par(cex = 0.75)
set.seed(555)
mult_cart <- mvpart(spiders ~. , data = env_vars, xv = "min", minsplit = 5)

## ----mvtree_print_results,  include = TRUE, echo = TRUE, eval = TRUE, purl = TRUE----
print(mult_cart)

## ----mvtree_summary_results,  include = TRUE, echo = TRUE, eval = TRUE, purl = TRUE----
summary(mult_cart)

## ----mvtree_result2,  include = TRUE, echo = TRUE, eval = TRUE, purl = TRUE----
library(mvpart)
# set graphic parameter to avoid cluttered plot
par(cex = 0.75)
set.seed(555)
mult_cart_mcv <- mvpart(spiders ~. , data = env_vars, xv = "min", minsplit = 5, xvmult = 100) 

## ----mvtpart_extract,  include = TRUE, echo = TRUE, eval = TRUE, purl = TRUE----
# extract terminal node numbers
term_nod_num <- mult_cart$where
# convert to factor and subsequently extract levels
term_nod_fct <- as.factor(term_nod_num)
groups_mvpart <- levels(term_nod_fct)
# now we have the terminal nodes in an object
groups_mvpart

## ----mvtpart_extract_node,  include = TRUE, echo = TRUE, eval = TRUE, purl = TRUE----
# select number of terminal node (refers to position in groups_mvpart vector)
leaf_id <- 1
# inspect spider composition
spiders[which(mult_cart$where == groups_mvpart[leaf_id]), ]
# inspect environmental variables
env_vars[which(mult_cart$where == groups_mvpart[leaf_id]), ]

## ----mvtpart_tab1,  include = TRUE, echo = TRUE, eval = TRUE, purl = TRUE----
leaf_sum <- matrix(data = 0, nrow = length(groups_mvpart), ncol = ncol(spiders))
# matrix
leaf_sum
# assign column names
colnames(leaf_sum) <- colnames(spiders)
# assign row names from group vector
rownames(leaf_sum) <- groups_mvpart
# look at matrix again
leaf_sum

## ----mvtpart_tab2,  include = TRUE, echo = TRUE, eval = TRUE, purl = TRUE----
for(i in 1:length(groups_mvpart))
                                {
                                leaf_sum[i, ] <- apply(spiders[which(mult_cart$where == groups_mvpart[i]), ], 2, sum)
                                }
# look at table with filled information
leaf_sum

## ----mvtpart_tab3,  include = TRUE, echo = TRUE, eval = TRUE, purl = TRUE----
# first sort vector with information on grouping in ascending order
term_nod_sort <- sort(term_nod_num)
# sum per group level
term_tab <- table(term_nod_sort)
# print table - first row gives group, second row number of observations
term_tab
# extract number of observations
num_obs_term <- as.vector(term_tab)
# divide sums of spider species by number of observations. Vector is applied to columns, which means that the calculations are done node-wise.
leaf_avg <- leaf_sum/num_obs_term
# look at table with filled information
leaf_avg

## ----mvtpart_barplots,  include = TRUE, echo = TRUE, eval = TRUE, purl = TRUE----
# set plooting window with the length of the group vector as number of rows
par(mfrow = c(1, 2))
for (i in 1:2)
              { 
                barplot(leaf_avg[i, ], main = paste("leaf no.", groups_mvpart[i]), las = 2, ylim = c(0, 8))
                }
par(mfrow = c(1, 2))
for (i in 3:4)
              { 
                barplot(leaf_avg[i, ], main = paste("leaf no.", groups_mvpart[i]), las = 2, ylim = c(0, 8))
              }
par(mfrow = c(1, 2))
for (i in 5)
              { 
                barplot(leaf_avg[i, ], main = paste("leaf no.", groups_mvpart[i]), las = 2, ylim = c(0, 8))
              }

## ----mvtpart_barplots_code,  include = TRUE, echo = TRUE, eval = FALSE, purl = TRUE----
## # loop for plotting
## par(mfrow = c(3, 2))
## for (i in 1:length(groups_mvpart))
##                      {
##                      barplot(leaf_sum[i, ], main = paste("leaf no.", groups_mvpart[i]))
##                    }

## ----mvrt_wrap, exercise = TRUE, exercise.eval = FALSE, purl = TRUE------
library(MVPARTwrap)
# use MRT function to extract information from an mvpart object
extract_mrtwrap <- MRT(mult_cart, percent = 10)



## ----mvrt_cluster,  include = TRUE, echo = TRUE, eval = TRUE, purl = TRUE----
trclcomp(mult_cart, method = "com")

## ----mvrt_pca,  include = TRUE, echo = TRUE, eval = TRUE, purl = TRUE----
rpart.pca(mult_cart, interact = TRUE, wgt.ave = TRUE) 

## ----rf_ostracod,  include = TRUE, echo = TRUE, eval = TRUE, purl = TRUE----
library(randomForest)
set.seed(2019)
ostrac_rf <- randomForest(E100 ~ ., data = data_oc2, importance = TRUE)
print(ostrac_rf)

## ----rf_ostra_varimp,  include = TRUE, echo = TRUE, eval = TRUE, purl = TRUE----
# putting an expression into brackets means that the resulting object is called after execution
(imp <- importance(ostrac_rf))

## ----rf_ostra_pdp,  include = TRUE, echo = TRUE, eval = TRUE, purl = TRUE----
# extract variable names
vars <- rownames(imp)
# order variables by order of importance
# create order vector
imp_seq <- order(imp[ ,1], decreasing = TRUE)
# use order vector to sort variables
impvar <- vars[imp_seq]
# loop to create plots
for (i in seq_along(impvar)) 
                            {
                              partialPlot(ostrac_rf, pred.data = data_oc2, x.var = impvar[i], xlab = impvar[i], main = paste("Partial Dependence Plot for", impvar[i]))
                              }

## ----read_ec_data,  include = TRUE, echo = TRUE, eval = TRUE, purl = TRUE, context = "setup"----
ec <- read.csv("data_EC.csv", header = TRUE, sep = ",") 
# overview on variables in dataset
names(ec)
# remove id
ec_1 <- ec %>% select(-site_id)
# extract predictors
predictors_ec <- ec_1 %>% select(-EC_value_fin)
# extract response
resp_ec <- ec_1 %>% select(EC_value_fin)

## ----read_ec_data-exercise,  exercise = TRUE, exercise.eval = FALSE, purl = TRUE----


## ----ec_near_zero,  include = TRUE, echo = TRUE, eval = TRUE, purl = TRUE----
library(caret)
zero_var_variables <- nearZeroVar(predictors_ec, saveMetrics = TRUE)
zero_var_variables

## ----rf_ec,  include = TRUE, echo = TRUE, eval = TRUE, purl = TRUE-------
set.seed(2019)
ec_rf <- randomForest(EC_value_fin ~ ., data = ec_1, importance = TRUE)
print(ec_rf)

## ----rf_ec_pdp,  include = TRUE, echo = TRUE, eval = TRUE, purl = TRUE----
imp_ec <- importance(ec_rf)
# extract variable names
vars_ec <- rownames(imp_ec)
# order variables by order of importance
# create order vector
imp_seqec <- order(imp_ec[ ,1], decreasing = TRUE)
# use order vector to sort variables
impvarec <- vars_ec[imp_seqec]
# loop to create plots
for (i in seq_along(impvarec)) 
                            {
                              partialPlot(ec_rf, pred.data = ec_1, x.var = impvarec[i], xlab = impvarec[i], main = paste("Partial Dependence Plot for", impvarec[i]))
                              }

## ----rf_ec_remvars,  include = TRUE, echo = TRUE, eval = TRUE, purl = TRUE----
# Create vector of variables to be dropped
drop_vars <- c("soil_permeability", "area_sqkm", "water_capability", "MgO_mean", "Bulk_mean", "S_mean")
# drop columns
ec_2 <- ec_1 %>% select(-one_of(drop_vars))
# refit model
set.seed(2019)
ec_rf_up <- randomForest(EC_value_fin ~ ., data = ec_2, importance = TRUE)
print(ec_rf_up)

## ----rf_ec_tune_ntree,  include = TRUE, echo = TRUE, eval = TRUE, purl = TRUE----
# fit model with 1000 trees
set.seed(2019)
ec_rf_up_1000 <- randomForest(EC_value_fin ~ ., data = ec_2, importance = TRUE, ntree = 1000)
print(ec_rf_up_1000)
# fit model with 2000 trees
set.seed(2019)
ec_rf_up_2000 <- randomForest(EC_value_fin ~ ., data = ec_2, importance = TRUE, ntree = 2000)
print(ec_rf_up_2000)

## ----rf_ec_imp_plots,  include = TRUE, echo = TRUE, eval = TRUE, purl = TRUE----
varImpPlot(ec_rf_up, main = "Default fit, 500 trees", scale = TRUE, type = 1)
varImpPlot(ec_rf_up_1000, main = "1000 trees", scale = TRUE, type = 1)
varImpPlot(ec_rf_up_2000, main = "2000 trees", scale = TRUE, type = 1)

## ----rf_ec_tune_mtry,  include = TRUE, echo = TRUE, eval = TRUE, purl = TRUE----
set.seed(2019)
tuneRF(x = ec_2[ , -1], y = ec_2[ , 1], mtryStart = 3, ntree = 2000, stepFactor = 1.5, improve = 0.01, trace = TRUE, plot = TRUE)

## ----rf_ec_plot_finalmod,  include = TRUE, echo = TRUE, eval = TRUE, purl = TRUE----
# fit model with 2000 trees
set.seed(2019)
ec_rf_fin <- randomForest(EC_value_fin ~ ., data = ec_2, importance = TRUE, ntree = 2000, mtry = 3)
print(ec_rf_fin)
varImpPlot(ec_rf_fin, main = "2000 trees", scale = FALSE, type = 1)

## ----rf_ec_pred_obsplot,  include = TRUE, echo = TRUE, eval = TRUE, purl = TRUE----
pred_ec <- predict(ec_rf_fin)
# plot EC_preds and EC_obs
plot(pred_ec, ec_2$EC_value_fin, ylab = "Observed EC [mS/cm]", xlab = "Predicted EC [mS/cm]")
# add regression line
abline(lm(ec_2$EC_value_fin ~ pred_ec))

