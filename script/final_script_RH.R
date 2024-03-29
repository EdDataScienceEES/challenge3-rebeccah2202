# Final script for Data Science Challenge 3
# Modelling population trends for Loggerhead Sea Turtle over time
# Script by Rebecca Hies
# Research question: How do Loggerhead Sea Turtle Populations change over time in different countries?
# 16/11/2022
# Contact: s2091339@ed.ac.uk

# Libraries ----
library(tidyverse)
library(brms)
library(tidybayes)
# the following three packages are necessary to make the table
library(sjPlot)   
library(insight)
library(httr)

# Load Living Planet Data ----
load("data/LPI_data.Rdata")

# Data wrangling ----

# Filtering out Loggerhead Sea turtle from dataset
data1 <- filter(data, Species == "caretta")

# Determining number of populations for Loggerhead Sea Turtle
length(unique(data1$id))

# Determining number of countries for Loggerhead Sea Turtle
length(unique(data1$Country.list))

# Reshaping data
long <- gather(data1, "year", "pop", 25:69) %>%                         # Reshaping data into long form
  mutate(year = parse_number(as.character(year))) %>%                   # Extracting numeric values from year column
  mutate(genus_species = paste(Genus, Species, sep=" ")) %>%            # Adding column with genus and species
  mutate(genus_species_id = paste (Genus, Species, id, sep=" ")) %>%    # Adding column with genus, species and id
  select(-Sub.species)                                                  # Removing subspecies column

long1 <- long %>% na.omit(long)  # Removing NA values

# Cutting down dataframe
long2 <- long1 %>% group_by(genus_species_id) %>%
  mutate(maxyear=max(year)) %>%                         # Column for most recent year of data collection
  mutate(minyear=min(year)) %>%                         # Column for first year of data collection 
  group_by(id) %>%   
  mutate(no_observations = length(id)) %>%              # Column with number of years with data for each population
  filter(no_observations>15) %>%                        # Only keeping populations with more than 15 years of data
  filter(!Units == "Total number of female turtles")    # Only keeping populations with unit nest counts

# Determining number of unique population in final dataset
length(unique(data1$id))

# Determining number of countries in final dataset
length(unique(data1$Country.list))

# Data distribution ----
# Plotting histogram

(hist_turtle <- ggplot(long2, aes(x = pop)) +
   geom_histogram(colour = c("#458B74"), fill = "#66CDAA") +
   theme_bw() +
   ylab("Count\n") +
   xlab("\nLoggerhead Sea Turtle nests") +
   theme(axis.text = element_text(size = 12),
         axis.title = element_text(size = 14, face = "plain")))

# The histogram clearly confirms poisson distribution. The data is left-skewed.


# Statistical analysis ----
# Hierarchical linear model using brms
long2$pop <- as.integer(long2$pop)  # making nest counts integers

# Final Model
# The final model looks at the interaction between country and time.
# Understanding how populations change over time in each country using nest counts as an index.
# The model takes around 20-30 minutes to run so the model output has been saved below.

# model <- brms::brm(pop ~ I(year - 1973) * Country.list + (1|Location.of.population),   # Interaction between country and year, location of pop. random effect
#                    data = long2, family = poisson(), chains = 3,                       # Poisson distribution
#                    iter = 4000, warmup = 1000,
#                    control = list(max_treedepth = 15, adapt_delta = 0.9))              # Increased maximum tree depth and alpha delta

# save(model, file = "script/model.RData")
load("script/model.RData")
summary(model)
# plot(model)
# pp_check(model)

# Data visualisation ----

# Create turtle theme
theme_turtle <- function(){
  theme_bw()+
    theme(legend.title = element_blank(), 
          legend.position = "none",
          axis.text.x = element_text(size = 12, angle = 45,  vjust = 1, hjust = 1),
          axis.text.y = element_text(size = 12),
          axis.title = element_text(size = 13, face = "plain"),
          plot.margin = unit(c(1,1,1,1), units = , "cm"), 
          panel.grid = element_blank(), 
          panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          legend.text = element_text(size = 12))
}

# Figure separate locations: This figure incorporates facet_wrap function to plot countries in separate plots including model predictions
(location_seperate <- long2 %>%
    group_by(Country.list) %>%
    add_predicted_draws(model) %>%                                                                  # Adding the posterior distribution
    ggplot(aes(x = year, y = pop, color = ordered(Country.list), fill = ordered(Country.list))) +   # Adding colours for different countries
    stat_lineribbon(aes(y = .prediction), .width = c(.95, .80, .50), alpha = 1/4) +                 # Adding regression line and CI
    geom_point(data = long2) +                                                                      # Adding raw data
    facet_wrap(~ Country.list, scales = "free_y") +                                                 # Separating countries into separate graphs
    ylab("Number of Loggerhead Sea Turtle nests\n") +
    xlab("\nYear") +
    scale_fill_brewer(palette = "Set2") +                                                           # Changing colour palette
    scale_color_brewer(palette = "Dark2") +
    theme_turtle() +                                                                                # adding turtle theme
    theme(panel.spacing = unit(1.5, "lines")))


ggsave(filename = 'figures/countries_model.png', location_seperate, 
       device = 'png', width = 10, height = 8)

# Model Output Table ----
tab_model(model)                      # Back-transformed table
tab_model(model, transform = NULL)    # Log scale table
