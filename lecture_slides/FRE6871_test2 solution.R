#################################
### FRE6871 Test #2 Solutions Oct 5, 2015
#################################
# Max score 60pts

# The below solutions are examples,
# Slightly different solutions are also possible.


############## Part I
# 1. (20pts) Create the character string "y = x1 + x2 - x3 - x4" from 
# characters "x", "y", "=", "+", and the vectors 1:2 and 2:4, using 
# the functions paste0() and paste() with a collapse string,
# You can also use these characters with spaces around them, say " x ",
# hint: you must call paste0() and paste() several times and nest them, 

paste("y", "=", 
      paste(
        paste(paste0("x", 1:2), collapse=" + "), 
        paste(paste0("x", 3:4), collapse=" - "), 
        sep=" - "))



############## Part II
# Summary: create a wrapper for function sum(), 
# 
# 1. (20pts) Create a wrapper for function sum(), called my_sum(). 
# The function my_sum() should be able to accept an indefinite number 
# of arguments, and pass them to the dots "..." argument of function sum().
# The function my_sum() should also accept an argument called "na.rm", 
# with default value TRUE, and pass its value to the "na.rm" argument of 
# function sum(). 

my_sum <- function(..., na.rm=TRUE) {
  sum(..., na.rm=na.rm)
}  # end my_sum

# call my_sum() as follows, to verify that it works correctly:

my_sum(1, 2, 3, NA)



############## Part III
# Summary: create a function that calculates a contingency table 
# for a single vector or factor, similar to function table(). 
# 
# 1. (20pts) Create a function that calculates a contingency table 
# and call it ta_ble(). 
# ta_ble() should accept a single argument, and calculate and return
# a named vector containing the number of times an element occurs in 
# the input argument.  The order of the elements is not important.  
# The names should be the elements of the input argument. 
# you can't use function table(), 
# you can use functions sapply(), unique(), sum(), and an anonymous function,

ta_ble <- function(in_put) {
  sapply(unique(in_put), 
         function(le_vel) {
           sum(in_put==le_vel)
         }) # end sapply
}  # end ta_ble

# call ta_ble() as follows, to verify that it works correctly:

vec_tor <- sample(c("a", "b", "c", "d"), size=10, replace=TRUE)
ta_ble(vec_tor)
table(vec_tor)

