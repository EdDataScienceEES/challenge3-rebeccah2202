# Challenge 3 Statistical Modelling
# Data Science in EES 2021
# Starter script written by Isla Myers-Smith
# Edited by Rebecca Hies
# 14th November 2022

# Starter code ----

setwd("C:/Users/rebec/Documents/data science/challenge3-rebeccah2202/script")

# Libraries
library(tidyverse)
library(tidyr)
library(dplyr)
library(ggplot2)
library(ggthemes)
library(gridExtra)
library(skimr)
library(brms)
library(readr)
library(crunch)

# Load Living Planet Data
load("data/LPI_data.Rdata")

# Choose your species from this list - don't forget to register your species
# on the issue for the challenge and check that no other student has chosen 
# the species already. Every student must choose a different species!
unique(data$Common.Name)

# Filter your species here
data1 <- filter(data, Species == "caretta")

# determining number of population
length(unique(data1$id))
# determingin number of countries
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


# Statistical analysis ----

# Hierarchical linear model using brms----
long4$pop <- as.integer(long4$pop)
model1 <- brms::brm(pop ~ I(year - 1970) + Country.list + (1|Location.of.population),
                    data = long4, family = poisson(), chains = 3,
                    iter = 3000, warmup = 1000)

summary(model1)
plot(model1)
pp_check(model1)

# Model and data visualisation ----

