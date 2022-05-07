### Divvy_Exercise_Full_Year_Analysis ###

# This analysis is based on the Divvy case study "'Sophisticated, Clear, and Polished': Divvy and Data Visualization" written by Kevin Hartman (found here: https://artscience.blog/home/divvy-dataviz-case-study). The purpose of this script is to consolidate downloaded Divvy data into a single dataframe and then conduct simple analysis to help answer the key question: "In what ways do members and casual riders use Divvy bikes differently?"

# # # # # # # # # # # # # # # # # # # # # # # 
# Install required packages
# tidyverse for data import and wrangling
# lubridate for date functions
# ggplot for visualization
# # # # # # # # # # # # # # # # # # # # # # #  
install.packages("dplyr")
help("dplyr")

library(tidyverse)  #helps wrangle data
library(lubridate)  #helps wrangle date attributes
library(ggplot2)  #helps visualize data
library(dplyr)
getwd() 


#=====================
# STEP 1: COLLECT DATA
#=====================
# Upload Divvy datasets (csv files) here

marchdata <- X202103_divvy_tripdata
colnames(marchdata)

#====================================================
# STEP 2: WRANGLE DATA AND COMBINE INTO A SINGLE FILE
#====================================================
# Compare column names each of the files
# While the names don't have to be in the same order, they DO need to match perfectly before we can use a command to join them into one file

head(marchdata)

# Rename columns  to make them consistent with q1_2020 (as this will be the supposed going-forward table design for Divvy)

# <- rename(marchdata,trip_id=ride_id)



help("dplyr")
browseVignettes(package = "dplyr")

marchdata <- rename(marchdata
                   ,ride_id = trip_id
                   ,rideable_type = bikeid 
                   ,started_at = start_time  
                   ,ended_at = end_time  
                   ,start_station_name = from_station_name 
                   ,start_station_id = from_station_id 
                   ,end_station_name = to_station_name 
                   ,end_station_id = to_station_id 
                   ,member_casual = usertype)

    
                                      
# Inspect the dataframes and look for incongruencies
str(marchdata)

# Convert ride_id and rideable_type to character so that they can stack correctly
marchdata <-  mutate(marchdata, ride_id = "trip_id")
 

# Stack individual quarter's data frames into one big data frame
#all_trips <- bind_rows(q2_2019, q3_2019, q4_2019, q1_2020)

# Remove lat, long, birthyear, and gender fields as this data was dropped beginning in 2020
marchdata <- marchdata %>%  
  select(-c(start_lat, start_lng, end_lat, end_lng))
         
         
         
#======================================================
# STEP 3: CLEAN UP AND ADD DATA TO PREPARE FOR ANALYSIS
#======================================================
# Inspect the new table that has been created
colnames(marchdata)  #List of column names
nrow(marchdata)  #How many rows are in data frame?
dim(marchdata)  #Dimensions of the data frame?
head(marchdata)  #See the first 6 rows of data frame.  Also tail(all_trips)
str(marchdata)  #See list of columns and data types (numeric, character, etc)
summary(marchdata)  #Statistical summary of data. Mainly for numerics

# There are a few problems we will need to fix:
# (1) In the "member_casual" column, there are two names for members ("member" and "Subscriber") and two names for casual riders ("Customer" and "casual"). We will need to consolidate that from four to two labels.
# (2) The data can only be aggregated at the ride-level, which is too granular. We will want to add some additional columns of data -- such as day, month, year -- that provide additional opportunities to aggregate the data.
# (3) We will want to add a calculated field for length of ride since the 2020Q1 data did not have the "tripduration" column. We will add "ride_length" to the entire dataframe for consistency.
# (4) There are some rides where tripduration shows up as negative, including several hundred rides where Divvy took bikes out of circulation for Quality Control reasons. We will want to delete these rides.

# In the "member_casual" column, replace "Subscriber" with "member" and "Customer" with "casual"
# Before 2020, Divvy used different labels for these two types of riders ... we will want to make our dataframe consistent with their current nomenclature
# N.B.: "Level" is a special property of a column that is retained even if a subset does not contain any values from a specific level


# Begin by seeing how many observations fall under each usertype

table(marchdata$member_casual)
table(marchdata$rideable_type)


# Reassign to the desired values (we will go with the current 2020 labels)
#all_trips <-  all_trips %>% 
  #mutate(member_casual = recode(member_casual
                                ,"Subscriber" = "member"
                                ,"Customer" = "casual"))

# Check to make sure the proper number of observations were reassigned
#table(all_trips$member_casual)

# Add columns that list the date, month, day, and year of each ride
# This will allow us to aggregate ride data for each month, day, or year ... before completing these operations we could only aggregate at the ride level
# https://www.statmethods.net/input/dates.html more on date formats in R found at that link

