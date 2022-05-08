Analyzing Data with R
================
Juan Pablo Contreras M
2022-05-08

# Case Study: Bike-sharing company

## How Does a Bike-Share Navigate Speedy Success?

### Introduction

This is an example of the work I can do with R programming language
using a case study example.

### Scenario

You are a junior data analyst working in the marketing analyst team at
Cyclistic, a bike-share company in Chicago. The director of marketing
believes the company’s future success depends on maximizing the number
of annual memberships. Therefore, your team wants to understand how
casual riders and annual members use Cyclistic bikes differently. From
these insights, your team will design a new marketing strategy to
convert casual riders into annual members. But first, Cyclistic
executives must approve your recommendations, so they must be backed up
with compelling data insights and professional data visualizations.

### Characters and teams

● **Cyclistic:** A bike-share program that features more than 5,800
bicycles and 600 docking stations. Cyclistic sets itself apart by also
offering reclining bikes, hand tricycles, and cargo bikes, making
bike-share more inclusive to people with disabilities and riders who
can’t use a standard two-wheeled bike. The majority of riders opt for
traditional bikes; about 8% of riders use the assistive options.
Cyclistic users are more likely to ride for leisure, but about 30% use
them to commute to work each day.

● **Lily Moreno:** The director of marketing and your manager. Moreno is
responsible for the development of campaigns and initiatives to promote
the bike-share program. These may include email, social media, and other
channels.

● **Cyclistic marketing analytics team:** A team of data analysts who
are responsible for collecting, analyzing, and reporting data that helps
guide Cyclistic marketing strategy. You joined this team six months ago
and have been busy learning about Cyclistic’s mission and business goals
— as well as how you, as a junior data analyst, can help Cyclistic
achieve them.

● **Cyclistic executive team:** The notoriously detail-oriented
executive team will decide whether to approve the recommended marketing
program

### About the company

In 2016, Cyclistic launched a successful bike-share offering. Since
then, the program has grown to a fleet of 5,824 bicycles that are
geotracked and locked into a network of 692 stations across Chicago. The
bikes can be unlocked from one station and returned to any other station
in the system anytime.

Until now, Cyclistic’s marketing strategy relied on building general
awareness and appealing to broad consumer segments. One approach that
helped make these things possible was the flexibility of its pricing
plans: single-ride passes, full-day passes, and annual memberships.
Customers who purchase single-ride or full-day passes are referred to as
casual riders. Customers who purchase annual memberships are Cyclistic
members.

Cyclistic’s finance analysts have concluded that annual members are much
more profitable than casual riders. Although the pricing flexibility
helps Cyclistic attract more customers, Moreno believes that maximizing
the number of annual members will be key to future growth. Rather than
creating a marketing campaign that targets all-new customers, Moreno
believes there is a very good chance to convert casual riders into
members. She notes that casual riders are already aware of the Cyclistic
program and have chosen Cyclistic for their mobility needs.

Moreno has set a clear goal: Design marketing strategies aimed at
converting casual riders into annual members. In order to do that,
however, the marketing analyst team needs to better understand how
annual members and casual riders differ, why casual riders would buy a
membership, and how digital media could affect their marketing tactics.
Moreno and her team are interested in analyzing the Cyclistic historical
bike trip data to identify trends.

## Step 1: Collect Data

