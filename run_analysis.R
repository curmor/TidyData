## URL of the File to download
fUrl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'

## Location of the zip file
dataZip <- "./getdata-projectfiles-UCI-HAR-Dataset.zip"

## Sets the directory of the dataset
dFile <- "./UCI HAR Dataset"

## .txt or .csv filename for the tidy data:
tidyFile <- "./tidy_dataset.txt"
tidyFileAvtxt <- "./tidy_Average_dataset.txt"

## Downloads dataset if not already done
if (file.exists(dataZip) == FALSE) {
        download.file(fUrl, destfile = dataZip)
}

## Unzips data file
if (file.exists(dFile) == FALSE) {
        unzip(dataZip)
}

## Pt 1. Merges the training and the test sets to create one data set.
train_x <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
test_X <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
train_y <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
test_y <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
subj_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
subj_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)

## Combines train and test into one data_table by rows
x <- rbind(train_x, test_X)
y <- rbind(train_y, test_y)
s <- rbind(subj_train, subj_test)

## Pt 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
feat <- read.table("./UCI HAR Dataset/features.txt")

## Pt. 3. Uses descriptive activity names to name the activities in the data set
names(feat) <- c('feat_id', 'feat_name')
## Searches for mean or standard deviation arguments in each element of character vector
## and replaces all string feature matches
index_features <- grep("-mean\\(\\)|-std\\(\\)", features$feat_name) 
x <- x[, index_features] 
names(x) <- gsub("\\(|\\)", "", (features[index_features, 2]))

## Pt 4. Uses descriptive activity names to name the activities in the data set.
## and appropriately labels the data set with descriptive activity names:
acts <- read.table("./UCI HAR Dataset/activity_labels.txt")
names(acts) <- c('act_id', 'act_name')
y[, 1] = acts[y[, 1], 2]

names(y) <- "Activity"
names(s) <- "Subject"

## Combines the data_table by columns
tidySet <- cbind(s, y, x)

# Pt 5. creates a second, independent tidy data set with the average of each variable for 
##  each activity and each subject
p <- tidySet[, 3:dim(tidySet)[2]] 
tidyDataAvSet <- aggregate(p,list(tidySet$Subject, tidySet$Activity), mean)

names(tidyDataAvSet)[1] <- "Subject"
names(tidyDataAvSet)[2] <- "Activity"

write.table(tidySet, tidyFile, row.name=FALSE)
write.table(tidyDataAvSet, tidyFileAvtxt, row.name=FALSE)
