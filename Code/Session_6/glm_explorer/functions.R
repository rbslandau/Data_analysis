library(ggplot2)
library(MASS)
library(ggfortify)
library(gridExtra)
library(markdown)
library(DHARMa)


#' @param n number of observations
#' @param a intercept
#' @param b_x effect of continuous variable
#' @param b_fac effect of categorial variable
#' @param b_int interaction effect
#' @param link link function
#' @param family error distribution function
datagen <- function(n = 100, 
                    a = 0, 
                    b_x = 2, 
                    b_fac = -1, 
                    b_int = -3,
                    link = c('identity', 'log'),
                    family = c('gaussian', 'poisson', 'negbin'),
                    sigma = 1,
                    dispersion = 4) {
  link <- match.arg(link)
  family <- match.arg(family)
  
  x <- runif(n, min = 0, max = 20)
  fac <- sample(c('A', 'B'), n, replace = TRUE)
  fac_dummy <- ifelse(fac == 'A', 0, 1)
  
  # mean
  link_mu <- a + b_x*x + b_fac*fac_dummy + b_int*fac_dummy*x
  mu <- switch(link,
               identity = link_mu,
               log = exp(link_mu))
  if (family %in% c('poisson', 'negbin') && any(mu < 0))
    stop("Cannot simulate Poisson or NegBin with negative mean. 
         Try changing the link function.")
  # response
  y <- switch(family,
         poisson = rpois(n, mu),
         gaussian = rnorm(n, mean = mu, sd = sigma),
         negbin = rnbinom(n, mu = mu, size = 1/dispersion))
    
  # return
  df <- data.frame(x, y, fac)
  return(df)
}



#' @param df data.frame as returned by datagen
#' @param link link function
#' @param family error distribution function
datamodel <- function(df, 
                      family = c('gaussian', 'poisson', 'negbin'),
                      link = c('identity', 'log'),
                      terms = c('intercept', 'x', 'fac', 'both', 'interaction')){
  link <- match.arg(link)
  family <- match.arg(family)
  terms <- match.arg(terms)
  form <- switch(terms,
                 intercept = as.formula(y ~ 1),
                 x = as.formula(y ~ x),
                 fac = as.formula(y ~ fac),
                 both = as.formula(y ~ x+fac),
                 interaction = as.formula(y ~ x+fac+x:fac)
                 )
  start <- switch(terms,
                  intercept = 1,
                  x = rep(1, 2),
                  fac = rep(1, 2),
                  both = rep(1, 3),
                  interaction = rep(1, 4)
                  )
  
  mod <- switch(family,
         poisson = glm(form, data = df, family = poisson(link = link),
             start = start),
         gaussian = glm(form, data = df, family = gaussian(link = link),
                        start = start),
         negbin = glm.nb(form, data = df), link = link)
  return(mod)
}

mod_char <- function(family = c('gaussian', 'poisson', 'negbin'),
                     link = c('identity', 'log'),
                     terms = c('intercept', 'x', 'fac', 'both', 'interaction')) {
  form <- switch(terms,
                 intercept = "y ~ 1",
                 x = "y ~ x",
                 fac = "y ~ fac",
                 both = "y ~ x + fac",
                 interaction = "y ~ x + fac + x:fac"
  )
  
  
  switch(family,
    negbin = paste0("glm.nb(", form, ", data = df, link = ", link, ")"),
    gaussian = paste0("glm(", form, ", data = df, gaussian(link = ", link, ")"),
    poisson = paste0("glm(", form, ", data = df, poisson(link = ", link, ")")
  )
}
  
  
#' @param df data.frame as returned by datagen
#' @param mod model as returned by datamodel
#' @param show_pred logical; show prediction band?
#' @param lim ylimits of plot
dataplot <- function(df, mod = NULL, show_pred, ylim = NULL
                     ) {
  # model fit + ci
  pdat <- expand.grid(x = seq(min(df$x), max(df$x), 
                              length.out = 100), 
                      fac = levels(df$fac))
  pdat$fit <- predict(mod, newdata = pdat, type = "link")
  pdat$se <- predict(mod, newdata = pdat, type = "link", se.fit = TRUE)$se.fit
  mod_fam <- mod$family$family
  mod_fam <- ifelse(grepl('Negative Binomial', mod_fam), 'negbin', mod_fam)
  # 95% CI
  crit <- switch(mod_fam,
                 gaussian = qt(0.975, df = mod$df.residual),
                 poisson = qnorm(0.975),
                 negbin = qt(0.975, df = mod$df.residual))
  pdat$lwr <- pdat$fit - crit * pdat$se
  pdat$upr <- pdat$fit + crit * pdat$se
  pdat$fit_r <- mod$family$linkinv(pdat$fit)
  pdat$lwr_r <- mod$family$linkinv(pdat$lwr)
  pdat$upr_r <- mod$family$linkinv(pdat$upr)
  
  p <- ggplot() + 
    geom_line(data = pdat, aes(x = x, y = fit_r, col = fac)) +
    geom_line(data = pdat, aes(x = x, y = upr_r, col = fac), 
              linetype = 'dashed') +
    geom_line(data = pdat, aes(x = x, y = lwr_r, col = fac), 
              linetype = 'dashed') +
    geom_point(data = df, aes(x = x, y = y, color = fac)) +
    labs(y = 'y') +
    # ylim(lim) +
    theme_bw() +
    geom_hline(aes(yintercept = 0), linetype = 'dotted') +
    geom_vline(aes(xintercept = 0), linetype = 'dotted')
  
  if (!is.null(ylim)) {
    p <- p +
      ylim(ylim)
  }
  
  # simulate from model for PI
  if (show_pred) {
    nsim <- 1000
    y_sim <- simulate(mod, nsim = nsim)
    y_sim_minmax <- apply(y_sim, 1, quantile, probs = c(0.025, 0.975))
    simdat <- data.frame(ysim_min = y_sim_minmax[1, ],
                         ysim_max = y_sim_minmax[2, ],
                         x = df$x,
                         fac = df$fac)
    p <- p + 
      geom_ribbon(data = simdat, aes(x = x, ymax = ysim_max, ymin = ysim_min, 
                                     fill = fac), alpha = 0.2)
  }
  
  p
}

range_warn <- function(df){
  if (any(df$y > 10) | any(df$y < -10))
    return('*** Simulated data out of plotting range!. \n Not all data points are displayed. Models are fitted to all data.***')
}
  
  
rawplot <- function(df, ylim = NULL) {
  p <- ggplot() + 
    geom_point(data = df, aes(x = x, y = y, color = fac)) +
    labs(y = 'y') +
    # ylim(lim) +
    theme_bw() +
    geom_hline(aes(yintercept = 0), linetype = 'dotted') +
    geom_vline(aes(xintercept = 0), linetype = 'dotted')
  
  if (!is.null(ylim)) {
    p <- p +
      ylim(ylim)
  }
  p
}

coefplot <- function(a = 2, 
                     b_x = 1, 
                     b_fac = 1, 
                     b_int = -2,
                     mod) {
  coefs <- coef(mod)
  se <- diag(vcov(mod))^0.5
  terms <- c('Intercept', 'x', 'fac', 'x:fac')
  terms <- terms[seq_along(coefs)]
  truths <- c(a, b_x, b_fac, b_int)
  truths <- truths[seq_along(coefs)]
  df <- data.frame(term = terms, estimate = coefs, se, truths)
  mod_fam <- mod$family$family
  mod_fam <- ifelse(grepl('Negative Binomial', mod_fam), 'negbin', mod_fam)
  crit <- switch(mod_fam,
                 gaussian = qt(0.975, df = mod$df.residual),
                 poisson = qnorm(0.975),
                 negbin = qt(0.975, df = mod$df.residual))
  df$lwr <- df$estimate - crit * df$se
  df$upr <- df$estimate + crit * df$se
  tlev <- levels(df$term)
  #reorder levels
  df$term <- factor(df$term, levels = c('Intercept', 'x', 'fac', 'x:fac'))
  # df$term <- factor(df$term, levels = c(tlev[which(levels(df$term) == 'Intercept')],
  #                                       tlev[which(levels(df$term) == 'x')],
  #                                       tlev[which(levels(df$term) == 'fac')],
  #                                       tlev[which(levels(df$term) == 'x:fac')]))
  p <- ggplot(df, aes(x = term)) +
    geom_pointrange(aes(y = estimate, ymax = upr, ymin = lwr)) +
    geom_point(aes(y = truths), col = 'red') +
    geom_hline(yintercept = 0, linetype = 'dashed') +
    coord_flip() +
    theme_bw() +
    labs(x = 'Coefficient', y = 'Value') +
    scale_x_discrete(breaks = c('Intercept', 'x', 'fac', 'x:fac'))
  p
}

diagplot <- function(df, mod) {
  par(mfrow = c(1,2))
  plot(mod, which = 1)
  plot(df$y,
    predict(mod, type = 'response'),
    main = 'Observed vs. Predicted',
    xlab = 'Observed',
    ylab = 'Predicted')
  abline(0, 1, col = 'red')
}

diagplot2 <- function(df, mod) {
  par(mfrow = c(1,2))
  plot(mod, which = 2)
  plot(mod, which = 5)

}

dharmaplot <- function(mod) {
  simulationOutput <- simulateResiduals(fittedModel = mod, n = 200)
  plotSimulatedResiduals(simulationOutput = simulationOutput)
}


chk_pos <- function(y, fam) {
  if (fam %in% c('poisson', 'negbin') && any(y < 0)) {
    "Negative values in data. Cannot fit Poisson or NegBin."
  } else {
    NULL
  }
}
