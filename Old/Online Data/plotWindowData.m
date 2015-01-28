%plotWindowData.m

%function to plot the data from the sliding window 

%ASM 6/13/12

function [guiObjects] = plotWindowData(procWinData,guiID,checks,guiObjects)
    
    warning('off','MATLAB:legend:PlotEmpty');
    if unique(structfun(@(x) x,checks)) == 0
        set(guiObjects.nothingChecked,'visible','on');
    else
        set(guiObjects.nothingChecked,'visible','off');
    end
    
    xTimes = 1:size(procWinData.winTrials,2);
    
    %reshape data
    [procWinData xTimes] = shiftWin(procWinData,xTimes,guiID);
    
    xTimes = xTimes/procWinData.totTime;
    
    guiObjects.windowPlot = subplot('Position',[0.05 0.68 0.9 0.26]);
    cla reset;
    
    if checks.trialCheck && checks.percCorrCheck && guiID ~= 2
        [ax h1 h2] = plotyy(xTimes,procWinData.winPercRewards,xTimes,procWinData.winTrials);
        set(h1,'Color','b');
        set(h2,'Color','r');
    elseif checks.percCorrCheck && ~checks.trialCheck
        percCorrPlot = plot(xTimes,procWinData.winPercRewards,'b');
    end
    hold on
    
    if checks.trialCheck && ~checks.percCorrCheck
        [ax h1 h2] = plotyy(xTimes,procWinData.winPercRewards,xTimes,procWinData.winTrials);
        set(h1,'Color','b');
        set(h2,'Color','r');
        delete(h1);
    end
    
    if guiID == 2 && checks.percCorrCheck && checks.trialCheck
        [ax h1 h2] = plotyy(xTimes,procWinData.winPercRewardsTower,xTimes,procWinData.winTrials);
        set(h1,'Color','b');
        set(h2,'Color','r');
        hold on;
        noTowerPlot = plot(xTimes,procWinData.winPercRewardsNoTower,'m');
    elseif guiID == 2 && checks.percCorrCheck && ~checks.trialCheck
        TowerPlot = plot(xTimes,procWinData.winPercRewardsTower,'b');
        hold on;
        noTowerPlot = plot(xTimes,procWinData.winPercRewardsNoTower,'m');
    end
    
    if checks.leftCheck
        leftPlot = plot(xTimes,procWinData.winPercLeft,'g');
        fracLeftPlot = plot(xTimes,procWinData.winFracLeft,'k');
    end
    
    if checks.whiteCheck
        whitePlot = plot(xTimes,procWinData.winPercWhite,'g:');
        fracWhitePlot = plot(xTimes,procWinData.winFracWhite,'k:');
    end
    
    %generate legend strings
    legStrings = {};
    if guiID == 2 && checks.percCorrCheck
        legStrings{length(legStrings)+1} = 'Tower';
        legStrings{length(legStrings)+1} = 'No Tower';
    elseif guiID ~= 2 && checks.percCorrCheck
        legStrings{length(legStrings)+1} = 'Percent Correct';
    end
    if checks.leftCheck
        legStrings{length(legStrings)+1} = 'Left Turns';
        legStrings{length(legStrings)+1} = 'Fraction Left Trials';
    end
    if checks.whiteCheck
        legStrings{length(legStrings)+1} = 'White Turns';
        legStrings{length(legStrings)+1} = 'Fraction White Trials';
    end
    if checks.trialCheck 
        legStrings{length(legStrings)+1} = 'Trials';
    end
    
    if checks.legendCheck
        legend(legStrings,'Location','SouthWest');
    end
    
    if checks.trialCheck
        set(get(ax(1),'Ylabel'),'String','Percent Correct','Color','k');
        set(ax(1),'ylim',[0 100],'YColor','k','ytick',0:10:100,'xlim',[0 1]);
        set(get(ax(2),'Ylabel'),'String','Number of Trials','Color','r');
        set(ax(2),'ylim',[0 50],'ytick',0:5:50,'yticklabel',0:5:50,'YColor','r','xlim',[0 1]);
        set(ax(1),'XTickLabel','')
        set(ax(2),'XTickLabel','')
    else
        ylabel('Percent Correct');
        ylim([0 100]);
        set(gca,'ytick',0:10:100);
        xlim([0 1]);
        set(gca,'XTickLabel','');
    end
    
    if guiID == 3 || guiID == 4
        lineHan = gobjects(1,size(procWinData.delayInd,2));
        for i=1:size(procWinData.delayInd,2)
            lineHan(i) = line([procWinData.delayInd(1,i)/procWinData.totTime procWinData.delayInd(1,i)/procWinData.totTime],[0 100]);
            set(lineHan(i),'Color','k','LineStyle','--');
            text((procWinData.delayInd(1,i)/procWinData.totTime)+0.01,5,[num2str(procWinData.delayInd(2,i)),'%'],'HorizontalAlignment','Left'); 
        end
    end
    
    title('Trials Throughout Session')
        
end
    
    