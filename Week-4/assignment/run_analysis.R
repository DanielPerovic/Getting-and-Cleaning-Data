# This function is the main function that leverages multiple other functions 
# to create the final data set.  The data being analyzed must reside under the working directory
# of where this function is being executed.
create_analysis_data <- function() {
    # Get test data prepared
    print("Getting and tidying test data...")
    new.test <- tidy_test_data()
    # Get train data prepared
    print("Getting and tidying train data...")
    new.train <- tidy_train_data()
    # Merge test and train data
    print("Merging test and train data...")
    merged_data <- merge_test_train(new.test, new.train)
    # Subset the merged data
    print("Subsetting merged data...")
    tidy_subset <- get_tidy_subset(merged_data)
    # Create the final analysis data (with text file)
    print("Creating final data set...")
    subset_mean_data <- get_subset_mean(tidy_subset)
}


# This function returns a tidy data frame for the "test" volunteer (subject) data.
# The data for the function must reside in the folder structure under the working directory
#
# Input: none
# Output: new.test (data.frame)
tidy_test_data <- function() {
    # Set the variable names
    features <- read.delim("./UCI HAR Dataset/features.txt", sep = "", header = FALSE)
    
    # Set the activity names
    activities <- read.delim("./UCI HAR Dataset/activity_labels.txt", sep = "", header = FALSE)
    
    # Tidy the data for the "test" volunteers
    
    # Get the volunteer (subject) data. Variables names will align with features names.
    test.X <- read.delim("./UCI HAR Dataset/test/X_test.txt", sep = "", header = FALSE)
    # Get the rows of activities. Labels will be applied to the numeric values in the data set.
    test.y <- read.delim("./UCI HAR Dataset/test/y_test.txt", sep = "", header = FALSE)
    
    # Add a variable to hold the descriptive activity name (referenced by its numeric values) 
    uniqueactivities <- unique(test.y$V1)
    for (i in uniqueactivities) {
        test.y$activity[test.y$V1 == i] <- as.character(activities$V2[i])
    }
    
    # Get the volunteers (subjects) of the test data set. This data will be aligned to the test volunteer data.
    test.subject <- read.delim("./UCI HAR Dataset/test/subject_test.txt", sep = "", header = FALSE, col.names = c("volunteer_id"))

    library(data.table)
    # Rename the variables of the test volunteer data to the descriptive feature names
    setnames(test.X, names(test.X), as.character(features$V2))
    
    # Add the descriptive activity observations/rows to the data observations
    new.test <- data.frame(activity = test.y$activity, test.X)
    
    # Add the volunteer (subject) observations to their data observations
    new.test <- data.frame(volunteer_id = test.subject$volunteer_id, new.test)

    return(new.test)
}

# This function returns a tidy data frame for the "train" volunteer (subject) data.
# The data for the function must reside in the folder structure under the working directory
#
# Input: none
# Output: new.train (data.frame)
tidy_train_data <- function() {
    # Set the variable names
    features <- read.delim("./UCI HAR Dataset/features.txt", sep = "", header = FALSE)
    
    # Set the activity names
    activities <- read.delim("./UCI HAR Dataset/activity_labels.txt", sep = "", header = FALSE)
    
    # Get the volunteer (subject) data. Variables names will align with features names.
    train.X <- read.delim("./UCI HAR Dataset/train/X_train.txt", sep = "", header = FALSE)
    # Get the rows of activities. Labels will be applied to the numeric values in the data set.
    train.y <- read.delim("./UCI HAR Dataset/train/y_train.txt", sep = "", header = FALSE)

    # Add a variable to hold the descriptive activity name (referenced by its numeric values) 
    uniqueactivities <- unique(train.y$V1)
    for (i in uniqueactivities) {
        train.y$activity[train.y$V1 == i] <- as.character(activities$V2[i])
    }
    
    # Get the volunteers (subjects) of the test data set.
    train.subject <- read.delim("./UCI HAR Dataset/train/subject_train.txt", sep = "", header = FALSE, col.names = c("volunteer_id"))
    
    library(data.table)
    # Rename the variables of the test volunteer data to the descriptive feature names
    setnames(train.X, names(train.X), as.character(features$V2))
    
    # Align the descriptive activity observations/rows to the data observations
    new.train <- data.frame(activity = train.y$activity, train.X)
    
    # Align the test volunteer (subject) observations to their data observations
    new.train <- data.frame(volunteer_id = train.subject, new.train)

    return(new.train)
}

# The following function merges the tidy test and train data frame and returns a new data frame
# ordered by volunteer_id (subject) ascending
#
# Input: testdata (data.frame), traindata (data.frame)
# Output: merged_data (data.frame)
merge_test_train <- function(testdata, traindata) {
    library(plyr)
    merged_data <- arrange(join(testdata, traindata, by = "volunteer_id", type = "full"), volunteer_id)
    return(merged_data)
}

# The following function takes the tidy data frame and subsets the data 
# by the specified matching variable names (i.e. "mean" and "std" variable names).
#
# Input: tidydata (data.frame)
# Output: tidy_subset (data.frame)
get_tidy_subset <- function(tidydata) {
    a <- match("volunteer_id", names(tidydata))
    b <- match("activity", names(tidydata))
    c <- grep("\\.mean\\.", names(tidydata))
    d <- grep("\\.std\\.", names(tidydata))
    e <- c(a,b,c,d)
    tidy_subset <- tidydata[ ,e]
    return(tidy_subset)
}

# The following function takes the tidy subset of data, groups the data by volunteer_id (subject)
# and activity, then calculates the mean for each of the variables.
# This function also creates a text file of the resultant data set.
#
# Input: tidy_subset (data.frame)
# Ouput: subset_mean (grouped data.frame)
get_subset_mean <- function(tidy_subset) {
    library(dplyr)
    subset_mean <- tidy_subset %>%
        group_by(volunteer_id, activity) %>%
        summarize_each(funs(mean))
    # Write the result to a text file
    write.table(subset_mean, file = "subset_mean_data.txt", row.names = FALSE)
    return(subset_mean)
}