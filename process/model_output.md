**This file was made by me to try and understand model outputs without having to rerun the model each time**    

### Model 5:
Output:
```r
Family: poisson 
  Links: mu = log 
Formula: pop ~ I(year - 1973) * Country.list + (1 | Location.of.population) 
   Data: long4 (Number of observations: 224) 
  Draws: 3 chains, each with iter = 4000; warmup = 1000; thin = 1;
         total post-warmup draws = 9000

Group-Level Effects: 
~Location.of.population (Number of levels: 11) 
              Estimate Est.Error l-95% CI u-95% CI Rhat Bulk_ESS Tail_ESS
sd(Intercept)     0.91      0.33     0.50     1.77 1.00     2291     3270

Population-Level Effects: 
                                    Estimate Est.Error l-95% CI u-95% CI Rhat Bulk_ESS Tail_ESS
Intercept                               6.74      0.96     4.82     8.74 1.00     3763     2887
IyearM1973                             -0.13      0.00    -0.13    -0.12 1.00     7512     4954
Country.listBrazil                     -2.03      1.19    -4.53     0.23 1.00     3761     3197
Country.listGreece                     -1.72      1.04    -3.91     0.34 1.00     3882     3185
Country.listSouthAfrica                -0.24      1.37    -3.12     2.52 1.00     4210     3794
Country.listUnitedStates                1.01      1.36    -1.65     3.74 1.00     4524     4029
IyearM1973:Country.listBrazil           0.20      0.00     0.19     0.20 1.00     7613     5216
IyearM1973:Country.listGreece           0.13      0.00     0.12     0.13 1.00     7712     5433
IyearM1973:Country.listSouthAfrica      0.16      0.00     0.15     0.16 1.00     7528     5045
IyearM1973:Country.listUnitedStates     0.14      0.00     0.14     0.15 1.00     7609     5191

Draws were sampled using sampling(NUTS). For each parameter, Bulk_ESS
and Tail_ESS are effective sample size measures, and Rhat is the potential
scale reduction factor on split chains (at convergence, Rhat = 1).
Warning message:
There were 3 divergent transitions after warmup. Increasing adapt_delta above 0.9 may help. See http://mc-stan.org/misc/warnings.html#divergent-transitions-after-warmup 
```

### Model 4:

Output:   
```r
 Family: poisson 
  Links: mu = log 
Formula: pop ~ I(year - 1973) + Country.list + (1 | Location.of.population) 
   Data: long4 (Number of observations: 224) 
  Draws: 3 chains, each with iter = 4000; warmup = 1000; thin = 1;
         total post-warmup draws = 9000

Group-Level Effects: 
~Location.of.population (Number of levels: 11) 
              Estimate Est.Error l-95% CI u-95% CI Rhat Bulk_ESS Tail_ESS
sd(Intercept)     0.91      0.34     0.50     1.81 1.00     2083     3223

Population-Level Effects: 
                         Estimate Est.Error l-95% CI u-95% CI Rhat Bulk_ESS Tail_ESS
Intercept                    4.79      0.98     2.83     6.78 1.00     3679     3570
IyearM1973                   0.02      0.00     0.02     0.02 1.00     8946     5225
Country.listBrazil           1.08      1.20    -1.34     3.48 1.00     3728     3291
Country.listGreece          -0.20      1.06    -2.36     1.91 1.00     3600     3453
Country.listSouthAfrica      1.82      1.37    -0.88     4.53 1.00     4115     3919
Country.listUnitedStates     2.80      1.36     0.04     5.48 1.00     4013     3269

Draws were sampled using sampling(NUTS). For each parameter, Bulk_ESS
and Tail_ESS are effective sample size measures, and Rhat is the potential
scale reduction factor on split chains (at convergence, Rhat = 1).
```


I did some calculations to understand output and realized I don't actually understand output:
```r
# actual value of increase by adding mean to intercept estimate
0.02 + 4.72
# exponentiate value to undo log-transformation 
exp(4.74)
# on average there were 114.43 new sea turtle nests every year (worldwide or in Australia??) between 1973 and 2009
```

