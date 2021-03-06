#################################
### FRE7241 HW #1 due Sep 22, 2015
#################################
# Max score 55 pts

# Please write in this file the R code needed to perform the tasks below, 
# rename it to your_name_hw1.R
# and upload the file to NYU Classes


##################################
# 1. (15pts) create a vector of weekly "POSIXct" dates corresponding  
# to Mondays at 09:30AM, and call it "mon_days", 
# start with the date "2015-02-09", and end at the most recent Monday
# before today (today is defined by Sys.time()),
# set the timezone to "America/New_York", 
# hint: first calculate the number of weeks between today and the start 
# date, and use that number to create a vector of weekly "POSIXct" dates,
# you can use functions Sys.setenv(), as.POSIXct(), difftime() and ceiling(), 
# and lubridate function weeks(),

### write your code here


# convert "mon_days" to the days of the week, using three different methods,
# to verify that all the dates in "mon_days" are indeed Mondays,
# use function weekdays(),

### write your code here

# use function as.POSIXlt(),

### write your code here

# use lubridate function wday(),

### write your code here



###############
# 2. (20pts) Download from Yahoo the "AdjClose" prices and "Volume" for 
# MSFT stock, starting from Jun/01/2007, and call it "zoo_msft",
# use tseries function get.hist.quote(),

library(tseries)  # load package tseries
library(zoo)  # load package zoo

### write your code here


# calculate the 50-day moving average of the "AdjClose" prices,
# merge the moving average with "zoo_msft" by adding it as the last column,
# rename the last column to "50DMA",
# use function rollmean(), with the proper "align" argument, 
# so that the averages are calculated using values from the past,

### write your code here


# plot "zoo_msft" columns "AdjClose" and "50DMA" in the same panel, 
# starting from "2015-01-01",
# use method plot.zoo() with the proper argument "plot.type",
# add legend so that it doesn't obscure the plot,

### write your code here


# calculate the vector of dates when zoo_msft[, "AdjClose"] 
# crosses "50DMA", and call it "cross_es", 
# "cross_es" should be TRUE for dates when a cross had just occurred, 
# and FALSE otherwise,

### write your code here


# add vertical ablines to the plot above, at the dates of "cross_es",

### write your code here



###############
# 3. (20pts) Calculate the 50-day rolling maximum and minimum of 
# the "AdjClose" prices,
# use function rollmax() with the proper "align" argument, so that 
# the aggregations are calculated using values from the past,
# calculate the difference between the rolling maximum and minimum, 
# and call it "ba_nd",

### write your code here


# calculate the rolling upper (lower) band as the moving average
# plus (minus) one half of "ba_nd",
# merge the rolling upper and lower bands with "zoo_msft" by adding 
# them as the last columns,
# rename the last columns to "Up_band" and "Low_band",
# remove rows with NAs using function na.omit(), 

### write your code here


# plot "zoo_msft" columns "AdjClose", "Up_band", and "Low_band" in the 
# same panel, starting from "2015-01-01",
# use method plot.zoo() with the proper argument "plot.type",
# add legend so that it doesn't obscure the plot,

### write your code here


# calculate the vector of dates when zoo_msft[, "AdjClose"] 
# crosses any of the bands, and call it "cross_es", 
# "cross_es" should be TRUE for dates when a cross had just occurred, 
# and FALSE otherwise,

### write your code here


# add vertical ablines to the plot above, at the dates of "cross_es",

### write your code here


