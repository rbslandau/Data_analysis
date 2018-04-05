#' ---
#' title: "Session 1: First steps in R and data exploration"
#' author: "Ralf B. Schäfer"
#' date: "April 10, 2018"
#' output: pdf_document
#' urlcolor: blue
#' bibliography: /Users/ralfs/Literatur/Natural_Sciences.bib
#' 
#' ---
#' 
#' 
#' # First steps
#' Before we begin, some notes on notation and terminology: **Bold statements** mostly refer to little exercises or questions, R functions
#' inside text are *italicised* and coloured in $\textcolor {MidnightBlue}{MidnightBlue}$ and [this is an URL](https://www.uni-koblenz-landau.de/en/campus-landau/faculty7/environmental-sciences/landscape-ecology/teaching/r-statistics)
#' that brings you to the course website. R code chunks are formatted as follows
#' (This code does not run!):
#+ eval=FALSE
object_assignment <- thisfunction(argument = does_not_work$it_only_serves_illustration)
# Comments within R code are coloured in brown. 
#' If you write own R code, consider the [style guide by Hadley Wickham](http://adv-r.had.co.nz/Style.html) as well as using the [styler package](https://cran.r-project.org/web/packages/styler/index.html)
#' on [files or on code through the RStudio Addins](https://github.com/r-lib/styler).
#' Although called "First steps", we assume that you have followed short tutorials on installing and using R/R Studio and on the very
#' basics of R. We recommend the free datacamp course [Introduction to R](https://www.datacamp.com/courses/free-introduction-to-r) and the free
#' datacamp chapter [Orientation](https://www.datacamp.com/courses/working-with-the-rstudio-ide-part-1) of the course 
#' *Working with the R Studio IDE (Part 1)*.
#' 
#' Whenever you start working with R, you should set a working directory. This is the directory where R, unless 
#' specified otherwise, will look for files to load or will save files. The working directory can be set through the
#' R Studio [Graphical User Interface (GUI)](https://www.datacamp.com/courses/working-with-the-rstudio-ide-part-1):
#' Go to Session –> Set Working Directory –> Choose Directory... . However,
#' you can also do this from the command line using the command $\textcolor {MidnightBlue}{setwd}$:
setwd("~/Gitprojects/Teaching/Data_analysis/Code")
#' If you run the script, you have to replace my file path with a path to a working directory 
#' on your local machine. To simplify the identification of your path, you can use the 
#' following function:
#+ eval=FALSE
file.choose()
#' and select a file in your desired working directory. Subsequently, copy the path
#' **without** the file reference into the $\textcolor {MidnightBlue}{setwd}$ function. Make sure
#' to enclose the path with double quotation marks. Finally, we set an option to reduce the amount of output
#' that is printed to save some space in this document:
options(max.print = 50)
#' For an overview of the options available to influence computations and displaying check the help:
#+ eval=FALSE
?options
#' 
#' We start by importing a data file from the university website (obviously, you require an internet connection to 
#' successfully run the command). To store the data after import, we assign (<-) the data to an object (*data*). 
link <- "http://www.uni-koblenz-landau.de/en/campus-landau/faculty7/environmental-sciences/landscape-ecology/Teaching/possum.csv"
# link is not properly displayed in knitted document, but shown if you locate the mouse
# pointer over the URL
data <- read.table(link)
#' The object *data* is now shown in the *Environment pane* in R Studio.
#' For interested students: **What happens if you run the read table function without assignment to an object?**
#' *Hint: Inspect the Console pane in R Studio.*
#' 
#' Useful functions to inspect imported data are $\textcolor {MidnightBlue}{head}$ and $\textcolor {MidnightBlue}{str}$.
#' **Try what these functions do by running them on the imported data and by calling the related help pages
#' as shown below:**
#+ eval=FALSE 
head(data)
?head
str(data)
?str

