# load libraries ====
# install_formats()
# install.packages("here")
library(rio)
library(here)
library(dbplyr)
library(pacman)
library(stringi)
library(lubridate)
p_load(
  fs, dplyr 
)

# TIP: To quickly convert all \ to / for absolute file path, highlight the code of interest, use Ctrl+f (in Windows), check the option box for “In selection”, and then use the replace functionality to convert them.

# 7.4 Select a file manually  ====
my_data <- import(file.choose()) # choose a file from a pop-up window.  Be careful, the pop-up maybe behind RStudio.

# 7.5 Import data ====
linelist <- import(here("data", "linelist_raw.xlsx"))
linelist %>% head()

linelist <- import("C:/Users/sarad/Github/epi_handbook/data/linelist_cleaned.rds")
linelist %>% head()

# read from spreadsheet
my_data <- import(here("data", "hospital_linelists.xlsx"), which = "Central Hospital")
my_data %>% head()

# Missing values
my_data <- import(here("data", "hospital_linelists.xlsx"), which = "Central Hospital", na = c("Missing", "", " ", "no"))
my_data %>% head()

# Manage a second header row  
# NOTE: personally, I prefer using "select"
# import first time; store the column names
linelist_raw_names <- import(here("data", "linelist_raw.xlsx")) %>% names()  # save true column names
linelist_raw_names

linelist_raw <- import(here("data", "linelist_raw.xlsx")) 
linelist_raw %>% head(2)

# import second time; skip row 2, and assign column names to argument col_names =
linelist_raw <- import(here("data", "linelist_raw.xlsx"),
                       skip = 2,
                       col_names = linelist_raw_names
) 
linelist_raw %>% head(2)

# assign/overwrite headers using the base 'colnames()' function
colnames(linelist_raw) <- linelist_raw_names
colnames(linelist_raw)

# Entry by columns
# define each vector (vertical column) separately, each with its own name
PatientID <- c(235, 452, 778, 111)
Treatment <- c("Yes", "No", "Yes", "Yes")
Death     <- c(1, 0, 1, 0)
# CAUTION: All vectors must be the same length (same number of values).
# combine the columns into a data frame, by referencing the vector names
manual_entry_cols <- data.frame(PatientID, Treatment, Death)
manual_entry_cols

# 7.9 Import most recent file ** IMPORTANT** ====
# Dates in file name
# a) get file names from folder
linelist_filenames <- dir(here("data")) 
linelist_filenames        

# b) extract numbers and any characters in between
linelist_dates_raw <- stri_extract(str = linelist_filenames, 
                                     regex = ("[0-9].*[0-9]"))  ## TODO fix PR
linelist_dates_raw

# c) check the format of date
lineslist_dates_clean <- ymd(linelist_dates_raw)  # when failed to parse, replaced with NA
lineslist_dates_clean

# d) get the latest file index
index_latest_file <- which.max(lineslist_dates_clean)
index_latest_file

# e) get the file name
linelist_filenames[index_latest_file]

# In summary  
latest_file <- dir(here("data")) %>% 
  stri_extract(regex = ("[0-9].*[0-9]")) %>% 
  ymd() %>% 
  which.max() %>% 
  dir(here("data"))  ##TODO no need to use "[[.]]" as a place holder
latest_file

# full file path
here("data", latest_file)

# to import the latest file
x <- import(here("data", latest_file))
x %>% head()

# Alternatively, use a file's meta data to get the latest modified file
latest_file <- dir_info(here("data")) %>%  # collect file info on all files in directory
  arrange(desc(modification_time)) %>%      # sort by modification time
  head(1) %>%                               # keep only the top (latest) file
  pull(path) %>%                            # extract only the file path
  import()  

# 7.10 APIs  ====
p_load(httr, jsonlite, tidyverse)

# prepare the request
path <- "http://api.ratings.food.gov.uk/Establishments"

# specific request
request <- GET(url = path,
               query = list(
                 localAuthorityId = 188,
                 # BusinessTypeId = 7844,
                 pageNumber = 1,
                 pageSize = 5000),
               add_headers("x-api-version" = "2"))

# check for any server error ("200" is good!)
request$status_code

# submit the request, parse the response, and convert to a data frame
response <- content(request, as = "text", encoding = "UTF-8") %>%
  fromJSON(flatten = TRUE) %>%
  pluck("establishments") %>%
  as_tibble()
response

response %>% 
  group_by(BusinessTypeID) %>% 
  summarise(n())


# 7.11 Export  ====
linelist <- head(linelist, 5L)
export(linelist, here("figures", "my_linelist.csv"))

import(here("figures", "my_linelist.csv"))

# 7.12 RDS files (specific for R)  ====
export(linelist, here("figures", "my_linelist.rds"))
import(here("figures", "my_linelist.rds"))


