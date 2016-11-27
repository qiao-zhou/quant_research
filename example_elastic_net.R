library(glmnet)
setwd("c:/dev/quant_research")

rmse <- function(obs, sim)
{
  error = obs - sim
  sqrt(mean(error^2))
}



R = read.table(file = "data/12_Industry_Portfolios.CSV",header = T, sep=",",skip = 11, nrows = 1057)
colnames(R)[5]

nrows = dim(R)[1]
ncols = dim(R)[2]
in_sample = seq(1,300)
out_of_sample = seq(300,nrows)

drops <- c("Date","Enrgy") 
x = as.matrix(R[ , !(names(R) %in% drops)])
y = as.matrix(R[,"Enrgy"])

x_in = as.matrix(x[in_sample,])
y_in = as.matrix(y[in_sample])

x_out = as.matrix(x[out_of_sample,])
y_out = as.matrix(y[out_of_sample])


fit = glmnet(x_in,y_in,family = "gaussian",intercept = T, standardize = T, alpha=1)
plot(fit,label = T)


#unconstrained regression coefficients (when the lasso constraint is not binding)
round(sort(fit$beta[,length(fit$lambda)]), digits=2)

#cross validation 
cvfit = cv.glmnet(x_in,y_in,nfolds = 10, family= "gaussian",lambda = fit$lambda)
plot(cvfit, sign.lambda = -1)

#alpha=1 is the lasso penalty, and alpha=0 the ridge penalty
#lambda.min value of lambda that gives minimum cvm
#lambda.1se largest value of lambda such that error is within 1 standard error of the minimum.
lambda_min = cvfit$lambda.min
sprintf("Optimal lambda: %4.4f", lambda_min)

#variable selection: best cross-validation in-sample fit
betas = round(fit$beta[,which(cvfit$lambda==lambda_min)],digits=2)
print(betas)
a0 = fit$a0[which(cvfit$lambda==cvfit$lambda.min)]

# making predictions using the lambda that gives minimum cv min 
y_in_hat = predict(cvfit,newx=x_in, s="lambda.min")
#y_in_hat = (cbind(a0 = 1, x_in)) %*% c(a0,betas)
y_out_hat = predict(cvfit,newx=x_out, s="lambda.min")


plot(y_in,y_in_hat)
plot(y_out,y_out_hat)

# fit the same model using simple ols 
fit_ols <- lm(y_in ~ x_in)
y_in_ols = cbind(a0=1,x_in) %*% fit_ols$coefficients
y_out_ols = cbind(a0=1,x_out) %*% fit_ols$coefficients

plot(y_in,y_in_ols)
plot(y_out,y_out_ols)

# compare the in-sample and out-of-sample prediction error measured by RMSE
rmse(y_in,y_in_ols)
rmse(y_in,y_in_hat)

rmse(y_out,y_out_ols)
rmse(y_out,y_out_hat)