#' The imported data look mixed up. This happens when the arguments in the import function have not been set properly.
#' We can set different arguments including:
#' 
#' * header: specify if the data have a header (TRUE) or not (FALSE)
#' * sep: specify the column separator (in this case ";")
#' * dec: specify the character used for the decimal point (in this case "."). In Germany and several other countries, 
#' the character for the decimal point is ",", which often leads to trouble (unless you do not exchange
#' files with others). In academic contexts, I generally recommend to set all software products such as spreadsheet programs
#' (e.g. Microsoft Excel, LibreOffice Calc) [to locale "English (Great Britain)"](https://help.libreoffice.org/Common/Languages#Locale_setting)
#' or another locale related to an english-speaking country. 
#' * row.names: specify row names, a variable that provides row names (our data set actually contains a variable
#' *row.names*, but we ignore that) or import without row names (= NULL)
#' 
#' Call $\textcolor {MidnightBlue}{?read.table}$ for further details and options. 
#' Misspecification of import arguments is one of the most frequent errors of beginners. 
#' We run the import function again, now with the arguments properly specified.
pos_dat <- read.table(url(link), dec = ".", sep = ";", header = TRUE, row.names = NULL)
# close connection after import
close(url(link))
#' For further details on how to import data refer to [this tutorial](https://www.datacamp.com/community/tutorials/r-data-import-tutorial).
#' 
#' We inspect the imported data again.
# show first 6 rows of dataframe
head(pos_dat) 
# looks ok
str(pos_dat)  
# structure of object also looks meaningful now 
# data.frame with 15 variables and 104 rows (obs. = observations)
# $ indicates variables with type of data (i.e. Factor: categorical, chr: character,
# int: integer = natural number, num: numeric = real number)   

#' The file was taken from the R package [DAAG](https://cran.r-project.org/web/packages/DAAG/index.html) and contains information on 
#' [possums](https://en.wikipedia.org/wiki/Phalangeridae#/media/File:Brushtail_possum.jpg) that were published in @LindenmayerMorphologicalVariationPopulations1995. To access an R package, we have
#' to load and attach a package with the function $\textcolor {MidnightBlue}{library}$:
library(DAAG)
#' If loaded and attached, we can subsequently load the possum data, which we have imported from a file above,
#' quite conveniently (e.g. without the need to specify separator or decimal point) from the package:
data(possum)
# display first rows
head(possum)
#' The [metadata](https://en.wikipedia.org/wiki/Metadata) for data that are in a package can be called via help. **Call the help for the possum data and study the metadata.** 
#'
#' You can also save data that are in the session workspace for later use. For example, if you wanted to save the 
#' imported possum data for later use (ignoring that we have them in the package) on your local hard drive, 
#' execute the following code:
#+ eval=FALSE
save(pos_dat, file = "Possum.Rdata")
#'  Of course, you can provide a different path to the file argument in the $\textcolor {MidnightBlue}{save}$ function.
#' **Where has the file been saved?** *Hint: If you can't find the file, run the following function:*
#+ eval=FALSE
getwd()
#' If saved, you can load the data into a new R session with:
#+ eval=FALSE
load("Possum.Rdata")
# Works only if file is in working directory!