marchdata$date <- as.Date(marchdata$started_at) #The default format is yyyy-mm-dd
marchdata$month <- format(as.Date(marchdata$date), "%m")
marchdata$day <- format(as.Date(marchdata$date), "%d")
marchdata$year <- format(as.Date(marchdata$date), "%Y")
marchdata$day_of_week <- format(as.Date(marchdata$date), "%A")

marchdata


marchdata2 <- marchdata


# Add a "ride_length" calculation to all_trips (in seconds)
# https://stat.ethz.ch/R-manual/R-devel/library/base/html/difftime.html
marchdata$ride_length <- difftime(marchdata$ended_at,marchdata$started_at)

# Inspect the structure of the columns
str(marchdata)
summary(marchdata)  #Statistical summary of data. Mainly for numerics

# Convert "ride_length" from Factor to numeric so we can run calculations on the data
is.factor(marchdata$ride_length)
marchdata$ride_length <- as.numeric(as.character(marchdata$ride_length))
is.numeric(marchdata$ride_length)

# Remove "bad" data

# The dataframe includes a few hundred entries when bikes were taken out of docks and checked for quality by Divvy or ride_length was negative
# We will create a new version of the dataframe (v2) since data is being removed
# https://www.datasciencemadesimple.com/delete-or-drop-rows-in-r-with-conditions-2/
marchdata <- marchdata[!(marchdata$start_station_name == "HQ QR" | marchdata$ride_length<=0),]

#=====================================
# STEP 4: CONDUCT DESCRIPTIVE ANALYSIS
#=====================================

# Descriptive analysis on ride_length (all figures in seconds)

mean(marchdata$ride_length) #straight average (total ride length / rides)
median(marchdata$ride_length) #midpoint number in the ascending array of ride lengths
max(marchdata$ride_length) #longest ride
min(marchdata$ride_length) #shortest ride

# You can condense the four lines above to one line using summary() on the specific attribute

summary(marchdata$rideable_type)
str(marchdata)

# Compare members and casual users

aggregate(marchdata$ride_length ~ marchdata$member_casual, FUN = mean)
aggregate(marchdata$ride_length ~ marchdata$member_casual, FUN = median)
aggregate(marchdata$ride_length ~ marchdata$member_casual, FUN = max)
aggregate(marchdata$ride_length ~ marchdata$member_casual, FUN = min)

# See the average ride time by each day for members vs casual users

aggregate(marchdata$ride_length ~ marchdata$member_casual + marchdata$day_of_week, FUN = mean)

# Notice that the days of the week are out of order. Let's fix that.

ordered(marchdata$day_of_week)

# Now, let's run the average ride time by each day for members vs casual users

aggregate(marchdata$ride_length ~ marchdata$member_casual + marchdata$day_of_week, FUN = mean)

# analyze ridership data by type and weekday

marchdata %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>%  #creates weekday field using wday()
  group_by(member_casual, weekday) %>%  #groups by usertype and weekday
  summarise(number_of_rides = n()							#calculates the number of rides and average duration 
            ,average_duration = mean(ride_length)) %>% 		# calculates the average duration
  arrange(member_casual, -number_of_rides)		


# Let's visualize the number of rides by rider type

marchdata %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>% 
  group_by(member_casual, weekday) %>% 
  drop_na(started_at) %>% 
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>% 
  arrange(member_casual, weekday)  %>% 
  ggplot(aes(x = weekday, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge")

# Let's create a visualization for average duration

marchdata %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>% 
  group_by(member_casual, weekday) %>% 
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>% 
  arrange(member_casual, weekday)  %>% 
  ggplot(aes(x = weekday, y = average_duration, fill = member_casual)) +
  geom_col(position = "dodge")


# Let's create a visualization for number of rides and bike type

marchdata %>% 
  group_by(rideable_type, member_casual) %>% 
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>% 
  arrange(rideable_type)  %>% 
  ggplot(aes(x = member_casual, y = number_of_rides, fill = rideable_type)) +
  geom_col(position = "dodge")




#=================================================
# STEP 5: EXPORT SUMMARY FILE FOR FURTHER ANALYSIS
#=================================================
# Create a csv file that we will visualize in Excel, Tableau, or my presentation software
# N.B.: This file location is for a Mac. If you are working on a PC, change the file location accordingly (most likely "C:\Users\YOUR_USERNAME\Desktop\...") to export the data. You can read more here: https://datatofish.com/export-dataframe-to-csv-in-r/
counts <- aggregate(marchdata$ride_length ~ marchdata$member_casual + marchdata$day_of_week, FUN = mean)
write.csv(counts, file = '~/Desktop/Divvy_Exercise/avg_ride_length.csv')
