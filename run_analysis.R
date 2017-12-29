##Download file and unzip
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Data.zip")
unzip(zipfile="./data/Data.zip",exdir="./data")

## Read in data 
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
features <- read.table('./data/UCI HAR Dataset/features.txt')
activitylabels <- read.table('./data/UCI HAR Dataset/activity_labels.txt')

## 1) Merges the training and the test sets to create one data set.

## Merge data 
train_merged <- cbind(y_train, subject_train, x_train)
test_merged <- cbind(y_test, subject_test, x_test)
all_merged <- rbind(train_merged, test_merged)

## Set column names
features2 <- as.vector(features[,2])
colnames(all_merged) <- c("activityid", "subject", features2)

## 2) Extracts only the measurements on the mean and standard deviation for each measurement
mean_std <- all_merged[ , grep("-(mean|std)\\(\\)" , names(all_merged) ) ]
col <- all_merged[,c(1,2)]
all_mean_std <- cbind(col,mean_std)

## 3) Uses descriptive activity names to name the activities in the data set
colnames(activitylabels) <- c("activityid","activityname")
addedlabels <- merge(activitylabels, all_mean_std, by='activityid') 
addedlabels$activityname <- as.character(addedlabels$activityname)

## 4) Appropriately labels the data set with descriptive variable names.
## descriptive variable names added in step 1 above with 
  ## colnames(all_merged) <- c("activityid", "subject", features2)

## 5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
## average for each subject and each activity
tidydf <- aggregate(. ~subject + activityid + activityname, addedlabels, mean)
##order by subject and then by activity 
tidydf <- tidydf[order(tidydf$subject,tidydf$activityid),]
##save as a txt file called TidyData.txt 
write.table(tidydf, "./data/UCI HAR Dataset/TidyData.txt", row.name=FALSE, col.name=TRUE)




