url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "/Users/hyli/Dropbox/A01_Research/04_R/work.zip", method="curl")
unzip("/Users/hyli/Dropbox/A01_Research/04_R/work.zip")


# Part1: Merge data
library(reshape2)
library(plyr)

xTest <- read.table("UCI HAR Dataset/test/X_test.txt")
xTrain <- read.table("UCI HAR Dataset/train/X_train.txt")
yTest <- read.table("UCI HAR Dataset/test/Y_test.txt")
yTrain <- read.table("UCI HAR Dataset/train/Y_train.txt")

xcomb <- rbind(xTrain, xTest)
ycomb <- rbind(yTrain, yTest)

names(ycomb) <- 'activity'

subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt")
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt")
subjectcomb <- rbind(subjectTrain, subjectTest)

names(subjectcomb) <- 'subject'
combinedData <- cbind(xcomb, ycomb, subjectcomb)

# Part2: Mean and Standard Deviation
features <- read.table("UCI HAR Dataset/features.txt")
meanSDFeatures <- grep("(mean\\(\\)|std\\(\\))", features[,2])
requiredFields <-  combinedData[, meanSDFeatures]

# Part3: Name the data set
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
ycomb[, 1] <- activityLabels[ycomb[, 1],2]

# Part4: Appropriately labels the data set
names(combinedData) <- c(as.character(features[, 2]), "activity", "subject")

# Part5: Creates a second, independent tidy data set
out <- ddply(combinedData, .(activity, subject), function(x) colMeans(x[1:561]))
write.table(out, "average.txt", row.names = FALSE)
