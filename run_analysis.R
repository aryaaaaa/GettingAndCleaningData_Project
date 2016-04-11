library(dplyr)
library(data.table)
library(tidyr)

setwd("/Users/aryaviswanathan/Desktop/Data Science Specialization/Course 3 - Getting and Cleaning Data/Week 4")
download.file(url="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
              destfile="/Users/aryaviswanathan/Desktop/Data Science Specialization/Course 3 - Getting and Cleaning Data/Week 4/Course3Project.zip",method="curl")
unzip(zipfile="Course3Project.zip")

files <- "/Users/aryaviswanathan/Desktop/Data Science Specialization/Course 3 - Getting and Cleaning Data/Week 4/UCI HAR Dataset"
#Read test files
testSubject <- tbl_df(read.table(file.path(files,"test","subject_test.txt")))
testData <- tbl_df(read.table(file.path(files,"test","X_test.txt")))
testActivity <- tbl_df(read.table(file.path(files,"test","y_test.txt")))
#Read train files
trainSubject <- tbl_df(read.table(file.path(files,"train","subject_train.txt")))
trainData <- tbl_df(read.table(file.path(files,"train","X_train.txt")))
trainActivity <- tbl_df(read.table(file.path(files,"train","y_train.txt")))

#Merge Subject, Activity, and Data files
allSubject <- rbind(trainSubject,testSubject)
allActivity <- rbind(trainActivity,testActivity)
allData <- rbind(trainData,testData)
colnames(allSubject) <- c("Subject")
colnames(allActivity) <- c("ActivityNumber")

#Label columns by feature
features <- tbl_df(read.table(file.path(files,"Features.txt")))
colnames(features) <- c("FeatureNumber","FeatureName")
colnames(allData) <- features$featureName

#Label columns for activity
activityLabels <- tbl_df(read.table(file.path(files,"activity_labels.txt")))
colnames(activityLabels) <- c("ActivityNumber","ActivityName")

#Merge data
allSubjectActivity <- cbind(allSubject,allActivity)
allData <- cbind(allSubjectActivity,allData)

#Extracts only the measurements on the mean and std. dev. for each measurement
featuresMeanStdDev <- grep("mean\\(\\)|std\\(\\)",features$FeatureName,value=TRUE)
featuresMeanStdDev <- union(c("Subject","ActivityNumber"),featuresMeanStdDev)
allData <- subset(allData,select=featuresMeanStdDev)

allData <- merge(activityLabels,allData,by="ActivityNumber",all.x=TRUE)
allData$ActivityName <- as.character(allData$ActivityName)
dataAggregate <- aggregate(. ~ Subject - ActivityName,data=allData,mean)

#Rename dataset labels with descriptive variable names
names(allData) <- gsub("mean()", "Mean", names(allData))
names(allData) <- gsub("std()", "StdDev", names(allData))
names(allData) <- gsub("^t", "Time", names(allData))
names(allData) <- gsub("Acc", "Accelerometer", names(allData))
names(allData) <- gsub("Gyro", "Gyroscope", names(allData))
names(allData) <- gsub("Mag", "Magnitude", names(allData))
names(allData) <- gsub("^f", "Frequency", names(allData))
names(allData) <- gsub("BodyBody", "Body", names(allData))

#Creates a second, independent tidy dataset with the average of each variable for each activity and each subject
write.table(allData,"NewData.txt",row.name=FALSE)