#' # Data handling
#' Now that we have properly imported the data into R, we can explore and analyse the data. However, before data exploration and analysis, 
#' the data often require (re-)organisation including joining data sets, transformation and subsetting. Here, we focus on
#' subsetting based on conditions. But let us start with some basics. To return the column names (i.e. variable names) call:
names(pos_dat)
#' or:
colnames(pos_dat)
#' The function $\textcolor {MidnightBlue}{colnames}$, in contrast to $\textcolor {MidnightBlue}{names}$, also works for matrices.
#' If we want to access variables in a dataframe, we can do this as follows: 
pos_dat$totlngth
# Displays the data stored in the column totlngth (total length of a possum)
#' Generally, we can access parts of objects including vectors, matrics, data.frames and lists with squared brackets:
# Select column via name
pos_dat[ , "totlngth"]
#' **If you assign the resulting data to a new object, of what class (e.g. list, vector, matrix) is the resulting object?** 
#' 
#' We can also select rows and columns via column and row numbers: 
# Select 1. to 3. row of the 5. and 6. column
pos_dat[1:3, 5:6] 
# Select 1., 3. and 4. row of the 7. and 9. column
pos_dat[c(1,3,4), c(7,9)] 
#' If we want to store the selected rows and columns, we can simply assign them to a new object:
#+ eval=FALSE
new_obj <- pos_dat[c(1,3,4), c(7,9)]
#'
#' Often we want to subset data based on conditions. If we apply a condition to a vector, we obtain a logical (i.e. TRUE/FALSE) vector:
pos_dat$totlngth > 95
# TRUE: condition met, FALSE: condition not met
#' To use a condition to select data, we apply the logical vector to an object (e.g. vector or dataframe):
log_vector <- pos_dat$totlngth > 95
pos_dat$totlngth[log_vector]
# Subset variable directly without storing logical vector in object
pos_dat$totlngth[pos_dat$totlngth > 95]
# Different way to do this
pos_dat[pos_dat$totlngth > 95, "totlngth"]
# Subset dataframe
pos_dat[pos_dat$totlngth > 95, ]
#' To query values *smaller or equal than* is done in R via $\textcolor {MidnightBlue}{<=}$, to query values *larger or equal than* is 
#' done via $\textcolor {MidnightBlue}{>=}$. Similarly, $\textcolor {MidnightBlue}{==}$ means *equal*, 
#' and $\textcolor {MidnightBlue}{!=}$ means *not equal*. We exemplify this by querying selected variables conditioned
#' by the sex of the possums:
# Select male possums
pos_dat[pos_dat$sex == "m", c(5,7:9)]
# Select female possums
pos_dat[pos_dat$sex == "f", c(5,7:9)]
# Select female possums as those not male
pos_dat[pos_dat$sex != "m", c(5,7:9)]
#' Sometimes it is necessary to know the row numbers that meet a condition. These can be queried using the $\textcolor {MidnightBlue}{which}$ function:
which(pos_dat$totlngth > 95)
#' In every scripting or programming language, you often have multiple ways to reach a result. 
#' **Try yourself: Store the vector resulting from the 'which' function and use it as condition for subsetting the dataframe pos_dat**. 
#' 
#' Of course, you can also combine conditions (& = logical AND, | = logical OR) to subset data:
# selects all possums that are male and larger than 95 (cm)
pos_dat[pos_dat$sex == "m" & pos_dat$totlngth > 95, ] # AND
# selects all possums that are male or larger than 95 (cm) 
pos_dat[pos_dat$sex == "m" | pos_dat$totlngth > 95, ]# OR

#' The combination of conditions looks complicated. The [dplyr package](https://cran.r-project.org/web/packages/dplyr/index.html) provides functions
#' that are intended to simplify such operations on dataframes. We only outline a few examples for application of dplyr functions,
#'  please refer to a [blog post](https://datascienceplus.com/getting-started-with-dplyr-in-r-using-titanic-dataset/) and the 
#'  course material on OpenOLAT for more extensive tutorials.
# load dplyr library
library(dplyr)
# Select variables with the select function
# First argument is data set followed by the variable names
select(pos_dat, totlngth, sex, skullw)
# Note: No need for quotation marks.
# Select rows with the filter function
filter(pos_dat, totlngth > 95)
filter(pos_dat, sex == "m")
# Combine conditions
filter(pos_dat, totlngth > 95 & sex == "m")
#' We can also combine $\textcolor {MidnightBlue}{select}$ and $\textcolor {MidnightBlue}{filter}$:
select(filter(pos_dat, sex == "m"), totlngth, sex, skullw)
#' In this example, the output of $\textcolor {MidnightBlue}{filter}$ takes the position of 
#' the *data* argument in the $\textcolor {MidnightBlue}{select}$ function. A particular strength of dplyr is the use of 
#' [pipelines](https://en.wikipedia.org/wiki/Pipeline_(Unix)), defined in the R context as a sequence of functions, where the output from one
#' function feeds directly as input of the next function. This can also enhance readability. Consider for example the previous code
#' (combination of $\textcolor {MidnightBlue}{select}$ and $\textcolor {MidnightBlue}{filter}$) rewritten as pipe (pipe operator: %>%):
pos_dat %>%
  filter(sex == "m") %>%
  select(totlngth, sex, skullw)
