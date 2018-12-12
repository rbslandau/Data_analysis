## Exercises

### Gaussian Linear Model
#### Data Generation

1. Vary only the intercept. What happens to the simulated data?
2. Set the intercept back to 0, vary only the slope. What happens to the simulated data?
3. Set the slope back to zero. Vary only the group difference. What do you observe?
4. Set the group difference to 2, change only the slope. What happens to the simulated data?
5. Set the group difference to 2, and the slope to 2.
Change only the intercept. What happens to the simulated data?
6. Set the intercept to 0, the group difference to 2, the slope to 2.
Change the interaction. What do you observe for a negative and positive interaction?
8. Set the intercept to 0, the group difference to 2, the slope to 2 and the interaction to 0. Change $\sigma$. What is happening?


#### Model fitting

1- `Simulate data`: Reset the app (press `F5`).  Set the intercept to 1 and the slope to -1. 

`Fit model`: Change the model formula between `y ~ x` and `y ~ 1`. What is the difference between the fitted values?

`Model summary`: Which model has the lower AIC? Where can you read the result for the estimate of $\sigma$?

`Model coefficients`: Compare the estimates of the regression coefficients. Which model recovers the coefficients?

`Model diagnostics`: Inspect the differences between the two models. Why is there no *Residuals vs. Leverage* plot?

2- `Simulate data`: Keep the intercept at 1 and set the slope to -1. Set the group difference to 2.  

`Fit model`: What is the difference in the plotted model between `y ~ x`, `y ~ fac`, `y ~ x + fac` and `y ~ x + fac + x:fac` as model formula? 

`Model summary`: What is the difference between the model formulas `y ~ x`, `y ~ fac`, `y ~ x + fac` and `y ~ x + fac + x:fac` regarding the coefficients? What is the slope for group B?

`Model diagnostics`:  Inspect the differences between the models?

3- `Simulate data`: Keep as is and set the interaction to -1.

`Fit model`: What is the difference between `y ~ x + fac` and `y ~ x + fac + x:fac` as model formula? 

`Model summary`: What is the difference in AIC and the estimate of $\sigma$ between `y ~ x + fac` and `y ~ x + fac + x:fac` as fitted terms? What is the slope for group B?

`Model coefficients`: What is the difference between the models `y ~ x + fac` and `y ~ x + fac + x:fac`?

`Model diagnostics`:  What is the difference between the models `y ~ x + fac` and `y ~ x + fac + x:fac`?


4- `Simulate data`: Keep as is but set the interaction to 1.

`Model summary`: What is the slope for group B?



5- `Simulate data`: Keep all settings. Set $\sigma$ to the following levels: 0.2, 1.5 and 3. 

`Fit model`: What do you observe for the `y ~ x + fac + x:fac` model?

`Model summary`: What do you observe for the `y ~ x + fac + x:fac` model?

`Model coefficients`: What do you observe for the `y ~ x + fac + x:fac` model?

`Model diagnostics`:  What do you observe for the `y ~ x + fac + x:fac` model?


6- `Simulate data`: Keep all settings. Set the number of observations to the following levels: 10, 100, 500, 1000. 

`Fit model`: What do you observe for the `y ~ x + fac + x:fac` model?

`Model summary`: What do you observe for the `y ~ x + fac + x:fac` model?

`Model coefficients`: What do you observe for the `y ~ x + fac + x:fac` model?

`Model diagnostics`:  What do you observe for the `y ~ x + fac + x:fac` model?




### Count data models

Ignore the `Model coefficients` for these models.

### Data generation

7- `Simulate data`: Reset the app. Set family to `Poisson` and Link function to `log`.

 What is the difference in the generated data compared to data from the Gaussian model with identity link? What happens in the Poisson GLM if you change the intercept to -3 or 3 (mind the scale)?


### Model fitting


8- `Simulate data`: Set family to `Poisson` and Link function to `log`, the intercept to -1, the slope to 0.3 and the interaction to -0.1.

`Fit model`: Set family to `Poisson` and fit the models `y ~ x + fac` and `y ~ x + fac + x:fac`. What is the difference between the link functions?

`Model summary`: What is the difference in AIC between the link functions for the models `y ~ x + fac` and `y ~ x + fac + x:fac`?

`Model diagnostics`: What is the difference between the link functions for the model `y ~ x + fac`? How can we spot an incorrectly specified link?


9- `Simulate data`: Keep settings as is.

`Fit model`: Compare the `Poisson` model with `log` link to the `Gaussian` model with `identity` link for the model formula `y ~ x + fac`. Are negative values meaningful?  
  
  Note that you can not compare the AIC between the linear (Gaussian) model and the Poisson GLM as the likelihood functions differ and a comparison is therefore not meaningful. Hence, ignore the `Model summary`.

`Model diagnostics`: Compare the related model diagnostics.


10- `Simulate data`: Keep settings as is. 

`Fit model`: Compare the `Poisson` model with `log` link to the `Gaussian` model with `log` link for the model formula `y ~ x + fac`. Which model fits better?  
  
  Note that you can not compare the AIC between the linear (Gaussian) model and the Poisson GLM as the likelihood functions differ and a comparison is therefore not meaningful. Hence, ignore the `Model summary`.

`Model diagnostics`: Compare the `Poisson` model with `log` link to the `Gaussian` model with `log` link for the model formula `y ~ x + fac`? Which model violates assumptions?  


11- `Simulate data`: Set family to `Negative binomial` and Link function to `log`, the intercept to -2, the slope to 0.2 and the interaction to -0.1.

`Fit model`: Compare the `Poisson` model with `log` link to the `Negative binomial` model with `log` link for the model formulas `y ~ x + fac` and `y ~ x + fac + x:fac`. Also check the prediction bands. Does the Poisson model provide good predictions?

`Model summary`:  Compare the `Poisson` model with `log` link to the `Negative binomial` model with `log` link for the model formulas `y ~ x + fac`. Compare the estimates and the standard errors. Which model gives a lower standard error? What are the consequences? What about the ignored overdispersion  (residual deviance >> the degrees of freedom) in the poisson model?

`Model diagnostics`: How can you detect the overdispersion of the Poisson model? Which plots are useful?


12- `Simulate data`: Set family to `Negative binomial` and Link function to `log`, the intercept to -2, the slope to 0.2 and the interaction to -0.1.

`Fit model`: Fit the negative binomial model `y ~ x + fac + x:fac`. Compare different values of $\kappa$ (e.g. 0.3, 1, 1.5, 3). What is $\kappa$ controlling?

`Model summary`:  How does $\kappa$ effect the summary?  
  
  

13- `Simulate data`: Keep as is.

`Fit model`: Fit the Poisson model `y ~ x + fac`. Compare the model fits including prediction bands for different values of $\kappa$ (e.g. 0.3, 1, 1.5, 3). 

`Model summary`:  How does $\kappa$ effect the summary?

`Model diagnostics`: At which value of $\kappa$ does the overdispersion of the Poisson model disappear?

