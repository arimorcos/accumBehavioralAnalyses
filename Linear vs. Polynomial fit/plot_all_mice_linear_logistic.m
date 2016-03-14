num_mice = length(linear);

figH = figure;
axH = axes;
hold(axH, 'on');

for i = 1:num_mice
    
    mean_linear = mean(linear{i});
    sem_linear = calcSEM(linear{i});
    mean_logistic = mean(logistic{i});
    sem_logistic = calcSEM(logistic{i});
    
    %plot 
    errH = errorbar([1, 2], [mean_linear, mean_logistic],...
        [sem_linear, sem_logistic]);
    errH.Marker = 'o';
    errH.MarkerFaceColor = errH.MarkerEdgeColor;
    
end

beautifyPlot(figH, axH);

axH.XTick = [1 2];
axH.XLim = [0.5 2.5];
axH.XTickLabel = {'Linear fit', 'Logistic fit'};
axH.XTickLabelRotation = -45;
axH.YLabel.String = 'Fit RMSE';