function [barRMSE] = plotLinearPolyLogistic(polyOut, useOrders)
%plotLinearPolyLogistic.m Plots the output of linearVsPolyLogisticFit as a
%bar plot with error
%
%ASM 10/15

%get number of orders 
orders = polyOut{1}.poly.orders;
nOrders = length(orders);

if nargin < 2 || isempty(useOrders)
    useOrders = 1:nOrders;
end

%get polynomial rmse (nMice x nOrders)
polyRMSE = cellfun(@(x) x.poly.RMSE, polyOut, 'UniformOutput', false);
polyRMSE = cat(2,polyRMSE{:})';
polyRMSE = polyRMSE(:,useOrders);
orders = orders(useOrders);

%get logistic rmse 
logRMSE = cellfun(@(x) x.logistic.RMSE,polyOut)';

%combine into single matrix 
barRMSE = cat(2, polyRMSE, logRMSE);

%% plot
figH = figure;
axH = axes; 

% plot bar plot with errors 
[barH, errH] = barwitherr(calcSEM(barRMSE), mean(barRMSE));

%beautify
beautifyPlot(figH, axH);

%xtick labels 
nOptions = size(barRMSE,2);
labels = cell(1,nOptions);
for label = 1:length(labels)
    if label < length(labels)
        labels{label} = sprintf('Polynomial order %d', orders(label));
    else
        labels{label} = 'Logistic';
    end
end
axH.XTickLabel = labels;
axH.XTickLabelRotation = -45;

%label axes 
axH.YLabel.String = 'Test RMSE';

%calculate significance 
groups = cell(nchoosek(nOptions,2),1);
pVal = nan(size(groups));
ind = 1;
for startVal = 1:nOptions
    for endVal = startVal + 1:nOptions
        [~,pVal(ind)] = ttest2(barRMSE(:,startVal),...
            barRMSE(:,endVal));
        groups{ind} = [startVal, endVal];
        ind = ind + 1;
    end
end
sigstar(groups,pVal);

%color plots 
% keyboard