# Case Study: How Does a Bike-Share Navigate Speedy Success?

Capstone project example of the [Google Data Analytics
Certificate](https://www.coursera.org/professional-certificates/google-data-analytics).

## Scenario

You are a junior data analyst working in the marketing analyst team at
Cyclist, a bike-share company in Chicago. The director of marketing
believes the company’s future success depends on maximizing the number
of annual memberships.Therefore, your team wants to understand how
casual riders and annual members use Cyclist bikes differently. From
these insights, your team will design a new marketing strategy to
convert casual riders into annual members. But first, Cyclist executives
must approve your recommendations, so they must be backed up with
compelling data insights and professional data visualizations.

## Business task

-   **Question:** How do annual members and casual riders use Cyclistic
    bikes differently?
-   **Key stakeholders:** Cyclist executive team
-   **How can your insights drive business decisions?** By getting
    insights on the different user behaviors of annual members and
    casual riders, marketing campaigns or features of the subscription
    or bike offer could be adapted to the needs of casual riders to
    motivate them to subscribe to an annual membership

## Preparation and processing of data

For details see file [prepare-process](prepare-process.md).

### Description of data sources used

The data used is usage data from the fictional company Cyclistic from
the last 12 months. There is one file for each month, from May 2021 to
April 2022. Each file contains 13 columns (ride id, rideable type,
member type, start and end time, start and end station and their
location). The monthly average of bike rides is 479,795, ranging from
103,770 to 822,410 rides per month.

### Licensing

The data comes with a license, that states that the data is available to
the public, and that it can be included as source material in analyses,
reports or studies published for non-commercial purposes. This is
applies to the case of this analysis.

### Data cleaning

I merged all 12 files to one and saved it as a new file in the folder
“output-data”. The original files are in “raw-data”. I backed up the
original data, chekced for missing values, irrelevant data, checked if
strings are consistent and meaningful, misfielded values, mismatched
data types, irregularities, and created new columns that could be useful
for analysis. For details, please see [here](prepare-process.md).

## Analysis and visualizations

For details see file [analyze-share](analyze-share.md).

## Insights and recommendations with regards to the business task

The question was “How do annual members and casual riders use Cyclistic
bikes differently?”. Here are some insights: \* There are more rides
from annual members (3,221,055), than from casual users (2,536,267).
What we don’t know is the number of rides by person. \* Annual members
use only classic and electric bikes, not docked bikes. Casual riders use
all three types. This might be due to restrictions in docked bike usage
for members, but I would have to ask the stakeholder to find this out.
\* The most popular bike type in general are classic bikes, but the
percentage is greater in annual members. Maybe annual members are more
sportive, maybe they rather choose the classic bike because it is
cheaper, or they pick classic bikes because they go on shorter rides.
There could be many different reasons.

-   Casual riders tend to go on longer rides than annual members, and
    they rather ride in the weekend, compared to annual members who ride
    more on weekdays.
-   So, how to make the annual membership more attractive for casual
    riders?
    -   Maybe allow docked bikes for annual members, some casual members
        might prefer them (if my theory is true that they are not
        available for annual members)
    -   Make the annual membership cheaper compared to the renting bikes
        casually.
    -   Put advertisements in workplaces, because annual membership
        seems to be more popular amongst people who use it to go to
        work. But that would be for new members, not casual riders.

## Reflection on the case study

This case study felt like a really good practice and was fun! It was
helpful that there were lots of guiding questions and suggestions for
steps, because just setting everything up and getting it running is hard
enough if one is not used to doing it. I feel no i actually internalized
what I learned in theory, by putting it into practice, and I feel more
confident. It was a lot harder (of course) than in the classes, because
there was much more liberty and no ‘one correct answer’.

I could have spent a lot more time on this, and I think my markdown
files are too full and messy to be nice and readable for stakeholders,
and don’t have enough interpretational text. They are rather a help /
documentation for analysts at this point.

But overall I’m happy with the learning experience!