#' dplyr also provides a useful function ($\textcolor {MidnightBlue}{arrange}$) to sort a dataframe according to selected variables:
pos_dat %>%
  arrange(totlngth)
# now in descending order
pos_dat %>%
  arrange(desc(totlngth))
#' Compare this to the sorting of dataframes in basic R, which is much less elegant:
ord_1 <- order(pos_dat[ ,"totlngth"])
pos_dat[ord_1, ]
#' We can also easily sort by multiple columns and afterwards select a few variables:
pos_dat %>%
  arrange(age, desc(totlngth)) %>%
  select(age, totlngth, belly)
#' Another useful function is $\textcolor {MidnightBlue}{rename}$:
pos_dat %>%
  rename(total_length = totlngth)
# We inspect the original dataframe
head(pos_dat)
#' Why is the original name still in the dataframe? **What would you need to do, to keep the
#' changed name?**
#' 
#' Finally, the mutate function allows to create new columns, for example, as
#' a function of existing columns:
pos_dat %>%
  mutate(Sum_hdln_totlng = hdlngth + totlngth)
# Combined with subsetting to a few columns
pos_dat %>%
  mutate(Sum_hdln_totlng = hdlngth + totlngth) %>%
  select(sex, age, hdlngth, totlngth, Sum_hdln_totlng)
#' Still, you would need to assign this to a new object to store the changes.
#' 
#' # Data exploration
#' 
#' After we have learnt how to process data, we explore the data that will be analysed in the next session. Although graphical tools are most suitable 
#' to obtain an overview on data, the $\textcolor {MidnightBlue}{summary}$ function quickly provides information on potential outliers, 
#' missing values (*NA's*) and the range of data:
# Reset max.print options to 100 to avoid that information is omitted
options(max.print = 120)
summary(pos_dat)
#' For the categorical variables *Pop* and *sex* the function returns the number of cases per level. For numerical variables, the minimum, maximum,
#' quartiles, median and mean are returned. In the following we use the cleveland plot and boxplot to check for potential errors and outliers.
#' Let us first look at a cleveland plot:
dotchart(pos_dat$totlngth) 
# Provides an overview, but plot would benefit from polishing.
# Increase font size of labels and symbols
par(cex = 1.4)
# Check ?par for explanation and overview of other arguments
dotchart(pos_dat$totlngth,cex.lab = 1.3, 
     xlab = "Total length [cm]", main = "Data overview") 
#' No outlier is visible. This is how an outlier would look like:
#+ echo = FALSE
totlng_outl <- c(pos_dat$totlngth, 830)
dotchart(totlng_outl,cex.lab = 1.3, 
         xlab = "Total length [cm]", main = "Data overview") 
#' The observation at 830 ist an extreme outlier. If you spot such an extreme difference to the remainder
#' of the data, you should scrutinise the raw data, because an order of magnitude difference points 
#' to an error with a decimal point during data entry. Another useful tool that can be used for
#' different purposes including checking for outliers is the boxplot (for brief explanation and different types 
#' [visit the R graph gallery](https://www.r-graph-gallery.com/boxplot/)).
boxplot(pos_dat$totlngth, las = 1, cex.lab = 1.3, 
        ylab = "Total length [cm]", main = "Data overview")
