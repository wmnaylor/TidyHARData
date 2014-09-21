#TidyHARData
===========

##Running The Analysis
In order to run the script: run_analysis.R you will need to make sure the following packages are installed in your version of R
1. data.table
2. reshape2

You will also need to 
1. Download and unzip the dataset into your R working directory. You can download the dataset at the following address: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
2. Place run_analysis.R in your working directory

*For More Information on the Dataset, please see: (http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) *

##What the Script Does
1. Loads the test and training data and combines them into a single dataset where 
  a. each row represents a single observation
  b. each variable is represented in it's own column
2. Subsets the original data to only include mean and standard deviation observations.
3. Renames the columns using human readable names
4. Transforms the data into a cross tab table where
  a. each row represents a single activity and subject
  b. calculates the mean of each observation for that activity/participant
5. Outputs a file of the combined and subsetted data named 'all_my_data.txt'
6. Outputs a file of the transformed data 'Final.txt'
