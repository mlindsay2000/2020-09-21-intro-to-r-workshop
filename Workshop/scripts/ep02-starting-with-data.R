#   _____ _             _   _                        _ _   _       _____        _        
#  / ____| |           | | (_)                      (_| | | |     |  __ \      | |       
# | (___ | |_ __ _ _ __| |_ _ _ __   __ _  __      ___| |_| |__   | |  | | __ _| |_ __ _ 
#  \___ \| __/ _` | '__| __| | '_ \ / _` | \ \ /\ / | | __| '_ \  | |  | |/ _` | __/ _` |
#  ____) | || (_| | |  | |_| | | | | (_| |  \ V  V /| | |_| | | | | |__| | (_| | || (_| |
# |_____/ \__\__,_|_|   \__|_|_| |_|\__, |   \_/\_/ |_|\__|_| |_| |_____/ \__,_|\__\__,_|
#                                    __/ |                                               
#                                   |___/                                                
#
# Based on: https://datacarpentry.org/R-ecology-lesson/02-starting-with-data.html



# Lets download some data (make sure the data folder exists)
download.file(url = "https://ndownloader.figshare.com/files/2292169",
              destfile = "data_raw/portal_data_joined.csv")

# now we will read this "csv" into an R object called "surveys"
surveys <- read.csv("data_raw/portal_data_joined.csv")

# and take a look at it

surveys
head(surveys)           # gives first six rows
View(surveys)           # this is a R Studio command (as opposed to R)

# BTW, we assumed our data was comma separated, however this might not
# always be the case. So we may been to tell read.csv more about our file.



# So what kind of an R object is "surveys" ?

class(surveys)            #  answer is "data.frame"

# ok - so what are dataframes ?

str(surveys)       # this gives us the structure of the dataframe
                   # a factor is a way of recording elements - will cover this later today
dim(surveys)       # tells us the dimension of the dataframe
nrow(surveys)       # tells us the number of rows in the dataframe
ncol(surveys)       # tells us the number of rows in the dataframe
tail(surveys)       # gives last six rows (opposite to head())
tail(surveys,2)       # gives last two rows 
names(surveys)       # gives us the names of the columns
rownames(surveys)       # gives us the names of the rows
summary(surveys)       # will produce some statistics that may or may not be useful

# --------
# Exercise
# --------
#
# What is the class of the object surveys?
#
# Answer: data.frame


# How many rows and how many columns are in this survey ?
#
# Answer:  34786 x 13

# What's the average weight of survey animals
#
#
# Answer: 42.67   can be found in      summary(surveys)  

# Are there more Birds than Rodents ?
#
#
# Answer:   no


# 
# Topic: Sub-setting
#

# first element in the first column of the data frame (as a vector)
surveys[1,1]                 # note SQUARE BRACKETS

# first element in the 6th column (as a vector)
surveys[1,6]  

# first column of the data frame (as a vector)
surveys[,6]  

# first column of the data frame (as a data frame)


# first row (as a data frame)


# first three elements in the 7th column (as a vector)


# the 3rd row of the data frame (as a data.frame)


# equivalent to head(metadata)


# looking at the 1:6 more closely


# we also use other objects to specify the range



#
# Challenge: Using slicing, see if you can produce the same result as:
#
#   tail(surveys)
#
# i.e., print just last 6 rows of the surveys dataframe
#
# Solution:



# We can omit (leave out) columns using '-'



# column "names" can be used in place of the column numbers



#
# Topic: Factors (for categorical data)
#


# factors have an order


# Converting factors


# can be tricky if the levels are numbers


# so does our survey data have any factors


#
# Topic:  Dealing with Dates
#

# R has a whole library for dealing with dates ...



# R can concatenated things together using paste()


# 'sep' indicates the character to use to separate each component


# paste() also works for entire columns


# let's save the dates in a new column of our dataframe surveys$date 


# and ask summary() to summarise 


# but what about the "Warning: 129 failed to parse"


