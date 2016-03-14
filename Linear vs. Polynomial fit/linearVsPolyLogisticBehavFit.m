function out = linearVsPolyLogisticBehavFit(dataCell, trainFrac)
%linearVsPolyLogisticBehavFit.m Divides dataCell into train and test set
%and attempts fits with different polynomial orders and a logistic fit. 
%
%INPUTS
%dataCell - dataCell to fit 
%trainFrac - training fraction. Default is 0.5
%
%OUTPUTS
%out - output structure containing fields:
%   poly - polynomial data 
%       orders - array of polynomial orders
%       RMSE - root mean squared error on test set
%   logistic - logistic data
%       RMSE - root mean squared error on test set
%       alpha - threshold parameter for logistic
%       beta - slope parameter for logistic
%
%ASM 10/15


if nargin < 2 || isempty(trainFrac)
    trainFrac = 0.5;
end

verbose = false;
shouldPlot = false;

%% get behavior in each condition
nSeg = 6;
nTrials = length(dataCell);
nTrainTrials = round(trainFrac*nTrials);
trainTrials = randsample(nTrials, nTrainTrials);
testTrials = setdiff(1:nTrials, trainTrials);

[trainPerf,trainLeft,trainTrialsNum] = getPerf(dataCell(trainTrials));
testPerf = getPerf(dataCell(testTrials));


%% perform fit on averaged left turns

orders = 1:4;

if shouldPlot
    figure;
    hold on;
    scatter(0:6,testPerf);
    scatter(0:6,trainPerf,'r');
end
polyRMSE = nan(length(orders),1);
for order = orders
    predictors = repmat((0:nSeg)',1,order);
    for i = 1:order
        predictors(:,i) = predictors(:,i).^i;
    end
    
    %fit model
    linModel = fitlm(predictors, trainPerf);
    
    %plot
    yPred = predict(linModel,predictors);
    if shouldPlot
        plotH = plot(0:6,yPred);
        plotH.Tag = sprintf('Polynomial Order %d',order);
    end
    
    polyRMSE(order) = getRMSE(yPred,testPerf);
    
    if verbose
        %print
        fprintf('Order: %d, train RMSE: %0.3f\n', order, polyRMSE(order));
    end
end
out.poly.RMSE = polyRMSE;
out.poly.orders = orders;

% add logistic fit
[alpha,beta,xValsFit,yValsFit] = fitLogisticPAL(0:nSeg,trainLeft',trainTrialsNum');
if shouldPlot
    plotH = plot(xValsFit,yValsFit,'k');
    plotH.Tag = 'Logistic';
end
out.logistic.alpha = alpha;
out.logistic.beta = beta;
out.logistic.RMSE = getRMSE(yValsFit(ismember(xValsFit,0:nSeg)),testPerf');
if verbose
    fprintf('Logistic train RMSE: %0.3f\n', ...
        out.logistic.RMSE);
end
axis square; 

