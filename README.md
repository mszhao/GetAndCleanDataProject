---
title: "README"
author: "mzhao"
date: "Thursday, April 23, 2015"
output: html_document
---

"run_analysis.R" is to read the test and train data which store the 651 features of measurement on 6 kinds of activities performed by 30 subjects. The data are in txt files. 
The train and test data will be merged as one dataset and the mean and std measurements will be extracted from it. The extracted data will be properly labeled and reshaped. The result dataset is a new dataset with the average value of each extracted measurement for every subject and every activity.

The new dataset is then written to a txt file.