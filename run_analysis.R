##################################################################
#getting things ready
##################################################################
#load up the main library libraries that we'll be using
library(dplyr)

#Download the file from the interwebz, and unzip it to the current directory so we have a reference point.
# download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile="data", mode = "wb")
# unzip("data")


##################################################################
#Creating the file paths
##################################################################
#get the paths to the test files
xtrainpath <- file.path("UCI HAR Dataset", "train", "X_train.txt")
xtrainpath <- normalizePath(xtrainpath)

ytrainpath <- file.path("UCI HAR Dataset", "train", "Y_train.txt")
ytrainpath <- normalizePath(ytrainpath)

subjecttrainpath <- file.path("UCI HAR Dataset", "train", "subject_train.txt")
subjecttrainpath <- normalizePath(subjecttrainpath)

#build the paths to the training files
xtestpath <- file.path("UCI HAR Dataset", "test", "X_test.txt")
xtestpath <- normalizePath(xtestpath)

ytestpath <- file.path("UCI HAR Dataset", "test", "Y_test.txt")
ytestpath <- normalizePath(ytestpath)

subjecttestpath <- file.path("UCI HAR Dataset", "test", "subject_test.txt")
subjecttestpath <- normalizePath(subjecttestpath)


##################################################################
#actually read in the data, which takes 9GB of RAM!!
##################################################################
#read in the X data
xcolumnwidth <- rep(16, 561)
xtraindata <- read.fwf(xtrainpath, xcolumnwidth, header = FALSE)
xtestdata <- read.fwf(xtestpath, xcolumnwidth, header = FALSE)

#read in the Y data
ytraindata <- read.table(ytrainpath, header = FALSE)
ytestdata <- read.table(ytestpath, header = FALSE)

#read in the subject data
subjecttestdata <- read.table(subjecttestpath, header = FALSE)
subjecttraindata <- read.table(subjecttrainpath, header = FALSE)


##################################################################
#Add the columnnames to enable dplyr "search()" functionality for step 2
##################################################################

#get the column names for the "X" data
columnnamespath <- file.path("UCI HAR Dataset", "features.txt")
columnnamespath <- normalizePath(columnnamespath)
columnnames <- read.table(columnnamespath)

#get the column names for the "Y" data, which is actually just Activity data. So rename the column as such
ycolumnname <- "Activity"

#get the column names for the "Y" data
subjectcolumnname <- "SubjectID"

#rename the columns of X datasets
names(xtraindata) <- columnnames[[2]]
names(xtestdata) <- columnnames[[2]]

#rename the columns of y datasets
names(ytraindata) <- ycolumnname
names(ytestdata) <- ycolumnname

#rename the columns of the subject datasets
names(subjecttraindata) <- subjectcolumnname
names(subjecttestdata) <- subjectcolumnname


##################################################################
##1.Merges the training and the test sets to create one data set. This is done by adding the "Y" data to the "X" data
##################################################################

#first combine all the subject, y, and x data together into a single dataframe
combinedtraindata <- cbind(subjecttraindata, ytraindata, xtraindata)
combinedtestdata <- cbind(subjecttestdata, ytestdata, xtestdata)


##################################################################
#cleaning the fixed format data in prep for task #2, by removing the few duplicate column names that break dplyr "select" functionality
##################################################################
#remove the duplicate columns (fBodyAccJerk-bandsEnergy()).
#These commands assume that the data output format for the device is fixed, and will remain in the same format
#The offending columns were then found via manual inspection, and removed here
combinedtestdata <- combinedtestdata[-(384:425)]
combinedtraindata <- combinedtraindata[-(384:425)]

#the last of the un-needed columns that break "select" functionality (fBodyAcc-bandsEnergy()).
#Again this is assuming that the file is fixed format and will not be changing.
combinedtestdata <- combinedtestdata[-(305:346)]
combinedtraindata <- combinedtraindata[-(305:346)]


##################################################################
#Finally performing task #2.Extracting only the measurements on the mean and standard deviation for each measurement (as well as retaining subject and activity)
##################################################################

filteredxtest <- select(combinedtestdata, contains("SubjectID"), contains("Activity"), contains("mean()"), contains("std()"))
filteredxtrain <- select(combinedtraindata, contains("SubjectID"), contains("Activity"), contains("mean()"), contains("std()"))

#clean up some unused datasets to free up ram/make the program run faster and make debugging easier.
rm(xtestdata)
rm(xtraindata)
rm(ytestdata)
rm(ytraindata)
rm(subjecttestdata)
rm(subjecttraindata)
rm(combinedtestdata)
rm(combinedtraindata)
    
#Finally completing step 1. It made more sense to do it here with my method. made both of the filtered, correctly ordered dataframes into one dataframe
totaldata <- rbind(filteredxtest, filteredxtrain)


##################################################################
#3.#There are 5 activities (1-5) each number represent an activity, walking, laying, sitting, etc etc. you are to replace each number to its respective activity.
##################################################################

#4 rename each variable name to a more descriptive variable name-

ordereddata <- filter(totaldata, Activity == 1)
ordereddata[,2] <- "walking"

tempdata <- filter(totaldata, Activity == 2)
tempdata[,2] <- "walkingupstairs"
ordereddata <- rbind(ordereddata, tempdata)

tempdata <- filter(totaldata, Activity == 3)
tempdata[,2] <- "walkingdownstairs"
ordereddata <- rbind(ordereddata, tempdata)

tempdata <- filter(totaldata, Activity == 4)
tempdata[,2] <- "sitting"
ordereddata <- rbind(ordereddata, tempdata)

tempdata <- filter(totaldata, Activity == 5)
tempdata[,2] <- "standing"
ordereddata <- rbind(ordereddata, tempdata)

tempdata <- filter(totaldata, Activity == 6)
tempdata[,2] <- "laying"
ordereddata <- rbind(ordereddata, tempdata)


##################################################################
#5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
##################################################################

#and finally, the tidydata is constructed by grouping by the SubjectID and Activity, then the mean taken of all other columns.
tidydata <- ordereddata %>% group_by(SubjectID, Activity) %>% summarize_each(funs(mean))

#output/return the tidydata
tidydata

#commented out code for writing the output as asked for in the assignment.
#write.table(tidydata, row.name = FALSE, file = "run_analysis_output.txt")
