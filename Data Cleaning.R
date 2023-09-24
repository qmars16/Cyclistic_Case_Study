### Cyclistic_Exercise_Full_Year_Analysis ###

# # # # # # # # # # # # # # # # # # # # # # # 
# Install required packages
# tidyverse for data import and wrangling
# libridate for date functions
# ggplot for visualization
# # # # # # # # # # # # # # # # # # # # # # #  

library(tidyverse)  #helps wrangle data
library(lubridate)  #helps wrangle date attributes
library(ggplot2)  #helps visualize data
# getwd() #displays your working directory
# setwd("\Users\Kumaresh\OneDrive - SSN Trust\SSN College\Placements\Google Data Analytics\Capstone Project\files\csv_files") #sets your working directory to simplify calls to data ... make sure to use your OWN username instead of mine ;)

#=====================
# STEP 1: COLLECT DATA
#=====================
# Upload Divvy datasets (csv files) here
m1_2023 = read_csv("202301-divvy-tripdata.csv")
m2_2023 = read_csv("202302-divvy-tripdata.csv")
m3_2023 = read_csv("202303-divvy-tripdata.csv")
m4_2023 = read_csv("202304-divvy-tripdata.csv")
m5_2023 = read_csv("202305-divvy-tripdata.csv")
m6_2023 = read_csv("202306-divvy-tripdata.csv")
m7_2023 = read_csv("202307-divvy-tripdata.csv")
#====================================================
# STEP 2: WRANGLE DATA AND COMBINE INTO A SINGLE FILE
#====================================================
# Compare column names each of the files
# While the names don't have to be in the same order, they DO need to match perfectly before we can use a command to join them into one file
colnames(m1_2023)
colnames(m2_2023)
colnames(m3_2023)
colnames(m4_2023)
colnames(m5_2023)
colnames(m6_2023)
colnames(m7_2023)

# Inspect the dataframes and look for inconguencies
str(m1_2023)
str(m2_2023)
str(m3_2023)
str(m4_2023)
str(m5_2023)
str(m6_2023)
str(m7_2023)

# changing datatype of started_at, ended_at column to datetime
m5_2023 = mutate(m5_2023, started_at = as_datetime(started_at)
                 ,ended_at = as_datetime(ended_at))
m6_2023 = mutate(m6_2023, started_at = as_datetime(started_at)
                 ,ended_at = as_datetime(ended_at))
m7_2023 = mutate(m6_2023, started_at = as_datetime(started_at)
                 ,ended_at = as_datetime(ended_at))

# changing dtatype of end_station_id to character
m6_2023 = mutate(m6_2023, end_station_id = as.character(end_station_id))
m7_2023 = mutate(m7_2023, end_station_id = as.character(end_station_id))


# Convert ride_id and rideable_type to character so that they can stack correctly
m1_2023 = mutate(m1_2023, ride_id = as.character(ride_id)
                   ,rideable_type = as.character(rideable_type)) 
m2_2023 = mutate(m2_2023, ride_id = as.character(ride_id)
                 ,rideable_type = as.character(rideable_type)) 
m3_2023 = mutate(m3_2023, ride_id = as.character(ride_id)
                 ,rideable_type = as.character(rideable_type)) 
m4_2023 = mutate(m4_2023, ride_id = as.character(ride_id)
                 ,rideable_type = as.character(rideable_type)) 
m5_2023 = mutate(m5_2023, ride_id = as.character(ride_id)
                 ,rideable_type = as.character(rideable_type)) 
m6_2023 = mutate(m6_2023, ride_id = as.character(ride_id)
                 ,rideable_type = as.character(rideable_type)) 
m7_2023 = mutate(m7_2023, ride_id = as.character(ride_id)
                 ,rideable_type = as.character(rideable_type)) 

# Stack individual quarter's data frames into one big data frame
all_trips = bind_rows(m1_2023,m2_2023,m3_2023,m4_2023,m5_2023,m6_2023,m7_2023)

# Remove lat, long as this data was dropped beginning in 2020
all_trips = all_trips %>%  
  select(-c(start_lat, start_lng, end_lat, end_lng))

#======================================================
# STEP 3: CLEAN UP AND ADD DATA TO PREPARE FOR ANALYSIS
#======================================================
# Inspect the new table that has been created
colnames(all_trips)  #List of column names
nrow(all_trips)  #How many rows are in data frame?
dim(all_trips)  #Dimensions of the data frame?
head(all_trips)  #See the first 6 rows of data frame.  Also tail(qs_raw)
str(all_trips)  #See list of columns and data types (numeric, character, etc)
summary(all_trips)  #Statistical summary of data. Mainly for numerics

# There are a few problems we will need to fix:
# (1) In the "member_casual" column, there are two names for members ("member" and "Subscriber") and two names for casual riders ("Customer" and "casual"). We will need to consolidate that from four to two labels.
# (2) The data can only be aggregated at the ride-level, which is too granular. We will want to add some additional columns of data -- such as day, month, year -- that provide additional opportunities to aggregate the data.
# (3) We will want to add a calculated field for length of ride since the 2020Q1 data did not have the "tripduration" column. We will add "ride_length" to the entire dataframe for consistency.
# (4) There are some rides where tripduration shows up as negative, including several hundred rides where Divvy took bikes out of circulation for Quality Control reasons. We will want to delete these rides.

# In the "member_casual" column, replace "Subscriber" with "member" and "Customer" with "casual"
# Before 2020, Divvy used different labels for these two types of riders ... we will want to make our dataframe consistent with their current nomenclature
# N.B.: "Level" is a special property of a column that is retained even if a subset does not contain any values from a specific level
# Begin by seeing how many observations fall under each usertype
table(all_trips$member_casual)

# Reassign to the desired values (we will go with the current 2020 labels)
all_trips =  all_trips %>% 
  mutate(member_casual = recode(member_casual
                           ,"Subscriber" = "member"
                           ,"Customer" = "casual"))

# Check to make sure the proper number of observations were reassigned
table(all_trips$member_casual)

# Add columns that list the date, month, day, and year of each ride
# This will allow us to aggregate ride data for each month, day, or year ... before completing these operations we could only aggregate at the ride level
# https://www.statmethods.net/input/dates.html more on date formats in R found at that link
all_trips$date = as.Date(all_trips$started_at) #The default format is yyyy-mm-dd
all_trips$month = format(as.Date(all_trips$date), "%m")
all_trips$day = format(as.Date(all_trips$date), "%d")
all_trips$year = format(as.Date(all_trips$date), "%Y")
all_trips$day_of_week = format(as.Date(all_trips$date), "%A")

# Add a "ride_length" calculation to all_trips (in seconds)
# https://stat.ethz.ch/R-manual/R-devel/library/base/html/difftime.html
all_trips$ride_length = difftime(all_trips$ended_at,all_trips$started_at)

# Inspect the structure of the columns
str(all_trips)

# Convert "ride_length" from Factor to numeric so we can run calculations on the data
is.factor(all_trips$ride_length)
all_trips$ride_length = as.numeric(as.character(all_trips$ride_length))
is.numeric(all_trips$ride_length)

# Remove "bad" data
# The dataframe includes a few hundred entries when bikes were taken out of docks and checked for quality by Divvy or ride_length was negative
# We will create a new version of the dataframe (v2) since data is being removed
# https://www.datasciencemadesimple.com/delete-or-drop-rows-in-r-with-conditions-2/
all_trips_v2 = all_trips[!(all_trips$start_station_name == "HQ QR" | all_trips$ride_length<0),]