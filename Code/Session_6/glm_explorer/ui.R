7
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(navbarPage("Explore Generalized Linear Models",
  tabPanel("Introduction",
           withMathJax(),
           includeMarkdown("introduction.md")
  ),
  tabPanel("Modelling",
    sidebarLayout(
      sidebarPanel(
        conditionalPanel(condition="input.conditionedPanels==1",
          h3('Simulated data'),
          selectInput("family",
                      "Family:",
                      c("Gaussian" = "gaussian",
                        "Poisson" = "poisson",
                        "Negative binomial" = "negbin"),
                      "gaussian",
                      FALSE
          ),
          selectInput("link",
                      "Link function:",
                      c("identity" = "identity",
                        "log" = "log"),
                      "identity",
                      FALSE
          ),
          sliderInput("n",
                      "Number of observations:",
                      min = 10,
                      max = 1000,
                      value = 200,
                      step = 10),
          sliderInput("a",
                      HTML("Intercept (<i>&beta;</i><sub>0</sub>):"),
                      min = -3,
                      max = 3,
                      value = 0,
                      step = 0.5),
          sliderInput("b_x",
                       HTML("Slope (<i>&beta;</i><sub>1</sub>):"),
                      min = -2,
                      max = 2,
                      value = 0.3,
                      step = 0.1),
          sliderInput("b_fac",
                       HTML("Group difference (<i>&beta;</i><sub>2</sub>):"),
                      min = -2,
                      max = 2,
                      value = 0,
                      step = 0.1),
          sliderInput("b_int",
                       HTML("Interaction between <i>x</i> and <i>fac</i> (<i>&beta;</i><sub>3</sub>):"),
                      min = -3,
                      max = 3,
                      value = 0,
                      step = 0.1),
          sliderInput("sigma",
                       HTML("<i>&sigma;</i> (only Gaussian):"),
                      min = 0,
                      max = 3,
                      value = 1,
                      step = 0.1),
          sliderInput("dispersion",
                       HTML("<i>&kappa;</i> (only Negative Binomial):"),
                      min = 0,
                      max = 3,
                      value = 1.5,
                      step = 0.1)
        ),
        conditionalPanel(condition = "input.conditionedPanels==2",
          h3('Fit model'),
          selectInput("family_mod",
                      "Family:",
                      c("Gaussian" = "gaussian",
                        "Poisson" = "poisson",
                        "Negative binomial" = "negbin"),
                      "gaussian",
                      FALSE),
          selectInput("link_mod",
                      "Link function:",
                      c("identity" = "identity",
                        "log" = "log"),
                      "identity",
                      FALSE),
          selectInput("terms_mod",
                      "Model formula:",
                      c("y ~ 1 (Intercept only)" = "intercept",
                        "y ~ x" = "x",
                        "y ~ fac" = "fac",
                        "y ~ x + fac" = "both",
                        "y ~ x + fac + x:fac" = "interaction"),
                      "x",
                      FALSE),
          checkboxInput("show_pred", "Show 95% prediction intervals?", FALSE)
        )
      ),
      mainPanel(
        tabsetPanel(
          tabPanel("Simulate data", value = 1,
                   plotOutput("Plot_model")
                   # , verbatimTextOutput("range_warn")
          ),
          tabPanel("Fit model", value = 2,
                   plotOutput("Plot_model2"),
                   verbatimTextOutput("model_char")
          ),
          tabPanel("Model summary", value = 2,
                   verbatimTextOutput("Summary")
          ),
          tabPanel("Model coefficients", value = 2,
                   plotOutput("Plot_coefs")
          ),
          tabPanel("Model diagnostics", value = 2,
                   plotOutput("Plot_diag"),
                   plotOutput("Plot_diag2"),
                   plotOutput("Plot_dharma")
          ),
          id = "conditionedPanels"
        )
      )
    )
  ),
  tabPanel("Exercises",
           includeMarkdown("exercises.md")
  )
))
