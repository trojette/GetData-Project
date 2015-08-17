---
title: "README"
author: "Mohammed Adnène TROJETTE"
date: "17 août 2015"
output: html_document
---

This README is to document the `run_analysis.R` file.

Beware that we did the 4th step before the 3rd.

Step 0: Getting the data
------------------------

First we set the working directory and load the basic data manipulation libraries.

Then we get the data from [its original location](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) and `unzip` it.

Step 1: Merging data sets
-------------------------

As explained in `UCI HAR Dataset/README.txt`, we have to look in the `UCI HAR Dataset/{train,test}/` directories to find most of the data we need:

- `features_info.txt`: Shows information about the variables used on the feature vector.
- `features.txt`: List of all features.
- `activity_labels.txt`: Links the class labels with their activity name.
- `train/X_train.txt`: Training set.
- `train/y_train.txt`: Training labels.
- `test/X_test.txt`: Test set.
- `test/y_test.txt`: Test labels.
- `{train,test}/subject_{train,test}.txt`: Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

We actually start by (row-)merging (two by two), the data in the following tables:

- `X_train` and `X_test` and call it `XSet`.
- `y_train` and `y_test` (and set the column name to "activity") and call it `ySet`.
- `subject_train` and `subject_test` (and set the column name to "subject") and call it `subjectSet`.

Step 2: Extracting only measurements on the `mean()` and `std()`
----------------------------------------------------------------

To do that, we need to identify in the data from `features.txt` variables containing the string "mean()" or the string "std()". To that effect, we use the `grep()` function and determine the indexes of the interesting variables. Then we only select the columns in `XSet`.

Step 4: Labelling the data set
------------------------------

At this moment of the project, it seems easier to label the data set with the correct variable names. We want to do that before doing all the merging, because merging will introduce two additional columns.

We do the labelling using the indexes we determined in the previous step.

Step 3: Using descriptive activity names
----------------------------------------

That step is the toughest, as we chain many functions:
- `merge` to get the correct activity names.
- `mutate` to set the appropriate column.
- `select` to clean the data set.
- `group_by` to prepare for the next step.

Step 5: Creating a second tidy set
----------------------------------

After testing the `summarise` function and searching a bit, we discovered the `summarise_each` function, which did the job we wanted.

Last but not least, we created `myTidyDataSet.txt`, before happily submitting everything to GitHub!

Enjoy ;-)
