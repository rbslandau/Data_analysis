
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
source('functions.R')


shinyServer(function(input, output) {
  df <- reactive({
    datagen(n = input$n, 
            a = input$a, 
            b_x = input$b_x, 
            b_fac = input$b_fac, 
            b_int = input$b_int,
            link = input$link,
            family = input$family,
            sigma = input$sigma,
            dispersion = input$dispersion)
  })
  
  mod <- reactive({
    validate(
      chk_pos(df()$y, input$family_mod)
    )
    
    datamodel(df(), 
              family = input$family_mod, 
              link = input$link_mod,
              terms = input$terms_mod)
  })
  

  output$Plot_model <- renderPlot({
    rawplot(df())
  })
  
  output$Plot_model2 <- renderPlot({
    dataplot(df(), mod(), show_pred = input$show_pred)
  })
  
  output$Summary <- renderPrint({
    summary(mod())
  })
  
  output$model_char <- renderText({
    mod_char(family = input$family_mod, 
              link = input$link_mod,
              terms = input$terms_mod)
  })
  
  output$range_warn <- renderText({
    range_warn(df())
  })
  
  
  output$Plot_coefs <- renderPlot({
    coefplot(a = input$a, 
             b_x = input$b_x, 
             b_fac = input$b_fac, 
             b_int = input$b_int,
             mod = mod())
  })
  
  output$Plot_diag <- renderPlot({
    diagplot(df(), mod())
  })
  
  output$Plot_diag2 <- renderPlot({
    diagplot2(df(), mod())
  })
  
  output$Plot_dharma <- renderPlot({
    validate(
      need(input$terms_mod != 'intercept', 
           "DHARMa not working for intercept only models.")
    )
    dharmaplot(mod())
  })
})