# For the same variable with an added outlier
boxplot(totlng_outl, las = 1, cex.lab = 1.3, 
        ylab = "Total length [cm]", main = "Data overview")
#' You can save a figure from the graphics device using the graphical user interface (*Export* in R Studio). Direct export of 
#' a figure without plotting in R Studio can be done using specific functions such as $\textcolor {MidnightBlue}{jpeg}$, 
#' $\textcolor {MidnightBlue}{png}$ or $\textcolor {MidnightBlue}{pdf}$. For details see $\textcolor {MidnightBlue}{?jpeg}$ and 
#' $\textcolor {MidnightBlue}{?pdf}$
#+ eval = FALSE
# example for directly exporting the boxplot to a file
jpeg("Boxplot.jpeg", quality = 100)
par(cex = 1.4)
boxplot(pos_dat$totlngth, las = 1, cex.lab = 1.3, 
        ylab = "Total length [cm]", main = "Data overview")
dev.off()
# Switches off the device (here: saves content to file in working directory)
#' Although the boxplot is widely used and you should be familiar with its interpretation, interesting alternatives such as the beanplot
#' have been introduced [@KampstraBeanplotBoxplotAlternative2008]. The related paper is [available via open access](http://www.jstatsoft.org/v28/c01/). 
#' Refer to the paper and the lecture for explanation of the plot. We first load and attach the package:
library(beanplot)
#' If you do not have the package installed, you need to install the package via:
# install.packages("beanplot") # (remove comment in this case)
#' Now we create a beanplot for the total lenght of possums
beanplot(pos_dat$totlngth) 
# provides single observations (lines), mean (thick line) and 
# displays the estimated probability density distribution (black polygon)
#' Again, a few additional arguments improve the quality of the figure. It is quite handy
#' that these arguments are the same as for the boxplot or dotchart:
beanplot(pos_dat$totlngth, las = 1, cex.lab = 1.3, 
         ylab = "Total length [cm]", main = "Data overview") 
#' Both the boxplot and beanplot are practical tools to compare the distribution among variables or groups. Several statistical tests
#' for between group differences (e.g. *t*-test or analysis of variance) require that the variance is homogeneous across groups.
#' This homogeneity of variance translates to a similar spread of the data around the mean. Examplarily, we inspect the distribution
#' of possums from Victoria and from other states with a conditional boxplot:
boxplot(totlngth ~ Pop, data = pos_dat, las = 1, cex.lab = 1.3, 
        ylab = "Total length [cm]", xlab = "Possum population") 
#' The *tilde* sign ~ is used in R to formulate statistical models, where the response variable(s) are on the left hand side
#' and the explanatory variables/predictors on the right hand side. Here, the notation results in the plotting of the responses 
#' per factor level of the variable *Pop*. 
#' 
#' To ease visual comparison of the spread around the median, we put both variables on the same median. This can be done with the base
#' R function $\textcolor {MidnightBlue}{tapply}$ that applies a function to each group of data defined by the levels of a factor.
#' We calculate the median for each group and assign it to the object *med*:
med <- tapply(pos_dat$totlngth, pos_dat$Pop, median)
# first argument: data, second argument: factor, third argument: function
# to be applied to each group defined by the factor
med
#' The same calculation can be done using dplyr functions. We need two new functions $\textcolor {MidnightBlue}{group\_by}$ and
#' $\textcolor {MidnightBlue}{summarise}$ to elegently do this. **Check what is done by calling the help for the new functions and
#' by sequential execution of the code below (i.e. first execute the code until second %>% (not included), then until third %>%
#' (not included)):**  
pos_dat %>% 
  group_by(Pop) %>%
  select(totlngth, Pop) %>%
  summarise(med = median(totlngth)) 
