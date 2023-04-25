# Importing necessary libraries
library(tidyverse)
getwd()
setwd("~/Desktop/Portfolio project")

# Importing data
sqlJoint = read_csv("~/Desktop/Portfolio project/sql-joint-table.csv")
View(sqlJoint)

# Finding descriptive statistics of the table
summary(sqlJoint)

# We found that energy_cons_change has not been properly formatted because of the NULL value. We will drop that column, change the datatype and re-run the summary statistics
sqlJoint = sqlJoint [!(is.na(sqlJoint$energy_cons_change) | sqlJoint$energy_cons_change=="NULL"), ]

sqlJoint$energy_cons_change = as.numeric(sqlJoint$energy_cons_change)
str(sqlJoint)


# We'll check the descriptive statistics again
summary(sqlJoint)

  
# Let's get an idea of how much growth in population is India experiencing in relation to its energy consumption growth
# We will get a subset of the data first and then converting it to long data for easy plotting
sqlJointSubL = select(sqlJoint, year, population_index, energy_cons_index)
head(sqlJointSubL)

# Pivot
sqlJointLine = sqlJointSubL %>% 
  gather(key = Category, value = Index, 2:3)
head(sqlJointLine)

# Plot. 
# Formatted the plot line with color, given it a title, formatted the axis names, renamed the legend labels, dropped the legend title, put the legend inside the plot.
sqlJointLine %>% 
  ggplot(aes(x=year, y=Index)) +
  geom_line(aes(color=Category)) +
  labs(title='Population index v. energy consumption index (Year 2000 = 100)', x='Year', y='Index') +
  scale_color_discrete(labels=c('Energy Consumption', 'Population')) +
  theme(legend.title=element_blank(), legend.position=c(0.3, 0.8), legend.key.size=unit(0.5, 'cm'),legend.direction="horizontal")

  
# Finding the correlation between energy consumption and temperature changes, plotting the scatter plot and annotating the plot.
round(cor(sqlJoint$energy_cons_change, sqlJoint$temp_change), digits = 4)

ggplot(sqlJoint, aes(x=energy_cons_change, y=temp_change, colour = "#0c4c8a")) +
  geom_point() +
  geom_smooth(method=lm) +
  labs(title='Energy consumption change v. Temperature change', x='Energy consumption change', y='Temperature change') +
  annotate(
    'text', x=0, y=0.02, label="R = 0.0223", color='#0c4c8a', size=5
  ) +
  theme(legend.position='none')

  
# Column chart of energy consumption and population trend
# Creating subset

sqlJointSub = select(sqlJoint, year, population_change, energy_cons_change)
head(sqlJointSub)

# Pivot
sqlJointCol = sqlJointSub %>% 
  gather(key = Category, value = Change, 2:3)

# Plot
sqlJointCol %>% 
  ggplot(aes(x=year, y=Change, fill=Category)) +
  geom_col(position = "dodge") +
  labs(title='Energy consumption v. Population change over time', x='Year', y='% change') +
  scale_fill_discrete(labels=c('Energy Consumption', 'Population')) +
  theme(legend.title=element_blank(), legend.position=c(0.7, 0.9), legend.key.size=unit(0.4, 'cm'),legend.direction="horizontal")


# Column chart of energy consumption change and temperature change
# Creating subset
sqlJointSub2 = select(sqlJoint, year, energy_cons_change, temp_change)
head(sqlJointSub2)

# Pivot
sqlJointCol2 = sqlJointSub2 %>% 
  gather(key = Category, value = Change, 2:3)

# Plot
sqlJointCol2 %>% 
  ggplot(aes(x=year, y=Change, fill=Category)) +
  geom_col(position = "dodge") +
  labs(title='Energy consumption v. Temperature change over time', x='Year', y='% change') +
  scale_fill_discrete(labels=c('Energy Consumption', 'Temperature')) +
  theme(legend.title=element_blank(), legend.position=c(0.7, 0.9), legend.key.size=unit(0.4, 'cm'),legend.direction="horizontal")

