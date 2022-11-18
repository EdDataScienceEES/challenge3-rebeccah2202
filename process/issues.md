# Model process:   
**This file explains the ways in which the model was changed to converge and why an interaction term between year and country was added in.**   

**Model 1:**  
Warning messages:  
1: There were 3 divergent transitions after warmup. See
https://mc-stan.org/misc/warnings.html#divergent-transitions-after-warmup
to find out why this is a problem and how to eliminate them. 
- "if you get only few divergences and you get good Rhat and ESS values, the resulting posterior is often good enough to move forward" 
- I believe three divergent transitions is acceptable  

2: There were 4991 transitions after warmup that exceeded the maximum treedepth. Increase max_treedepth above 10. See
https://mc-stan.org/misc/warnings.html#maximum-treedepth-exceeded 
- is an efficiency concern - not as serious
- it is not recommended to increase maximum tree depth

3: Examine the pairs() plot to diagnose sampling problems
- I don't really understand what is going on here
![image](https://user-images.githubusercontent.com/114161047/201900697-7da507be-22ee-47f1-9bc4-a2faa3cf158f.png)
 
4: Bulk Effective Samples Size (ESS) is too low, indicating posterior means and medians may be unreliable.
Running the chains for more iterations may help. See
https://mc-stan.org/misc/warnings.html#bulk-ess
- I will increase iterations by 1000

**Model 2**
*By increasing the iterations by 1000, I have successfully increased the Effective Sample Size*
Warning messages:  
1: There were 13 divergent transitions after warmup. See
https://mc-stan.org/misc/warnings.html#divergent-transitions-after-warmup
to find out why this is a problem and how to eliminate them.   
- unfortunately there are more divergent transitions after warmup
- I will increase adapt_delta above 0.8 to 0.9 as this may help
- if this doesn't help I may scale the year data

2: There were 7513 transitions after warmup that exceeded the maximum treedepth. Increase max_treedepth above 10. See
https://mc-stan.org/misc/warnings.html#maximum-treedepth-exceeded  
- not sure what to do about this as I read itis not recommended to increase max_treedepth
- I will try increasing to 13

3: Examine the pairs() plot to diagnose sampling problems

**Model 3**  
*By increasing adapt_delta, I have managed to remove issue of divergent transition*  
*side note: this model is taking a horrifically long time to run*  
Warning messages:  
1: There were 1482 transitions after warmup that exceeded the maximum treedepth. Increase max_treedepth above 13. See
https://mc-stan.org/misc/warnings.html#maximum-treedepth-exceeded 
- I don't understand why I have even more transitions that exceeded maximum treedepth even though I already increased max_treedepth
- I might increase it to 15 BUT I am worried that it wil take a really really long time to run the model  

2: Examine the pairs() plot to diagnose sampling problems

**Model 4**  
The model converged and there were no more warning messages.  
BUT model took absolutely ages to run. Furthermore, when we plot the model predictions on to the raw data we can clearly see when we look at Australia, that the model predictions do not match the actual trends.

![image](https://user-images.githubusercontent.com/114161047/202538537-6e574d5c-947b-4a27-a5bf-0dd709d93071.png)



**Final model**   
Model 4, which assumed the same population trends for each country (same slope), is not suitable as seen when visualising the predictions on the raw data. 
To account for different slopes, a small change was made to model 4. An interaction between country and year was integrated into the model. There are some issues with model convergence, which have mostly been resolved (but still four divergent transitions left). The model is more efficient and took a lot less time to run than the previous one.  Furthermore, when we plot the model predictions from this model which allows for different slopes, we see that the model predictions match the trends in each country well.

![image](https://user-images.githubusercontent.com/114161047/202539110-80111a3b-6114-4c17-bf10-5071fccd0710.png)


