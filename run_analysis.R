# File: run_analysis.R
# Date: 09/20/2014
# Author: William Naylor

library(data.table)
library(reshape2)

#Set Up Filing Structure to put data in root directory
#setwd("/")
#if (!file.exists("HARdata")){dir.create("HARdata")}
##setwd("/HARdata")
if (!file.exists("FinalData")){dir.create("FinalData")}

### Assuming HAR Dataset is in working directory already ###
#Acquire Data From Internet, load and merge into three tables
#fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#download.file(fileUrl, destfile = "HARdataset.zip")
#dateDownloaded <- date()
#unzip("HARdataset.zip")

#load and merge into three tables
subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt")
subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt")
merged_subject <- rbind(subject_test,subject_train)
colnames(merged_subject)<- "Subject"

x_test<-read.table("./UCI HAR Dataset/test/X_test.txt")
x_train<-read.table("./UCI HAR Dataset/train/X_train.txt")
merged_x <- rbind(x_test,x_train)

#Rename columns and Subset Data
xColNames <- c("tBodyAccXMean","tBodyAccYMean","tBodyAccZMean","tBodyAccXStd","tBodyAccYStd","tBodyAccZStd","tGravityAccXMean","tGravityAccYMean","tGravityAccZMean","tGravityAccXStd","tGravityAccYStd","tGravityAccZStd","tBodyAccJerkXMean","tBodyAccJerkYMean","tBodyAccJerkZMean","tBodyAccJerkXStd","tBodyAccJerkYStd","tBodyAccJerkZStd","tBodyGyroXMean","tBodyGyroYMean","tBodyGyroZMean","tBodyGyroXStd","tBodyGyroYStd","tBodyGyroZStd","tBodyGyroJerkXMean","tBodyGyroJerkYMean","tBodyGyroJerkZMean","tBodyGyroJerkXStd","tBodyGyroJerkYStd","tBodyGyroJerkZStd","tBodyAccMagMean","tBodyAccMagStd","tGravityAccMagMean","tGravityAccMagStd","tBodyAccJerkMagMean","tBodyAccJerkMagStd","tBodyGyroMagMean","tBodyGyroMagStd","tBodyGyroJerkMagMean","tBodyGyroJerkMagStd","fBodyAccXMean","fBodyAccYMean","fBodyAccZMean","fBodyAccXStd","fBodyAccYStd","fBodyAccZStd","fBodyAccJerkXMean","fBodyAccJerkYMean","fBodyAccJerkZMean","fBodyAccJerkXStd","fBodyAccJerkYStd","fBodyAccJerkZStd","fBodyGyroXMean","fBodyGyroYMean","fBodyGyroXMean","fBodyGyroXStd","fBodyGyroYStd","fBodyGyroZStd","fBodyAccMagMean","fBodyAccMagStd","fBodyAccJerkMagMean","fBodyAccJerkMagStd","fBodyGyroMagMean ","fBodyGyroMagStd","fBodyGyroJerkMagMean","fBodyGyroJerkMagStd")
subsetted_x <-merged_x[,c(1,2,3,4,5,6,41,42,43,44,45,46,81,82,83,84,85,86,121,122,123,124,125,126,161,162,163,164,165,166,201,202,214,215,227,228,240,241,253,554,266,267,268,269,270,271,345,346,347,348,349,350,424,425,426,427,428,429,503,504,516,517,529,530,542,543)]
colnames(subsetted_x) <- xColNames


y_test<-read.table("./UCI HAR Dataset/test/y_test.txt")
y_train<-read.table("./UCI HAR Dataset/train/y_train.txt")
merged_y <- rbind(y_test,y_train)
colnames(merged_y)<- "Activity"

#Combine all of the data into a single data table
all_my_dat<- cbind(merged_subject,merged_y,subsetted_x)

#Substitute character labels for the numerical activity codes 
all_my_dat$Activity[all_my_dat$Activity == "1"] <- "WALKING"
all_my_dat$Activity[all_my_dat$Activity == "2"] <- "WALKING_UPSTAIRS"
all_my_dat$Activity[all_my_dat$Activity == "3"] <- "WALKING_DOWNSTAIRS"
all_my_dat$Activity[all_my_dat$Activity == "4"] <- "SITTING"
all_my_dat$Activity[all_my_dat$Activity == "5"] <- "STANDING"
all_my_dat$Activity[all_my_dat$Activity == "6"] <- "LAYING"
all_my_dat$Activity <- as.factor(all_my_dat$Activity)
all_my_dat$Subject <- as.factor(all_my_dat$Subject)

#all_my_dat is now a tidy data set 
#Melt the combined subsetted data to create a 'narrow' version of the data
datMelt <- melt(all_my_dat,id=c("Subject","Activity"),measure.vars=xColNames)

#Create a crosstab of each Activity/Subject pair and the mean of each observations
#values
xTab_all_my_dat <- dcast(datMelt,Activity + Subject ~ variable,mean)

#Write out a copy of the Tidy version of the source data prior to it's transformation
write.table(all_my_dat, file="./FinalData/all_my_dat.txt")

#Write out a copy of Tidy version of the transformed data
write.table(xTab_all_my_dat, file="./FinalData/Final.txt", append=FALSE, row.names=FALSE)
