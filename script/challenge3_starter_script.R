# Challenge 3 Statistical Modelling
# Data Science in EES 2021
# Starter script written by Isla Myers-Smith
# Edited by Rebecca Hies
# 14th November 2022

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
  mutate(no_observations = length(id)) %>%              # column with number of years with data for each population
  filter(no_observations>15) %>%                        # only keep populations with more than 15 years of data
  filter(!Units == "Total number of female turtles")    # only keep populations with nest counts

length(unique(long4$year))

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
# Model 1 ----
model1 <- brms::brm(pop ~ I(year - 1970) + Country.list + (1|Location.of.population),
                    data = long4, family = poisson(), chains = 3,
                    iter = 3000, warmup = 1000)

summary(model1)
plot(model1)
pp_check(model1)
pairs(model1)

# Model 2 ----
# I am increasing iterations to resolve issue of Bulk Effective Samples Size (ESS) being too low
model2 <- brms::brm(pop ~ I(year - 1970) + Country.list + (1|Location.of.population),
                    data = long4, family = poisson(), chains = 3,
                    iter = 4000, warmup = 1000)

summary(model2)

# Model 3 ----
# I have increased the maximum tree depth to 13 and adapt delta to 0.99 to try and resolve
# (1) high number of divergent transitions
# (2) high number of transitions that exceed maximum treedepth

model3 <- brms::brm(pop ~ I(year - 1970) + Country.list + (1|Location.of.population),
                    data = long4, family = poisson(), chains = 3,
                    iter = 4000, warmup = 1000,
                    control = list(max_treedepth = 13, adapt_delta = 0.99))

summary(model3)
plot(model3)
pp_check(model3)
pairs(model3)

# Model 4 ----
# increasing maximum tree depth to 15 to resolve high number of transitions that exceed max treedepth
# i realised my data starts from 1973, so I changed that too
model4 <- brms::brm(pop ~ I(year - 1973) + Country.list + (1|Location.of.population),
                    data = long4, family = poisson(), chains = 3,
                    iter = 4000, warmup = 1000,
                    control = list(max_treedepth = 15, adapt_delta = 0.99))
summary(model4)
output <- summary(model4)
plot(model4)
pp_check(model4)

# actual value of increase by adding mean to intercept estimate
0.02 + 4.72
# exponentiate value to undo log-transformation 
exp(4.74)
# on average there were 114.43 new sea turtle nests in Australia between 1973 and 1974

# Model 5 ----
# Data visualisation showed that the general population trend does not fit to individual countries
# E.g. See f2 - Australia is clearly decreasing
# Therefore interaction term introduced into model to account for this
# different slopes for population trends in each country

model5 <- brms::brm(pop ~ I(year - 1973) * Country.list + (1|Location.of.population),
                    data = long4, family = poisson(), chains = 3,
                    iter = 4000, warmup = 1000,
                    control = list(max_treedepth = 15, adapt_delta = 0.9))
summary(model5)
plot(model5)
pp_check(model5)


# MODEL 4 VISUALISATION ----
# based on plot used in bayesian tutorial

# Figure 1: Figure that includes all raw data and one line for population trends worldwide bases on model predictions
# not informative
(f1 <- long4 %>%
    add_predicted_draws(model4) %>%  # adding the posterior distribution 
    ggplot(aes(x = year, y = pop)) +
    stat_lineribbon(aes(y = .prediction), .width = c(.95, .80, .50),  # regression line and CI
                    alpha = 0.5, colour = "black") +
    geom_point(data = long4, colour = "darkseagreen4", size = 3) +   # raw data
    scale_fill_brewer(palette = "Greys") +
    ylab("Loggerhead Sea Turtle abundance\n") +  
    xlab("\nYear") +
    theme_bw() +
    theme(legend.title = element_blank(),
          legend.position = c(0.15, 0.85)))

# Figure location: Makes a seperate trendline based on model predictions for each country in one plot
# not all trendlines visible
(location_fit <- long4 %>%
    group_by(Country.list) %>%  # grouping by country
    add_predicted_draws(model4) %>%
    ggplot(aes(x = year, y = pop, color = ordered(Country.list), fill = ordered(Country.list))) +  # this colours trendlines and data points by country
    stat_lineribbon(aes(y = .prediction), .width = c(.95, .80, .50), alpha = 1/4) +
    geom_point(data = long4) +
    scale_fill_brewer(palette = "Set2") +
    scale_color_brewer(palette = "Dark2") +
    theme_bw() +
    ylab("Loggerhead Sea Turtle nests\n") +
    xlab("\nYear") +
    theme_bw() +
    theme(legend.title = element_blank()))

