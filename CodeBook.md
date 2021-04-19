# Final project for Getting and Cleaning Data course

## Data sets

  Initial data set obtained from UCI for Human Activity Recognition Using Smartphones.
  
  Final Data set contains the data merged and summarized as the averages for all measurement variables and grouped by Subject and Activity.
  

## Prep scripts that load the dplyr library and creates variabled to download the data

    library(dplyr)

  Source file information:
  
      fileURL<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
      datafile <- "getdata_projectfiles_UCI_HAR_Dataset.zip"

  **Download if it is not already in the working directory**
  
    if(!file.exists(datafile)){
      download.file(fileURL, datafile, method="curl")
    }

  **Unzip file if the zipped folder is not already in the working directory**
  
    if(!file.exists("UCI HAR Dataset")){
      unzip(datafile)
    }

## Data Load scripts 
  
  The following scripts load the initial data into data tables using **read.table** and labels the variables  
  
  **Load activity Labels and features**
  
    activity_Labels <- read.table(".\\UCI HAR Dataset\\activity_labels.txt", col.names = c("activity_id","activity"))
  
    features <- read.table(".\\UCI HAR Dataset\\features.txt", col.names = c("feature_id","feature"))

  **Load test data**
  
    subject_test <- read.table(".\\UCI HAR Dataset\\test\\subject_test.txt", col.names = "subject")
  
    x_test <- read.table(".\\UCI HAR Dataset\\test\\X_test.txt", col.names = features$feature)
  
    y_test <- read.table(".\\UCI HAR Dataset\\test\\Y_test.txt", col.names = "activity_id")

  **Load train data**
  
    subject_train <- read.table(".\\UCI HAR Dataset\\train\\subject_train.txt", col.names = c("subject"))
  
    x_train <- read.table(".\\UCI HAR Dataset\\train\\X_train.txt", col.names = features$feature)
  
    y_train <- read.table(".\\UCI HAR Dataset\\train\\Y_train.txt", col.names = "activity_id")

## 1. Merges the training and test sets to create one complete data set.

  The following scripts merge data using **rbind** to join the rows of the subject, training, and test data.

  **Merge rows for subject train and test data**
    
    subject_data <- rbind(subject_train, subject_test)
    
  **Merge rows for x train and test data**
  
    x_data <- rbind(x_train, x_test)
    
  **Merge rows for x train and test data**
  
    y_data <- rbind(y_train, y_test)
    
  The following script uses **cbind** to merge the variables from the *subject data*, *x data*, and *y data* into a single data set called *merged_data*
    
  **Merge columns in subject data, x data, and y data**

    merged_data <- cbind(subject_data, x_data, y_data)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

  The following script extracts the data for the variables *activity_id*, *subject*, and all variables containing *mean*, and *std* for means, and standard deviation variables respectively. It uses the **select** function and *contains* functions to accomplish this.

    extract_data <- select(merged_data, activity_id, subject, contains("mean"), contains("std"))

## 3. Uses descriptive activity names to name the activities in the data set
  
  The following scripts uses the activity id values in the *extract_data* to find the corresponding descriptive names in the *activity_labels* data table, and replace it into the *activity_id* variable using the **match** function.
  
    extract_data[["activity_id"]] <- activity_Labels[ match(extract_data[['activity_id']], activity_Labels[['activity_id']] ) , 'activity']


