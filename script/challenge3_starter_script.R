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

# type of data distribution: plot histogram ----
(hist_turtle <- ggplot(long4, aes(x = pop)) +
   geom_histogram(colour = c("#458B74"), fill = "#66CDAA") +
   theme_bw() +
   ylab("Count\n") +
   xlab("\nLoggerhead Sea Turtle abundance") +  # latin name for red knot
   theme(axis.text = element_text(size = 12),
         axis.title = element_text(size = 14, face = "plain")))    
# the histogram clearly confirms poisson distribution
# we have integer values and lef-skewed data


# Statistical analysis ----
# Hierarchical linear models using brms

# Model 1 ----
long4$pop <- as.integer(long4$pop)
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
model4 <- brms::brm(pop ~ I(year - 1970) + Country.list + (1|Location.of.population),
                    data = long4, family = poisson(), chains = 3,
                    iter = 4000, warmup = 1000,
                    control = list(max_treedepth = 15, adapt_delta = 0.99))
summary(model4)
plot(model4)
pp_check(model4)
pairs(model4)


# Model and data visualisation ----

# not sure how informative this plot is
# also why is there an increase in pop????????
(f1 <- ggplot(long4, aes(x=year, y=pop)) +
   geom_point() + 
   geom_smooth(method="lm", se = FALSE) +
   theme_bw() +                                                   # adding black white theme to remove background
   theme(panel.grid = element_blank(),                            # remove grid lines
         plot.margin = unit(c(1,1,1,1), units = , "cm")) +        # changing margins
   labs(title="Turtle trends \n between 1971 and 1991") +         # adding plot title
   theme(plot.title=element_text(size=15, hjust=0.5))) 

# Trying out a different plot used in bayesian tutorial
library(tidybayes)
(f2 <- long4 %>%
    add_predicted_draws(model3) %>%  # adding the posterior distribution
    ggplot(aes(x = year, y = pop)) +  
    stat_lineribbon(aes(y = .prediction), .width = c(.95, .80, .50),  # regression line and CI
                    alpha = 0.5, colour = "black") +
    geom_point(data = long4, colour = "darkseagreen4", size = 3) +   # raw data
    scale_fill_brewer(palette = "Greys") +
    ylab("Loggerhead Sea Turtle abundance\n") +  # latin name for red knot
    xlab("\nYear") +
    theme_bw() +
    theme(legend.title = element_blank(),
          legend.position = c(0.15, 0.85)))
# that looks horrible lol

# plot for each country
# Plot the population change for countries individually
(turtle_scatter_facets <- ggplot(long4, aes (x = year, y = pop, colour = Country.list)) +
    geom_point(size = 2) +                                               # Changing point size
    geom_smooth(method = "lm", se = FALSE) +               # Adding linear model fit, colour-code by country
    facet_wrap(~ Country.list, scales = "free_y", "free_x") +                      # THIS LINE CREATES THE FACETTING
    theme_bw() +
    scale_fill_manual(values = c("#66CDAA", "#7AC5CD", "#EEE685", "#EE6A50", "#EE6AA7"),
                      labels = c("Australia", "Brazil", "Greece", "South Africa", "United States")) +
    ylab("Number of Loggerhead Sea Turtle nests\n") +                             
    xlab("\nYear")  +
    theme(axis.text.x = element_text(size = 12, angle = 45, vjust = 1, hjust = 1),     # making the years at a bit of an angle
          axis.text.y = element_text(size = 12),
          axis.title = element_text(size = 14, face = "plain"),                        
          panel.grid = element_blank(),                                   # Removing the background grid lines               
          plot.margin = unit(c(1,1,1,1), units = , "cm"),                 # Adding a 1cm margin around the plot
          legend.text = element_text(size = 12, face = "italic"),         # Setting the font for the legend text
          legend.title = element_blank(),                                 # Removing the legend title
          legend.position = "none")) 


ggsave(filename = 'pop_country.png', turtle_scatter_facets, 
       device = 'png', width = 10, height = 8)

# table ----
# doesn't include what I want it to include :/
library(sjPlot)
library(insight)
library(httr)
tab_model(model4)

tab_model(model4, show.est = TRUE)

# not vibing
launch_shinystan(model4)

devtools::install_github('m-clark/lazerhawk')
library(lazerhawk)
brms_SummaryTable(model4)
# lol I thought this would give me a proper table 


