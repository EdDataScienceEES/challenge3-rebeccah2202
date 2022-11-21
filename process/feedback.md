# PARTCIPATION
### This file is a summary of the feedback I received, the feedback I implemented and the feedback I gave. All feedback can also be found in the issues of the challenge repositories. This is also for me to keep track of which feedback I have already impemented and what I still need to change.

**Feedback Pippa gave me**   
Read.me:   
In your main readme file, I would cite where you got the picture of the turtle from. *done, added citations for both images*   
Not sure what you mean by workflow script? Is this draft script before you landed on your Final script?    

Report:   
Cite the picture in your main report as well. *done*   
Really like how in your background you did a different paper for each country's conservation effort and that these countries are also in your data.   
Get rid of the title on your graph. *I have removed it from the script and will add new figure to report*   
Really good report!    

Workflow:   
Cool that it is handwritten   

Model process:   
Really like how you have a step by step work through of why you changed and what you changed in your models.   

Final Script:   
Everything runs up until your models (which is what you wanted so that is fine)   
Double check you need all those libraries, I wasn’t sure because I wasn't able to run the model so I did not know if they were all necessary for the graph you made but on your laptop it is worth checking. *There were three unnecessary packages which I have now removed. The script still runs without any issues.*   
On your inline commenting sometimes you start with a capital and sometimes it starts with a lowercase letter. Change these to one or the other for consistency. 
*All inline commenting now starts with a capital*    

**Feedback I gave to Pippa**   
Here are few suggestions I have just from going through your repo:

Folder Challenge 3 info: maybe give it a more simple name (one word)

Feel free to ignore this comment: I don't find it visually appealing to have green points on pink (Tanzania).

in image folder only image in README file not from the final report. I would add that to image folder.

maybe add a README to preregistration folder to explain why you made several preregistrations

I am a bit confused about the figure and images folders. You have the same figure in two folders. Once in the figures folder and then also in the image subfolder in the report folder. Maybe have one folder with all images and one folder with all figures.

I really like that you created your own theme! Very creative!!

I also like the section effects in your script. Very helpful for understanding dataset.

I am not sure what to put in the gitignore file. I just added what was suggested in the github tutorial

Report:
Overall I really like your report! I just have a few suggestions:
- always put latin names in italics
- maybe write a short sentence on why you predict that populations will be declining and why this is likely to vary between countries
- I really like your justification for why a longer duration of observations are necessary for monitoring elephants
- it's not confidence intervals, it's credible intervals in bayesian stats


**Feedback I gave to luisa**   
is inca package necessary (I've not come across it)?   
why is there a star after 1970?   

The variables section is unclear to me:   
what do you mean by levels?   
the dependent variable is not population change, the dependent change is the annual.index1000   
I see now that this is more clear in the components section   

I think it is really interesting that you assigned the location into regions, good idea!   

why does gaussian model have pipe at the end?   

**Feedback Kinga gave me**
Some things I ran into:   
main thing: loading your models with   
`load("~/data science/challenge3-rebeccah2202/script/model.RData")`   
does not work on someone else's computer if they clone your repo as that is a filepath on your computer - instead use
`load("script/model4.Rdata")`   *I have changed that now*   
as the working directory is your repo, so the filepath needs to be relative to that if that makes sense
when I loaded the models with this code I got the warning message
Warning: namespace ‘crunch’ is not available and has been replaced
by .GlobalEnv when processing object ‘model4’
but it didn't cause any issues when loading the summary etc, so not sure what it means/whether thats relevant.
Overall great that I can just look at the output and don't need to run the models!!   

In the data exploration script, you set your working directory to your local computer, so I can't run the script at all. I'm not sure that's a problem as you only used that script for yourself but if you leave it like that maybe mention in the first few lines that the script was only used to find out stuff about your turtle and is not relevant for anyone looking at your repo to run / alternatively load data from repo instead of computer. You also load some libraries you don't use in the exploration.   *I removed setwd*   

Report: very nice and clear, with lots of background info and great structure! only thing I noticed is that sometimes you capitalise the name of your turtle and sometimes not ( so sometimes it's Loggerhead Sea Turtle and sometimes loggerhead sea turtle), be consistent with that. In model design once you spell Australia as australia so capitalize that. Also typo in the last line (cliamte instead of climate). Content-wise nothing to say, i really liked it!!   *changed the typo*

### Participation in issues
I opened two issues with questions that I had about the challenge:    
challenge 3 differences between locations #112
and reproducible code #139   

I also tried to help others in the issues:   
cannot change the image size in readme #125   
My response: @VeeCong hi, the second code works for me. Are you sure you have specified the right file path for the image? If you want the code to work it has to be in the same folder or you would have to specify where in the repo your image is saved. Hope that helps.





