**This file was made by me to try and understand model outputs without having to rerun the model each time**

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

