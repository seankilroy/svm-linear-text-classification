# svm-linear-text-classification

## Overview

  This web mining project utilizes both text classification and Support Vector Machines. Text classification techniques used in this project include building a corpus, text tokenization, stem word removal, and document term matrices. The classifier will be Support Vector Machines with the linear kernel. 
The project seeks to predict if news articles are fake. A Pew Research Center poll from 2016 showed that 88% of Americans think fake news is causing either a great amount or some amount of confusion about current events. By using the techniques outlined in this project document, I think machine learning can help in the fight against fake news. 
To demonstrate the feasibility of this idea, the project uses the title, not the larger full text, of each article fed through a text preprocessing routine and then fed into the SVM Linear classifier. The title is used over the full text for a few reasons:
* Processing the title is cheaper and faster.
* While the data set always presents the full article text, in the real world, many news articles are hidden behind paywalls. Their titles are typically always available though. 

## Libraries

The code uses the following R Programming libraries:

* caret: https://cran.r-project.org/web/packages/caret/index.html
* quanteda: https://cran.r-project.org/web/packages/quanteda/index.html
* e1071: https://cran.r-project.org/web/packages/e1071/index.html

## Functions

```load_data()```
1. Reads the CSV file into a data frame.
2. Concatenates the Title and Subject attributes.
3. Reorders the data frame so that the Class column is at the end.

```text_preprocessing(data)```
* data = the text column from the data frame that is to be tokenized.
1. Creates a corpus.
2. Removes punctuation, numbers, and English stop words.

```cross_validation(data, k)```
* data = the data frame containing the tokenized text
* k = the number of folds used for the cross validation
1. Returns k sets of indices to be used to split the data frame.

```train(data, fold)```
* data = the data frame containing the tokenized text
*	fold = set of generated indices 
1. Creates the training data set by using a fold.
2. Creates a document term matrix.
3. Converts the document term matrix into a data frame
4. Removes the indexing column added by the document term matrix process.
5. Trains the Support Vector Machines model with Linear kernel.

```test(data, fold, trained)```
*	data =  the data frame containing the tokenized text
*	fold = set of generated indices 
*	trained = the model trained via SVM Linear kernel.
1. Creates the testing data set by using all unused folds from the training set.
2. Creates a document term matrix.
3. Matches the document term matrix to the training document term matrix.
4. Converts the document term matrix to a data frame.
5. Removes the indexing column added by the document term matrix process.
6. Makes predictions using the trained model and the testing data.
7. Returns the accuracy of the model.

```calculate_accuracy(a, b, c, d)```
	a = True Positives
	b = False Positives
	c = False Negatives
	d = True Negatives
Calculates the accuracy of the predictions using Accuracy = (TP + TN) / (TP + TN + FP + FN)