#' Note that a different type of object is produced using dplyr than using the base R function above:
#' a so-called [tibble](https://cran.r-project.org/web/packages/tibble/vignettes/tibble.html).
#'
#' Anyway, we proceed within the framework of base R and now substract the respective median from each observation of the groups.
w <- pos_dat$totlngth - med[pos_dat$Pop]
#' **Call the object *med* and check how it is modified by *med[pos_dat$Pop]*.**
#' 
#' The resulting vector *w* gives the distance of each observation to the median of its group. 
#' This is equivalent to setting the median of both data sets to 0. We plot again:
boxplot(w ~ Pop, data = pos_dat, las = 1, cex.lab = 1.3, 
        ylab = "Distance to median [cm]", xlab = "Possum population")
#' The variance looks slightly higher in Victoria, but such a small difference would be irrelevant (i.e. not violate 
#' the assumption of same variance of statistical tests). If this was a serious analysis, we would also need to account 
#' for the sex of possums as this is known to influence the body length. Ignoring the
#' sex in the analysis could lead to flawed inference if for example the proportion of females differs between the 
#' two sample populations *Pop* (see the Chapter *Sample and Population* in the document *Key terms and concepts*, in particular
#' the explanation of the *Simpson's paradox*). Indeed, the proportion of females differs strongly between possums measured
#' in Victoria (*Vic*) and other states (*other*):
pos_dat %>% 
  select(sex, Pop) %>% 
  group_by(Pop, sex) %>% 
  count
# more than 50% females in Victoria, but only 1/3 in other states.

#' A question you may still have is: *When should we be concerned about a difference
#' in the variance?* We discuss this question in the context of the respective method as there is no general answer.
#' 
#' We can also use the beanplot for comparison:
beanplot(w ~ Pop, data = pos_dat, las = 1, cex.lab = 1.3, 
        ylab = "Distance to median [cm]", xlab = "Possum population")
# The Victorian possum population is less symmetric presumably due to the higher
# proportion of females in the population (superimposition of two distributions)
#' The Victorian population is less symmetric than the 
#' Note that we can again use the same arguments for the boxplot and beanplot function. Quite convenient, isn't it? However,
#' the beanplot displays the mean instead of median. **Try to produce the same plot with the mean substracted from each observation!** *Hint:
#' the function to calculate the mean is mean().*
#' 
#' Another assumption of several data analysis tools is that the data is normally distributed. This can be checked using 
#' the so-called *QQ-plot*, which plots theoretical Quantiles from a normal distribution against the sample Quantiles 
#' (the definition and interpretation of Quantiles is explained in the lecture). If the data originate from a
#' normal distribution, the points should approximately fall on a 1:1 line. For statistical tests focusing on
#' between-group differences, the assumption would need to be checked for each group. Here, we ignore any potential grouping 
#' structure of the data and exemplify the QQ-plot for the variable total length:
# Quantile-Quantile plot
qqnorm(pos_dat$totlngth)
# We add a line that goes through the first and third quartiles, 
# which helps to spot deviations.
qqline(pos_dat$totlngth)
#' The deviations here are minor and can be ignored. Again, you may ask: *When should we be concerned about a difference
#' in the variance?* A helpful function in this context is $\textcolor {MidnightBlue}{qreference}$ provided 
#' in the package [DAAG](https://cran.r-project.org/web/packages/DAAG/index.html), which relates to the book
#' by Maindonald & Braun [-@MaindonaldDataanalysisgraphics2010]. It produces reference plots to aid in 
#' the evaluation whether the data are normally distributed. The reference plots are based on sample quantiles from
#' data that has been generated through random sampling from a normal distribution with the same parameters (sample mean and sample 
#' variance) and sample size as the data under evaluation.  

