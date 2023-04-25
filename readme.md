# Case
I've always had thoughts on how could human survive in the near future with the ever increasing population. It was the start of the annual Indian heat wave in and Bloomberg posted an article on how India will soon surpass China as the most populous country

So something struck me and got me thinking about global temperature and India's population as my first portfolio project.

<br>

## **Ask**
There were a lot of question in mind but I ended up hypothesizing that temperature in India itself must've been increasing at an exponential pace in correlation to the country's energy consumption generated from it's increasing population. 

**The problem I'm trying to answer are:**
- Is India's temperature getting worse every year due to its energy consumption?
- Is population growth and energy consumption increase one of the factor contributing to increasing annual temperature of India?
- Is India's average temperature growing faster than the global rate? (I have the data but not shown in the analysis process)

**With this simple hypothesis I looked for three measurable variables which may help answering this task.**
- India's energy consumption trend
- India's annual temperature trend
- India's population trend

We will treat this study as a study to show to the government of India for the sake of argument. We hope that this data can show us correlation (if any) between India's energy use and what measures can the government take to slow down the warming issue.

<br>

## **Preparing**
I have gotten the dataset from these sources:

[World bank population data](https://data.worldbank.org/indicator/SP.POP.TOTL)

[Kaggle public dataset](https://www.kaggle.com/datasets/venky73/temperatures-of-india)

[Energy Consumption](https://ourworldindata.org/energy/country/india#how-much-energy-does-the-country-consume-each-year)

The data is sourced from reliable study from organisations like British Petroleum and International Energy Agency. Temperature record on India is difficult to find in my experience, even though it is hard to verify the integrity of the Kaggle temperature dataset, it is the best resources I could get.

Depending on dataset, the data is generally organised on a time series basis. Dataset showing sources of energy breaks down data in long format categorised by the type of course.

Since the dataset is small, I am able to verify the integrity of the data by checking each cell in the master table and ensure data format is consistent, data is complete, no null or duplicate values.

**These datasets will help us answer a few key questions**
- What is the energy growth rate of India against its population growth rate? Does energy demand growth exceeds population growth greatly?
- Does the growth in energy demand correlates highly with the change in temperature?

There are no issues with the data but some files arranges the data in long format while others in wide format, so some cleaning will be required.

<br>

## **Data cleaning/manipulation**
Since this is my first hands on, I chose to familiarise myself with the data using Excel first. After cleaning with Excel, I will replicate the process using SQL to build on my SQL skills. Below highlights the simple process in both Excel and SQL, please refer to 'Project-sql-queries.sql' file for step by step detail.

**I have done the following in Excel to make sure my data is clean**
- I used the duplicate function in Excel to check for duplicates.
- I used the COUNTBLANK function in Excel to ensure each field has no NULL observations.
- I checked each cell has been correctly formatted as NUMBERS using the =ISNUMBER() function
- I checked for NULL values using COUNTIFS with criteria 0 and “” 
- I checked for leading and trailing white spaces using the TRIM() function.
- The data are all in numbers, so misfielded values cannot be filtered like string. However for text dtype fields such as 'country', I have ensured it only contains country and no  numerical data.
- I used the cell formatting tool to format the dtypes of each field.
- No spelling error because the data is number
- Data bias will be tough to identify in this case as the data is third party, however the source of data I will treat the data as having minimal bias.
- Lastly the final file is exported as joint-table.

<br>

**I replicated this process in SQL using SQL server by importing the three raw files and cleaning them by:**
- Dropping all columns from energyCons table except India, and then renaming column names so it's easier and more concise to work with
- Dropping all column from temperature table except YEAR and ANNUAL, and then renaming columns
- Selecting and inserting Country_Name and India column from population table into another table, and then renaming columns
- Created new table with for each of the table. The new tables includes new columns to index the raw data so it is easier to compare across the tables. It also has a column to calculate the percentage change from year to year.
- Lastly the three new tables are joint together and exported. The exported file will be used in RStudio for analysis.

Please refer to 'Project-sql-queries.sql' file for step by step detail.

<br>

## **Analysis**
Similar to data cleaning, I did my analysis in Excel first before moving to RStudio. Below highlights the simple process in both Excel and RStudio, please refer to 'Project-Rscript.R' or 'Project-Rmarkdown.Rmd' file for step by step detail.

**Excel Process**
- Prior the analysis, the data after cleaning is organised as long format with fields as column. Each observation shows corresponding years. Since the dataset spans across 57 years, There are 57 observations for our country of interest. After dropping some rows due to null values and inner joins, the final dataset consist of 52 rows.

- Recall that my hypothesis was that India’s increasing energy demand causes India’s increase in temperature across 50 years, my findings found that **the relationship is weak and there was no clear trend** that the growth in energy consumption resulted in temperature changes. 

- Per capita energy consumption increases steadily over the year, upon further analysis at the population growth data we realise India’s population has been on a downtrend since 1990, which was 3 decades ago. India's population averaged 1.93% growth across 50 years, whereas energy consumption growth averaged 5.24% across the same time frame, explaining the per capita increase.

- Temperature shows increasing trend over 50 years but the cannot be explained by change India’s energy usage given our result of very little to no relationship between the two variables. Global warming and increasing world temperature is a plausible candidate we can explore further. India’s temperature has shown greater changes over 50 years but this does not seemed to be explained by India’s energy consumption.

- We can conclude that the effect of energy consumption increase is not the main factor contributing to temperature increase. With R^2 of less than 0.1, the government of India may be interested to look at factors other than energy consumption to help with increasing temperature. 

<br>

**RStudio Process**
- Imported tidyverse package for analysis

- I then import the joint table exported from SQL in my previous step to start with the analysis.

- I realised that the first row of the data consist of one NULL value and RStudio did not treat that column as numeric, therefore I have to drop the row and reformat that column as numeric so I can continue with the descriptive analysis

- Similar to what I've done in Excel, I'm looking to compare these few variables:
    1. Population growth vs Energy consumption growth
    2. Energy consumption growth vs Temperature changes
    3. Correlation between Energy consumption and Temperature 

<br>

- I ran a simple summary() function on the table and extracted the mean changes over 50 years for population and energy consumption as the growth value, then also ran a simple correlation using the cor() function between energy consumption and temperature to obtain the R-value.

- To the best of my ability and foraging for resources online, I've created three new tables for three of the four graphs I will be plotting. This is because the plotting requires a table with long format instead of wide format for the plot to work properly.

- The visualisations will be replicated in Tableau and will be built into a dashboard

Please refer to 'Project-Rscript.R' or 'Project-Rmarkdown.Rmd' file for step by step detail.

<br>

## **Visualisation**
I have imported the CSV into Tableau Public to be visualised. Link as below:\
[India energy vs temperature](https://public.tableau.com/views/India-energy-vs-temp/Dashboard?:language=en-GB&:display_count=n&:origin=viz_share_link)

Please refer to 'Dashboard.png' file for a simple image file.