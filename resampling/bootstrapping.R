library(arm)
data("lalonde")

#### Method 1: Without using boot, following the principles of bootstrapping
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

#### Method 2: Using BOOTSTRAPPING
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
