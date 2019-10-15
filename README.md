# Introduction
What resampling methods essentially do is to repeatedly draw samples from the training set and refitting the model of interest on each sample to obtain additional information about the fitted model. In this repository, I will perform two resampling methods: bootstrap and cross validation.

# Bootstrap

`library(boot)`

- Use: Most commonly used to provide a measure of accuracy of a parameter estimate.

- The inline code uses lalonde dataset

```
library(Matching)
data(lalonde)
```

**Method 1:** Bootstrap without using *boot library* to calculate confidence interval

The inline code below explains what actually happens inside bootstrap.
```R 
tre = which(lalonde$treat==1)
con = which(lalonde$treat==0)
storage_vector = rep(0,10000) #replicates the values for 1000 times

for (i in 1:10000) #do 10000 times to have 10,000 treatment and 10,000 control samples
{
  sample_treat=sample(tre, length(tre), replace=T) #sampled treatment group with equal length as tre
  sample_control=sample(con, length(con), replace=T)#sampled control group with equal length as con
  mean_treat=mean(lalonde$re78[sample_treat]) #mean re78 of the treatment group
  mean_control=mean(lalonde$re78[sample_control]) #mean re78 of the control group
  storage_vector[i]= mean_treat - mean_control #store all means in vector storage_vector
}

#Caclulate confidence interval of storage_vector
quantile(storage_vector, probs = c(0.025,0.975))

```


**Method 2:** Bootstrap using *boot library* to calculate standard error
```
library(boot)
#Define a auxiriliary function to receive data and sample
boot.use = function(data,sample) return(coef(lm(re78~.,data = data, subset = sample)))
boot.use(lalonde, 1:nrow(lalonde))
boot.lalonde = boot(lalonde, boot.use, 1000) 
  #use boot on lalonde data, with function bootuse, boot for 1000 times

#Calculate standard errors
boot.se = apply(boot.lalonde$t, 2, sd) #find the SE on boot.lalonde throug boostrapping
lm.se = summary(lm(re78~., data = lalonde))$coef[,2] #find SE of the regression function
format(data.frame(boot.se,lm.se), digits=2, scientific = F) #put them together in a dataframe to compare
```


| variable | boot.se  | lm.se |
--- | --- | ---
| (Intercept) | 3716.63 | 3521.682|
| age | 43.41  | 45.806 |
| educ | 200.83 | 228.822 |
| black | 1063.78 | 1173.716 |
| hisp | 1431.26| 1564.553 |
| married | 928.16 | 882.257 |
| nodegr | 1085.89| 1005.885 |
| re74 | 0.13 | 0.088 |
| re75 | 0.15 | 0.150 |
| u74 | 1559.61 | 1187.917 |
| u75 | 1464.95 | 1024.878 |
| treat | 682.85 | 641.132 |

We can see that the coefficients generated from normal linear regression summary and from SE in bootrap are quite similar.



# Cross-validation

- Use: Cross-validation can be used to estimate the test error associated with a given statistical learning method in order to evaluate its performance, or to select the appropriate level of flexibility.

```
library(Matching)
library(arm)
data("lalonde")

glm.lalonde = glm(re78 ~ ., data = lalonde)

cv.error <- cv.glm(lalonde, glm.lalonde) #if it's k-fold, add k at the end
#compute MSE from delta
cv.error$delta[1]
```
