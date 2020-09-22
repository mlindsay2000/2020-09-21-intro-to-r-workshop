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
surveys[,6]       # if you leave out the number of rows it will give you all of them

# first column of the data frame (as a data frame)
surveys[1]        # notice no comma, which results in you getting a dataframe as opposed to a vector

# first row (as a data frame)
surveys[1,]       # notice that this doesn't output as a vector cause all the 
#    peices of info are different data types, The output is actually a dataframe

# first three elements in the 7th column (as a vector)
surveys[1:3,7]

# the 3rd row of the data frame (as a data.frame)
surveys[3,] 

# equivalent to head(surveys)
head(surveys)
surveys[1:6,]
# looking at the 1:6 more closely
1:6               #  it is a range that includes the numbers you start with and finish with
surveys[c(1,2,3,4,5,6),]         #    this gives you the same as head()
# we also use other objects to specify the range

rows <- 6
surveys[1:rows,3]

#
# Challenge: Using slicing, see if you can produce the same result as:
#
#   tail(surveys)
#
# i.e., print just last 6 rows of the surveys dataframe
#
# Solution:
nrow(surveys)
surveys[34781:34786,]
surveys[34781:nrow(surveys),]
surveys[(nrow(surveys)-6):nrow(surveys),]     # but this gives 7 rows cause it includes the first and last
surveys[(nrow(surveys)-5):nrow(surveys),]     # this gives 6 rows

length(surveys)
length(surveys[1])
length(surveys[,1])

# We can omit (leave out) columns using '-'

surveys[-1]                  #  gives us the whole dataframe except the first column
surveys[c(-1,-2,-3)]                  #  gives us the whole dataframe except the first three column
head(surveys[c(-1,-2,-3)])            # wrapping it in head() makes the output neater
head(surveys[-(1:3)])                 # can also use range
# column "names" can be used in place of the column numbers
head(surveys[2])                 # this uses column number
head(surveys["month"])           # produces the same with column names


#
# Topic: Factors (for categorical data)
#   ML - e.g. they are not continuous
#   Rankings: low, medium, high
#   gender

gender <- c("male","male","female")           # but this creates a vector of character stings, so use
gender <- factor(c("male","male","female"))      # which creates a factor
gender

class(gender)
levels(gender)
nlevels(gender)
# factors have an order
# ML - such as low, medium, high

temperature <- factor (c("hot","cold","hot","warm"))
temperature[1]
temperature[4]
levels(temperature)

# level order automatically in alphabetical order, BUT WE CAN SPECIFY AN ALTERNATIVE
temperature <- factor (c("hot","cold","hot","warm"),
                      level = c("cold","warm","hot"))
levels(temperature)

# Converting factors
#  can take an object and turn it in to a different object
as.numeric(temperature)
as.character(temperature)

# can be tricky if the levels are numbers
year <- factor(c(1970,1985,1965,1970))
year
as.numeric(year)
as.character(year)
as.numeric(as.character(year))

# so does our survey data have any factors

str(surveys)

# it turns out that quite a few of the variables are factors
# this happened automatically when the data was being transferred into R
# this can be avoided in some circumstances

# Topic:  Dealing with Dates
#  ML - can be a nightmare. There are in built solutions, but there are also 'Packages'
#  that contributors have developed to help address some issues that arise when dealing with dates
#  these can be installed using the library function



# R has a whole library for dealing with dates ...
library(lubridate)

my_date <- ymd("2015-01-01")        # ymd is a function that comes from lubridate
class(my_date)
# I want date in this format date: 7-16-1977 which will involve pasting 3 columns in some way
# R can concatenated things together using paste()

paste("abc","123","xyz")
paste("abc","123","xyz", sep ="+")
paste("abc","123","xyz", sep ="-")
paste("2015","01","26", sep ="-")
ymd(paste("2015","01","26", sep ="-"))
my_date <- ymd(paste("2015","01","26", sep ="-"))
class(my_date)

# 'sep' indicates the character to use to separate each component


# paste() also works for entire columns
surveys[,2]
surveys$month
head(surveys[,2])
head(surveys$month)
paste(surveys$year,surveys$month,surveys$day, sep ="-")
ymd(paste(surveys$year,surveys$month,surveys$day, sep ="-"))
# typing in the name of the dataframe and then '$' will then present you with a list of the variable names
#  which you can choose from
# let's save the dates in a new column of our dataframe surveys$date 
surveys$date <- ymd(paste(surveys$year,
                          surveys$month,
                          surveys$day, sep ="-"))
#  surveys$date creates a new variable called 'date'

View(surveys)
# and ask summary() to summarise 
summary(surveys)

# but what about the "Warning: 129 failed to parse"

# some data cannot be converted to date

summary(surveys$date)
# output showed that there are 129 NAs in the data column
# so how do we find them?

is.na(surveys$date)           #  but this is a bit tedious
missing_date <- is.na(surveys$date)           
missing_date <- surveys[is.na(surveys$date),"date"]
missing_date
# but we also want to know what the inputs for the date look 
#  like so we can try to find out why date is 'NA'
missing_date <- surveys[is.na(surveys$date),c("date","year","month","day")]
missing_date
missing_date <- surveys[is.na(surveys$date),c("year","month","day")]
missing_date
summary(missing_date)

# problem is that some dates are shown as 31st day of months that only have 30 days

# then to try to find each of the actual observations I would ask for record_id as well

missing_date <- surveys[is.na(surveys$date),c("record_id",year","month","day")]
missing_date
summary(missing_date)


today <- ymd("2020-09-22")
yesterday <- ymd("2020-09-21")
today - yesterday

boc <- ymd("0000-12-25")
today - boc
