### CROSS VALIDATION method
library(Matching)
library(arm)
data("lalonde")

glm.lalonde = glm(re78 ~ ., data = lalonde)

cv.error <- cv.glm(lalonde, glm.lalonde) #if it's k-fold, add k at the end
#compute MSE from delta
cv.error$delta[1]
