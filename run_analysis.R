
## Local settings

setwd("Documents/Boulot/MOOCs/Coursera/Data Specialisation/3. Getting and Cleaning Data/project/")

library("dplyr")
library("tidyr")

## Get the data

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

fileName <- "UCI HAR Dataset/"
zipName <- "getdata-projectfiles-UCI HAR Dataset.zip"

if(!file.exists(fileName)) {
  if(!file.exists(zipName)) {
    download.file(fileUrl, zipName)
  }
  unzip(zipName)
}

## 1. Merges the training and the test sets to create one data set.

subjectTrainPath <- "UCI HAR Dataset/train/subject_train.txt"
XtrainPath <- "UCI HAR Dataset/train/X_train.txt"
ytrainPath <- "UCI HAR Dataset/train/y_train.txt"

subjectTestPath <- "UCI HAR Dataset/test/subject_test.txt"
XtestPath <- "UCI HAR Dataset/test/X_test.txt"
ytestPath <- "UCI HAR Dataset/test/y_test.txt"

featuresPath <- "UCI HAR Dataset/features.txt"
activityPath <- "UCI HAR Dataset/activity_labels.txt"

Xtrain <- read.table(XtrainPath) %>% tbl_df
Xtest <- read.table(XtestPath) %>% tbl_df
XSet <- bind_rows(Xtrain, Xtest)

subjectTrain <- read.table(subjectTrainPath) %>% tbl_df
subjectTest <- read.table(subjectTestPath) %>% tbl_df
subjectSet <- bind_rows(subjectTrain, subjectTest)
names(subjectSet) <- "subject"

ytrain <- read.table(ytrainPath) %>% tbl_df
ytest <- read.table(ytestPath) %>% tbl_df
ySet <- bind_rows(ytrain, ytest)
names(ySet) <- "activity"

## 2. Extracts only the measurements on the mean and standard deviation for
##   each measurement.

# Get descriptive variable names
features <- read.table(featuresPath) %>% tbl_df

# Grepping because contains() doesn't work when you have duplicate column names
meanIndexes <- grep("mean\\(\\)", features$V2)
stdIndexes <- grep("std\\(\\)", features$V2)

Indexes <- c(meanIndexes, stdIndexes) %>%
  sort

myExtractedXSet <- select(XSet, Indexes)
myNames <- features$V2[Indexes]

## 4. Appropriately labels the data set with descriptive variable names.
names(myExtractedXSet) <- myNames

myExtractedSet <- cbind(subjectSet, ySet, myExtractedXSet) %>% tbl_df

## 3. Uses descriptive activity names to name the activities in the data set

# Get labels from file
activityLabels <- read.table(activityPath) %>% tbl_df

# Merge tables
myDescribedSet <- myExtractedSet %>%
  merge(activityLabels, by.x = "activity", by.y = "V1") %>%
  mutate(activity = V2) %>%
  select(-V2) %>%
  group_by(subject, activity)

#write.table(myDescribedSet, "myDescribedSet.txt", row.name=FALSE)

## 5. From the data set in step 4, creates a second, independent tidy data set
#    with the average of each variable for each activity and each subject.

myTidyDataSet <- myDescribedSet %>%
  summarise_each(funs(mean), -activity, -subject)

#write.table(myTidyDataSet, "myTidyDataSet.txt", row.name=FALSE)

myTidyDataSet
