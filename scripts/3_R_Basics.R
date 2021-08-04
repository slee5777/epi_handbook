## Chapter 2 Download data ====

# install.packages("pacman")
library(pacman)
# install the latest version of the Epi R Handbook package
pacman::p_install_gh("appliedepi/epirhandbook")

# load the package for use
pacman::p_load(epirhandbook)

# download the offline handbook to your computer
# download_book()

# download all the example data into a folder on your computer
# get_data("all")

## Chpater 3 R Basic ====
# install.packages("installr")
library(installr)
updateR()  # 4.1.0 (2021-May-18)

# TinyTex (for compiling an RMarkdown document to PDF):
install.packages('tinytex')
# to uninstall TinyTeX, run tinytex::uninstall_tinytex()
library(tinytex)

# TIP: If your RStudio displays only one left pane it is because you have no scripts open yet.

# 3.6 Functions =====
sqrt(49)
# Print summary statistics of column 'age' in the dataset 'linelist'


linelist <-  readRDS("C:/Users/sarad/Documents/R/Epi_R_Handbook/data/linelist_cleaned.rds")
# alternatively
p_load("rio")

linelist <- rio::import("C:/Users/sarad/Documents/R/Epi_R_Handbook/data/linelist_cleaned.xlsx", which = "Sheet 1")

dim(linelist)
colnames(linelist)
head(linelist)
linelist$age

# Print summary statistics of column 'age' in the dataset 'linelist'
summary(linelist$age)

# Create an age pyramid
age_pyramid(
  data = linelist,
  age_group = "age_cat5",
  split_by = "gender"
)

# 3.9 Working directory ======
getwd()
setwd("C:/Users/sarad/Documents/R/Epi_R_Handbook/data")
getwd()

# 3.10 Objects =====

# Assignment
current_week <- "2018-w10"
current_week

linelist <- import("linelist_cleaned.xlsx", which = "Sheet 1")
dim(linelist)

# printed to R console only
table(linelist$gender, linelist$outcome)

# create new "bmi" column using dplyr syntax
library(dplyr)
linelist <- linelist %>% 
  mutate (bmi = wt_kg / (ht_cm/100)^2)

linelist %>% head()



# Object types
class(linelist)
class(linelist$age)
class(linelist$gender)

num_vector <- c(1,2,3,4,5)
class(num_vector)
num_vector[3] <- "three"
class(num_vector)
num_vector

# Convert an object to another class

x <- c(0, "1", 1.0, 1.00)
# check an object class
is.numeric(x[1])  # F  ???
is.numeric(x[3])  # F  ???
is.character(x[2])  # T
is.double(x[3])

# Retrieve the length of the vector age_years
length(linelist$age)  # 5888
dim(linelist)  # 5888 x 30

# Access/index with brackets []
my_vector <- c("a", "b", "c", "d", "e", "f")
my_vector[5]

# Summary for a single column
summary(linelist$age)

# Summary for a whole dataframe
summary(linelist)

# Just the second element of the summary, with name (using only single brackets)
summary(linelist$age)[2]  # 1st Qu. 6

# Just the second element, without name (using double brackets)
summary(linelist$age)[[2]]  # 6

summary(linelist$age)["Median"]
# Just the second element, without name (using double brackets)
summary(linelist$age)[["Median"]]

dim(linelist)
head(linelist, 2)
# View a specific row (1) from dataset, with all columns (don't forget the comma!)
linelist[1,]
# without a comma, list out the whole column one!!!  
linelist[1]

# View all rows, but just one column
linelist["date_onset"]  ##TODO PR linelist[, "date_onset"] not working

# View values from row 2 and columns 5 through 10
linelist[2, 5:10]

# View values from row 2 and columns 5 through 10 and 18
linelist[2, c(5:10, 18)]

# View rows 2 through 20, and specific columns
linelist[2:5, c("date_onset", "outcome", "age")]

# View rows and columns based on criteria
# *** Note the dataframe must still be named in the criteria!
linelist[linelist$age > 25 , c("date_onset", "outcome", "age")]
dim(linelist[linelist$age > 25 , c("date_onset", "outcome", "age")])
  
# one filter for the whole dateframe
linelist[linelist$age > 25 ,] 

# Use View() to see the outputs in the RStudio Viewer pane (easier to read) 
# *** Note the capital "V" in View() function
View(linelist[2:20, "date_onset"])

# Save as a new object
new_table <- linelist[2:20, "date_onset"]

# dplyr ====
# View first 100 rows
linelist %>%  head(100)

# Show row 5 only
linelist %>%  filter(row_number() == 5)

