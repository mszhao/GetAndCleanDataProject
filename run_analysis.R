#files are in /data subdirectory
#read features table and activity label
features<-read.table("./data/features.txt")
actLbl<-read.table("./data/activity_labels.txt")

#extract the features of mean and std
fMeanStd<-filter(features, grepl("mean|std|Mean", features$V2))

root<-"./data/"
#read all txt file into tables, use the file names as dataset names
strList<-list("test","train")
dataList<-list()
for(str in strList)
{
  path1<-paste(root,str,"/",sep="")
  tblList<-list()
  files1 <- list.files(path=path1, pattern="*.txt")
  for(file in files1)
  {
    perpos <- which(strsplit(file, "")[[1]]==".")
    tbl<- gsub(" ","",substr(file, 1, perpos-1))
    assign(tbl, 
      read.table(paste(path1,file,sep="")))
    tblList<-c(tblList,tbl)
  }
 
}
#merge train and test data
data<-rbind(X_test,X_train)
activity<-rbind(y_test,y_train)
subject<-rbind(subject_test,subject_train)
#assign column names to data
colnames(data)<-features$V2
#select the mean and std measurement
MeanStd<-data[,fMeanStd$V1]
#add subject and activity to data
MeanStd$ActivityID<-activity$V1
MeanStd$Subject<-subject$V1
#number of mean-std columns
nCol<-ncol(MeanStd)-2
#tidy data 
library(tidyr)
gat<-gather(MeanStd,features, measurement, 1:nCol)
sep<-separate(data = gat, col = features, into = c("Signal", "Variable","Axis"),sep = "-",extra="drop")
#add activity column names and join to mean-std data
colnames(actLbl)<-c("ActivityID", "Activity")
jData<-join(sep,actLbl)
jData<-subset(jData,select=-c(ActivityID))

#melt
library(reshape2)
melted <- melt(jData, id=c("Subject", "Activity","Signal", "Variable","Axis"),measure.vars="measurement")
#reshape for every subject and every activity and mean of every measurement 
summary<-dcast(melted, Subject +Activity+Signal+Variable+Axis~ variable,mean)

#write to a txt file
write.table(summary, "./project.txt", sep="\t",row.name=FALSE)


