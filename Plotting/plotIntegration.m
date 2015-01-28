function figH = plotIntegration(dataCell)

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



%create figure
figH = figure;

if flagWhite
    %calculate condition breakdown
    if flagCap
        numSeg = max(getCellVals(dataCell,'maze.numWhite'));
    else
        numSeg = max(getCellVals(dataCell,'maze.numwhite'));
    end
    numConds = numSeg + 1;
    percWhite = nan(1,numConds);
    numTrials = nan(1,numConds);
    numWhite = nan(1,numConds);
    pVal = nan(1,numConds);
    percCorr = nan(1,numConds);
    results = cell(1,numConds);
    for i=0:numSeg
        if flagCap
            trialSub = getTrials(dataCell,['maze.numWhite==',num2str(i)]);
        else
            trialSub = getTrials(dataCell,['maze.numwhite==',num2str(i)]);
        end
        percWhite(i+1) = 100*sum(findTrials(trialSub,'result.whiteTurn==1'))/length(trialSub);
        numTrials(i+1) = length(trialSub);
        numWhite(i+1) = sum(findTrials(trialSub,'result.whiteTurn==1'));

        if ~isempty(trialSub)
            %determine significance
            percCorr(i+1) = 100*sum(findTrials(trialSub,'result.correct==1'))/length(trialSub);
            results{i+1}(1,:) = getCellVals(trialSub,'maze.whiteTrial')';
            results{i+1}(2,:) = getCellVals(trialSub,'result.whiteTurn')';
            [dist] = shuffleTrialLabels(results{i+1},10000,false);
            pVal(i+1) = sum(dist >= (percCorr(i+1)/100))/size(dist,2);
        end
    end
else %left
    %calculate condition breakdown
    numSeg = max(getCellVals(dataCell,'maze.numLeft'));
    numConds = numSeg + 1;
    percLeft = nan(1,numConds);
    numTrials = nan(1,numConds);
    numLeft = nan(1,numConds);
    pVal = nan(1,numConds);
    percCorr = nan(1,numConds);
    results = cell(1,numConds);
    for i=0:numSeg
        trialSub = getTrials(dataCell,['maze.numLeft==',num2str(i)]);
        percLeft(i+1) = 100*sum(findTrials(trialSub,'result.leftTurn==1'))/length(trialSub);
        numTrials(i+1) = length(trialSub);
        numLeft(i+1) = sum(findTrials(trialSub,'result.leftTurn==1'));
        
        if ~isempty(trialSub)
            %determine significance
            percCorr(i+1) = 100*sum(findTrials(trialSub,'result.correct==1'))/length(trialSub);
            results{i+1}(1,:) = getCellVals(trialSub,'maze.leftTrial')';
            results{i+1}(2,:) = getCellVals(trialSub,'result.leftTurn')';
            [dist] = shuffleTrialLabels(results{i+1},10000,false);
            pVal(i+1) = sum(dist >= (percCorr(i+1)/100))/size(dist,2);
        end
    end
end

%plot data
integrationGUIData.intPlot = subplot('Position',[0.05 0.15 0.9 0.8]);
xlim([0 numSeg]);
if flagWhite
    integrationGUIData.intScatter = scatter(0:numSeg,percWhite,'MarkerFaceColor','b');
    ylabel('Percent Turns Toward White');
    xlabel('Number of White Dot Segments');
else
    integrationGUIData.intScatter = scatter(0:numSeg,percLeft,'MarkerFaceColor','b');
    ylabel('Percent Turns Toward Left');
    xlabel('Number of Left Dot Segments');