## 4. Appropriately labels the data set with descriptive variable names. 

  The following scripts uses **gsub** rename the variables by replacing abbreviated names and capitalizing them. 
  It also eliminates or replaces periods.
  
    names(extract_data) <- gsub(x = names(extract_data),pattern = "activity_id",replacement="Activity",ignore.case=T)
    names(extract_data) <- gsub(x = names(extract_data),pattern = "subject",replacement ="Subject",ignore.case= T)
    names(extract_data) <- gsub(x = names(extract_data),pattern = "freq",replacement ="Frequency",ignore.case= T)
    names(extract_data) <- gsub(x = names(extract_data),pattern = "mean",replacement ="Mean",ignore.case= T)
    names(extract_data) <- gsub(x = names(extract_data),pattern = "\\.\\.\\.","_", ignore.case= T)
    names(extract_data) <- gsub(x = names(extract_data),pattern = "\\.\\.$","",ignore.case= T)
    names(extract_data) <- gsub(x = names(extract_data),pattern = "\\.$","",ignore.case= T)
    names(extract_data) <- gsub(x = names(extract_data),pattern = "\\.","_",ignore.case= T)
    names(extract_data) <- gsub(x = names(extract_data),pattern ="tBody",replacement ="TimeBody",ignore.case=T)
    names(extract_data) <- gsub(x = names(extract_data),pattern ="fBody",replacement ="FrequencyBody",ignore.case=T)
    names(extract_data) <- gsub(x = names(extract_data),pattern ="tGravity",replacement ="TimeGravity",ignore.case=T)
    names(extract_data) <- gsub(x = names(extract_data),pattern ="Acc",replacement = "Accelerometer",ignore.case= T)
    names(extract_data) <- gsub(x = names(extract_data),pattern = "Gyro",replacement = "Gyroscope",ignore.case= T)
    names(extract_data) <- gsub(x = names(extract_data),pattern = "gravity",replacement = "Gravity",ignore.case= T)
    names(extract_data) <- gsub(x = names(extract_data),pattern = "mag",replacement = "Magnitude",ignore.case= T)
    names(extract_data) <- gsub(x = names(extract_data),pattern = "BodyBody",replacement = "Body",ignore.case= T)
    names(extract_data) <- gsub(x = names(extract_data),pattern = "angle",replacement = "Angle",ignore.case= T)
    names(extract_data) <- gsub(x = names(extract_data),pattern = "std",replacement = "StdDeviation",ignore.case= T)

## 5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.

  The following script groups the *extract_data* by *Subject* and *Activity* and uses **summarize_all** to apply the **mean** function to all the measurement variables, and stores it in *tidy_average_data*

    tidy_average_data <- extract_data %>% group_by(Subject, Activity) %>% summarize_all(funs(mean))

## Text file created with write.table() using row.name=FALSE
  
  The following script uses **write.table** to create the finale text file for the summarized data into the *TidyAvgData.txt* file

    write.table(tidy_average_data,"TidyAvgData.txt", row.name=FALSE)
    
