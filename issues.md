# Making a model that converges:

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
