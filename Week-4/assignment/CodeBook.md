---
title: "Code Book"
author: "Daniel Perovic"
date: "April 17, 2016"
output: html_document
---

This Code Book outlines details of the resulting data set and the analysis performed to create it.

The data used create the final data set exists in the `UCI HAR Dataset` folder.  Within that folder is a filed called `activity_labels.txt`.  That file is used to create the descriptive activity names that align to the numeric label values for the "test" and "train" subjects.  The `features.txt` file is used to create the variable names for the observations captured for the "test" and "train" subjects.

Within the `UCI HAR Dataset` folder are 2 subfolders, "test" and "train".  The file `X_test.txt` contains all the subject obvservation data.  The `subject_test.txt` file contains the actual subjects (or volunteer ids) for the observation data.  The `y_test.txt` file contains the numeric labels for the activity performed by the subjects.  A similar set of data exists for the "train" subjects.

The data analysis performed was done in the following steps:

1. Enhance and tidy the "test" subjects data.  A descriptive variable called **volunteer_id** was added to indicate the subject in question.  A variabled called **activity** was created to indicate the activity performed by the subjects.
2. Similar to the previous bullet, the same was done for the "train" subjects data.
3. After enhancing and tidying the "test" and "train" data, the resultant data sets were merged into a new data set, containing all the data from both.  The data was then arranged (ordered) by "volunteer_id" ascending.
4. After merging the data, it was subsetted by extracting only the variables that contained "mean" or "std" data.  The "volunteer_id" and "activity" variables were also kept to help understand the data.
5. The final step of analysis grouped the subsetted data by "volunteer_id" and "activity", then determined the "mean" for all the remaining variables, resulting a grouped data set.  This data set is saved to a file called `subset_mean_data.txt`.

