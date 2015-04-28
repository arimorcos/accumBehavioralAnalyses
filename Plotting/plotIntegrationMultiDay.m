function [figH,axH] = plotIntegrationMultiDay(indDataCells,figH,axH,colorToPlot,...
    shouldFit,filterBegEnd,shouldJitter,indLines)
%plotIntegrationMultiDay.m Plots integration data over multiple days with
%error bars representing std for each point
%
%INPUTS
%indDataCells - cell array of dataCells for each day. 
%figH - figure to plot in
%axH - axes to plot in
%colorToPlot - color to plot in
%shouldFit - should add fit
%filtBegEnd - trials to filter at beginning and end. 1 x 2 vector
%shouldJitter - should add jitter
%indLines - should plot individual lines for each session along with mean
%
%OUTPUTS
%figH - figure plotted in
%axH - axes plotted in
%
%ASM 7/14

%check for axes inputs
if nargin < 8 || isempty(indLines)
    indLines = false;
end
if nargin < 7 || isempty(shouldJitter)
    shouldJitter = false;
end
if nargin < 6 || isempty(filterBegEnd)
    filterBegEnd = [20 20];
end
if nargin < 5 || isempty(shouldFit) 
    shouldFit = true;
end
if nargin < 4 || isempty(colorToPlot)
    colorToPlot = [0 0 1];
end
if nargin < 2 || isempty(figH) 
    figH = figure;
    axH = axes;
elseif nargin < 3 || isempty(axH) 
    axH = axes;
else
    set(0,'CurrentFigure',figH);
    axes(axH);
end

%get number of days
nDays = length(indDataCells);

markSize = 12;

%loop through each day and get info.
percLeft = [];
percWhite = [];
numWhite = [];
numLeft = [];
numTrials = [];
for dayInd = 1:nDays
    
    %get dataCell subset
    dataCell = indDataCells{dayInd};
    dataCell = dataCell(filterBegEnd(1)+1:end-filterBegEnd(2)+1);
    dataCell = getTrials(dataCell,'maze.crutchTrial==0');

    if ~isfield(dataCell{1}.maze,'numWhite') &&...
            ~isfield(dataCell{1}.maze,'numwhite') && ~isfield(dataCell{1}.maze,'numLeft')
        warndlg('This maze does not contain any integration data');
        return
    end

    if isfield(dataCell{1}.maze,'numWhite')
        flagCap = true;
        flagWhite = true;
    elseif isfield(dataCell{1}.maze,'numwhite')
        flagCap = false;
        flagWhite = true;
    elseif isfield(dataCell{1}.maze,'numLeft')
        flagCap = true;
        flagWhite = false;    
    end

    if flagWhite
        %calculate condition breakdown
        if flagCap
            numSeg = max(getCellVals(dataCell,'maze.numWhite'));
        else
            numSeg = max(getCellVals(dataCell,'maze.numwhite'));
        end
        numConds = numSeg + 1;
        percWhiteTemp = nan(1,numConds);
        numTrialsTemp = nan(1,numConds);
        numWhiteTemp = nan(1,numConds);
%         pVal = nan(1,numConds);
%         percCorr = nan(1,numConds);
%         results = cell(1,numConds);
        for i=0:numSeg
            if flagCap
                trialSub = getTrials(dataCell,['maze.numWhite==',num2str(i)]);
            else
                trialSub = getTrials(dataCell,['maze.numwhite==',num2str(i)]);
            end
            percWhiteTemp(i+1) = 100*sum(findTrials(trialSub,'result.whiteTurn==1'))/length(trialSub);
            numTrialsTemp(i+1) = length(trialSub);
            numWhiteTemp(i+1) = sum(findTrials(trialSub,'result.whiteTurn==1'));

