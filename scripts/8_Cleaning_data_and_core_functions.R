# 8.2 Load packages  ====
library(pacman)
p_load(
  rio,        # importing data  
  here,       # relative file pathways  
  janitor,    # data cleaning and tables
  lubridate,  # working with dates
  epikit,     # age_categories() function
  tidyverse,  # data management and visualization
  skimr       # reivew a table
)

options("max.print" = 999999)


# 8.3 Import source data  ====
linelist_raw <- import(here("data", "linelist_raw.xlsx"))
linelist_raw %>% head(50)

# review (similar to pandas' profiling)
skim(linelist_raw)


# 8.4 Column names  ====
# NOTE: To reference a column name that includes spaces, surround the name with back-ticks, for example: linelist$` '\x60infection date\x60'`. note that on your keyboard, the back-tick (`) is different from the single quotation mark (’).
colnames(linelist_raw)  # merged header for colnumns 27 & 28

# auto clean column names
linelist <- linelist_raw %>% 
  clean_names()

names(linelist)

# manual name cleaning, alternatively using "select"
linelist <- linelist_raw %>% 
  rename(date_infection      = `infection date`,  # I can use tab for columns name
         date_hospialisation = `hosp date`,
         date_outcome = date_of_outcome) %>% 
  clean_names()
  
names(linelist)

linelist$x28

# For example, if you want to re-order the columns, everything() is a useful function to signify “all other columns not yet mentioned”. The command below moves columns date_onset and date_hospitalisation to the beginning (left) of the dataset, but keeps all the other columns afterward. Note that everything() is written with empty parentheses:
linelist %>% 
  select(date_onset, date_hospialisation, everything()) %>% 
  names()

linelist %>% 
  select(contains("time")) %>% 
  names()

linelist %>% 
  select(contains("date")) %>% 
  names()

# same results if the date is placed at the beginning
linelist %>% 
  select(starts_with("date")) %>% 
  names()

linelist %>% 
  select(ends_with("date")) %>% 
  names()

linelist %>% 
  select(starts_with("merged_")) %>% 
  names()

linelist %>% 
  select(starts_with("x")) %>% 
  names()

linelist %>% 
  select(last_col()) %>% 
  names()

linelist %>% 
  select(matches("[pt]al")) %>%  # apply regular expression
  names()

linelist %>% 
  select(num_range()) %>%  # not application for this example
  names()

linelist %>% 
  select(where(is.numeric)) %>%   # note: without empty parentheses 
  names()

linelist %>% 
  select(matches("onset|hosp|fev")) %>% 
  names()

# Note: any_of is not so useful when selecting columns. If the df is loaded, use tab to pick up the available columns and avoid misspelling.
linelist %>% 
  select(any_of(c("date_onset", "village_origin", "village_detection", "village_residence", "village_travel"))) %>% 
  names()

names(linelist)