library(DAAG)
qreference(pos_dat$totlngth, nrep = 8, xlab = "Theoretical Quantiles") 
# nrep controls the number of reference plots
#' The reference plots give an idea how data randomly sampled data from a normal distribution can deviate from the theoretical
#' normal distribution. Clearly, the data (blue) does not look conspicuous when compared to the reference plots (purple).
#' 
#' A similar approach is to plot the QQ-plot for the data among reference QQ-plots without indication in the figure 
#' which QQ-plot relates to the data. Unless the data deviate strongly from a normal distribution, the QQ-plot 
#' related to the data is presumably indistinguishable from the reference plots. Hence, if you cannot identify the 
#' QQ-plot related to the data, there is no need for concern regarding a potential deviation from the normal distribution.
#' The code for this approach is provided in a [blog](https://biologyforfun.wordpress.com/2014/04/16/checking-glm-model-assumptions-in-r/).
#' 
#' How would a strong deviation look? We discuss two examples. First, we draw samples from a binomial distribution:
set.seed(2018)
# set.seed is used for reproducibility
# i.e. the function returns the same random numbers
x <- rbinom(n = 15, size = 5, p = 0.6) 
# n = sample size, size = number of trials
# p = probability of success
#' We use the QQ plot to evaluate normal distribution:
qqnorm(x)
# Strong deviation
qqline(x)
# The deviation is particularly obvious when compared to reference plots
qreference(x, nrep = 8, xlab = "Theoretical Quantiles") 
#' Even if the data would deviate less from the 1:1 line, the data clearly comes from a discrete distribution, whereas the normal distribution 
#' is continuous. In the second example, we draw samples from a [uniform distribution](https://en.wikipedia.org/wiki/Uniform_distribution_(continuous)).
set.seed(2018)
y <- runif(50, min = 0, max = 20) 
#' Again, we use the QQ plot to evaluate for normal distribution:
qqnorm(y)
qqline(y)
#' A strong deviation is visible, particularly for the lower and upper Quantiles. This impression is confirmed when
#' comparing the QQ-plot for the data to reference QQ-plots. A much stronger curvature is visible.
qreference(y, nrep = 8, xlab = "Theoretical Quantiles") 

#' Another useful tool is the histogram. It can be used to check normality of the data, symmetry and whether the data is
#' bi- or multi-modal. Typically, the histogram displays the frequency with which values of the data fall into, typically
#' same-sized, intervals. For example, we plot a histogram for the total length of Victorian possum populations:
# extract Victorian possum data for variable total length
Vic_pos <- pos_dat %>%
              filter(Pop == "Vic") %>%
              select(totlngth)
# convert to vector, otherwise histogram function throws an error
Vic_pos2 <- as.vector(t(Vic_pos))
# create histogram
hist(Vic_pos2) 
# Intervals have a width of 5
#' The histogram shows that more than 15 possums had a lenght between 85 and 90 cm, whereas 11 and 12 possums had a lenght
#' between 80 and 85 cm and between 90 and 95 cm, respectively. Instead of absolute frequencies, the histogram can also be used 
#' to display relative frequencies, i.e. the probability densities: 
hist(Vic_pos2, probability = TRUE) 
#' Note that different intervals affect the outlook and potentially the interpretation of a histogram:
# We use the data from the non-Victorian possum population.
nVic_pos <- pos_dat %>%
  filter(Pop == "other") %>%
  select(totlngth)
# convert to vector
nVic_pos2 <- as.vector(t(nVic_pos))
# plot histogram, manually provide breaks
hist(nVic_pos2, breaks = 72.5 + (0:5) * 5, 
     xlim = c(70, 105), ylim = c(0, 26), 
     xlab = "Total length (cm)", main = "", las = 1) 
# Plot suggests a normal distribution
# Provide different set of breaks
hist(nVic_pos2, breaks = 75 + (0:5) * 5, 
     xlim = c(70, 105), ylim = c(0, 26), 
     xlab = "Total length (cm)", main = "", las = 1) 
