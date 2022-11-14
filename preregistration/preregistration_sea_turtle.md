### Pre-registration

#### Name: Rebecca Hies

#### Date: 11.11.2022

#### Species: Loggerhead Sea Turtle (*Caretta caretta*)

**1. What is the data source?  Do you have permission to use the data?**  
The data used for this analysis is from The Living Planet Database. It contains time-series data of population abundance from across the world. The LPI dataset that we are using contains data between 1970 and 2014 and is publically available.  
The current LPI data set can be found under this link: https://www.livingplanetindex.org/data_portal  
The data-use agreement can be found under this link: https://livingplanetindex.org/documents/data_agreement.pdf

**2. What is the aim of this study?**  
The aim of this study is to understand the population trends of the **Loggerhead Sea Turtle** (*Caretta caretta*). Loggerhead Sea Turtle populations are found across the world in geographically distinct regions. Therefore, the goal of this study is to not only look at how loggerhead sea turtle abundance has changed over time. We want to understand how the differences in population abundances vary between countries. This is important as it will help understand which populations need more conservation efforts to help conserve loggerhead sea turtle populations globally. 

**3. What's the main question being asked or hypothesis being tested in this study?**  
Research question: **How has the abundance of loggerhead sea turtle populations changed over time gloabally and how do abundances vary between countries across the world?**  
Hypothesis: We expect there to be an overall decline in sea turtle abundance as Loggerhead turtles are protected under the Endangered Species Act and several populations are listed as endangered or threatened (NOAA, https://www.fisheries.noaa.gov/species/loggerhead-turtle#:~:text=Loggerhead%20turtles%20are%20protected%20under,significant%20portion%20of%20its%20range.).  

However, we also expect the changes to vary depending on the country so we predict that some populations will have a population increase and some populations will have a population decline. This is due to climate change impacts not being uniform across the world, and some places putting more effort into conserving turtle populations than others (Casale and Hutchinson, 2017, The Conservation Status of Loggerhead Populations Worldwide: https://www.seaturtlestatus.org/articles/2017/the-conservation-status-of-loggerhead-populations-worldwide).

**4. Describe the key independent and dependent variable(s).**  
The key dependent variable is the population abundance (this will likely be scaled to be able to better compare between populations of very different sizes). The independent variables will be time and country.  

**5. What are the spatial and temporal structures to the data (number of sites, duration in years, etc.)?**  
Overall the data of the populations is between 1970 and 2009. We will be looking at populations with data from at least 15 years, thus comparing between 5 countries: Australia, South Africa, Greece, United States and Brazil. The number of years with data ranges from 16 to 37 years. It is likely that there is variation between years caused by environemtal fluctuations. There is a more exact location of population describing whereabouts a population is within a country e.g. Daphni Beach, Laganas Bay, Zakynthos Island. Populations that are closer to each are likely to experience more similar environmental conditions. Thus, population trends are analysed for each country and the location is included in the model as a random effect.

**6. What is the overall sample size?**  
The overall sample size is 224.  

**7. Specify exactly which analyses you will conduct to examine the main question/hypothesis.**  
The data will be analysed using the bayesian approach. The default priors of the brms package will be used which is a combination of uniform and weak priors based on our data. Our response variable is the population abundance and the explanatory variables are time and country. We assume that the location within a country has an effect on the abundances and therefore the location of population will be added as a random effect. There is likely to be some variation between years caused by environmental fluctuations, however these are probably quite small. To limit the complexity of the model, year will not be included as a random effect.

**8. Is there any other study information you would like to pre-register?**  
It is important to note that one population with >15 observations has been omitted due to a different unit. All other counts were of nests, except one population in Australia.  
Ideally, the model that I have described will converge. But if it doesn't changes to the model will have to be made. These will be justified in the final report and in the r script. 


