# ANALYZE

## data is already formatted, organized, and merged into one file from the last step.

## read merged file from summary csv created in last step
getwd()
library(readr)
library(tidyverse)
df <- read_csv("output-data/allbikedata-clean_onlyvalidridelength.csv")

## some descriptive stats
library(skimr)
skim(df)
glimpse(df)

## What surprises did you discover in the data?
### that there are negative rides and many with a duration of 0. There must be a systematic issue.

df_sort <- arrange(df, ride_length)
View(df_sort)

# calculate average ride length for members and casual riders
df %>% group_by(member_casual) %>% summarise(mean_length=mean(ride_length_num), 
                                             sd_length=sd(ride_length_num))
print(mean(df$ride_length))
tapply(df$ride_length, df$member_casual, summary)
colnames(df)

# count number of casual and member rides
df %>% group_by(member_casual) %>% summarise(count = n())

# count bike type by members and casual riders
df %>% group_by(member_casual, rideable_type) %>% summarise(count = n())

# count weekdays by members and casual riders
df %>% group_by(member_casual, day_of_week) %>% summarise(count = n())

# SHARE
library(ggplot2)

# bar plot of member and causal count
p <- ggplot(data=df, aes(x=member_casual)) +
  geom_bar(fill = "#00abff") +
  geom_text(stat="count", aes(label=scales::comma(..count..)), vjust = -0.5)
## format labels to show actual numbers and not abbreviated
require(scales)
p + scale_y_continuous(labels = comma)

# pie charts for bike type by member group
## make dfs with only member or casual type each
df_m <- subset(df, member_casual == "member")
df_c <- subset(df, member_casual == "casual")

## pie chart for members
### make summary df with count as value because the pie chart does not work for me with the actual count
df_m_sum <- df_m %>% group_by(rideable_type) %>% summarise(n = n())
print(df_m_sum)
ggplot(df_m_sum, aes(x="",y=n, fill=rideable_type)) +
  geom_bar(stat="identity", width = 1, color="white") +
  coord_polar("y", start=0) +
  theme_void() +
  theme(legend.position = "none", plot.title = element_text(hjust =0.5)) +
  geom_text(aes(y= n, label=scales::comma(n)), color = "white", size=4, vjust=-6) +
  geom_text(aes(y= n, label=rideable_type), color = "white", size=4, vjust=-8) +
  ggtitle("Rideable types of annual members")
## pie chart for casual riders
df_c_sum <- df_c %>% group_by(rideable_type) %>% summarise(n = n())
print(df_c_sum)
ggplot(df_c_sum, aes(x="",y=n, fill=rideable_type)) +
  geom_bar(stat="identity", width = 1, color="white") +
  coord_polar("y", start=0) +
  theme_void() +
  theme(legend.position = "none", plot.title = element_text(hjust =0.5)) +
  geom_text(aes(y= n, label=scales::comma(n)), position = position_stack(vjust = 0.5), color = "white", size=4) +
  geom_text(aes(y= n, label=rideable_type), position = position_stack(vjust = 0.5), color = "white", size=4, vjust=2.5) +
  ggtitle("Rideable types of casual riders")

# density plot for ride lengths
## for members
## does not look like a helpful plot. 
ggplot(df_m, aes(x=ride_length_num)) +
  geom_histogram(bins = 6) +
  scale_x_continuous(labels = comma) +
  scale_y_continuous(labels = comma)
print(mean(df_m$ride_length_num))
## cut off everything under 10th and over 90th quantile
quantile(df_m$ride_length_num, prob=c(.10,.5,.90))
df_m_small <- subset(df_m, (ride_length_num > 196 & ride_length_num < 1555))
mean(df_m_small$ride_length_num)
median(df_m_small$ride_length_num)
skim(df_m_small)
df_m_small$ride_length_min <- df_m_small$ride_length_num/60
skim(df_m_small)

ggplot(df_m_small, aes(ride_length_min)) +
  geom_histogram(binwidth = 0.5, col = "black", fill = "cornflowerblue") +
  labs(title="Frequency of ride lengths for annual members",
       subtitle="From 10th to 90th quantile",
       x="ride length in minutes")
## for casual riders
ggplot(df_c, aes(x=ride_length_num)) +
  geom_histogram(bins = 6) +
  scale_x_continuous(labels = comma) +
  scale_y_continuous(labels = comma)
print(mean(df_c$ride_length_num))

quantile(df_c$ride_length_num, prob=c(.10,.5,.90))
df_c_small <- subset(df_c, (ride_length_num > 317 & ride_length_num < 3217))
mean(df_c_small$ride_length_num)
median(df_c_small$ride_length_num)
df_c_small$ride_length_min <- df_c_small$ride_length_num/60
skim(df_c_small)

ggplot(df_c_small, aes(ride_length_min)) +
  geom_histogram(binwidth = 0.5, col = "black", fill = "cornflowerblue") +
  labs(title="Frequency of ride lengths for casual riders",
       subtitle="From 10th to 90th quantile",
       x="ride length in minutes")

# bar plot for ride lengths for member and casual 
##(better not, better report summary stats)

# bar plot for ride lengths per weekday (ordered), member groups next to each other
## make summary df for ggplot
df_weekday_member <- aggregate(df, by=list(df$day_of_week, df$member_casual), FUN=length)
df_weekday_member <- df_weekday_member %>% select("Group.1", "Group.2", "ride_id")
df_weekday_member <- df_weekday_member %>% rename(weekday = Group.1, member_casual = Group.2, count = ride_id)
View(df_weekday_member)
df_weekday_member$weekday <- as.factor(df_weekday_member$weekday)
df_weekday_member$weekday <- ordered(df_weekday_member$weekday,
                                     levels = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday","Sunday"))

glimpse(df_weekday_member)
df_weekday_member$weekday 
## make bar chart
ggplot(df_weekday_member, aes(x=weekday,y=count,fill=member_casual)) +
  geom_bar(stat="identity", position="dodge") +
  scale_fill_discrete(name="Membership type",
                      breaks=c("casual","member"),
                      labels=c("Casual", "Member")) +
  xlab("Weekday") + ylab("Count") +
  scale_y_continuous(labels = comma) +
  labs(title="Rides per weekday and membership type")
# casual riders tend to ride more on weekends, members more during weekdays

# there is no member id in the data (probably privacy reasons), but so we don't know
# how many rides members and casual riders make. 