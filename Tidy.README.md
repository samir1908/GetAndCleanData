getting the data from the web
loading data into R
downloading selected file
merging the downloaded data tables 
this data is messy data and will be filtered through  
tidy<-mergedData %>% select(subject,code,contains("mean"),contains("std"))
this tidy data will reduce number of columns down 
the tidy data above is assigned names 
this data is grouped by 
tidyData<-tidy %>% group_by(subject,activity)
and filtered again to produce 
tidyData <-tidyData %>% summarise_all(mean)
this data is written 
write.table(tidyData,"tidyData.txt",row.name=FALSE)