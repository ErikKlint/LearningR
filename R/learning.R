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


# Save the selected columns as a new data frame
# Recall the style guide for naming objects

nhanes_small <- select(
  NHANES,
  Age,
  Gender,
  BMI,
  Diabetes,
  PhysActive,
  BPSysAve,
  BPDiaAve,
  Education
)


# View the new data frame
nhanes_small



# Fixing variable names ---------------------------------------------------

nhanes_small <- rename_with(
  nhanes_small,
  snakecase::to_snake_case
)


# Renaming gender to sex for a correct term
nhanes_small <- rename(nhanes_small, sex = gender)
nhanes_small


# 7.7 Starting piping exercises  ------------------------------------------


# this
colnames(nhanes_small)


# is the same as this
nhanes_small %>% colnames()

# renaming a specific column using piping
nhanes_small %>%
  select(phys_active) %>%
  rename(physically_active = phys_active)

nhanes_small



# 7.8 testing  information ------------------------------------------------

nhanes_small %>%
  select(bp_sys_ave, education)

nhanes_small %>%
  rename(
    bp_sys = bp_sys_ave,
    bp_dia = bp_dia_ave
  )

# select(nhanes_small, bmi, contains("age")) to pipe

nhanes_small %>%
  select(bmi, contains("age"))

# blood_pressure <- select(nhanes_small, starts_with("bp_"))
# rename(blood_pressure, bp_systolic = bp_sys)


nhanes_small %>%
  select(starts_with("bp_")) %>%
  rename(bp_systolic = bp_sys_ave)


nhanes_small %>%
  select(education) %>%
  levels()



# filtering rows ----------------------------------------------------------

nhanes_small %>%
  filter(phys_active != "No")

nhanes_small %>%
  filter(
    bmi == 25,
    phys_active != "No"
  )

# is the same as:

nhanes_small %>%
  filter(bmi == 25 &
    phys_active != "No")

nhanes_small %>%
  filter(bmi == 25 |
    phys_active == "No")



# Arranging rows ----------------------------------------------------------


nhanes_small %>%
  arrange(desc(age))


nhanes_small %>%
  arrange(desc(age), bmi, education)


# Mutating columns --------------------------------------------------------


nhanes_update <- nhanes_small %>%
  mutate(
    age_month = age * 12,
    logged_bmi = log(bmi),
    age_weeks = age_month * 4,
    old = if_else(
      age >= 30,
      "old",
      "young"
    )
  )



# 7.12 Exercise  ----------------------------------------------------------

nhanes_small
# 1. BMI between 20 and 40 with diabetes
nhanes_small %>%
  # Format should follow: variable >= number or character
  filter(bmi >= 20 & bmi <= 40 & diabetes == "Yes")

# Pipe the data into mutate function and:
nhanes_modified <- nhanes_small %>% # Specifying dataset
  mutate(
    # 2. Calculate mean arterial pressure
    mean_arterial_pressure = ((2 * bp_dia_ave) + bp_sys_ave) / 3,
    # 3. Create young_child variable using a condition
    young_child = if_else(age < 6, "Yes", "No")
  )

nhanes_modified


# 7.14 Calculating summary statistics -------------------------------------

nhanes_small %>%
  summarise(max_bmi = max(bmi))

# you get NA, since contain NA values!

# exclude NA-values
nhanes_small %>%
  summarise(max_bmi = max(bmi, na.rm = TRUE))

# exclude and have many summaries
nhanes_small %>%
  filter(
    !is.na(diabetes),
    !is.na(phys_active)
  ) %>%
  group_by(
    diabetes,
    phys_active
  ) %>%
  summarise(
    max_bmi = max(bmi, na.rm = TRUE),
    min_bmi = min(bmi, na.rm = TRUE)
  ) %>%
ungroup()



# 7.15  Exercise: Calculate some basic statistics -------------------------

# 1.
nhanes_small %>%
  summarise(
    mean_bp_sys = mean(bp_sys_ave, na.rm = TRUE),
    mean_age = mean(age, na.rm = TRUE)
  )

str(nhanes_small)

# 2.
nhanes_small %>%
  summarise(
    max_bp_dia = max(bp_dia_ave, na.rm = TRUE),
    min_bp_dia = min(bp_dia_ave, na.rm = TRUE)
  )


# save dataset ------------------------------------------------------------

write_csv(
  nhanes_small,
  here::here("data/nhanes_small.csv")
)