end
set(integrationGUIData.intPlot,'XTick',0:numSeg);
integrationGUIData.textMarkers = gobjects(3,numConds);
if flagWhite
    for i=1:numConds
        if percWhite(i) > 50
            integrationGUIData.textMarkers(1,i) = text(i-1,percWhite(i)-10,['n = ',num2str(numTrials(i))],'FontWeight','Bold');
            integrationGUIData.textMarkers(2,i) = text(i-1,percWhite(i)-5,[num2str(round(percWhite(i))),'%'],'FontWeight','Bold');
            if pVal(i) <= .001
                integrationGUIData.textMarkers(3,i) = text(i-1,percWhite(i)-14,'***','FontWeight','Bold');
            elseif pVal(i) <= .01
                integrationGUIData.textMarkers(3,i) = text(i-1,percWhite(i)-14,'**','FontWeight','Bold');
            elseif pVal(i) <= .05
                integrationGUIData.textMarkers(3,i) = text(i-1,percWhite(i)-14,'*','FontWeight','Bold');
            else
                integrationGUIData.textMarkers(3,i) = text(i-1,percWhite(i)-14,'N.S.','FontWeight','Bold');
            end
        else
            integrationGUIData.textMarkers(1,i) = text(i-1,percWhite(i)+10,['n = ',num2str(numTrials(i))],'FontWeight','Bold');
            integrationGUIData.textMarkers(2,i) = text(i-1,percWhite(i)+5,[num2str(round(percWhite(i))),'%'],'FontWeight','Bold');
            if pVal(i) <= .001
                integrationGUIData.textMarkers(3,i) = text(i-1,percWhite(i)+12,'***','FontWeight','Bold');
            elseif pVal(i) <= .01
                integrationGUIData.textMarkers(3,i) = text(i-1,percWhite(i)+12,'**','FontWeight','Bold');
            elseif pVal(i) <= .05
                integrationGUIData.textMarkers(3,i) = text(i-1,percWhite(i)+12,'*','FontWeight','Bold');
            else
                integrationGUIData.textMarkers(3,i) = text(i-1,percWhite(i)+12,'N.S.','FontWeight','Bold');
            end
        end
    end
else %left
    for i=1:numConds
        if percLeft(i) > 50
            integrationGUIData.textMarkers(1,i) = text(i-1,percLeft(i)-10,['n = ',num2str(numTrials(i))],'FontWeight','Bold');
            integrationGUIData.textMarkers(2,i) = text(i-1,percLeft(i)-5,[num2str(round(percLeft(i))),'%'],'FontWeight','Bold');
            if pVal(i) <= .001
                integrationGUIData.textMarkers(3,i) = text(i-1,percLeft(i)-14,'***','FontWeight','Bold');
            elseif pVal(i) <= .01
                integrationGUIData.textMarkers(3,i) = text(i-1,percLeft(i)-14,'**','FontWeight','Bold');
            elseif pVal(i) <= .05
                integrationGUIData.textMarkers(3,i) = text(i-1,percLeft(i)-14,'*','FontWeight','Bold');
            else
                integrationGUIData.textMarkers(3,i) = text(i-1,percLeft(i)-14,'N.S.','FontWeight','Bold');
            end
        else
            integrationGUIData.textMarkers(1,i) = text(i-1,percLeft(i)+10,['n = ',num2str(numTrials(i))],'FontWeight','Bold');
            integrationGUIData.textMarkers(2,i) = text(i-1,percLeft(i)+5,[num2str(round(percLeft(i))),'%'],'FontWeight','Bold');
            if pVal(i) <= .001
                integrationGUIData.textMarkers(3,i) = text(i-1,percLeft(i)+12,'***','FontWeight','Bold');
            elseif pVal(i) <= .01
                integrationGUIData.textMarkers(3,i) = text(i-1,percLeft(i)+12,'**','FontWeight','Bold');
            elseif pVal(i) <= .05
                integrationGUIData.textMarkers(3,i) = text(i-1,percLeft(i)+12,'*','FontWeight','Bold');
            else
                integrationGUIData.textMarkers(3,i) = text(i-1,percLeft(i)+12,'N.S.','FontWeight','Bold');
            end
        end
    end
end
ylim([0 100]);
axis square;

integrationGUIData.intPlot.XLabel.FontSize = 30;
integrationGUIData.intPlot.YLabel.FontSize = 30;
integrationGUIData.intPlot.FontSize = 20;
integrationGUIData.intScatter.SizeData = 100;
for i = 1:numel(integrationGUIData.textMarkers)
    integrationGUIData.textMarkers(i).FontSize = 20;
end
end
