These scripts are based on data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description of the data is available at the site where the data was obtained:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Prior to running the code, make sure to install the following packages: dplyr, data.table, tidyr.

"CodeBook.md" is a code book that describes the variables and the data.

The script "run_analysis.R" does the following:
1) Merges the training and the test sets to create one data set
2) Extracts only the measurements on the mean and standard deviation for each measurement
3) Uses descriptive activity names to name the activities in the data set
4) Appropriately labels the data set with descriptive variable names
5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

"NewData.txt" is the tidy data set (mentioned in step 5 above) that contains the average of each variable for each activity and each subject.