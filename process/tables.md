Figure out how to make a table that is not static but changes everytime you run the model

Used suggestion from website: https://cran.r-project.org/web/packages/sjPlot/vignettes/tab_bayes.html  
*I don't understand what incidence rate ratios are*
![image](https://user-images.githubusercontent.com/114161047/201923077-704252a0-d32e-482e-a075-b82a64c0928e.png)


Update: I am very puzzled
When I use the tab_model function to make a table, I get the following result:
![image](https://user-images.githubusercontent.com/114161047/201949745-1c6c6126-6f2f-456b-a553-9f99ca5b6aac.png)

But my actual results are:
```r
Family: poisson 
  Links: mu = log 
Formula: pop ~ I(year - 1970) + Country.list + (1 | Location.of.population) 
   Data: long4 (Number of observations: 224) 
  Draws: 3 chains, each with iter = 4000; warmup = 1000; thin = 1;
         total post-warmup draws = 9000

Group-Level Effects: 
~Location.of.population (Number of levels: 11) 
              Estimate Est.Error l-95% CI u-95% CI Rhat Bulk_ESS Tail_ESS
sd(Intercept)     0.91      0.34     0.49     1.77 1.00     2102     3458

Population-Level Effects: 
                         Estimate Est.Error l-95% CI u-95% CI Rhat Bulk_ESS Tail_ESS
Intercept                    4.73      0.99     2.79     6.71 1.00     3609     3232
IyearM1970                   0.02      0.00     0.02     0.02 1.00     8731     5369
Country.listBrazil           1.08      1.23    -1.39     3.46 1.00     3825     3637
Country.listGreece          -0.22      1.10    -2.41     1.90 1.00     3308     2923
Country.listSouthAfrica      1.82      1.47    -1.11     4.65 1.00     3951     3107
Country.listUnitedStates     2.80      1.37    -0.02     5.48 1.00     4506     3764

Draws were sampled using sampling(NUTS). For each parameter, Bulk_ESS
and Tail_ESS are effective sample size measures, and Rhat is the potential
scale reduction factor on split chains (at convergence, Rhat = 1).
```

I went to coding club and we realised that the incidence rate ratios are the back-tranformed estimates. Therefore, they are not the same values as in the output. 
I can manipulate code to not back-transform estimates `transform = NULL`.
