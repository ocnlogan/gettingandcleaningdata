# run_analysis readme/codebook

In this assignment I made a series of assumptions that were critical to how I completed the work.

###Assumption 1: The data is fixed in its output.

Assumption 1 came into play primarily when cleaning undesired rows from the data. This was done by manually inspecting the fixed format x test and x train files, and discovering the rows that caused dplyr's "select" function to break. The assumption is that all files output by the devices in the future will be of the same format, or that the script would be updated in the future.


###Assumption 2: Features.txt contained the descriptive column names required in the processing

I felt that the features.txt file contained all the needed column names, and that they would easily be understood by someone with domain knowledge, so I elected to keep them as they were. Any modifications to these names would have made the column names longer than they already are, or make them lose important information.


##Detailed step by step explanation of manipulations of the source data resulting it the output.

The processing of this dataset was relatively straightforward.

1. The file paths for all files are created and normalized (accounting for different operating systems)

2. The files are all read into dataframe variables

3. The dataframe variables all have their respective column names applied

4. The dataframes are then cleaned of columns that interfere with the column selection process (removing of duplicate columnnames)

5. The dataframes are then filtered down to the columns that are required (SubjectID, Activity, means, standard deviations)

6. The filtered dataframes are combined into a single dataframe

7. The single dataframe is filtered by row to replace the "Activity" columns ID's with human friendly names (1 = walking, etc)

8. The single dataframe is grouped by SubjectID and Activity, and then the mean of each column is calculated and displayed for that unique combination of SubjectID and Activity

###Example output:

  SubjectID          Activity tBodyAcc.mean...X tBodyAcc.mean...Y tBodyAcc.mean...Z tGravityAcc.mean...X tGravityAcc.mean...Y tGravityAcc.mean...Z
          1            laying         0.2215982      -0.040513953        -0.1132036           -0.2488818            0.7055498           0.44581772
          1           sitting         0.2612376      -0.001308288        -0.1045442            0.8315099            0.2044116           0.33204370
          1          standing         0.2789176      -0.016137590        -0.1106018            0.9429520           -0.2729838           0.01349058


##Code Book Section:

The variables in the output from this script come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ.

Variables with the "t" prefeix are time domain signals 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' prefix to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

Out of the initial large set of variables (561), only the mean and the standard deviations variations were selected for the output. These are the denoted as such:

mean(): Mean value
std(): Standard deviation

Also note that the output of tidy, summarized data is grouped by SubjectID and Activity, and then the MEAN of every observation is calculated. This means that these are MEANS of MEANS and of standard deviations. Just be aware.

The complete list of variables of each feature vector is available in 'features.txt'