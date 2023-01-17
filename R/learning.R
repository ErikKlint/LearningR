# Chapter 7: Data management and wrangling

#  Packages ---------------------------------------------------------------
library(tidyverse)
library(NHANES)


# Initial analyze ---------------------------------------------------------

# Briefly glimpse contents of dataset
glimpse(NHANES)
str(NHANES)
colnames(NHANES)

# Select one column by its name, without quotes
select(NHANES, Age)

# Select two or more columns by name, without quotes
select(NHANES, Age, Weight, BMI)

# To *exclude* a column, use minus (-)
select(NHANES, -HeadCirc, -Gender)

# All columns starting with letters "BP" (blood pressure)
select(NHANES, starts_with("BP"))

# All columns ending in letters "Day"
select(NHANES, ends_with("Day"))

# All columns containing letters "Age"
select(NHANES, contains("Age"))



