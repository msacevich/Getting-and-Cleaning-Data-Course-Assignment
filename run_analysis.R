# Coursera Getting and Cleaning Data Course Project 

library(data.table)
library(dplyr)

#Set working directory

setwd("C:/Users/msacevich/Documents/Rstudio/UCI HAR Dataset")

#Reading the data

features <- read.table("./features.txt", col.names = c("n","functions"))
activities <- read.table("./activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("./test/subject_test.txt", col.names = "subject")
x_test <- read.table("./test/X_test.txt", col.names = features$functions)
y_test <- read.table("./test/y_test.txt", col.names = "code")
subject_train <- read.table("./train/subject_train.txt", col.names = "subject")
x_train <- read.table("./train/X_train.txt", col.names = features$functions)
y_train <- read.table("./train/y_train.txt", col.names = "code")


##1. Merges the training and the test sets to create one data set.

X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged_Data <- cbind(Subject, Y, X)

##2. Extracts only the measurements on the mean and standard deviation for each measurement.

MeanStdOnly <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))

##3. Uses descriptive activity names to name the activities in the data set.
##4. Appropriately labels the data set with descriptive variable names.

MeanStdOnly$code <- activities[MeanStdOnly$code, 2]

names(MeanStdOnly)[2] = "activity"
names(MeanStdOnly)<-gsub("Acc", "Accelerometer", names(MeanStdOnly))
names(MeanStdOnly)<-gsub("Gyro", "Gyroscope", names(MeanStdOnly))
names(MeanStdOnly)<-gsub("BodyBody", "Body", names(MeanStdOnly))
names(MeanStdOnly)<-gsub("Mag", "Magnitude", names(MeanStdOnly))
names(MeanStdOnly)<-gsub("^t", "Time", names(MeanStdOnly))
names(MeanStdOnly)<-gsub("^f", "Frequency", names(MeanStdOnly))
names(MeanStdOnly)<-gsub("tBody", "TimeBody", names(MeanStdOnly))
names(MeanStdOnly)<-gsub("-mean()", "Mean", names(MeanStdOnly), ignore.case = TRUE)
names(MeanStdOnly)<-gsub("-std()", "STD", names(MeanStdOnly), ignore.case = TRUE)
names(MeanStdOnly)<-gsub("-freq()", "Frequency", names(MeanStdOnly), ignore.case = TRUE)
names(MeanStdOnly)<-gsub("angle", "Angle", names(MeanStdOnly))
names(MeanStdOnly)<-gsub("gravity", "Gravity", names(MeanStdOnly))

##5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

TidyData <- MeanStdOnly %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(FinalData, "TidyData.txt", row.name=FALSE)
