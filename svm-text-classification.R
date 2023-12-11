library(caret)
library(e1071)
library(quanteda)
#set seed to ensure results are consistent while testing across sessions
set.seed(4123)

load_data<-function(){
  #read data into data frame
  data<-read.csv("Z:/Web Mining Project/data-v1.csv", header=TRUE)
  #creating the Combined attribute
  data$combined<-paste(data$title, data$subject)
  #move new column before the class column for consistency
  data<-data[, c("title", "text", "subject", "date", "combined", "class")]
  return(data)
}

text_preprocessing<-function(data){
  #create the corpus
  text_corpus<-corpus(data)
  #remove punctuation and numbers
  text_tokens<-tokens(text_corpus, remove_punct = TRUE, remove_numbers = TRUE)
  #remove english stopwords
  text_tokens<-tokens_select(text_tokens, pattern = stopwords('en'), 
                             selection = 'remove')
  return(text_tokens)
}

cross_validation<-function(data, k){
  #create k folds to perform cross-validation on
  folds = createFolds(data$class, k=k)
  return(folds)
}

train<-function(data, fold){
  #create training data set using fold
  train<-data[fold, ]
  #create the training document term matrix
  train_docterm<<-dfm(train$combined)
  #convert the doc term matrix to a data frame
  train_df<-convert(train_docterm, to = "data.frame")
  #remove the index created by the dfm() function
  train_df<-train_df[,-1]
  #train the classifier
  train_svm<-svm(x=train_df, y=train$class, kernel='linear', 
                 type='C-classification', cost=10)
  return(train_svm)
}

test<-function(data, fold, trained){
  #create testing data set using folds not used by training data set
  test<-data[-fold, ]
  #create the testing document term matrix
  test_docterm<-dfm(test$combined)
  #match the testing doc term matrix to the training one
  matched_docterm<-dfm_match(test_docterm, features = featnames(train_docterm))
  #convert to a data frame
  test_df<-convert(matched_docterm, to = "data.frame")
  #remove the index created by the dfm() function
  test_df<-test_df[, -1]
  #make predictions on the testing data set using the trained classifier
  predictions<-predict(trained, newdata = test_df)
  #create a confusion matrix
  table_results<-table(test$class, predictions)
  #calculate the accuracy
  accuracy<-calculate_accuracy(a=table_results[1,1], b=table_results[1,2], 
                     c=table_results[2,1], d=table_results[2,2])
  return(accuracy)
}

calculate_accuracy<-function(a,b,c,d){
  accuracy<-(a + d) / (a + d + b + c)
  return(accuracy)
}
#main procedure
data<-load_data()
data$combined<-text_preprocessing(data$combined)
folds<-cross_validation(data, k=10)
#use lapply to use each fold as the training data set
cv_results<-lapply(folds, function(fold){
  model<-train(data, fold)
  fold_accuracy<-test(data, fold, model)
  return(fold_accuracy)
})
#the average of the accuracies from the k-fold cross validation
print(mean(unlist(cv_results)))

