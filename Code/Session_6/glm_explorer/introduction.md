## Introduction

This application allows you to simulate data with known effects and properties. Subsequently, you can explore the fit of Generalized Linear Models (GLMs) with different specifications to these data. Hence, you can explore interactively what happens if you fit a GLM with an assumed distribution that matches or does not match the distribution of the simulated data. In particular, you can inspect the resulting diagnostic plots. For example, you can check how diagnostic plots look if you specify an incorrect model. 
Overall, you will gain a better understanding of GLMs, their application and diagnostics. 


To use the app, click the `Modelling` tab in the top navigation bar.
You can modify the data and model in two modules (tabs):

1. `Simulate`
2. `Model`

Under `Simulate` you can specify the properties of the simulated data, including error structure, model parameters and sample size.
Under `Model` you can specify the GLM that is fitted to the simulated data.
Additional tabs provide you with model information. The `Model summary` tab provides the output of the `summary()` function, `Model coefficients` provides a visual overview of the estimated regression coefficients and `Model diagnostics` provides diagnostic plots for the fitted model. You can either explore for yourself or follow `Exercises` (see tab).



## Data Simulation

Data are generated from a GLM (`Simulate` tab).
The simulated data depend on two predictors (one continuous *x* and one categorical *fac*) and their interaction (*x:fac*), unless the related regression coefficient is set to 0.
You can vary the number of observations (i.e. sample size), the distribution from which the data originates, the link function and the variability within the data.

The simulation model can be written as:

$$Y \sim D(\mu)$$
$$\eta = g(\mu)$$
$$\eta = \beta_{0} + \beta_{1} x + \beta_{2} \text {fac} + \beta_{3} \: x \: \text {fac}$$

The distribution of the response ($D()$) can be set to:

1. Gaussian (i.e. Normal distribution): Normal$(\mu, \sigma)$
2. Poission distribution: Pois$(\mu)$
3. Negative Binomial distribution: Neg.Bin$(\mu, \kappa)$

The link-function $f()$ can be set to:

1. identity link: $g(\mu) = \mu$
2. log link: $g(\mu) = log_e(\mu)$

For the ordinary linear regression you need to select `Gaussian` and the `identity` link. If you use a log link, you should set a small `Slope ($\beta_1$)` of around 0.1 and a small `Interaction between *x* and *fac* ($\beta_3$)` of 0 or 0.1, otherwise you won't see much of the variation.

The effect of the continuous and categorical variables *x* and *fac* can be set via the related regression coefficients:

1. Intercept: Intercept ($\beta_0$)
2. Continuous predictor: Slope ($\beta_1$)
3. Categorical predictor with two levels (A and B): Group difference ($\beta_2$)
4. The interaction between the continuous and categorical predictor: Interaction between *x* and *fac* ($\beta_3$)

Additionally, the variance can be varied (via $\sigma$ for normally distributed data and $\kappa$ for negative binomial data).

All of these specifications can be done under the `Simulate` tab, on the left.
On the right from this tab you will see a plot of the simulated data.


## Fit a model to these data

In the `Model` tab you can set, on the left, specifications of the GLM including the distribution, link and predictors.
On the right you will see:

1. The simulated data
2. The fitted model (solid line)
3. The pointwise 95% Confidence Interval (dashed line)

Optional: 
4. The 95% Prediction Interval (PI, shaded band). The PI is based on simulations from the model.

Below the plot you find the corresponding R command.


## Model diagnostics

The application provides several model outputs and diagnostics:

1. `Model summary`
2. `Model coefficients`
3. `Model diagnostics` 

Within each module, you can change the fitted model on the left to see how this affects the output and diagnostics.


`Model summary` prints the `summary()` for the model.

`Model coefficients` shows a plot of the estimated coefficients (black dots),
their 95% confidence intervals (black lines) and the true (= value in the statistical population used for simulation) coefficients (red dots).

`Model Diagnostics` shows diagnostics plots from basic R on top:

1. (Pearson) Residuals vs. Fitted values
2. Observed vs. Predicted (Fitted) values
3. QQ-plot
4. (Pearson) Residuals vs. Leverage


Below you find two plots from the [DHARMa package](https://cran.r-project.org/web/packages/DHARMa/index.html) for diagnosing GL(M)M.
The left plot shows a QQ-plot for *randomized quantile residuals*, the right plot the *randomized quantile residuals* vs. fitted values.


## Exercises

You find several exercises under the `Exercises` tab. 

You can also find them [here](https://github.com/EDiLD/shiny_apps/blob/master/glm_explorer/exercises.md) (click on `Raw` to get the file).
It is best if you have the exercises open in a separate (browser) window.

You can always reset to start by pressing `F5` in your browser.



## Meta
This app was created using [Shiny](https://shiny.rstudio.com/) from RStudio.
It was originally written by [Eduard Szöcs](edild.github.io) and has been modified by [Ralf B. Schäfer](https://github.com/rbslandau). It is licensed under [MIT](https://opensource.org/licenses/MIT).

