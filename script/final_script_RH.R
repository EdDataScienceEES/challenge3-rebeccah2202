# Final script for Data Science Challenge 3
# Modelling population trends for Loggerhead Sea Turtle over time
# Script by Rebecca Hies
# Research question: How do Loggerhead Sea Turtle Populations change over time in different countries?
# 16/11/2022
# Contact: s2091339@ed.ac.uk



# Data wrangling ----

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
library(tidybayes)

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
# determining number of countries
length(unique(data1$Country.list))

# reshaping data into long form
long <- gather(data1, "year", "pop", 25:69) %>%                         # Reshape data into long form
  mutate(year = parse_number(as.character(year))) %>%                   # Extract numeric values from year column
  mutate(genus_species = paste(Genus, Species, sep=" ")) %>%            # Add column with genus and species
  select(-Sub.species)                                                  # Remove subspecies column

long1 <- long %>% na.omit(long)  # Remove NA values

long2 <- long1 %>% group_by(genus_species_id) %>%
  mutate(maxyear=max(year)) %>%                         # column for most recent year of data collection
  mutate(minyear=min(year)) %>%                         # column for first year of data collection 
  group_by(id) %>%   
  mutate(no_observations = length(id)) %>%              # column with number of years with data for each population
  filter(no_observations>15) %>%                        # only keep populations with more than 15 years of data
  filter(!Units == "Total number of female turtles")    # only keep populations with nest counts

length(unique(long2$year))

# Data distribution: plot histogram ----
(hist_turtle <- ggplot(long4, aes(x = pop)) +
   geom_histogram(colour = c("#458B74"), fill = "#66CDAA") +
   theme_bw() +
   ylab("Count\n") +
   xlab("\nLoggerhead Sea Turtle nests") +
   theme(axis.text = element_text(size = 12),
         axis.title = element_text(size = 14, face = "plain")))    
# the histogram clearly confirms poisson distribution
# we have integer values and lef-skewed data


# Statistical analysis ----
# Hierarchical linear models using brms
long4$pop <- as.integer(long4$pop)

# Final Model
# Data visualisation showed that the general population trend does not fit to individual countries
# Therefore interaction term introduced into model to account for this
# different slopes for population trends in each country

model <- brms::brm(pop ~ I(year - 1973) * Country.list + (1|Location.of.population),   # interaction between country and year
                    data = long4, family = poisson(), chains = 3,                      # poisson distribution
                    iter = 4000, warmup = 1000,
                    control = list(max_treedepth = 15, adapt_delta = 0.9))             # increased maximum treedepth and alpha delta
summary(model)
plot(model)
pp_check(model)

# Figure separate locations: This figure incorporates facet_wrap function to plot countries in separate plots including model predictions
(location_seperate <- long4 %>%
    group_by(Country.list) %>%
    add_predicted_draws(model) %>%  # this line adds the posterior distribution
    ggplot(aes(x = year, y = pop, color = ordered(Country.list), fill = ordered(Country.list))) +  # adding colours for different countries
    stat_lineribbon(aes(y = .prediction), .width = c(.95, .80, .50), alpha = 1/4) +  # adding regression line and CI
    geom_point(data = long4) +  # adds raw data
    facet_wrap(~ Country.list, scales = "free_y") +
    theme_bw() +
    ylab("Number of Loggerhead Sea Turtle nests\n") +
    xlab("\nYear") +
    scale_fill_brewer(palette = "Set2") +
    scale_color_brewer(palette = "Dark2") +
    theme(legend.title = element_blank(), 
          legend.position = "none",
          axis.text.x = element_text(size = 12, angle = 45,  vjust = 1, hjust = 1),
          axis.text.y = element_text(size = 12),
          axis.title = element_text(size = 13),                        
          panel.grid = element_blank(), 
          panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          plot.margin = unit(c(1,1,1,1), units = , "cm"),                 
          panel.spacing = unit(2, "lines"),
          plot.title = element_text( face = "bold")) +
    labs(title="\nLoggerhead Sea Turtle trends between 1973 and 2009 across the world"))

ggsave(filename = 'figures/countries_mod.png', location_seperate, 
       device = 'png', width = 10, height = 8)

# Model Output Table ----
library(sjPlot)
library(insight)
library(httr)

tab_model(model)  #  back-transformed
tab_model(model, transform = NULL)  # log scale
