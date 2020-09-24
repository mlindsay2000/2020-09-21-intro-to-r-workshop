#####################
# MANIPULATING DATA #
#       using       #
#     TIDYVERSE     #
#####################
#
#
# Based on: https://datacarpentry.org/R-ecology-lesson/03-dplyr.html

# Data is available from the following link (we should already have it)
download.file(url = "https://ndownloader.figshare.com/files/2292169",
              destfile = "data_raw/portal_data_joined.csv")

#---------------------
# Learning Objectives
#---------------------

#    Describe the purpose of the dplyr and tidyr packages.
#    Select certain columns in a data frame with the dplyr function select.
#    Select certain rows in a data frame according to filtering conditions with the dplyr function filter .
#    Link the output of one dplyr function to the input of another function with the ‘pipe’ operator %>%.
#    Add new columns to a data frame that are functions of existing columns with mutate.
#    Use the split-apply-combine concept for data analysis.
#    Use summarize, group_by, and count to split a data frame into groups of observations, apply summary statistics for each group, and then combine the results.
#    Describe the concept of a wide and a long table format and for which purpose those formats are useful.
#    Describe what key-value pairs are.
#    Reshape a data frame from long to wide format and back with the pivit_wider and pivit_longer commands from the tidyr package.
#    Export a data frame to a .csv file.
#----------------------

#------------------
# Lets get started!
#------------------
# ML - need to load tidyverse
install.packages("tidyverse")
library(tidyverse)
# dplyr and tidyr

# now load the dataset
surveys <- read_csv("data_raw/portal_data_joined.csv")

# check structure
str(surveys)


#-----------------------------------
# Selecting columns & filtering rows
#-----------------------------------

select(surveys, plot_id, species_id, weight)

# no select all the columns BUT not record_id and species_id

select(surveys, -record_id, -species_id)

# filter for a particular year

filter(surveys, year == 1995)

#  you can name the filtered data

surveys_1995 <- filter(surveys, year == 1995)

# and some more

surveys2 <- filter(surveys, weight < 5)
surveys_sml <- select(surveys2, species_id, sex, weight)
# or in one line
surveys_sml <- select(filter(surveys, weight < 5), species_id, sex, weight)


#-------
# Pipes
#-------

# The pipe --> %>%
# Shortcut --> Ctrl + shift = m

surveys %>%
  filter(weight < 5) %>%
  select(species_id, sex, weight)

surveys_sml <- surveys %>%
  filter(weight < 5) %>%
  select(species_id, sex, weight)




#-----------
# CHALLENGE
#-----------

# Using pipes, subset the ```surveys``` data to include animals collected before 1995 and 
# retain only the columns ```year```, ```sex```, and ```weight```.

surveys %>%
  select(year, sex, weight) %>% 
  filter(year < 1995)

#  you can name this if you want

surveys_1995 <- surveys %>%
  select(year, sex, weight) %>%    #  the order of your variables will be replicated in the dataframe
  filter(year < 1995)

#--------
# Mutate
#--------

# handy if you want to convert one column into another and keep the original column

surveys %>% 
  mutate(weight_kg = weight / 1000)

# now we can create more than one new var in same command

surveys %>% 
  mutate(weight_kg = weight / 1000,
         weight_lb = weight_kg / 2.2)
# to save this as a new dataframe

surveys_weights <- surveys %>% 
  mutate(weight_kg = weight / 1000,
         weight_lb = weight_kg / 2.2)

# to check this data

surveys %>% 
  mutate(weight_kg = weight / 1000,
         weight_lb = weight_kg / 2.2) %>% 
  head()

surveys %>% 
  mutate(weight_kg = weight / 1000,
         weight_lb = weight_kg / 2.2) %>% 
  tail()

# now filter out the NAs

surveys %>% 
  filter(!is.na(weight)) %>% 
  mutate(weight_kg = weight / 10000) %>% 
  head(20)


#-----------
# CHALLENGE
#-----------

# Create a new data frame from the ```surveys``` data that meets the following criteria: 
# 1. contains only the ```species_id``` column and a new column called ```hindfoot_cm``` containing 
# the ```hindfoot_length``` values converted to centimeters. In this hindfoot_cm column, 
# there are no ```NA```s and all values are less than 3.

# Hint: think about how the commands should be ordered to produce this data frame!


surveys_foot_len <- surveys %>% 
  mutate(hindfoot_cm = hindfoot_length / 10) %>% 
  filter(!is.na(hindfoot_cm), hindfoot_cm < 3) %>% 
  select(species_id, hindfoot_cm)

# REMINDER - ALL THE ABOVE IS DONE WITH TIDYVERSE PACKAGE


#---------------------
# Split-apply-combine
#---------------------

# say we want to group some elements of our data

surveys %>% 
  group_by(sex) %>% 
  summarise(mean_weight = mean(weight))

# BUT IF WE WANT TO REMOVE THE NAs before averaging