# Figure 2: This figure incorporates facet_wrap function to plot countries in seperate plots
# we see model predicitions do not match all countries
# e.g. clearly AUstralia has a population decline
(f2 <- long4 %>%
    group_by(Country.list) %>%
    add_predicted_draws(model4) %>%
    ggplot(aes(x = year, y = pop, color = ordered(Country.list), 
               fill = ordered(Country.list))) +
    stat_lineribbon(aes(y = .prediction), .width = c(.95, .80, .50), alpha = 1/4) +
    geom_point(data = long4) +
    facet_wrap(~ Country.list, scales = "free_y") +  # this creates seperate plots for each country
    scale_fill_brewer(palette = "Set2") +
    scale_color_brewer(palette = "Dark2") +
    theme_bw() +
    ylab("Loggerhead Sea Turtle nests\n") +
    xlab("\nYear") +
    theme_bw() +
    theme(legend.title = element_blank(), legend.position = "none"))

ggsave(filename = 'figures/countries_mod.png', f2, 
       device = 'png', width = 10, height = 8)


# MODEL 5 VISUALISATION ----
# Figure 3: Figure that includes all raw data and one line for population trends worldwide bases on model 5 predictions
# not informative
(f3 <- long4 %>%
    add_predicted_draws(model7) %>%  # adding the posterior distribution
    ggplot(aes(x = year, y = pop)) +
    stat_lineribbon(aes(y = .prediction), .width = c(.95, .80, .50),  # regression line and CI
                    alpha = 0.5, colour = "black") +
    geom_point(data = long4, colour = "darkseagreen4", size = 3) +   # raw data
    scale_fill_brewer(palette = "Greys") +
    ylab("Loggerhead Sea Turtle nests\n") +  
    xlab("\nYear") +
    theme_bw() +
    theme(legend.title = element_blank(),
          legend.position = c(0.15, 0.85)))

# Figure location: Makes a separate trendline based on model predictions for each country in one plot
# not all trendlines visible
(location <- long4 %>%
    group_by(Country.list) %>%
    add_predicted_draws(model7) %>%
    ggplot(aes(x = year, y = pop, color = ordered(Country.list), fill = ordered(Country.list))) +
    stat_lineribbon(aes(y = .prediction), .width = c(.95, .80, .50), alpha = 1/4) +
    geom_point(data = long4) +
    scale_fill_brewer(palette = "Set2") +
    scale_color_brewer(palette = "Dark2") +
    theme_bw() +
    ylab("Loggerhead Sea Turtle nests\n") +
    xlab("\nYear") +
    theme_bw() +
    theme(legend.title = element_blank()))

# Figure separate locations: This figure incorporates facet_wrap function to plot countries in separate plots
# we see model predictions match countries
# this figure best presents model results
(location_seperate <- long4 %>%
    group_by(Country.list) %>%
    add_predicted_draws(model7) %>%
    ggplot(aes(x = year, y = pop, color = ordered(Country.list), fill = ordered(Country.list))) +
    stat_lineribbon(aes(y = .prediction), .width = c(.95, .80, .50), alpha = 1/4) +
    geom_point(data = long4) +
    facet_wrap(~ Country.list, scales = "free_y") +
    scale_fill_brewer(palette = "Set2") +
    scale_color_brewer(palette = "Dark2") +
    theme_bw() +
    ylab("Number of Loggerhead Sea Turtle nests\n") +
    xlab("\nYear") +
    theme_bw() +
    theme(legend.title = element_blank(), 
          legend.position = "none",
          axis.text.x = element_text(size = 12, angle = 45,  vjust = 1, hjust = 1),
          axis.text.y = element_text(size = 12),
          axis.title = element_text(size = 13, face = "plain"),                        
          panel.grid = element_blank(), 
          panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          plot.margin = unit(c(1,1,1,1), units = , "cm"),                 
          legend.text = element_text(size = 12),
          panel.spacing = unit(2, "lines")))

ggsave(filename = 'figures/countries_mod5.png', location_seperate, 
       device = 'png', width = 10, height = 8)

# Table ----
stargazer(output, type = "html", summary = FALSE)
# stargazer does not support object type

# updates table when model output changes and code is rerun
library(sjPlot)
library(insight)
library(httr)

tab_model(model4)  #  back-transformed
tab_model(model4, transform = NULL)  # log scale

tab_model(model5)
tab_model(model5, transform = NULL)

table <- tab_model(model5)