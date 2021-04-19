
##load dplyr
library(dplyr)

##Source file information
fileURL<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
datafile <- "getdata_projectfiles_UCI_HAR_Dataset.zip"

## Download if it is not already in the working directory
if(!file.exists(datafile)){
  download.file(fileURL, datafile, method="curl")
}

##Unzip file if the inzipped folder is not already in the working directory
if(!file.exists("UCI HAR Dataset")){
  unzip(datafile)
}

##Load activity Labels and features
activity_Labels <- read.table(".\\UCI HAR Dataset\\activity_labels.txt", col.names = c("activity_id","activity"))
features <- read.table(".\\UCI HAR Dataset\\features.txt", col.names = c("feature_id","feature"))

##Load test data
subject_test <- read.table(".\\UCI HAR Dataset\\test\\subject_test.txt", col.names = "subject")
x_test <- read.table(".\\UCI HAR Dataset\\test\\X_test.txt", col.names = features$feature)
y_test <- read.table(".\\UCI HAR Dataset\\test\\Y_test.txt", col.names = "activity_id")

##Load train data
subject_train <- read.table(".\\UCI HAR Dataset\\train\\subject_train.txt", col.names = c("subject"))
x_train <- read.table(".\\UCI HAR Dataset\\train\\X_train.txt", col.names = features$feature)
y_train <- read.table(".\\UCI HAR Dataset\\train\\Y_train.txt", col.names = "activity_id")

##1. Merges the training and the test sets to create one data set.
##merge rows for subject train and test data
subject_data <- rbind(subject_train, subject_test)
##Merge rows for x train and test data
x_data <- rbind(x_train, x_test)
##Merge rows for x train and test data
y_data <- rbind(y_train, y_test)
##Merge columns in subject data, x data, and y data
merged_data <- cbind(subject_data, x_data, y_data)

##2. Extracts only the measurements on the mean and standard deviation for each measurement. 
extract_data <- select(merged_data, activity_id, subject, contains("mean"), contains("std"))

##3. Uses descriptive activity names to name the activities in the data set
extract_data[["activity_id"]] <- activity_Labels[ match(extract_data[['activity_id']], activity_Labels[['activity_id']] ) , 'activity']

##4. Appropriately labels the data set with descriptive variable names. 
##Also cleans up unnecessary characters
names(extract_data) <- gsub(x = names(extract_data),pattern = "activity_id",replacement ="Activity",ignore.case= T)
names(extract_data) <- gsub(x = names(extract_data),pattern = "subject",replacement ="Subject",ignore.case= T)
names(extract_data) <- gsub(x = names(extract_data),pattern = "freq",replacement ="Frequency",ignore.case= T)
names(extract_data) <- gsub(x = names(extract_data),pattern = "mean",replacement ="Mean",ignore.case= T)
names(extract_data) <- gsub(x = names(extract_data),pattern = "\\.\\.\\.","_", ignore.case= T)
names(extract_data) <- gsub(x = names(extract_data),pattern = "\\.\\.$","",ignore.case= T)
names(extract_data) <- gsub(x = names(extract_data),pattern = "\\.$","",ignore.case= T)
names(extract_data) <- gsub(x = names(extract_data),pattern = "\\.","_",ignore.case= T)
names(extract_data) <- gsub(x = names(extract_data),pattern ="tBody",replacement = "TimeBody",ignore.case= T)
names(extract_data) <- gsub(x = names(extract_data),pattern ="fBody",replacement = "FrequencyBody",ignore.case= T)
names(extract_data) <- gsub(x = names(extract_data),pattern ="tGravity",replacement = "TimeGravity",ignore.case= T)
names(extract_data) <- gsub(x = names(extract_data),pattern ="Acc",replacement = "Accelerometer",ignore.case= T)
names(extract_data) <- gsub(x = names(extract_data),pattern = "Gyro",replacement = "Gyroscope",ignore.case= T)
names(extract_data) <- gsub(x = names(extract_data),pattern = "gravity",replacement = "Gravity",ignore.case= T)
names(extract_data) <- gsub(x = names(extract_data),pattern = "mag",replacement = "Magnitude",ignore.case= T)
names(extract_data) <- gsub(x = names(extract_data),pattern = "BodyBody",replacement = "Body",ignore.case= T)
names(extract_data) <- gsub(x = names(extract_data),pattern = "angle",replacement = "Angle",ignore.case= T)
names(extract_data) <- gsub(x = names(extract_data),pattern = "std",replacement = "StdDeviation",ignore.case= T)

##5. From the data set in step 4, create a second, independent tidy data set with 
##the average of each variable for each activity and each subject.
tidy_average_data <- extract_data %>% group_by(Subject, Activity) %>% summarize_all(funs(mean))

##text file created with write.table() using row.name=FALSE
write.table(tidy_average_data,"TidyAvgData.txt", row.name=FALSE)
