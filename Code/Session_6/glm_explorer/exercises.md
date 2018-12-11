## Exercises

### Gausian Linear Model
#### Data Generation

1. Vary only the intercept. What happens to the simulated data?
2. Set the intercept back to 0, vary only the slope. What happens to the simulated data?
3. Set the intercept to 2, vary the slope.  What happens to the simulated data?
4. Set intercept and slope both back to zero. Vary only the group difference. What do you observe?
5. Set the group difference to 2, change only the slope. What happens to the simulated data?
6. Set the group difference to 2, and the slope to 2.
Change only the intercept. What happens to the simulated data?
7. Set the intercept to 0, the group difference to 2, the slope to 2.
Change the interaction. What do you observe?
8. Set the intercept to 0, the group difference to 2, the slope to 2 and the interaction to 0.
Change sigma. What is happing?


#### Model fitting

1- `Simulate`: Reset the app (press `F5`).  Set the intercept to 1 and the slope to -1. 

`Model`: Change the model formula between `y~1' and 'y~x'. What is the difference between the fitted values?

`Model Summary`: Which model has the lower AIC? Where can you read the result for the estimate of $\sigma$?

`Model Coefficients`: Which model recovers the coefficients?

`Model Diagnostics`: What are the differences between the two models?

2- `Simulate`: Keep the intercept to 1 and the slope to -1. Set the group difference to 2.  

`Model`: What is the difference between 'x', 'fac', 'x+fac' and 'x+fac+x:fac' as model formula? 

`Model Summary`: What is the difference between 'x+fac' and 'x+fac+x:fac' as fitted terms? What is the slope for group B?

`Model Coefficients`: What is the difference between 'fac', 'x+fac' and 'x+fac+x:fac' as fitted terms?

`Model Diagnostics`:  What is the difference between 'x', 'fac', 'x+fac' and 'x+fac+x:fac' as fitted terms?

3- `Simulate`: Keep the intercept to 1, the slope to -1 and the group difference to 2. Set the interaction to -1.

`Model`: What is the difference between 'x+fac' and 'x+fac+x:fac' as model formula?

`Model Summary`: What is the difference between 'x+fac' and 'x+fac+x:fac' as fitted terms? What is the slope for group B?

`Model Coefficients`: What is the difference between 'x+fac' and 'x+fac+x:fac' as fitted terms?

`Model Diagnostics`:  What is the difference between 'x', 'fac', 'x+fac' and 'x+fac+x:fac' as fitted terms?


4- `Simulate`: Set the intercept to 1, the slope to -1 and the group difference to 2. Set the interaction to 1.

`Model Summary`: What is the slope for group B?



5- `Simulate`: Keep all settings. Vary sigma. 

`Model`: What do you observe?

`Model Summary`: What do you observe?

`Model Coefficients`: What do you observe?

`Model Diagnostics`:  What do you observe?


6- `Simulate`: Keep all settings. Vary the number of observations. 

`Model`: What do you observe?

`Model Summary`: What do you observe?

`Model Coefficients`: What do you observe?

`Model Diagnostics`:  What do you observe?





### Count data models

### Data generation

7- `Simulate`: Reset the app. Set `family` to 'Poisson' and Link to 'log'.

 What is the difference of data from Poison + log compared to data from Gaussian Model with identity link?


### Model fitting


8- `Simulate`: Set `family` to 'Poisson' and Link to 'log', the intercept to -1, the slope to 1 and the interaction to -1.

`Model`: Set `family` to 'Poisson' and fit the interaction. What is the difference between the link functions?

`Model Summary`: What is the difference between the link functions? What is the slope for group B?

`Model Diagnostics`: What is the difference between the link functions? How can we spot a wrong link?


9- `Simulate`: Set `family` to 'Poisson' and Link to 'log', the intercept to -1, the slope to 1 and the interaction to -1.

`Model`: Compare the poisson + log-link with gaussian + identity link. Are negative values meaningful? 

`Model Diagnostics`: Compare the poisson + log-link with gaussian + identity link.


10- `Simulate`: Set `family` to 'Poisson' and Link to 'log', the intercept to -1, the slope to 1 and the interaction to -1.

`Model`: Repeat the previous exercise, but compare also gaussian + log-link. What is the difference between gaussian + identity and gaussian + log-link? Does it fit better than the poisson?

`Model Diagnostics`: Repeat the previous exercise, but compare also gaussian + log-link. What is the difference between gaussian + identity and gaussian + log-link? Does it fit better than the poisson?


11- `Simulate`: Set `family` to 'Negative binomial' and Link to 'log', the intercept to -1, the slope to 1 and the interaction to -1.

`Model`: Compare Poisson + log and Negative binomial + log models fitted (with interaction) to this data. Also check the prediction bands. Does the Poisson Model make good predictions? Why?

`Model Summary`:  Compare Poisson + log and Negative binomial + log models fitted (with interaction) to this data. Compare the estimates and the Standard error. Which gives a lower standard error? Is this correct? What are the consequences? What about the ignored overdispersion in the poisson model?

`Model Diagnostics`: How can you detect the overdispersion of the Poisson model?


12- `Simulate`: Set `family` to 'Negative binomial' and Link to 'log', the intercept to -1, the slope to 1 and the interaction to -1.

`Model`: Fit a Negative Binomial Model. Compare different values of $\theta$. What is theta controlling?

`Model Summary`:  How does theta effect the summary?

13- `Simulate`: Set `family` to 'Negative binomial' and Link to 'log', the intercept to -1, the slope to 1 and the interaction to -1.

`Model`: Fit a Poisson Model. Compare different values of $\theta$. 

`Model Summary`:  How does theta effect the summary? What is happening at $\theta = 0$?

`Model Diagnostics`: At which value of theta you cannot detect overdisperion in the Poisson model? What is happening at $\theta = 0$?