# With different break points between the intervals, the data look rather skewed
#' The outlook and interpretation is also affected by the number of breaks:
par(mfrow = c(2,2), las = 1)
hist(nVic_pos2, breaks = 5, main = "5 breaks", xlab = "Total length (cm)")
hist(nVic_pos2, breaks = 10, main = "10 breaks", xlab = "Total length (cm)")
hist(nVic_pos2, breaks = 20, main = "20 breaks", xlab = "Total length (cm)")
hist(nVic_pos2, breaks = 50, main = "50 breaks", xlab = "Total length (cm)")
#' Adding density lines to histograms aids in reducing the effect of the number
#' of breaks and of the position of the break points on the interpretation. The density lines are derived
#' from the empirical density distribution of the data.
# Derive density line
dens <- density(nVic_pos2)  
# add to first histogram that suggested normal distribution
# only works for relative frequency histogram, which requires
# to set the argument probability = TRUE
par(mfrow = c(1,2), las = 1)
hist(nVic_pos2, breaks = 72.5 + (0:5) * 5, 
     xlim = c(70, 105), ylim = c(0, 0.11), probability = TRUE,
     xlab = "Total length (cm)", main = "") 
lines(dens) 
# add to histogram for which data look rather skewed
hist(nVic_pos2, breaks = 75 + (0:5) * 5, 
     xlim = c(70, 105), ylim = c(0, 0.11), probability = TRUE,
     xlab = "Total length (cm)", main = "")
lines(dens) 
#' The density lines are the same and confirm the approximate normal distribution of the data.
#' Similarly, the density lines can alleviate the effect of the number of breaks on the interpretation,
#'  where too few or too many breaks may result in flawed interpretations.
par(mfrow = c(1,1), las = 1)
hist(nVic_pos2, breaks = 20, 
     xlim = c(70, 105), ylim = c(0, 0.2), probability = TRUE,
     xlab = "Total length (cm)", main = "20 breaks")
lines(dens) 
#' Setting break points manually or a high number of breaks is particularly useful when the aim is to assess
#' the frequency of distinct values such as zeros.
#' 
#' To evaluate normality of data in a histogram can be done by overlaying a density line from 
#' a theoretical normal probability distribution. To do this, we generate a normal distribution
#' with the parameters (i.e. mean and variance) taken from the sample data.
# calculate mean
mean_samp <- mean(nVic_pos2)
# calculate standard deviation
sd_samp <- sd(nVic_pos2)
# derive densities for normal distribution
dens_norm <- dnorm(seq(70, 105, by=.5), mean = mean_samp, sd = sd_samp)
# add to plot
hist(nVic_pos2, breaks = 20, 
     xlim = c(70, 105), ylim = c(0, 0.2), probability = TRUE,
     xlab = "Total length (cm)", main = "20 breaks", las = 1)
lines(dens) 
lines(seq(70, 105, by=.5), dens_norm, col="blue", lwd = 2)
#' The blue line displays the normal distribution. A slight deviation of the sample
#' distribution is visible, which is presumably due to ignoring the influence of sex 
#' on the length of possums.
#' 
#' A range of plots that illustrate different deviations from normality are available on the
#' [histogram Wikipedia page](https://en.wikipedia.org/wiki/Histogram): [right skewed distribution](https://en.wikipedia.org/wiki/Histogram#/media/File:Skewed-right.png), 
#' [left skewed distribution](https://en.wikipedia.org/wiki/Histogram#/media/File:Skewed-left.png), 
#' [bimodal distribution](https://en.wikipedia.org/wiki/Histogram#/media/File:Bimodal-histogram.png) and
#' [multimodal distribution](https://en.wikipedia.org/wiki/Histogram#/media/File:Multimodal.png).
#' 
#' Several other tools for exploratory analysis that have been mentioned in the lecture will be used
#' and introduced in the context of specific methods of data analysis later in the course.
#' 
#' You can render the Rmarkdown document related to the pdf by executing the following function:
# rmarkdown::render("/Users/ralfs/Gitprojects/Teaching/Data_analysis/Code/Session_1.R")
# You need to replace the file location with the path to your file location.

#' # References


