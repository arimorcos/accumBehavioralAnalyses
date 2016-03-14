function [linear, logistic] = get_linear_poly(indDataCells)
%GET_LINEAR_POLY Summary of this function goes here
%   Detailed explanation goes here

num_sessions = length(indDataCells);
linear = nan(num_sessions, 1);
logistic = nan(num_sessions, 1);

for i = 1:num_sessions
    out = linearVsPolyLogisticBehavFit(indDataCells{i});
    linear(i) = out.poly.RMSE(1);
    logistic(i) = out.logistic.RMSE;
end

