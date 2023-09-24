# Google Data Analytics Capstone: Cyclistic Case Study
Course: [Google Data Analytics Capstone: Complete a Case Study](https://www.coursera.org/learn/google-data-analytics-capstone)
## Introduction
In this case study, I will perform many real-world tasks of a junior data analyst at a fictional company, Cyclistic. In order to answer the key business questions, I will follow the steps of the data analysis process: [Ask](), [Prepare](), [Process](), [Analyze](), [Share](), and [Act]().

### Quick links:
Data Source: [divvy_tripdata](https://divvy-tripdata.s3.amazonaws.com/index.html) 
  
Code Scripts:
[01. Data Combining](https://github.com/qmars16/Cyclistic_Case_Study/blob/main/Data%20Combining.sql)
[02. Data Exploration](https://github.com/qmars16/Cyclistic_Case_Study/blob/main/Data%20Exploration.sql)
[03. Data Cleaning](https://github.com/qmars16/Cyclistic_Case_Study/blob/main/Data%20Cleaning.R)
[04. Data Analysis](https://github.com/qmars16/Cyclistic_Case_Study/blob/main/Data%20Analysis.R)  
  
Data Visualizations: [Tableau](https://public.tableau.com/app/profile/kumaresh.natarajan/viz/CyclisticDashboard_16955341346110/Dashboard1)  

## Background
### Cyclistic
A bike-share program that features more than 5,800 bicycles and 600 docking stations. Cyclistic sets itself apart by also offering reclining bikes, hand tricycles, and cargo bikes, making bike-share more inclusive to people with disabilities and riders who can’t use a standard two-wheeled bike. The majority of riders opt for traditional bikes; about 8% of riders use the assistive options. Cyclistic users are more likely to ride for leisure, but about 30% use them to commute to work each day.   
  
Until now, Cyclistic’s marketing strategy relied on building general awareness and appealing to broad consumer segments. One approach that helped make these things possible was the flexibility of its pricing plans: single-ride passes, full-day passes, and annual memberships. Customers who purchase single-ride or full-day passes are referred to as casual riders. Customers who purchase annual memberships are Cyclistic members.  
  
Cyclistic’s finance analysts have concluded that annual members are much more profitable than casual riders. Although the pricing flexibility helps Cyclistic attract more customers, Moreno (the director of marketing and my manager) believes that maximizing the number of annual members will be key to future growth. Rather than creating a marketing campaign that targets all-new customers, Moreno believes there is a very good chance to convert casual riders into members. She notes that casual riders are already aware of the Cyclistic program and have chosen Cyclistic for their mobility needs.  

Moreno has set a clear goal: Design marketing strategies aimed at converting casual riders into annual members. In order to do that, however, the marketing analyst team needs to better understand how annual members and casual riders differ, why casual riders would buy a membership, and how digital media could affect their marketing tactics. Moreno and her team are interested in analyzing the Cyclistic historical bike trip data to identify trends.  

### Scenario
I am assuming to be a junior data analyst working in the marketing analyst team at Cyclistic, a bike-share company in Chicago. The director of marketing believes the company’s future success depends on maximizing the number of annual memberships. Therefore, my team wants to understand how casual riders and annual members use Cyclistic bikes differently. From these insights, my team will design a new marketing strategy to convert casual riders into annual members. But first, Cyclistic executives must approve our recommendations, so they must be backed up with compelling data insights and professional data visualizations.

## Ask
### Business Task
Devise marketing strategies to convert casual riders to members.
### Analysis Questions
Three questions will guide the future marketing program:  
1. How do annual members and casual riders use Cyclistic bikes differently?  
2. Why would casual riders buy Cyclistic annual memberships?  
3. How can Cyclistic use digital media to influence casual riders to become members?  

Moreno has assigned me the first question to answer: How do annual members and casual riders use Cyclistic bikes differently?
## Prepare
### Data Source
I will use Cyclistic’s historical trip data to analyze and identify trends from Jan 2023 to Apr 2023 which can be downloaded from [divvy_tripdata](https://divvy-tripdata.s3.amazonaws.com/index.html). The data has been made available by Motivate International Inc. under this [license](https://www.divvybikes.com/data-license-agreement).  
  
This is public data that can be used to explore how different customer types are using Cyclistic bikes.
### Data Organization
There are 7 files with naming convention of YYYYMM-divvy-tripdata and each file includes information, such as the ride id, bike type, start time, end time, start station, end station, start location, end location, and whether the rider is a member or not. The corresponding column names are ride_id, rideable_type, started_at, ended_at, start_station_name, start_station_id, end_station_name, end_station_id, start_lat, start_lng, end_lat, end_lng and member_casual.

## Process
BigQuery is used to combine the various datasets into one dataset and clean it.    
Reason:  
A worksheet can only have 1,048,576 rows in Microsoft Excel because of its inability to manage large amounts of data. Because the Cyclistic dataset has more than 5.6 million rows, it is essential to use a platform like BigQuery that supports huge volumes of data.
### Combining the Data
SQL Query: [Data Combining](https://github.com/qmars16/Cyclistic_Case_Study/blob/main/Data%20Combining.sql)  
12 csv files are uploaded as tables in the dataset '2022_tripdata'. Another table named "combined_data" is created, containing 5,667,717 rows of data for the entire year. 
### Data Exploration
SQL Query: [Data Exploration](https://github.com/qmars16/Cyclistic_Case_Study/blob/main/Data%20Exploration.sql)  
Before cleaning the data, I am familiarizing myself with the data to find the inconsistencies.  

Observations:  
1. The table below shows the all column names and their data types. The __ride_id__ column is our primary key.  

   ![image](https://github.com/qmars16/Cyclistic_Case_Study/blob/main/images/colnames.png)  

2. The following table shows number of __null values__ in each column.  
   
   ![image](https://github.com/qmars16/Cyclistic_Case_Study/blob/main/images/null_values.png)

   Note that some columns have same number of missing values. This may be due to missing information in the same row i.e. station's name and id for the same station and latitude and longitude for the same ending station.  
3. As ride_id has no null values, let's use it to check for duplicates.  

   ![image](https://github.com/qmars16/Cyclistic_Case_Study/blob/main/images/duplicate_values-44.png)

   As we can see, there are __44 duplicate__ rows in the data.  
   We will remove these duplicates in Microsoft Excel by conditional formatting.
   
4. All __ride_id__ values have length of 16 so no need to clean it.

5. The __started_at__ and __ended_at__ shows start and end time of the trip in YYYY-MM-DD hh:mm:ss UTC format. New column ride_length can be created to find the total trip duration. There are some trips which has duration longer than a day and some trips having less than a minute duration or having end time earlier than start time so we need to remove them. 

6. Columns that need to be removed are start_station_id and end_station_id as they do not add value to analysis of our current problem. Longitude and latitude location columns may not be used in analysis but can be used to visualise a map.

### Data Cleaning
R script: [Data Cleaning](https://github.com/qmars16/Cyclistic_Case_Study/blob/main/Data%20Cleaning.R)  
1. All the rows having missing values are deleted.  
2. 3 more columns ride_length for duration of the trip, day_of_week and month are added.  
3. Trips with duration less than a minute and longer than a day are excluded.

After analyzing, we obtain a summary of the mean, median, max and min of the ride lengths for members and casual riders.

   ![image](https://github.com/qmars16/Cyclistic_Case_Study/blob/main/images/data%20summary.png)
  
## Analyze and Share
R script: [Data Analysis](https://github.com/qmars16/Cyclistic_Case_Study/blob/main/Data%20Analysis.R)  
Data Visualization: [Tableau](https://public.tableau.com/app/profile/kumaresh.natarajan/viz/CyclisticDashboard_16955341346110/Dashboard1)  
The data is stored appropriately and is now prepared for analysis. I queried multiple relevant tables for the analysis and visualized them in Tableau.  

The analysis question is: How do annual members and casual riders use Cyclistic bikes differently?  

First of all, no. of members and casual riders are compared.  

   ![image](https://github.com/qmars16/Cyclistic_Case_Study/blob/main/images/membervscasual.png)
  
The members make 74.93% of the total while remaining 25.07% constitutes casual riders.
  
Next the number of different bikes are examined.
   
   ![image](https://github.com/qmars16/Cyclistic_Case_Study/blob/main/images/typesofbikes.png)

Classic bikes are the most common with 56%. Electric bikes make up 42% of the total bikes in circulation, and 2% of the bikes are docked.

The average ride duration per day are examined for both types of riders.
   
   ![image](https://github.com/qmars16/Cyclistic_Case_Study/blob/main/images/avgduration_per_weekday.png)

Using [Tableau](https://public.tableau.com/app/profile/kumaresh.natarajan/viz/CyclisticDashboard_16955341346110/Dashboard1), we visualize our final cleaned and explored data to come up with a dashboard.

The ride lengths for the different months can be viewed by using the drop-down menu provided to the right of the graph.

### Summary:
-> Frequency of rides increase from Jan to Apr.
   - This is because as the summer months start to come in, heat increases and people turn to commute using bikes rather than walking.

-> Casual riders are more frequent on the weekends.
   - They rarely use bikes to go on outings, lesuire rides rather than for work.

## Act
After identifying the differences between casual and member riders, marketing strategies to target casual riders can be developed to persuade them to become members.  
Recommendations:  
1. Marketing campaigns might be conducted in summer at tourist/recreational locations popular among casual riders.
2. Casual riders are most active on weekends and during the summer, thus they may be offered seasonal or weekend-only memberships.
3. Casual riders use their bikes for longer durations than members. Offering discounts for longer rides may entice members to ride for longer periods of time.
