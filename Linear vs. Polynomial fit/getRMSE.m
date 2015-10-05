function rmse = getRMSE(y, yhat)

rmse = sqrt(nanmean((y - yhat).^2));