surveys %>% 
  group_by(sex) %>% 
  summarise(mean_weight = mean(weight, na.rm = TRUE))

summary(surveys)

# to find help for summarise function 
?summarise

# when you're running multiple packages that have the same function you can identify which of the 
# packages you want it to use by putting the package name then '::' before the name of the function
# e.g. dplyr::group_by(sex)

# now let's check the data again
str(surveys)

# what if we want the variable 'sex' as a data type factor instead of character

surveys$sex <- as.factor(surveys$sex)
str(surveys)

surveys %>% 
  filter(!is.na(weight)) %>% 
  group_by(sex, species_id) %>% 
  summarise(mean_weight = mean(weight)) %>% 
  tail()

# but what if we also want to get rid of the NAs in 'sex'

surveys %>% 
  filter(!is.na(weight), !is.na(sex)) %>% 
  group_by(sex, species_id) %>% 
  summarise(mean_weight = mean(weight)) %>% 
  tail()

# to see the top 20 obs we could end the above code with 'print(20) instead of 'head()' or 'tail()'

# Evan thinks there may be a way to get rid of the NAs in ALL of the variables - he's going to get back to us on that
# look at the complete.cases()  function   for help type ?complete.cases()

# if you want to order the data by a particular variable. The code below will sort by min_weight, a variable that is also 
# created in the code
surveys %>% 
  filter(!is.na(weight), !is.na(sex)) %>% 
  group_by(sex, species_id) %>% 
  summarise(mean_weight = mean(weight),
            min_weight = min(weight)) %>% 
  arrange(min_weight)

# to put it onto decending order
# ANSWER:  wrap the var in a desc(), as follows:

surveys %>% 
  filter(!is.na(weight), !is.na(sex)) %>% 
  group_by(sex, species_id) %>% 
  summarise(mean_weight = mean(weight),
            min_weight = min(weight)) %>% 
  arrange(desc(min_weight))

# ANSWER: or put a neg sign in front of the var, as follows:
surveys %>% 
  filter(!is.na(weight), !is.na(sex)) %>% 
  group_by(sex, species_id) %>% 
  summarise(mean_weight = mean(weight),
            min_weight = min(weight)) %>% 
  arrange(-min_weight)

# now the count function

surveys %>% 
  count(sex)

surveys %>% 
  group_by(sex) %>% 
  summarise(count = n())

# what about grouping by multiple vars? NOTE: order does matter
surveys %>% 
  group_by(sex,species, taxa) %>% 
  summarise(count = n())

# what about UNgrouping

surveys_new <- surveys %>% 
  group_by(sex,species, taxa) %>% 
  summarise(count = n())

str(surveys_new)


#-----------
# CHALLENGE
#-----------

# 1. How many animals were caught in each ```plot_type``` surveyed?

# 2. Use ```group_by()``` and ```summarize()``` to find the mean, min, and max hindfoot length 
#    for each species (using ```species_id```). Also add the number of observations 
#    (hint: see ```?n```).

# 3. What was the heaviest animal measured in each year? 
#    Return the columns ```year```, ```genus```, ```species_id```, and ```weight```.

#1
surveys %>% 
  count(plot_type)
#2
surveys %>% 
  filter(!is.na(hindfoot_length)) %>% 
  group_by(species_id) %>% 
  summarise(mean_hindfoot_length = mean(hindfoot_length),
            mean_hindfoot_length = min(hindfoot_length),
            max_hindfoot_length = max(hindfoot_length), 
            count = n())
#3
heaviest_year <- surveys %>% 
  group_by(year) %>% 
  select(year, genus, species_id, weight) %>% 
  mutate(max_weight = max(weight, na.rm = TRUE)) %>% 
  ungroup()




#-----------
# Reshaping
#-----------







#-----------
# CHALLENGE
#-----------

# 1. Spread the surveys data frame with year as columns, plot_id as rows, 
#    and the number of genera per plot as the values. You will need to summarize before reshaping, 
#    and use the function n_distinct() to get the number of unique genera within a particular chunk of data. 
#    It’s a powerful function! See ?n_distinct for more.

# 2. Now take that data frame and pivot_longer() it again, so each row is a unique plot_id by year combination.

# 3. The surveys data set has two measurement columns: hindfoot_length and weight. 
#    This makes it difficult to do things like look at the relationship between mean values of each 
#    measurement per year in different plot types. Let’s walk through a common solution for this type of problem. 
#    First, use pivot_longer() to create a dataset where we have a key column called measurement and a value column that 
#    takes on the value of either hindfoot_length or weight. 
#    Hint: You’ll need to specify which columns are being pivoted.

# 4. With this new data set, calculate the average of each measurement in each year for each different plot_type. 
#    Then pivot_wider() them into a data set with a column for hindfoot_length and weight. 
#    Hint: You only need to specify the key and value columns for pivot_wider().





#----------------
# Exporting data
#----------------












