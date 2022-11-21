# Data exploration
# to determine number of locations of subpopulations, number of countries, sampling methods, years with data
# Goal: come up with a sensible research question BEFORE moving on to any statistical analysis
# 11.11.2022
# Rebecca Hies
# This script was used for data exploration
# All relevant code has been copied into the workflow and final script

library(tidyr)
library(dplyr)
library(ggplot2)
library(ggthemes)
library(gridExtra)

# Load Living Planet Data ----
load("data/LPI_data.Rdata")

# filtering out Loggerhead Sea turtle populations
data1 <- filter(data, Species == "caretta")

# determining number of population
length(unique(data1$id))
# determining number of countries
length(unique(data1$Country.list))

# reshaping data into long form
long <- gather(data1, "year", "pop", 25:69) %>%                         # Reshape data into long form
  mutate(year = parse_number(as.character(year))) %>%                   # Extract numeric values from year column
  mutate(genus_species = paste(Genus, Species, sep=" ")) %>%            # Add column with genus and species
  mutate(genus_species_id = paste (Genus, Species, id, sep=" ")) %>%    # Add column with genus, species and id
  select(-Sub.species)                                                  # Remove subspecies column

long2 <- long %>% na.omit(long)  # Remove NA values

long3 <- long2 %>% group_by(genus_species_id) %>%
  mutate(maxyear=max(year)) %>%                         # column for most recent year of data collection
  mutate(minyear=min(year)) %>%                         # column for first year of data collection
  # creating a column for length of time data available and a column for scale pop trend data
  mutate(scalepop=(pop-min(pop))/(max(pop)-min(pop)), lengthyear = max(year) - min(year)) %>%  
  filter(is.finite(scalepop))

long4 <- long3 %>% 
  group_by(id) %>%
  mutate(no_observations = length(id)) %>%  # column with number of years with data for each population
  filter(no_observations>15) %>%  # only keep populations with more than 15 years of data
  filter(!Units == "Total number of female turtles")


# exploring number of populations and countries after removing populations with less than 15 years of data
length(unique(long4$id))             
length(unique(long4$Country.list))
length(unique(long4$Units))
unique(long4$Country.list)
unique(long4$Units)
