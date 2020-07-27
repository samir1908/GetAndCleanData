run_analysis0<-function()
{
  library(data.table)
  library(dplyr)
  #downloading and unzipping data
  ##################
  fileUrl<-("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip")
  if(!file.exists("messy.zip"))
  {
    download.file(fileUrl,"messy.zip",mode="wb")
  }
  if(!file.exists("UCI HAR Dataset"))
  {
    unzip("messy.zip")
    
  }
  ##################################################
  #loading data to R
  
  #The activities 
  activities<-read.table("UCI HAR Dataset/activity_labels.txt")
  #features of above activity
  features<-read.table("UCI HAR Dataset/features.txt")
  #The subjects
  subject_test<-read.table("UCI HAR Dataset/test/subject_test.txt")
  subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt")
  y_test<-read.table("UCI HAR Dataset/test/y_test.txt")
  y_train<-read.table("UCI HAR Dataset/train/y_train.txt")
  x_test<-read.table("UCI HAR Dataset/test/X_test.txt")
  x_train<-read.table("UCI HAR Dataset/train/X_train.txt")
  ##############################################################
  ########Column names
  colnames(x_train)<-features[,2]
  colnames(y_train)<-"code"
  colnames(subject_train)<-"subject"
  colnames(x_test)<-features[,2]
  colnames(y_test)<-"code"
  colnames(subject_test)<-"subject"
  colnames(activities)<-c("code","activity")
  ########################################################
  ############################################
  mergedTrain<-cbind(y_train,subject_train,x_train)
  mergedTest<-cbind(y_test,subject_test,x_test)
  mergedData<-rbind(mergedTrain,mergedTest)
  tidy<-mergedData %>% select(subject,code,contains("mean"),contains("std"))
  tidy$code=activities[tidy$code,2]
  names(tidy)
  names(tidy)[2] = "activity"
  names(tidy)<-gsub("Acc", "Accelerometer", names(tidy))
  names(tidy)<-gsub("Gyro", "Gyroscope", names(tidy))
  names(tidy)<-gsub("BodyBody", "Body", names(tidy))
  names(tidy)<-gsub("Mag", "Magnitude", names(tidy))
  names(tidy)<-gsub("^t", "Time", names(tidy))
  names(tidy)<-gsub("^f", "Frequency", names(tidy))
  names(tidy)<-gsub("tBody", "TimeBody",names(tidy))
  names(tidy)<-gsub("-mean()", "Mean", names(tidy), ignore.case = TRUE)
  names(tidy)<-gsub("-std()", "STD", names(tidy), ignore.case = TRUE)
  names(tidy)<-gsub("-freq()", "Frequency",names(tidy), ignore.case = TRUE)
  names(tidy)<-gsub("angle", "Angle",names(tidy))
  names(tidy)<-gsub("gravity", "Gravity",names(tidy))
  names(tidy)
  
  tidyData<-tidy %>% group_by(subject,activity)
  tidyData <-tidyData %>% summarise_all(mean)
  write.table(tidyData,"tidyData.txt",row.name=FALSE)
  tidyData
}