%             if ~isempty(trialSub)
%                 %determine significance
%                 percCorr(i+1) = 100*sum(findTrials(trialSub,'result.correct==1'))/length(trialSub);
%                 results{i+1}(1,:) = getCellVals(trialSub,'maze.whiteTrial')';
%                 results{i+1}(2,:) = getCellVals(trialSub,'result.whiteTurn')';
%                 [dist] = shuffleTrialLabels(results{i+1},10000,false);
%                 pVal(i+1) = sum(dist >= (percCorr(i+1)/100))/size(dist,2);
%             end
        end
        percWhite = cat(1,percWhite,percWhiteTemp);
        numWhite = cat(1,numWhite,numWhiteTemp);
        numTrials = cat(1,numTrials,numTrialsTemp);
    else %left
        %calculate condition breakdown
        numSeg = max(getCellVals(dataCell,'maze.numLeft'));
        numConds = numSeg + 1;
        percLeftTemp = nan(1,numConds);
        numTrialsTemp = nan(1,numConds);
        numLeftTemp = nan(1,numConds);
%         pVal = nan(1,numConds);
%         percCorr = nan(1,numConds);
%         results = cell(1,numConds);
        for i=0:numSeg
            trialSub = getTrials(dataCell,['maze.numLeft==',num2str(i)]);
            percLeftTemp(i+1) = 100*sum(findTrials(trialSub,'result.leftTurn==1'))/length(trialSub);
            numTrialsTemp(i+1) = length(trialSub);
            numLeftTemp(i+1) = sum(findTrials(trialSub,'result.leftTurn==1'));

%             if ~isempty(trialSub)
%                 %determine significance
%                 percCorr(i+1) = 100*sum(findTrials(trialSub,'result.correct==1'))/length(trialSub);
%                 results{i+1}(1,:) = getCellVals(trialSub,'maze.leftTrial')';
%                 results{i+1}(2,:) = getCellVals(trialSub,'result.leftTurn')';
%                 [dist] = shuffleTrialLabels(results{i+1},10000,false);
%                 pVal(i+1) = sum(dist >= (percCorr(i+1)/100))/size(dist,2);
%             end
        end
        percLeft = cat(1,percLeft,percLeftTemp);
        numLeft = cat(1,numLeft,numLeftTemp);
        numTrials = cat(1,numTrials,numTrialsTemp);
    end
end

xVals = 0:numSeg;
if shouldJitter
    xVals = xVals + 0.1*randn(size(xVals));
end
if flagWhite
    whiteSTD = nanstd(percWhite);
    if indLines
        hold on;
               