This analysis is based on the Divvy case study “‘Sophisticated, Clear,
and Polished’: Divvy and Data Visualization” written by Kevin Hartman
(found here: <https://artscience.blog/home/divvy-dataviz-case-study>).

The purpose of this script is to conduct simple analysis to help answer
the key question: **“In what ways do members and casual riders use Divvy
bikes differently?”**

Firs we need to install the required packages:

-   tidyverse for data import and wrangling
-   lubridate for date functions
-   ggplot for visualization

``` r
library(tidyverse)  #helps wrangle data
```

    ## -- Attaching packages --------------------------------------- tidyverse 1.3.1 --

    ## v ggplot2 3.3.5     v purrr   0.3.4
    ## v tibble  3.1.6     v dplyr   1.0.9
    ## v tidyr   1.2.0     v stringr 1.4.0
    ## v readr   2.1.2     v forcats 0.5.1

    ## -- Conflicts ------------------------------------------ tidyverse_conflicts() --
    ## x dplyr::filter() masks stats::filter()
    ## x dplyr::lag()    masks stats::lag()

``` r
library(lubridate)  #helps wrangle date attributes
```

    ## 
    ## Attaching package: 'lubridate'

    ## The following objects are masked from 'package:base':
    ## 
    ##     date, intersect, setdiff, union

``` r
library(ggplot2)  #helps visualize data
library(dplyr)
```

![](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACgAAAAaCAYAAADFTB7LAAAAa0lEQVR42u3OywnAIBBAwcXSUoCW5D11xDoNCBGNv0MOecJOBSOi1OZMsJ4dvFxEJ1OQnMxBarIKEpNNkJbsBknJYZCSnAYJyVVQziNig7/nZkFEbhTE5HpBVO4dxOXKIDL3BLG5BJ1T6rsbMfep2CaMN00AAAAASUVORK5CYII= "Run Current Chunk")

Then we need to check the directory where we are working

``` r
getwd() #displays your working directory
```

    ## [1] "C:/Users/jpcmi/OneDrive/Documents/Curso Data Analytics by Google/Course8_Capstone/CaseStudyData/R files"

``` r
setwd("C:/Users/jpcmi/OneDrive/Documents/Curso Data Analytics by Google/Course8_Capstone/CaseStudyData/R files")
```

Collecting the data from source. In this case we are importing data from
March and April 2021:

``` r
marchdata <- read.csv("202103-divvy-tripdata.csv")
aprildata <- read.csv("202104-divvy-tripdata.csv")
```

## Step 2: Wrangle Data and Combine into a single file

When we want to join two tables we need to check for column names.While
the names don’t have to be in the same order, they DO need to match
perfectly before we can use a command to join them into one file:

``` r
colnames(aprildata)
```

    ##  [1] "ride_id"            "rideable_type"      "started_at"        
    ##  [4] "ended_at"           "start_station_name" "start_station_id"  
    ##  [7] "end_station_name"   "end_station_id"     "start_lat"         
    ## [10] "start_lng"          "end_lat"            "end_lng"           
    ## [13] "member_casual"

``` r
colnames(marchdata)
```

    ##  [1] "ride_id"            "rideable_type"      "started_at"        
    ##  [4] "ended_at"           "start_station_name" "start_station_id"  
    ##  [7] "end_station_name"   "end_station_id"     "start_lat"         
    ## [10] "start_lng"          "end_lat"            "end_lng"           
    ## [13] "member_casual"

As we can see, the column names are equals so we proceed to inspect the
dataframe and look for incongruencies:

``` r
str(marchdata)
```

    ## 'data.frame':    228496 obs. of  13 variables:
    ##  $ ride_id           : chr  "CFA86D4455AA1030" "30D9DC61227D1AF3" "846D87A15682A284" "994D05AA75A168F2" ...
    ##  $ rideable_type     : chr  "classic_bike" "classic_bike" "classic_bike" "classic_bike" ...
    ##  $ started_at        : chr  "2021-03-16 08:32:30" "2021-03-28 01:26:28" "2021-03-11 21:17:29" "2021-03-11 13:26:42" ...
    ##  $ ended_at          : chr  "2021-03-16 08:36:34" "2021-03-28 01:36:55" "2021-03-11 21:33:53" "2021-03-11 13:55:41" ...
    ##  $ start_station_name: chr  "Humboldt Blvd & Armitage Ave" "Humboldt Blvd & Armitage Ave" "Shields Ave & 28th Pl" "Winthrop Ave & Lawrence Ave" ...
    ##  $ start_station_id  : chr  "15651" "15651" "15443" "TA1308000021" ...
    ##  $ end_station_name  : chr  "Stave St & Armitage Ave" "Central Park Ave & Bloomingdale Ave" "Halsted St & 35th St" "Broadway & Sheridan Rd" ...
    ##  $ end_station_id    : chr  "13266" "18017" "TA1308000043" "13323" ...
    ##  $ start_lat         : num  41.9 41.9 41.8 42 42 ...
    ##  $ start_lng         : num  -87.7 -87.7 -87.6 -87.7 -87.7 ...
    ##  $ end_lat           : num  41.9 41.9 41.8 42 42.1 ...
    ##  $ end_lng           : num  -87.7 -87.7 -87.6 -87.6 -87.7 ...
    ##  $ member_casual     : chr  "casual" "casual" "casual" "casual" ...

``` r
str(aprildata)
```

    ## 'data.frame':    337230 obs. of  13 variables:
    ##  $ ride_id           : chr  "6C992BD37A98A63F" "1E0145613A209000" "E498E15508A80BAD" "1887262AD101C604" ...
    ##  $ rideable_type     : chr  "classic_bike" "docked_bike" "docked_bike" "classic_bike" ...
    ##  $ started_at        : chr  "2021-04-12 18:25:36" "2021-04-27 17:27:11" "2021-04-03 12:42:45" "2021-04-17 09:17:42" ...
    ##  $ ended_at          : chr  "2021-04-12 18:56:55" "2021-04-27 18:31:29" "2021-04-07 11:40:24" "2021-04-17 09:42:48" ...
    ##  $ start_station_name: chr  "State St & Pearson St" "Dorchester Ave & 49th St" "Loomis Blvd & 84th St" "Honore St & Division St" ...
    ##  $ start_station_id  : chr  "TA1307000061" "KA1503000069" "20121" "TA1305000034" ...
    ##  $ end_station_name  : chr  "Southport Ave & Waveland Ave" "Dorchester Ave & 49th St" "Loomis Blvd & 84th St" "Southport Ave & Waveland Ave" ...
    ##  $ end_station_id    : chr  "13235" "KA1503000069" "20121" "13235" ...
    ##  $ start_lat         : num  41.9 41.8 41.7 41.9 41.7 ...
    ##  $ start_lng         : num  -87.6 -87.6 -87.7 -87.7 -87.7 ...
    ##  $ end_lat           : num  41.9 41.8 41.7 41.9 41.7 ...
    ##  $ end_lng           : num  -87.7 -87.6 -87.7 -87.7 -87.7 ...
    ##  $ member_casual     : chr  "member" "casual" "casual" "member" ...

Finally we stack individual data frames into one big data frame:

``` r
all_trips <- rbind(marchdata, aprildata)
```

Once we have the joined table, we review which are the variables that
will not be used in the analysis, and we proceed to remove them:

``` r
all_trips <- all_trips %>% 
  select(-c(start_lat,start_lng,end_lat,end_lng))
```

## Step 3: Clean up and Add Data to prepare for Analysis

In this step first we inspect the new table that has been created:

``` r
colnames(all_trips)  #List of column names
```

    ## [1] "ride_id"            "rideable_type"      "started_at"        
    ## [4] "ended_at"           "start_station_name" "start_station_id"  
    ## [7] "end_station_name"   "end_station_id"     "member_casual"

``` r
nrow(all_trips)  #How many rows are in data frame?
```

    ## [1] 565726

``` r
dim(all_trips)  #Dimensions of the data frame?
```

    ## [1] 565726      9

``` r
head(all_trips)  #See the first 6 rows of data frame.  Also tail(all_trips)
```

    ##            ride_id rideable_type          started_at            ended_at
    ## 1 CFA86D4455AA1030  classic_bike 2021-03-16 08:32:30 2021-03-16 08:36:34
    ## 2 30D9DC61227D1AF3  classic_bike 2021-03-28 01:26:28 2021-03-28 01:36:55
    ## 3 846D87A15682A284  classic_bike 2021-03-11 21:17:29 2021-03-11 21:33:53
    ## 4 994D05AA75A168F2  classic_bike 2021-03-11 13:26:42 2021-03-11 13:55:41
    ## 5 DF7464FBE92D8308  classic_bike 2021-03-21 09:09:37 2021-03-21 09:27:33
    ## 6 CEBA8516FD17F8D8  classic_bike 2021-03-20 11:08:47 2021-03-20 11:29:39
    ##             start_station_name start_station_id
    ## 1 Humboldt Blvd & Armitage Ave            15651
    ## 2 Humboldt Blvd & Armitage Ave            15651
    ## 3        Shields Ave & 28th Pl            15443
    ## 4  Winthrop Ave & Lawrence Ave     TA1308000021
    ## 5     Glenwood Ave & Touhy Ave              525
    ## 6     Glenwood Ave & Touhy Ave              525
    ##                      end_station_name end_station_id member_casual
    ## 1             Stave St & Armitage Ave          13266        casual
    ## 2 Central Park Ave & Bloomingdale Ave          18017        casual
    ## 3                Halsted St & 35th St   TA1308000043        casual
    ## 4              Broadway & Sheridan Rd          13323        casual
    ## 5           Chicago Ave & Sheridan Rd           E008        casual
    ## 6           Chicago Ave & Sheridan Rd           E008        casual

``` r
str(all_trips)  #See list of columns and data types (numeric, character, etc)
```

    ## 'data.frame':    565726 obs. of  9 variables:
    ##  $ ride_id           : chr  "CFA86D4455AA1030" "30D9DC61227D1AF3" "846D87A15682A284" "994D05AA75A168F2" ...
    ##  $ rideable_type     : chr  "classic_bike" "classic_bike" "classic_bike" "classic_bike" ...
    ##  $ started_at        : chr  "2021-03-16 08:32:30" "2021-03-28 01:26:28" "2021-03-11 21:17:29" "2021-03-11 13:26:42" ...
    ##  $ ended_at          : chr  "2021-03-16 08:36:34" "2021-03-28 01:36:55" "2021-03-11 21:33:53" "2021-03-11 13:55:41" ...
    ##  $ start_station_name: chr  "Humboldt Blvd & Armitage Ave" "Humboldt Blvd & Armitage Ave" "Shields Ave & 28th Pl" "Winthrop Ave & Lawrence Ave" ...
    ##  $ start_station_id  : chr  "15651" "15651" "15443" "TA1308000021" ...
    ##  $ end_station_name  : chr  "Stave St & Armitage Ave" "Central Park Ave & Bloomingdale Ave" "Halsted St & 35th St" "Broadway & Sheridan Rd" ...
    ##  $ end_station_id    : chr  "13266" "18017" "TA1308000043" "13323" ...
    ##  $ member_casual     : chr  "casual" "casual" "casual" "casual" ...

``` r
summary(all_trips)  #Statistical summary of data. Mainly for numerics
```

    ##    ride_id          rideable_type       started_at          ended_at        
    ##  Length:565726      Length:565726      Length:565726      Length:565726     
    ##  Class :character   Class :character   Class :character   Class :character  
    ##  Mode  :character   Mode  :character   Mode  :character   Mode  :character  
    ##  start_station_name start_station_id   end_station_name   end_station_id    
    ##  Length:565726      Length:565726      Length:565726      Length:565726     
    ##  Class :character   Class :character   Class :character   Class :character  
    ##  Mode  :character   Mode  :character   Mode  :character   Mode  :character  
    ##  member_casual     
    ##  Length:565726     
    ##  Class :character  
    ##  Mode  :character

There are a few problems we will need to fix:

-   The data can only be aggregated at the ride-level, which is too
    granular. We will want to add some additional columns of data – such
    as **day**, **month**, **year** – that provide additional
    opportunities to aggregate the data.
-   We will want to add a calculated field for length of ride since the
    2020Q1 data did not have the “tripduration” column. We will add
    **“ride_length”** to the entire dataframe for consistency.
-   There are some rides where tripduration shows up as negative,
    including several hundred rides where Divvy took bikes out of
    circulation for Quality Control reasons. We will want to delete
    these rides.

``` r
# Add columns that list the date, month, day, and year of each ride

all_trips$date <- as.Date(all_trips$started_at) #The default format is yyyy-mm-dd
all_trips$month <- format(as.Date(all_trips$date), "%m")
all_trips$day <- format(as.Date(all_trips$date), "%d")
all_trips$year <- format(as.Date(all_trips$date), "%Y")
all_trips$day_of_week <- format(as.Date(all_trips$date), "%A")

# Add a "ride_length" calculation to all_trips (in seconds)

all_trips$ride_length <- difftime(all_trips$ended_at,all_trips$started_at)
```

Once we create the variables, we inspect the structure of the columns:

``` r
str(all_trips)
```

    ## 'data.frame':    565726 obs. of  15 variables:
    ##  $ ride_id           : chr  "CFA86D4455AA1030" "30D9DC61227D1AF3" "846D87A15682A284" "994D05AA75A168F2" ...
    ##  $ rideable_type     : chr  "classic_bike" "classic_bike" "classic_bike" "classic_bike" ...
    ##  $ started_at        : chr  "2021-03-16 08:32:30" "2021-03-28 01:26:28" "2021-03-11 21:17:29" "2021-03-11 13:26:42" ...
    ##  $ ended_at          : chr  "2021-03-16 08:36:34" "2021-03-28 01:36:55" "2021-03-11 21:33:53" "2021-03-11 13:55:41" ...
    ##  $ start_station_name: chr  "Humboldt Blvd & Armitage Ave" "Humboldt Blvd & Armitage Ave" "Shields Ave & 28th Pl" "Winthrop Ave & Lawrence Ave" ...
    ##  $ start_station_id  : chr  "15651" "15651" "15443" "TA1308000021" ...
    ##  $ end_station_name  : chr  "Stave St & Armitage Ave" "Central Park Ave & Bloomingdale Ave" "Halsted St & 35th St" "Broadway & Sheridan Rd" ...
    ##  $ end_station_id    : chr  "13266" "18017" "TA1308000043" "13323" ...
    ##  $ member_casual     : chr  "casual" "casual" "casual" "casual" ...
    ##  $ date              : Date, format: "2021-03-16" "2021-03-28" ...
    ##  $ month             : chr  "03" "03" "03" "03" ...
    ##  $ day               : chr  "16" "28" "11" "11" ...
    ##  $ year              : chr  "2021" "2021" "2021" "2021" ...
    ##  $ day_of_week       : chr  "martes" "domingo" "jueves" "jueves" ...
    ##  $ ride_length       : 'difftime' num  244 627 984 1739 ...
    ##   ..- attr(*, "units")= chr "secs"

``` r
summary(all_trips)  #Statistical summary of data. Mainly for numerics
```

    ##    ride_id          rideable_type       started_at          ended_at        
    ##  Length:565726      Length:565726      Length:565726      Length:565726     
    ##  Class :character   Class :character   Class :character   Class :character  
    ##  Mode  :character   Mode  :character   Mode  :character   Mode  :character  
    ##                                                                             
    ##                                                                             
    ##                                                                             
    ##  start_station_name start_station_id   end_station_name   end_station_id    
    ##  Length:565726      Length:565726      Length:565726      Length:565726     
    ##  Class :character   Class :character   Class :character   Class :character  
    ##  Mode  :character   Mode  :character   Mode  :character   Mode  :character  
    ##                                                                             
    ##                                                                             
    ##                                                                             
    ##  member_casual           date               month               day           
    ##  Length:565726      Min.   :2021-03-01   Length:565726      Length:565726     
    ##  Class :character   1st Qu.:2021-03-21   Class :character   Class :character  
    ##  Mode  :character   Median :2021-04-05   Mode  :character   Mode  :character  
    ##                     Mean   :2021-04-03                                        
    ##                     3rd Qu.:2021-04-18                                        
    ##                     Max.   :2021-04-30                                        
    ##      year           day_of_week        ride_length      
    ##  Length:565726      Length:565726      Length:565726    
    ##  Class :character   Class :character   Class :difftime  
    ##  Mode  :character   Mode  :character   Mode  :numeric   
    ##                                                         
    ##                                                         
    ## 

The type of our new variable **ride_length** is not numeric, so wee need
to convert it to numeric so we can run calculations on the data:

``` r
is.factor(all_trips$ride_length) #checking...
```

    ## [1] FALSE

``` r
typeof(all_trips$ride_length)
```

    ## [1] "double"

``` r
all_trips$ride_length <- as.numeric(as.character(all_trips$ride_length)) # defining the type of the variable

is.numeric(all_trips$ride_length)
```

    ## [1] TRUE

``` r
summary(all_trips)  #Statistical summary of data. Mainly for numerics
```

    ##    ride_id          rideable_type       started_at          ended_at        
    ##  Length:565726      Length:565726      Length:565726      Length:565726     
    ##  Class :character   Class :character   Class :character   Class :character  
    ##  Mode  :character   Mode  :character   Mode  :character   Mode  :character  
    ##                                                                             
    ##                                                                             
    ##                                                                             
    ##  start_station_name start_station_id   end_station_name   end_station_id    
    ##  Length:565726      Length:565726      Length:565726      Length:565726     
    ##  Class :character   Class :character   Class :character   Class :character  
    ##  Mode  :character   Mode  :character   Mode  :character   Mode  :character  
    ##                                                                             
    ##                                                                             
    ##                                                                             
    ##  member_casual           date               month               day           
    ##  Length:565726      Min.   :2021-03-01   Length:565726      Length:565726     
    ##  Class :character   1st Qu.:2021-03-21   Class :character   Class :character  
    ##  Mode  :character   Median :2021-04-05   Mode  :character   Mode  :character  
    ##                     Mean   :2021-04-03                                        
    ##                     3rd Qu.:2021-04-18                                        
    ##                     Max.   :2021-04-30                                        
    ##      year           day_of_week         ride_length     
    ##  Length:565726      Length:565726      Min.   :   -132  
    ##  Class :character   Class :character   1st Qu.:    419  
    ##  Mode  :character   Mode  :character   Median :    754  
    ##                                        Mean   :   1419  
    ##                                        3rd Qu.:   1409  
    ##                                        Max.   :2870202

``` r
typeof(all_trips$ride_length)  #cheking
```

    ## [1] "double"

The dataframe includes a few hundred entries when bikes were taken out
of docks and checked for quality by Divvy or ride_length was negative:

``` r
all_trips_V2 <- all_trips[!(all_trips$start_station_name == "HQ QR" | all_trips$ride_length<0),]
```

## Step 4: Conduct Descriptive Analysis

``` r
mean(all_trips_V2$ride_length) #straight average (total ride length / rides)
```

    ## [1] 1419.359

``` r
median(all_trips_V2$ride_length) #midpoint number in the ascending array of ride lengths
```

    ## [1] 754

``` r
max(all_trips_V2$ride_length) #longest ride
```

    ## [1] 2870202

``` r
min(all_trips_V2$ride_length) #shortest ride
```

    ## [1] 0

``` r
# You can condense the four lines above to one line using summary() on the specific attribute
summary(all_trips_V2$ride_length)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##       0     419     754    1419    1409 2870202

After the summary of our analysis, we start to compare the different
*type of users*:

``` r
aggregate(all_trips_V2$ride_length ~ all_trips_V2$member_casual, FUN = mean)
```

    ##   all_trips_V2$member_casual all_trips_V2$ride_length
    ## 1                     casual                2288.2935
    ## 2                     member                 863.8003

``` r
aggregate(all_trips_V2$ride_length ~ all_trips_V2$member_casual, FUN = median)
```

    ##   all_trips_V2$member_casual all_trips_V2$ride_length
    ## 1                     casual                     1098
    ## 2                     member                      614

``` r
aggregate(all_trips_V2$ride_length ~ all_trips_V2$member_casual, FUN = max)
```

    ##   all_trips_V2$member_casual all_trips_V2$ride_length
    ## 1                     casual                  2870202
    ## 2                     member                    93596

``` r
aggregate(all_trips_V2$ride_length ~ all_trips_V2$member_casual, FUN = min)
```

    ##   all_trips_V2$member_casual all_trips_V2$ride_length
    ## 1                     casual                        0
    ## 2                     member                        0

See the average ride time by each day for members vs casual users:

``` r
# Notice that the days of the week are out of order. Let's fix that.

aggregate(all_trips_V2$ride_length ~ all_trips_V2$member_casual + all_trips_V2$day_of_week, FUN = mean)
```

    ##    all_trips_V2$member_casual all_trips_V2$day_of_week all_trips_V2$ride_length
    ## 1                      casual                  domingo                2514.1051
    ## 2                      member                  domingo                 989.9823
    ## 3                      casual                   jueves                1598.1490
    ## 4                      member                   jueves                 769.3787
    ## 5                      casual                    lunes                2410.7893
    ## 6                      member                    lunes                 857.9420
    ## 7                      casual                   martes                2300.2270
    ## 8                      member                   martes                 843.3907
    ## 9                      casual                miércoles                2048.9287
    ## 10                     member                miércoles                 791.5619
    ## 11                     casual                   sábado                2366.4514
    ## 12                     member                   sábado                 976.6102
    ## 13                     casual                  viernes                2288.5469
    ## 14                     member                  viernes                 825.8508

Now, let’s run the average ride time by each day for members vs casual
users:

``` r
aggregate(all_trips_V2$ride_length ~ all_trips_V2$member_casual + all_trips_V2$day_of_week, FUN = mean)
```

    ##    all_trips_V2$member_casual all_trips_V2$day_of_week all_trips_V2$ride_length
    ## 1                      casual                  domingo                2514.1051
    ## 2                      member                  domingo                 989.9823
    ## 3                      casual                   jueves                1598.1490
    ## 4                      member                   jueves                 769.3787
    ## 5                      casual                    lunes                2410.7893
    ## 6                      member                    lunes                 857.9420
    ## 7                      casual                   martes                2300.2270
    ## 8                      member                   martes                 843.3907
    ## 9                      casual                miércoles                2048.9287
    ## 10                     member                miércoles                 791.5619
    ## 11                     casual                   sábado                2366.4514
    ## 12                     member                   sábado                 976.6102
    ## 13                     casual                  viernes                2288.5469
    ## 14                     member                  viernes                 825.8508

Analyzing ridership data by type and weekday, ordered by user type and
number of rides (desc):

``` r
all_trips_V2 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>%  #creates weekday field using wday()
  group_by(member_casual, weekday) %>%  #groups by usertype and weekday
  summarise(number_of_rides = n()                           #calculates the number of rides and average duration 
            ,average_duration = mean(ride_length)) %>%      # calculates the average duration
  arrange(member_casual, -number_of_rides)
```

    ## `summarise()` has grouped output by 'member_casual'. You can override using the
    ## `.groups` argument.

    ## # A tibble: 14 x 4
    ## # Groups:   member_casual [2]
    ##    member_casual weekday  number_of_rides average_duration
    ##    <chr>         <ord>              <int>            <dbl>
    ##  1 casual        "sáb\\."           49817            2366.
    ##  2 casual        "dom\\."           42538            2514.
    ##  3 casual        "mar\\."           30840            2300.
    ##  4 casual        "vie\\."           30706            2289.
    ##  5 casual        "lun\\."           28020            2411.
    ##  6 casual        "mié\\."           20874            2049.
    ##  7 casual        "jue\\."           17838            1598.
    ##  8 member        "mar\\."           55385             843.
    ##  9 member        "vie\\."           53673             826.
    ## 10 member        "lun\\."           50565             858.
    ## 11 member        "sáb\\."           49818             977.
    ## 12 member        "mié\\."           48139             792.
    ## 13 member        "jue\\."           44064             769.
    ## 14 member        "dom\\."           43442             990.

Now that we have the table with the information, we can visualize the
number of rides, by the next variables:

``` r
all_trips_V2 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>% 
  group_by(member_casual, weekday) %>% 
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>% 
  arrange(member_casual, weekday)  %>% 
  ggplot(aes(x = weekday, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge") + labs(title="Number of Rides by User Type")
```

    ## `summarise()` has grouped output by 'member_casual'. You can override using the
    ## `.groups` argument.

![](AnalyzingData_R_files/figure-gfm/unnamed-chunk-18-1.png)<!-- -->

``` r
all_trips_V2 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>% 
  group_by(member_casual, weekday) %>% 
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>% 
  arrange(member_casual, weekday)  %>% 
  ggplot(aes(x = weekday, y = average_duration, fill = member_casual)) +
  geom_col(position = "dodge") + labs(title="Average Ride Duration by User Type")
```

    ## `summarise()` has grouped output by 'member_casual'. You can override using the
    ## `.groups` argument.

![](AnalyzingData_R_files/figure-gfm/unnamed-chunk-19-1.png)<!-- -->