## Variables in TidyAvgData

    Subject							Subject ID
    Activity						Activity name
    TimeBodyAccelerometer_Mean_X				Average of TimeBodyAccelerometer_Mean_X
    TimeBodyAccelerometer_Mean_Y				Average of TimeBodyAccelerometer_Mean_Y
    TimeBodyAccelerometer_Mean_Z				Average of TimeBodyAccelerometer_Mean_Z
    TimeGravityAccelerometer_Mean_X				Average of TimeGravityAccelerometer_Mean_X
    TimeGravityAccelerometer_Mean_Y				Average of TimeGravityAccelerometer_Mean_Y
    TimeGravityAccelerometer_Mean_Z				Average of TimeGravityAccelerometer_Mean_Z
    TimeBodyAccelerometerJerk_Mean_X			Average of TimeBodyAccelerometerJerk_Mean_X
    TimeBodyAccelerometerJerk_Mean_Y			Average of TimeBodyAccelerometerJerk_Mean_Y
    TimeBodyAccelerometerJerk_Mean_Z			Average of TimeBodyAccelerometerJerk_Mean_Z
    TimeBodyGyroscope_Mean_X				Average of TimeBodyGyroscope_Mean_X
    TimeBodyGyroscope_Mean_Y				Average of TimeBodyGyroscope_Mean_Y
    TimeBodyGyroscope_Mean_Z				Average of TimeBodyGyroscope_Mean_Z
    TimeBodyGyroscopeJerk_Mean_X				Average of TimeBodyGyroscopeJerk_Mean_X
    TimeBodyGyroscopeJerk_Mean_Y				Average of TimeBodyGyroscopeJerk_Mean_Y
    TimeBodyGyroscopeJerk_Mean_Z				Average of TimeBodyGyroscopeJerk_Mean_Z
    TimeBodyAccelerometerMagnitude_Mean			Average of TimeBodyAccelerometerMagnitude_Mean
    TimeGravityAccelerometerMagnitude_Mean			Average of TimeGravityAccelerometerMagnitude_Mean
    TimeBodyAccelerometerJerkMagnitude_Mean			Average of TimeBodyAccelerometerJerkMagnitude_Mean
    TimeBodyGyroscopeMagnitude_Mean				Average of TimeBodyGyroscopeMagnitude_Mean
    TimeBodyGyroscopeJerkMagnitude_Mean			Average of TimeBodyGyroscopeJerkMagnitude_Mean
    FrequencyBodyAccelerometer_Mean_X			Average of FrequencyBodyAccelerometer_Mean_X
    FrequencyBodyAccelerometer_Mean_Y			Average of FrequencyBodyAccelerometer_Mean_Y
    FrequencyBodyAccelerometer_Mean_Z			Average of FrequencyBodyAccelerometer_Mean_Z
    FrequencyBodyAccelerometer_MeanFrequency_X		Average of FrequencyBodyAccelerometer_MeanFrequency_X
    FrequencyBodyAccelerometer_MeanFrequency_Y		Average of FrequencyBodyAccelerometer_MeanFrequency_Y
    FrequencyBodyAccelerometer_MeanFrequency_Z		Average of FrequencyBodyAccelerometer_MeanFrequency_Z
    FrequencyBodyAccelerometerJerk_Mean_X			Average of FrequencyBodyAccelerometerJerk_Mean_X
    FrequencyBodyAccelerometerJerk_Mean_Y			Average of FrequencyBodyAccelerometerJerk_Mean_Y
    FrequencyBodyAccelerometerJerk_Mean_Z			Average of FrequencyBodyAccelerometerJerk_Mean_Z
    FrequencyBodyAccelerometerJerk_MeanFrequency_X		Average of FrequencyBodyAccelerometerJerk_MeanFrequency_X
    FrequencyBodyAccelerometerJerk_MeanFrequency_Y		Average of FrequencyBodyAccelerometerJerk_MeanFrequency_Y
    FrequencyBodyAccelerometerJerk_MeanFrequency_Z		Average of FrequencyBodyAccelerometerJerk_MeanFrequency_Z
    FrequencyBodyGyroscope_Mean_X				Average of FrequencyBodyGyroscope_Mean_X
    FrequencyBodyGyroscope_Mean_Y				Average of FrequencyBodyGyroscope_Mean_Y
    FrequencyBodyGyroscope_Mean_Z				Average of FrequencyBodyGyroscope_Mean_Z
    FrequencyBodyGyroscope_MeanFrequency_X			Average of FrequencyBodyGyroscope_MeanFrequency_X
    FrequencyBodyGyroscope_MeanFrequency_Y			Average of FrequencyBodyGyroscope_MeanFrequency_Y
    FrequencyBodyGyroscope_MeanFrequency_Z			Average of FrequencyBodyGyroscope_MeanFrequency_Z
    FrequencyBodyAccelerometerMagnitude_Mean		Average of FrequencyBodyAccelerometerMagnitude_Mean
    FrequencyBodyAccelerometerMagnitude_MeanFrequency	Average of FrequencyBodyAccelerometerMagnitude_MeanFrequency
    FrequencyBodyAccelerometerJerkMagnitude_Mean		Average of FrequencyBodyAccelerometerJerkMagnitude_Mean
    FrequencyBodyAccelerometerJerkMagnitude_MeanFrequency	Average of FrequencyBodyAccelerometerJerkMagnitude_MeanFrequency
    FrequencyBodyGyroscopeMagnitude_Mean			Average of FrequencyBodyGyroscopeMagnitude_Mean
    FrequencyBodyGyroscopeMagnitude_MeanFrequency		Average of FrequencyBodyGyroscopeMagnitude_MeanFrequency
    FrequencyBodyGyroscopeJerkMagnitude_Mean		Average of FrequencyBodyGyroscopeJerkMagnitude_Mean
    FrequencyBodyGyroscopeJerkMagnitude_MeanFrequency	Average of FrequencyBodyGyroscopeJerkMagnitude_MeanFrequency
    Angle_TimeBodyAccelerometerMean_Gravity			Average of Angle_TimeBodyAccelerometerMean_Gravity
    Angle_TimeBodyAccelerometerJerkMean__GravityMean	Average of Angle_TimeBodyAccelerometerJerkMean__GravityMean
    Angle_TimeBodyGyroscopeMean_GravityMean			Average of Angle_TimeBodyGyroscopeMean_GravityMean
    Angle_TimeBodyGyroscopeJerkMean_GravityMean		Average of Angle_TimeBodyGyroscopeJerkMean_GravityMean
    Angle_X_GravityMean					Average of Angle_X_GravityMean
    Angle_Y_GravityMean					Average of Angle_Y_GravityMean
    Angle_Z_GravityMean					Average of Angle_Z_GravityMean
    TimeBodyAccelerometer_StdDeviation_X			Average of TimeBodyAccelerometer_StdDeviation_X
    TimeBodyAccelerometer_StdDeviation_Y			Average of TimeBodyAccelerometer_StdDeviation_Y
    TimeBodyAccelerometer_StdDeviation_Z			Average of TimeBodyAccelerometer_StdDeviation_Z
    TimeGravityAccelerometer_StdDeviation_X			Average of TimeGravityAccelerometer_StdDeviation_X
    TimeGravityAccelerometer_StdDeviation_Y			Average of TimeGravityAccelerometer_StdDeviation_Y
    TimeGravityAccelerometer_StdDeviation_Z			Average of TimeGravityAccelerometer_StdDeviation_Z
    TimeBodyAccelerometerJerk_StdDeviation_X		Average of TimeBodyAccelerometerJerk_StdDeviation_X
    TimeBodyAccelerometerJerk_StdDeviation_Y		Average of TimeBodyAccelerometerJerk_StdDeviation_Y
    TimeBodyAccelerometerJerk_StdDeviation_Z		Average of TimeBodyAccelerometerJerk_StdDeviation_Z
    TimeBodyGyroscope_StdDeviation_X			Average of TimeBodyGyroscope_StdDeviation_X
    TimeBodyGyroscope_StdDeviation_Y			Average of TimeBodyGyroscope_StdDeviation_Y
    TimeBodyGyroscope_StdDeviation_Z			Average of TimeBodyGyroscope_StdDeviation_Z
    TimeBodyGyroscopeJerk_StdDeviation_X			Average of TimeBodyGyroscopeJerk_StdDeviation_X
    TimeBodyGyroscopeJerk_StdDeviation_Y			Average of TimeBodyGyroscopeJerk_StdDeviation_Y
    TimeBodyGyroscopeJerk_StdDeviation_Z			Average of TimeBodyGyroscopeJerk_StdDeviation_Z
    TimeBodyAccelerometerMagnitude_StdDeviation		Average of TimeBodyAccelerometerMagnitude_StdDeviation
    TimeGravityAccelerometerMagnitude_StdDeviation		Average of TimeGravityAccelerometerMagnitude_StdDeviation
    TimeBodyAccelerometerJerkMagnitude_StdDeviation		Average of TimeBodyAccelerometerJerkMagnitude_StdDeviation
    TimeBodyGyroscopeMagnitude_StdDeviation			Average of TimeBodyGyroscopeMagnitude_StdDeviation
    TimeBodyGyroscopeJerkMagnitude_StdDeviation		Average of TimeBodyGyroscopeJerkMagnitude_StdDeviation
    FrequencyBodyAccelerometer_StdDeviation_X		Average of FrequencyBodyAccelerometer_StdDeviation_X
    FrequencyBodyAccelerometer_StdDeviation_Y		Average of FrequencyBodyAccelerometer_StdDeviation_Y
    FrequencyBodyAccelerometer_StdDeviation_Z		Average of FrequencyBodyAccelerometer_StdDeviation_Z
    FrequencyBodyAccelerometerJerk_StdDeviation_X		Average of FrequencyBodyAccelerometerJerk_StdDeviation_X
    FrequencyBodyAccelerometerJerk_StdDeviation_Y		Average of FrequencyBodyAccelerometerJerk_StdDeviation_Y
    FrequencyBodyAccelerometerJerk_StdDeviation_Z		Average of FrequencyBodyAccelerometerJerk_StdDeviation_Z
    FrequencyBodyGyroscope_StdDeviation_X			Average of FrequencyBodyGyroscope_StdDeviation_X
    FrequencyBodyGyroscope_StdDeviation_Y			Average of FrequencyBodyGyroscope_StdDeviation_Y
    FrequencyBodyGyroscope_StdDeviation_Z			Average of FrequencyBodyGyroscope_StdDeviation_Z
    FrequencyBodyAccelerometerMagnitude_StdDeviation	Average of FrequencyBodyAccelerometerMagnitude_StdDeviation
    FrequencyBodyAccelerometerJerkMagnitude_StdDeviation	Average of FrequencyBodyAccelerometerJerkMagnitude_StdDeviation
    FrequencyBodyGyroscopeMagnitude_StdDeviation		Average of FrequencyBodyGyroscopeMagnitude_StdDeviation
    FrequencyBodyGyroscopeJerkMagnitude_StdDeviation	Average of FrequencyBodyGyroscopeJerkMagnitude_StdDeviation