library(readr)
df_01 <- read_csv("data/202105-divvy-tripdata.csv")
View(df)
library(tidyverse)
library(skimr)
library(dplyr)
# read all the csv files into a list and then create a list of data frames from them
filenames <- list.files(path="data")
print(filenames)
setwd("data")
filelist <- lapply(filenames, read.csv)
print(length(filelist))
names(filelist) <- c("df_05_21","df_06_21","df_07_21","df_08_21","df_09_21","df_10_21","df_11_21","df_12_21","df_01_22","df_02_22","df_03_22","df_04_22")
# create overviews and summaries of all data frames to get a first impression
for (i in 1:length(filelist)) {
  glimpse(filelist[[i]])
  #skim(filelist[[i]]) # I have no idea why, but skim does not seem to work in loop.
}
# skim each df manually, because it does not seem to work in a loop (I don't manage to find out why:( ))
skim(filelist[1])
skim(filelist[2])
skim(filelist[3])
skim(filelist[4])
skim(filelist[5])
skim(filelist[6])
skim(filelist[7])
skim(filelist[8])
skim(filelist[9])
skim(filelist[10])
skim(filelist[11])
skim(filelist[12])

# make one combined data frame from all the data frames
df_all <- bind_rows(filelist, .id = "column_label")
glimpse(df_all)
skim(df_all)

for (i in 1:length(filelist)) {
  print(dim(filelist[[i]]))
}

# DATA CLEANING
### reply later on: Why did you make the changes that you did? How did you do them? What version of the raw data did you use?
### and make a nice markdown document from it for documentation!

## back up original data
### no need to do this, because I'm not directly working with the files. But when I save the dataframes to files, 
### I'll have to save them to a new one

# make new df for cleaned / wip version
df_all_clean <- df_all

## check for missing values and decide how to deal with them
skim(df_all_clean)
## there are 4766 missing values for end_lat and end_long each. There are also empty strings
## in other columns (but not NA): start_station_name (790,207), start_station_id (790,204),
## end_station_name (843,361), and end_station_id (843,361)

## check for duplicates
### the output from skim() contains a n_unique column. It states that there are 5,757,551 unique ride ids,
### which equals the number of rows. Thus, there seem to be no duplicates, assuming that the ride id is trustworthy

## removing extra spaces and blanks
df_all_clean <- trimws(df_all_clean, "both") # did not end up doing this because the function did not finish in a reasonable amout of time

## check for irrelevant data
### there are not many columns, and I would not judge any of them as irrelevant per se. Those columns with many
### missing values could be judged to be less relevant, because they are not complete. However, those rows that
### have no missing values in these columns could still give insights. So I'd not remove any data at this point.
### Moreover, I downloaded only data from the last 12 months, so there is no old data in my dataset that could
### be irrelevant.

## are the columns named meaningfully?
colnames(df_all_clean) # yes

## are strings consistent and meaningful? check if there are spelling errors or formatting issues.
### for 'factors': I looked at possible values of 'rideable_type' and 'member_casual" and counted their occurrences.
### this seems to be correct.
df_all %>%  count(rideable_type)
unique(df_all$rideable_type)
df_all %>% count(member_casual)
unique(df_all$member_casual)
### the ride ids equal the number of rows, and the sample I checked seemed to be formatted reasonably
### For the rest, I also checked a sample manually. The station ids seem to have two different formats. 
### The station names seem to look reasonably formatted, but I'm not an expert on the area and its naming conventions.

## check for misfielded values
### I only looked at a subset but that looks fine.

## check for mismatched data types
### the only datatypes used are character and numeric. Those columns that have a small, distinct numbers of values
### should be transformed into 'factor', start and end times to 'datetime'
df_all_clean["member_casual"] <- as.factor(df_all_clean["member_casual"]) # didn't do for now because it took long and returned NA, TODO: find out why
df_all_clean["rideable_type"] <- as.factor(df_all_clean["rideable_type"]) # see above. Also: do I really need to transform chr to factor?
df_all_clean$started_at <- as.POSIXct(df_all_clean$started_at, format="%Y-%m-%d %H:%M:%S") #2021-05-25 17:28:11
df_all_clean$ended_at <- as.POSIXct(df_all_clean$ended_at, format="%Y-%m-%d %H:%M:%S")
glimpse(df_all_clean)

# create new column ride length
df_all_clean$ride_length <- df_all_clean$ended_at - df_all_clean$started_at
## format from seconds to dd:hh:mm:ss
library(lubridate)
df_all_clean$ride_length_period <- seconds_to_period(df_all_clean$ride_length) 
glimpse(df_all_clean)

# create day of week column for start date
df_all_clean$day_of_week <- weekdays(df_all_clean$started_at)

## check for data irregularities (invalid values or outliers)
summary(df_all_clean)
## there are outliers in the "ride_length_period" column:  Min.   :-58M -2S,
## Max.   :38d 20H 24M 9S. I will check them manually by sorting
df_sorted <- arrange(df_all_clean, ride_length_period)
View(df_sorted)
head(df_all_clean)
df_all_clean$ride_length_num <- as.numeric(df_all_clean$ride_length)
glimpse(df_all_clean)
print(sum(df_all_clean$ride_length_period < 0, na.rm = TRUE))
View(df_all_clean)
# there are 140 minus values. I should drop them when I work with them later on.
# there are also rides with a duration of 0s (512) or a few s. In a real-world scenario, I would ask the stakeholders
# what this could mean and if they want to keep the data. I would ask them if they know what could have caused this
# In this fictional case I will only remove the negative rides. 
print(sum(df_all_clean$ride_length_period == 0, na.rm = TRUE))

# i'm wondering why the skim method did not show me the missing values for start and end before. Now it shows.
skim(df_all_clean)

# remove all rows that have negative or missing values for ride length
df_all_no_na <- subset(df_all_clean, (!is.na(df_all_clean["ride_length"])))
df_all_no_neg <- subset(df_all_no_na, df_all_no_na["ride_length"]>= 0)
glimpse(df_all_no_neg)
skim(df_all_no_neg)

## save to csv for storage / for later
getwd()
write.csv(df_all_clean, "../output-data/allbikedata-clean.csv", row.names = FALSE)
write.csv(df_all_no_na, "../output-data/allbikedata-clean_onlyvalidridelength.csv", row.names = FALSE)
