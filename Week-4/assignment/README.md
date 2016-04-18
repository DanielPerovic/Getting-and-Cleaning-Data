---
title: "README"
author: "Daniel Perovic"
date: "April 17, 2016"
output: html_document
---

The **run_analysis.R** contains a series of functions to produce the final data set.  The main function is called `create_analysis_data()`.  It will produce the grouped data frame as well as a file called **subset_mean_data.txt**.

In order to run the script successfully, the provided data must reside under the working directory of the **run_analysis.R** script.  Therefore, the first folder in the working directory would be: `./UCI HAR Dataset`.  After you source the script, simply run it by typing:

```{r}
create_analysis_data()
```