# View rows 2 through 20, and three specific columns (note no quotes necessary on column names)
linelist %>% 
  select(date_onset, outcome, age) %>% 
  filter(row_number() %in% 2:20)

my_list <- list(
  hospitals = c("Central", "Empire", "Santa Anna"),
  addresses = data.frame(
    street = c("145 Medical Way", "1048 Brown Ave", "999 El Camino"),
    city = c("Andover", "Hamilton", "El Paso")
  )
)

my_list

my_list[1]
my_list[["hospitals"]]
my_list[[1]][3]
my_list[[2]][1]
my_list[[2]][2,1]

# Remove objects ====
rm(x)
x  # Output: Error: object 'x' not found

# You can remove all objects (clear your workspace) by running:
rm(list = ls(all = TRUE))

# 3.11 Piping (%>%) ====
linelist_summary <- linelist %>% 
  count(age_cat) 

linelist_summary

linelist %>% 
  filter(age > 50)

# 3.12 Key operators and functions ====
is.na(7)  # False
!is.na(7)  # True

colnames(linelist)

linelist_cleaned <- linelist %>% 
  mutate(case_def = case_when(
    is.na(outcome) ~ NA_character_,
    fever == "yes" & cough == "yes" ~ "Confirmed",
    fever == "no" & chills == "no" & cough == "no" & aches == "no" & vomit == "no" ~ "Suspected",
    TRUE ~ "Probable"
  ))

linelist_cleaned %>% 
  count(case_def)

rdt_result <- c("Positive", "Suspected", "Positive", NA)   # two positive cases, one suspected, and one unknown
is.na(rdt_result)  # Tests whether the value of rdt_result is NA

# Mathematical functions
n = 3.145
round(n, digits = 2)  # 3.14
# DANGER: round() uses “banker’s rounding” which rounds up from a .5 only if the upper number is even. Use round_half_up() from janitor to consistently round halves up to the nearest whole number. See this explanation
round(c(2.5, 3.5))  # DANGER 2, 4
janitor::round_half_up(c(2.5, 3.5))  # 3, 4

# install.packages("janitor")
library(janitor)
janitor::round_half_up(n, digits = 2) # 3.15
ceiling(n)  # 4
floor(n)

# number of significant figures
signif(n, digits = 2)

log(n)
log10(n)
log2(n)

# turn off scientific notation
options(scipen=999)

# If supplying raw numbers to a function, wrap them in c()
mean(1, 6, 12, 10, 5, 0)    # !!! INCORRECT !!!  1
mean(c(1, 6, 12, 10, 5, 0)) # CORRECT  5.666667
mean(c(1, 6, 12, 10, 5, 0, NA), na.rm = T) # ignore NA, 5.666667
mean(c(1, 6, 12, 10, 5, 0, 0), na.rm = T)  # 4.857143

# create a sequence
seq(1, 10, 2)

# repeat x, n times
rep(1:3, 3)
rep(c("a", "b", "c"), 3)

# subdivide a numeric vector
head(linelist$age) 
head(cut(linelist$age, 5))  ##TODO see docs

# take a random sample
set.seed(8964)
sample(linelist$case_id, size = 5)

# %in% A very useful operator for matching values, and for quickly assessing if a value is within a vector or dataframe.

my_vector <- c("a", "b", "c", "d")
"a" %in% my_vector  # True
"h" %in% my_vector  # False

# To ask if a value is not %in% a vector, put an exclamation mark (!) in front of the logic statement:
! "a" %in% my_vector  # False
! "h" %in% my_vector  # True

# %in% is very useful when using the dplyr function case_when(). You can define a vector previously, and then reference it later. For example:
ctr_hospitals <- c("St. Mark's Maternity Hospital (SMMH)", 
                   "Military Hospital",
                   "Central Hospital")

linelist_regions <- linelist %>% 
  mutate(regions = case_when(
    hospital %in% ctr_hospitals & age < 18 ~ "center child",
    hospital %in% ctr_hospitals & age > 18 ~ "center audlt",
    ! hospital %in% ctr_hospitals & age < 18 ~ "region child",
    ! hospital %in% ctr_hospitals & age > 18 ~ "region audlt",
    TRUE                                      ~ "Not"))

unique(linelist_regions$regions)

linelist_regions %>% 
  count(regions)

# Note: If you want to detect a partial string, perhaps using str_detect() from stringr, it will not accept a character vector like c("1", "Yes", "yes", "y"). Instead, it must be given a regular expression - one condensed string with OR bars, such as “1|Yes|yes|y”. For example, str_detect(hospitalized, "1|Yes|yes|y"). See the page on Characters and strings for more information.

# 3.13 Errors & warnings ====