```{r}
> head(subset_mean_data, 3)
  volunteer_id activity tBodyAcc.mean...X tBodyAcc.mean...Y tBodyAcc.mean...Z
1            1   LAYING         0.2215982      -0.040513953        -0.1132036
2            1  SITTING         0.2612376      -0.001308288        -0.1045442
3            1 STANDING         0.2789176      -0.016137590        -0.1106018
  tGravityAcc.mean...X tGravityAcc.mean...Y tGravityAcc.mean...Z tBodyAccJerk.mean...X
1           -0.2488818            0.7055498           0.44581772            0.08108653
2            0.8315099            0.2044116           0.33204370            0.07748252
3            0.9429520           -0.2729838           0.01349058            0.07537665
  tBodyAccJerk.mean...Y tBodyAccJerk.mean...Z tBodyGyro.mean...X tBodyGyro.mean...Y
1          0.0038382040           0.010834236        -0.01655309        -0.06448612
2         -0.0006191028          -0.003367792        -0.04535006        -0.09192415
3          0.0079757309          -0.003685250        -0.02398773        -0.05939722
  tBodyGyro.mean...Z tBodyGyroJerk.mean...X tBodyGyroJerk.mean...Y tBodyGyroJerk.mean...Z
1         0.14868944            -0.10727095            -0.04151729            -0.07405012
2         0.06293138            -0.09367938            -0.04021181            -0.04670263
3         0.07480075            -0.09960921            -0.04406279            -0.04895055
  tBodyAccMag.mean.. tGravityAccMag.mean.. tBodyAccJerkMag.mean.. tBodyGyroMag.mean..
1         -0.8419292            -0.8419292             -0.9543963          -0.8747595
2         -0.9485368            -0.9485368             -0.9873642          -0.9308925
3         -0.9842782            -0.9842782             -0.9923678          -0.9764938
  tBodyGyroJerkMag.mean.. fBodyAcc.mean...X fBodyAcc.mean...Y fBodyAcc.mean...Z
1              -0.9634610        -0.9390991        -0.8670652        -0.8826669
2              -0.9919763        -0.9796412        -0.9440846        -0.9591849
3              -0.9949668        -0.9952499        -0.9770708        -0.9852971
  fBodyAccJerk.mean...X fBodyAccJerk.mean...Y fBodyAccJerk.mean...Z fBodyGyro.mean...X
1            -0.9570739            -0.9224626            -0.9480609         -0.8502492
2            -0.9865970            -0.9815795            -0.9860531         -0.9761615
3            -0.9946308            -0.9854187            -0.9907522         -0.9863868
  fBodyGyro.mean...Y fBodyGyro.mean...Z fBodyAccMag.mean.. fBodyBodyAccJerkMag.mean..
1         -0.9521915         -0.9093027         -0.8617676                 -0.9333004
2         -0.9758386         -0.9513155         -0.9477829                 -0.9852621
3         -0.9889845         -0.9807731         -0.9853564                 -0.9925425
  fBodyBodyGyroMag.mean.. fBodyBodyGyroJerkMag.mean.. tBodyAcc.std...X tBodyAcc.std...Y
1              -0.8621902                  -0.9423669       -0.9280565       -0.8368274
2              -0.9584356                  -0.9897975       -0.9772290       -0.9226186
3              -0.9846176                  -0.9948154       -0.9957599       -0.9731901
  tBodyAcc.std...Z tGravityAcc.std...X tGravityAcc.std...Y tGravityAcc.std...Z
1       -0.8260614          -0.8968300          -0.9077200          -0.8523663
2       -0.9395863          -0.9684571          -0.9355171          -0.9490409
3       -0.9797759          -0.9937630          -0.9812260          -0.9763241
  tBodyAccJerk.std...X tBodyAccJerk.std...Y tBodyAccJerk.std...Z tBodyGyro.std...X
1           -0.9584821           -0.9241493           -0.9548551        -0.8735439
2           -0.9864307           -0.9813720           -0.9879108        -0.9772113
3           -0.9946045           -0.9856487           -0.9922512        -0.9871919
  tBodyGyro.std...Y tBodyGyro.std...Z tBodyGyroJerk.std...X tBodyGyroJerk.std...Y
1        -0.9510904        -0.9082847            -0.9186085            -0.9679072
2        -0.9664739        -0.9414259            -0.9917316            -0.9895181
3        -0.9877344        -0.9806456            -0.9929451            -0.9951379
  tBodyGyroJerk.std...Z tBodyAccMag.std.. tGravityAccMag.std.. tBodyAccJerkMag.std..
1            -0.9577902        -0.7951449           -0.7951449            -0.9282456
2            -0.9879358        -0.9270784           -0.9270784            -0.9841200
3            -0.9921085        -0.9819429           -0.9819429            -0.9930962
  tBodyGyroMag.std.. tBodyGyroJerkMag.std.. fBodyAcc.std...X fBodyAcc.std...Y fBodyAcc.std...Z
1         -0.8190102             -0.9358410       -0.9244374       -0.8336256       -0.8128916
2         -0.9345318             -0.9883087       -0.9764123       -0.9172750       -0.9344696
3         -0.9786900             -0.9947332       -0.9960283       -0.9722931       -0.9779373
  fBodyAccJerk.std...X fBodyAccJerk.std...Y fBodyAccJerk.std...Z fBodyGyro.std...X
1           -0.9641607           -0.9322179           -0.9605870        -0.8822965
2           -0.9874930           -0.9825139           -0.9883392        -0.9779042
3           -0.9950738           -0.9870182           -0.9923498        -0.9874971
  fBodyGyro.std...Y fBodyGyro.std...Z fBodyAccMag.std.. fBodyBodyAccJerkMag.std..
1        -0.9512320        -0.9165825        -0.7983009                -0.9218040
2        -0.9623450        -0.9439178        -0.9284448                -0.9816062
3        -0.9871077        -0.9823453        -0.9823138                -0.9925360
  fBodyBodyGyroMag.std.. fBodyBodyGyroJerkMag.std..
1             -0.8243194                 -0.9326607
2             -0.9321984                 -0.9870496
3             -0.9784661                 -0.9946711
```