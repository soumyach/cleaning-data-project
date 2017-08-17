library(reshape2)



## Download and unzip the dataset:
if (!file.exists("t.zip")){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, "t.zip")
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip("t.zip") 
}

# Load activity labels + features
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# Extract only the data on mean and standard deviation
meansd <- grep(".*mean.*|.*std.*", features[,2])
meansd.names <- features[meansd,2]
meansd.names = gsub('-mean', 'Mean', meansd.names)
meansd.names = gsub('-std', 'Std', meansd.names)
meansd.names <- gsub('[-()]', '', meansd.names)


# Load the datasets
train <- read.table("UCI HAR Dataset/train/X_train.txt")[meansd]
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

test <- read.table("UCI HAR Dataset/test/X_test.txt")[meansd]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

# merge datasets and add labels
Data <- rbind(train, test)
colnames(Data) <- c("subject", "activity", meansd.names)

# turn activities & subjects into factors
Data$activity <- factor(Data$activity, levels = activityLabels[,1], labels = activityLabels[,2]
Data$subject <- as.factor(Data$subject)

# getting the tidy data
Data.melted <- melt(Data, id = c("subject", "activity"))
Data.mean <- dcast(Data.melted, subject + activity ~ variable, mean)

write.table(allData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)