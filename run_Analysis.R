#Read training and test tables
xtrain = read.table("./UCI HAR Dataset/train/X_train.txt")
ytrain = read.table("./UCI HAR Dataset/train/Y_train.txt")
subject_train = read.table("./UCI HAR Dataset/train/subject_train.txt")
xtest = read.table("./UCI HAR Dataset/test/X_test.txt")
ytest = read.table("./UCI HAR Dataset/test/Y_test.txt")
subject_test = read.table("./UCI HAR Dataset/test/subject_test.txt")

#Read features
features = read.table("./UCI HAR Dataset/features.txt")
activityLabels = read.table("./UCI HAR Dataset/activity_labels.txt")

#Run sanity checks
colnames(xtrain) = features[,2]
colnames(ytrain) = "activityId"
colnames(subject_train) = "subjectId"
colnames(xtest) = features[,2]
colnames(ytest) = "activityId"
colnames(subject_test) = "subjectId"
colnames(activityLabels) <- c('activityId','activityType')

#Merge the train and test data; create new table
mrg_train = cbind(ytrain, subject_train, xtrain)
mrg_test = cbind(ytest, subject_test, xtest)
setCombined = rbind(mrg_train, mrg_test)

#Extra mean and SD
colNames = colnames(setCombined)
mean_and_std = (grepl("activityId" , colNames) | grepl("subjectId" , colNames) | grepl("mean.." , colNames) | grepl("std.." , colNames))
setMeanAndSD <- setCombined[ , mean_and_std == TRUE]

#Descriptive activity names
setWithActivityNames = merge(setMeanAndSD, activityLabels, by='activityId', all.x=TRUE)

#New tidy dataset
secTidy <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secTidy <- secTidy[order(secTidy$subjectId, secTidy$activityId),]
write.table(secTidy, "secTidy.txt", row.name=FALSE)