%         grayColors = bsxfun(@times,ones(length(indDataCells),3),linspace(50,200,length(indDataCells))')/255;
        grayColors = ones(length(indDataCells),3)*0.5;
        for i = 1:length(indDataCells) %for each day
            xVals = 0:numSeg;
            if shouldJitter
                xVals = xVals + 0.1*randn(size(xVals));
            end
            
            plot(xVals,percWhite(i,:),'o','LineStyle','none','MarkerFaceColor',grayColors(i,:),...
                'MarkerEdgeColor',grayColors(i,:),'MarkerSize',markSize);
            if shouldFit
%                 b = glmfit(0:numSeg,[numWhite(i,:)' numTrials(i,:)'],'binomial','link','probit');
%                 yfit = glmval(b,0:0.001:numSeg,'probit');
%                 plotH = plot(0:0.001:numSeg,100*yfit,'Color',grayColors(i,:),'LineWidth',2);
                [alpha,beta,xValsFit,yValsFit] = fitLogisticPAL(0:numSeg,numWhite(i,:),numTrials(i,:));
                plotH = plot(xValsFit,100*yValsFit,'Color',grayColors(i,:),'LineWidth',2);
                set(get(get(plotH,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
            end
        end
        plot(xVals,nanmean(percWhite),'o','LineStyle','none','MarkerFaceColor',colorToPlot,...
            'MarkerEdgeColor',colorToPlot,'MarkerSize',markSize);
        if shouldFit
%             b = glmfit(0:numSeg,[mean(numWhite)' mean(numTrials)'],'binomial','link','probit');
%             yfit = glmval(b,0:0.001:numSeg,'probit');
            [alpha,beta,xValsFit,yValsFit] = fitLogisticPAL(0:numSeg,mean(numWhite),mean(numTrials));
            plotH = plot(xValsFit,100*yValsFit,'Color',colorToPlot,'LineWidth',2);
            set(get(get(plotH,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
        end
    else
        if length(indDataCells) > 1
            errorbar(xVals,nanmean(percWhite),whiteSTD,'o','LineStyle','none',...
                'MarkerFaceColor',colorToPlot,'MarkerEdgeColor',colorToPlot,'LineWidth',1.4,...
                'Color',colorToPlot);
        else
            plot(xVals,percLeft,'o','LineStyle','none','MarkerFaceColor',colorToPlot,...
                'MarkerEdgeColor',colorToPlot);
        end
    end
    ylabel('Percent Turns Toward White');
    xlabel('Number of White Dot Segments');
else
    leftSTD = calcSEM(percLeft);
    
    if indLines
        
        hold on;       
%         grayColors = bsxfun(@times,ones(length(indDataCells),3),linspace(50,200,length(indDataCells))')/255;
        grayColors = ones(length(indDataCells),3)*0.5;
        for i = 1:length(indDataCells) %for each day
            xVals = 0:numSeg;
            if shouldJitter
                xVals = xVals + 0.1*randn(size(xVals));
            end
            
            plot(xVals,percLeft(i,:),'o','LineStyle','none','MarkerFaceColor',grayColors(i,:),...
                'MarkerEdgeColor',grayColors(i,:),'MarkerSize',markSize);
            if shouldFit
%                 b = glmfit(0:numSeg,[numLeft(i,:)' numTrials(i,:)'],'binomial','link','probit');
%                 yfit = glmval(b,0:0.001:numSeg,'probit');
                [alpha,beta,xValsFit,yValsFit] = fitLogisticPAL(0:numSeg,numLeft(i,:),numTrials(i,:));
                plotH = plot(xValsFit,100*yValsFit,'Color',grayColors(i,:),'LineWidth',2);
                set(get(get(plotH,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
            end
        end
        plot(xVals,nanmean(percLeft),'o','LineStyle','none','MarkerFaceColor',colorToPlot,...
            'MarkerEdgeColor',colorToPlot,'MarkerSize',markSize);
        if shouldFit
%             b = glmfit(0:numSeg,[mean(numLeft)' mean(numTrials)'],'binomial','link','probit');
%             yfit = glmval(b,0:0.001:numSeg,'probit');
            [alpha,beta,xValsFit,yValsFit] = fitLogisticPAL(0:numSeg,mean(numLeft),mean(numTrials));
            plotH = plot(xValsFit,100*yValsFit,'Color',colorToPlot,'LineWidth',2);
            set(get(get(plotH,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
        end
    else
        if length(indDataCells) > 1
            errorbar(xVals,nanmean(percLeft),leftSTD,'o','LineStyle','none',...
                'MarkerFaceColor',colorToPlot,'MarkerEdgeColor',colorToPlot,'LineWidth',1.4,...
                'Color',colorToPlot);
        else
            plot(xVals,percLeft,'o','LineStyle','none','MarkerFaceColor',colorToPlot,...
                'MarkerEdgeColor',colorToPlot);
        end
    end
    ylabel('Percent Turns Toward Left');
    xlabel('Number of Left Dot Segments');
end
set(gca,'XTick',0:numSeg);
xlim([-0.5 numSeg+0.5]);
ylim([0 100]);
% title('Integration Breakdown');
axis square;

%add fit line
if shouldFit && ~indLines
    hold on;
    if flagWhite
        [alpha,beta,xValsFit,yValsFit] = fitLogisticPAL(0:numSeg,mean(numWhite),mean(numTrials));
%         b = glmfit(0:numSeg,[mean(numWhite)' mean(numTrials)'],'binomial','link','probit');
    else
        [alpha,beta,xValsFit,yValsFit] = fitLogisticPAL(0:numSeg,mean(numLeft),mean(numTrials));
%         b = glmfit(0:numSeg,[mean(numLeft)' mean(numTrials)'],'binomial','link','probit');
    end
%     yfit = glmval(b,0:0.001:numSeg,'probit');
    plotH = plot(xValsFit,100*yValsFit,'Color',colorToPlot,'LineWidth',2);
    set(get(get(plotH,'Annotation'),'LegendInformation'),'IconDisplayStyle','off')
end