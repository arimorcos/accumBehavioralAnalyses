%convertToTableFormat.m

%function to convert procData structure into the proper table format based
%on the guiID 

%ASM 6/13/12

function [table] = convertToTableFormat(procData,guiID,lastX)
    
    if guiID == 1
        
        numConds = length(procData.nTrialsConds);
        
        %set table data
        table.data(1,1) = procData.nTrials;
        table.data(1,2) = procData.nTrialsLastX;
        table.data(2,1) = procData.nRewards;
        table.data(2,2) = procData.nRewardsLastX;
        table.data(3,1) = procData.percCorr;
        table.data(3,2) = procData.percCorrLastX;
        table.data(4,1) = procData.percLeft;
        table.data(4,2) = procData.percLeftLastX;
        table.data(5,1) = procData.percWhite;
        table.data(5,2) = procData.percWhiteLastX;
        table.data(6,1) = procData.trialsPerMin;
        table.data(6,2) = procData.trialsPerMinLastX;
        table.data(7,1) = procData.rewPerMin;
        table.data(7,2) = procData.rewPerMinLastX;
        table.data(8:8+numConds-1,1) = procData.percCorrConds;
        table.data(8:8+numConds-1,2) = procData.percCorrCondsLastX;
        table.data(8+numConds:8+2*numConds-1,1) = procData.nTrialsConds;
        table.data(8+numConds:8+2*numConds-1,2) = procData.nTrialsCondsLastX;
        table.data(8+2*numConds:8+3*numConds-1,1) = procData.nRewConds;
        table.data(8+2*numConds:8+3*numConds-1,2) = procData.nRewCondsLastX;
        table.data(8+3*numConds,1) = procData.meanTrialDur;
        table.data(8+3*numConds,2) = procData.meanTrialDurLastX;
        table.data(8+3*numConds+1,1) = procData.stdTrialDur;
        table.data(8+3*numConds+1,2) = procData.stdTrialDurLastX;
        table.data(8+3*numConds+2,1) = procData.nRewardsRec;
        table.data(8+3*numConds+2,2) = NaN;
        table.data(8+3*numConds+3,1) = procData.corrRes.leftPeak;
        table.data(8+3*numConds+3,2) = NaN;
        table.data(8+3*numConds+4,1) = procData.corrRes.leftLag;
        table.data(8+3*numConds+4,2) = NaN;
        table.data(8+3*numConds+5,1) = procData.corrRes.whitePeak;
        table.data(8+3*numConds+5,2) = NaN;
        table.data(8+3*numConds+6,1) = procData.corrRes.whiteLag;
        table.data(8+3*numConds+6,2) = NaN;
        
        %set column names
        table.colNames = {'All Trials', ['Last ',num2str(lastX),' Trials']};
        
        %generate strings for each condition
        [condStrings] = generateCondStrings(numConds);
        
        %set row names
        table.rowNames = ['Elapsed Time','nTrials','nRewards','Percent Correct','Percent Left','Percent White',...
            'Trials Per Minute','Rewards Per Minute',condStrings.percCorr,condStrings.trials,condStrings.rewards,...
            'Mean Trial Duration','Std of Trial Duration','Rewards Received','Left Peak Ratio','Left Lag',...
            'White Peak Ratio','White Lag'];
        
    elseif guiID == 2
        
        numConds = length(procData.nTrialsConds);
        
        %set table data
        table.data(1,1) = procData.nTrialsTower;
        table.data(1,2) = procData.nTrialsTowerLastX;
        table.data(2,1) = procData.nRewTower;
        table.data(2,2) = procData.nRewTowerLastX;
        table.data(3,1) = procData.percCorrTower;
        table.data(3,2) = procData.percCorrTowerLastX;
        table.data(4,1) = procData.nTrialsNoTower;
        table.data(4,2) = procData.nTrialsNoTowerLastX;
        table.data(5,1) = procData.nRewNoTower;
        table.data(5,2) = procData.nRewNoTowerLastX;
        table.data(6,1) = procData.percCorrNoTower;
        table.data(6,2) = procData.percCorrNoTowerLastX;
        table.data(7,1) = procData.percLeftTower;
        table.data(7,2) = procData.percLeftTowerLastX;
        table.data(8,1) = procData.percLeftNoTower;
        table.data(8,2) = procData.percLeftNoTowerLastX;
        table.data(9,1) = procData.percWhiteTower;
        table.data(9,2) = procData.percWhiteTowerLastX;
        table.data(10,1) = procData.percWhiteNoTower;
        table.data(10,2) = procData.percWhiteNoTowerLastX;
        table.data(11,1) = procData.trialsPerMinTower;
        table.data(11,2) = procData.trialsPerMinTowerLastX;
        table.data(12,1) = procData.trialsPerMinNoTower;
        table.data(12,2) = procData.trialsPerMinNoTowerLastX;
        table.data(13,1) = procData.rewardsPerMinTower;
        table.data(13,2) = procData.rewardsPerMinTowerLastX;
        table.data(14,1) = procData.rewardsPerMinNoTower;
        table.data(14,2) = procData.rewardsPerMinNoTowerLastX;
        table.data(15,1) = procData.nTrials;
        table.data(15,2) = procData.nTrialsLastX;
        table.data(16,1) = procData.nRewards;
        table.data(16,2) = procData.nRewardsLastX;
        table.data(17,1) = procData.percCorr;
        table.data(17,2) = procData.percCorrLastX;
        table.data(18,1) = procData.percLeft;
        table.data(18,2) = procData.percLeftLastX;
        table.data(19,1) = procData.percWhite;
        table.data(19,2) = procData.percWhiteLastX;
        table.data(20,1) = procData.trialsPerMin;
        table.data(20,2) = procData.trialsPerMinLastX;
        table.data(21,1) = procData.rewPerMin;
        table.data(21,2) = procData.rewPerMinLastX;
        table.data(22:22+numConds-1,1) = procData.percCorrConds;
        table.data(22:22+numConds-1,2) = procData.percCorrCondsLastX;
        table.data(22+numConds:22+2*numConds-1,1) = procData.nTrialsConds;
        table.data(22+numConds:22+2*numConds-1,2) = procData.nTrialsCondsLastX;
        table.data(22+2*numConds:22+3*numConds-1,1) = procData.nRewConds;
        table.data(22+2*numConds:22+3*numConds-1,2) = procData.nRewCondsLastX;
        table.data(22+3*numConds,1) = procData.meanDurTower;
        table.data(22+3*numConds,2) = procData.meanDurTowerLastX;
        table.data(22+3*numConds+1,1) = procData.meanDurNoTower;
        table.data(22+3*numConds+1,2) = procData.meanDurNoTowerLastX;
        table.data(22+3*numConds+2,1) = procData.stdDurTower;
        table.data(22+3*numConds+2,2) = procData.stdDurTowerLastX;
        table.data(22+3*numConds+3,1) = procData.stdDurNoTower;
        table.data(22+3*numConds+3,2) = procData.stdDurNoTowerLastX;
        table.data(22+3*numConds+4,1) = procData.meanTrialDur;
        table.data(22+3*numConds+4,2) = procData.meanTrialDurLastX;
        table.data(22+3*numConds+5,1) = procData.stdTrialDur;
        table.data(22+3*numConds+5,2) = procData.stdTrialDurLastX;
        table.data(22+3*numConds+6,1) = procData.corrRes.leftPeak;
        table.data(22+3*numConds+6,2) = NaN;
        table.data(22+3*numConds+7,1) = procData.corrRes.leftLag;
        table.data(22+3*numConds+7,2) = NaN;
        table.data(22+3*numConds+8,1) = procData.corrRes.whitePeak;
        table.data(22+3*numConds+8,2) = NaN;
        table.data(22+3*numConds+9,1) = procData.corrRes.whiteLag;
        table.data(22+3*numConds+9,2) = NaN;
        
        %set column names
        table.colNames = {'All Trials', ['Last ',num2str(lastX),' Trials']};
        
        %generate strings for each condition
        [condStrings] = generateCondStrings(numConds);
        
        %set row names
        table.rowNames = ['Elapsed Time','nTrials Tower','nRewards Tower','Percent Correct Tower',...
            'nTrials No Tower','nRewards No Tower','Percent Correct No Tower','Percent Left Tower','Percent Left No Tower',...
            'Percent White Tower','Percent White No Tower','Trials Per Minute Tower','Trials Per Minute No Tower',...
            'Rewards Per Minute Tower','Rewards Per Minute No Tower','nTrials Total','nRewards Total','Percent Correct Total',...
            'Percent Left Total','Percent White Total','Trials Per Minute Total','Rewards Per Minute Total',...
            condStrings.percCorr,condStrings.trials,condStrings.rewards,'Mean Trial Duration Tower','Mean Trial Duration No Tower',...
            'Std of Trial Duration Tower','Std of Trial Duration No Tower','Mean Trial Duration Total','Std of Trial Duration Total',...
            'Left Peak Ratio','Left Lag','White Peak Ratio','White Lag'];
        
    elseif guiID == 3
        numConds = length(procData.nTrialsConds);
        numDelays = length(procData.whichDelays);
        table.data = [];
        
        %set table data
        for i=numDelays:-1:1 
            x = size(table.data,1);
            table.data(x+1,1) = procData.delayData(i).nTrials;
            table.data(x+2,1) = procData.delayData(i).nRewards;
            table.data(x+3,1) = procData.delayData(i).percCorr;
            table.data(x+4,1) = procData.delayData(i).percLeft;
            table.data(x+5,1) = procData.delayData(i).percWhite;
            table.data(x+6,1) = procData.delayData(i).trialsPerMin;
            table.data(x+7,1) = procData.delayData(i).rewPerMin;
            table.data(x+1,2) = procData.delayDataLastX(i).nTrials;
            table.data(x+2,2) = procData.delayDataLastX(i).nRewards;
            table.data(x+3,2) = procData.delayDataLastX(i).percCorr;
            table.data(x+4,2) = procData.delayDataLastX(i).percLeft;
            table.data(x+5,2) = procData.delayDataLastX(i).percWhite;
            table.data(x+6,2) = procData.delayDataLastX(i).trialsPerMin;
            table.data(x+7,2) = procData.delayDataLastX(i).rewPerMin;
            for j=1:numConds
                table.data(x+5+3*j,1) = procData.delayData(i).percCorrConds(j);
                table.data(x+6+3*j,1) = procData.delayData(i).nTrialsConds(j);
                table.data(x+7+3*j,1) = procData.delayData(i).nRewConds(j);
                table.data(x+5+3*j,2) = procData.delayDataLastX(i).percCorrConds(j);
                table.data(x+6+3*j,2) = procData.delayDataLastX(i).nTrialsConds(j);
                table.data(x+7+3*j,2) = procData.delayDataLastX(i).nRewConds(j);
            end
            table.data(x+8+3*numConds,1) = procData.delayData(i).meanTrialDur;
            table.data(x+8+3*numConds+1,1) = procData.delayData(i).stdTrialDur;
        end
        x = size(table.data,1);
        table.data(x+1,1) = procData.nTrials;
        table.data(x+1,2) = procData.nTrialsLastX;
        table.data(x+2,1) = procData.nRewards;
        table.data(x+2,2) = procData.nRewardsLastX;
        table.data(x+3,1) = procData.percCorr;
        table.data(x+3,2) = procData.percCorrLastX;
        table.data(x+4,1) = procData.percLeft;
        table.data(x+4,2) = procData.percLeftLastX;
        table.data(x+5,1) = procData.percWhite;
        table.data(x+5,2) = procData.percWhiteLastX;
        table.data(x+6,1) = procData.trialsPerMin;
        table.data(x+6,2) = procData.trialsPerMinLastX;
        table.data(x+7,1) = procData.rewPerMin;
        table.data(x+7,2) = procData.rewPerMinLastX;
        table.data(x+8:x+8+numConds-1,1) = procData.percCorrConds;
        table.data(x+8:x+8+numConds-1,2) = procData.percCorrCondsLastX;
        table.data(x+8+numConds:x+8+2*numConds-1,1) = procData.nTrialsConds;
        table.data(x+8+numConds:x+8+2*numConds-1,2) = procData.nTrialsCondsLastX;
        table.data(x+8+2*numConds:x+8+3*numConds-1,1) = procData.nRewConds;
        table.data(x+8+2*numConds:x+8+3*numConds-1,2) = procData.nRewCondsLastX;
        table.data(x+8+3*numConds,1) = procData.meanTrialDur;
        table.data(x+8+3*numConds,2) = procData.meanTrialDurLastX;
        table.data(x+8+3*numConds+1,1) = procData.stdTrialDur;
        table.data(x+8+3*numConds+1,2) = procData.stdTrialDurLastX;
        table.data(x+8+3*numConds+2,1) = procData.nRewardsRec;
        table.data(x+8+3*numConds+2,2) = NaN;
        table.data(x+8+3*numConds+3,1) = procData.corrRes.leftPeak;
        table.data(x+8+3*numConds+3,2) = NaN;
        table.data(x+8+3*numConds+4,1) = procData.corrRes.leftLag;
        table.data(x+8+3*numConds+4,2) = NaN;
        table.data(x+8+3*numConds+5,1) = procData.corrRes.whitePeak;
        table.data(x+8+3*numConds+5,2) = NaN;
        table.data(x+8+3*numConds+6,1) = procData.corrRes.whiteLag;
        table.data(x+8+3*numConds+6,2) = NaN;
        
        if guiID == 4
            table.data(x+8+3*numConds+7,1) = procData.scaleFacCurr;
        end
        
        %set column names
        table.colNames = {'All Trials', ['Last ',num2str(lastX),' Trials']};
        
        %generate strings for each delay and condition
        [delayStrings] = generateDelayStrings(procData.whichDelays,numConds);
        [condStrings] = generateCondStrings(numConds);
        delayStrings = struct2cell(delayStrings);
        delayStringsAll = [];
        if length(procData.whichDelays) > 1
            for i=length(procData.whichDelays):-1:1
                delayStringsAll = cat(1,delayStringsAll,delayStrings(:,:,i));
            end
        else
            delayStringsAll = delayStrings;
        end
        delayStringsAll = delayStringsAll';
        
        %set row names
        table.rowNames = ['Elapsed Time',delayStringsAll,'nTrials','nRewards','Percent Correct','Percent Left','Percent White',...
            'Trials Per Minute','Rewards Per Minute',condStrings.percCorr,condStrings.trials,condStrings.rewards,...
            'Mean Trial Duration','Std of Trial Duration','Rewards Received','Left Peak Ratio','Left Lag',...
            'White Peak Ratio','White Lag'];
        if guiID == 4
            table.rowNames = [table.rowNames,'Scale Factor'];
        end
    elseif guiID == 4
        numConds = length(procData.nTrialsConds);
        numDelays = length(procData.whichDelays);
        table.data = [];
        
        %set table data
        table.data(1,1) = procData.scaleFacCurr;
        table.data(2,1) = procData.lengthFacCurr;
        table.data(3,1) = procData.scaleFacQuarts(3,1);
        table.data(4,1) = procData.scaleFacQuarts(1,1);
        table.data(5,1) = procData.scaleFacQuarts(2,1);
        table.data(6,1) = procData.scaleFacQuarts(3,2);
        table.data(7,1) = procData.scaleFacQuarts(1,2);
        table.data(8,1) = procData.scaleFacQuarts(2,2);
        table.data(9,1) = procData.scaleFacQuarts(3,3);
        table.data(10,1) = procData.scaleFacQuarts(1,3);
        table.data(11,1) = procData.scaleFacQuarts(2,3);
        table.data(12,1) = procData.scaleFacQuarts(3,4);
        table.data(13,1) = procData.scaleFacQuarts(1,4);
        table.data(14,1) = procData.scaleFacQuarts(2,4);
        table.data(15,1) = procData.scaleFacQuarts(3,5);
        table.data(16,1) = procData.scaleFacQuarts(1,5);
        table.data(17,1) = procData.scaleFacQuarts(2,5);
        table.data(1,2) = procData.scaleFacCurr;
        table.data(2,2) = procData.lengthFacCurr;
        table.data(3,2) = procData.scaleFacQuartsLastX(3,1);
        table.data(4,2) = procData.scaleFacQuartsLastX(1,1);
        table.data(5,2) = procData.scaleFacQuartsLastX(2,1);
        table.data(6,2) = procData.scaleFacQuartsLastX(3,2);
        table.data(7,2) = procData.scaleFacQuartsLastX(1,2);
        table.data(8,2) = procData.scaleFacQuartsLastX(2,2);
        table.data(9,2) = procData.scaleFacQuartsLastX(3,3);
        table.data(10,2) = procData.scaleFacQuartsLastX(1,3);
        table.data(11,2) = procData.scaleFacQuartsLastX(2,3);
        table.data(12,2) = procData.scaleFacQuartsLastX(3,4);
        table.data(13,2) = procData.scaleFacQuartsLastX(1,4);
        table.data(14,2) = procData.scaleFacQuartsLastX(2,4);
        table.data(15,2) = procData.scaleFacQuartsLastX(3,5);
        table.data(16,2) = procData.scaleFacQuartsLastX(1,5);
        table.data(17,2) = procData.scaleFacQuartsLastX(2,5);
        for i=numDelays:-1:1 
            x = size(table.data,1);
            table.data(x+1,1) = procData.delayData(i).nTrials;
            table.data(x+2,1) = procData.delayData(i).nRewards;
            table.data(x+3,1) = procData.delayData(i).percCorr;
            table.data(x+4,1) = procData.delayData(i).percLeft;
            table.data(x+5,1) = procData.delayData(i).percWhite;
            table.data(x+6,1) = procData.delayData(i).trialsPerMin;
            table.data(x+7,1) = procData.delayData(i).rewPerMin;
            table.data(x+1,2) = procData.delayDataLastX(i).nTrials;
            table.data(x+2,2) = procData.delayDataLastX(i).nRewards;
            table.data(x+3,2) = procData.delayDataLastX(i).percCorr;
            table.data(x+4,2) = procData.delayDataLastX(i).percLeft;
            table.data(x+5,2) = procData.delayDataLastX(i).percWhite;
            table.data(x+6,2) = procData.delayDataLastX(i).trialsPerMin;
            table.data(x+7,2) = procData.delayDataLastX(i).rewPerMin;
            for j=1:numConds
                table.data(x+5+3*j,1) = procData.delayData(i).percCorrConds(j);
                table.data(x+6+3*j,1) = procData.delayData(i).nTrialsConds(j);
                table.data(x+7+3*j,1) = procData.delayData(i).nRewConds(j);
                table.data(x+5+3*j,2) = procData.delayDataLastX(i).percCorrConds(j);
                table.data(x+6+3*j,2) = procData.delayDataLastX(i).nTrialsConds(j);
                table.data(x+7+3*j,2) = procData.delayDataLastX(i).nRewConds(j);
            end
            table.data(x+8+3*numConds,1) = procData.delayData(i).meanTrialDur;
            table.data(x+8+3*numConds+1,1) = procData.delayData(i).stdTrialDur;
        end
        x = size(table.data,1);
        table.data(x+1,1) = procData.nTrials;
        table.data(x+1,2) = procData.nTrialsLastX;
        table.data(x+2,1) = procData.nRewards;
        table.data(x+2,2) = procData.nRewardsLastX;
        table.data(x+3,1) = procData.percCorr;
        table.data(x+3,2) = procData.percCorrLastX;
        table.data(x+4,1) = procData.percLeft;
        table.data(x+4,2) = procData.percLeftLastX;
        table.data(x+5,1) = procData.percWhite;
        table.data(x+5,2) = procData.percWhiteLastX;
        table.data(x+6,1) = procData.trialsPerMin;
        table.data(x+6,2) = procData.trialsPerMinLastX;
        table.data(x+7,1) = procData.rewPerMin;
        table.data(x+7,2) = procData.rewPerMinLastX;
        table.data(x+8:x+8+numConds-1,1) = procData.percCorrConds;
        table.data(x+8:x+8+numConds-1,2) = procData.percCorrCondsLastX;
        table.data(x+8+numConds:x+8+2*numConds-1,1) = procData.nTrialsConds;
        table.data(x+8+numConds:x+8+2*numConds-1,2) = procData.nTrialsCondsLastX;
        table.data(x+8+2*numConds:x+8+3*numConds-1,1) = procData.nRewConds;
        table.data(x+8+2*numConds:x+8+3*numConds-1,2) = procData.nRewCondsLastX;
        table.data(x+8+3*numConds,1) = procData.meanTrialDur;
        table.data(x+8+3*numConds,2) = procData.meanTrialDurLastX;
        table.data(x+8+3*numConds+1,1) = procData.stdTrialDur;
        table.data(x+8+3*numConds+1,2) = procData.stdTrialDurLastX;
        table.data(x+8+3*numConds+2,1) = procData.nRewardsRec;
        table.data(x+8+3*numConds+2,2) = NaN;
        table.data(x+8+3*numConds+3,1) = procData.corrRes.leftPeak;
        table.data(x+8+3*numConds+3,2) = NaN;
        table.data(x+8+3*numConds+4,1) = procData.corrRes.leftLag;
        table.data(x+8+3*numConds+4,2) = NaN;
        table.data(x+8+3*numConds+5,1) = procData.corrRes.whitePeak;
        table.data(x+8+3*numConds+5,2) = NaN;
        table.data(x+8+3*numConds+6,1) = procData.corrRes.whiteLag;
        table.data(x+8+3*numConds+6,2) = NaN;
        
        %set column names
        table.colNames = {'All Trials', ['Last ',num2str(lastX),' Trials']};
        
        %generate strings for each delay and condition
        [delayStrings] = generateDelayStrings(procData.whichDelays,numConds);
        [condStrings] = generateCondStrings(numConds);
        delayStrings = struct2cell(delayStrings);
        delayStringsAll = [];
        if length(procData.whichDelays) > 1
            for i=length(procData.whichDelays):-1:1
                delayStringsAll = cat(1,delayStringsAll,delayStrings(:,:,i));
            end
        else
            delayStringsAll = delayStrings;
        end
        delayStringsAll = delayStringsAll';
        
        %set row names
        table.rowNames = ['Elapsed Time','Current Scale Factor','Current Length Factor','Percent Correct sF = 1',...
            'nTrials sF = 1','nRewards sF = 1','Percent Correct 0.75 <= sF < 1','nTrials 0.75 <= sF < 1',...
            'nRewards 0.75 <= sF < 1','Percent Correct 0.5 <= sF < 0.75','nTrials 0.5 <= sF < 0.75','nRewards 0.5 <= sF < 0.75',...
            'Percent Correct 0.25 <= sF < 0.5','nTrials 0.25 <= sF < 0.5','nRewards 0.25 <= sF < 0.5',...
            'Percent Correct 0 <= sF < 0.25','nTrials 0 <= sF < 0.25','nRewards 0 <= sF < 0.25',delayStringsAll,...
            'nTrials','nRewards','Percent Correct','Percent Left','Percent White','Trials Per Minute',...
            'Rewards Per Minute',condStrings.percCorr,condStrings.trials,condStrings.rewards,'Mean Trial Duration',...
            'Std of Trial Duration','Rewards Received','Left Peak Ratio','Left Lag','White Peak Ratio','White Lag'];
    elseif guiID == 5
        numConds = length(procData.nTrialsConds);
        
        %set table data
        table.data(1,1) = procData.greyFac;
        table.data(1,2) = procData.greyFac;
        table.data(2,1) = procData.nTrials;
        table.data(2,2) = procData.nTrialsLastX;
        table.data(3,1) = procData.nRewards;
        table.data(3,2) = procData.nRewardsLastX;
        table.data(4,1) = procData.percCorr;
        table.data(4,2) = procData.percCorrLastX;
        table.data(5,1) = procData.percLeft;
        table.data(5,2) = procData.percLeftLastX;
        table.data(6,1) = procData.percWhite;
        table.data(6,2) = procData.percWhiteLastX;
        table.data(7,1) = procData.trialsPerMin;
        table.data(7,2) = procData.trialsPerMinLastX;
        table.data(8,1) = procData.rewPerMin;
        table.data(8,2) = procData.rewPerMinLastX;
        table.data(9:9+numConds-1,1) = procData.percCorrConds;
        table.data(9:9+numConds-1,2) = procData.percCorrCondsLastX;
        table.data(9+numConds:9+2*numConds-1,1) = procData.nTrialsConds;
        table.data(9+numConds:9+2*numConds-1,2) = procData.nTrialsCondsLastX;
        table.data(9+2*numConds:9+3*numConds-1,1) = procData.nRewConds;
        table.data(9+2*numConds:9+3*numConds-1,2) = procData.nRewCondsLastX;
        table.data(9+3*numConds,1) = procData.meanTrialDur;
        table.data(9+3*numConds,2) = procData.meanTrialDurLastX;
        table.data(9+3*numConds+1,1) = procData.stdTrialDur;
        table.data(9+3*numConds+1,2) = procData.stdTrialDurLastX;
        table.data(9+3*numConds+2,1) = procData.nRewardsRec;
        table.data(9+3*numConds+2,2) = NaN;
        table.data(9+3*numConds+3,1) = procData.corrRes.leftPeak;
        table.data(9+3*numConds+3,2) = NaN;
        table.data(9+3*numConds+4,1) = procData.corrRes.leftLag;
        table.data(9+3*numConds+4,2) = NaN;
        table.data(9+3*numConds+5,1) = procData.corrRes.whitePeak;
        table.data(9+3*numConds+5,2) = NaN;
        table.data(9+3*numConds+6,1) = procData.corrRes.whiteLag;
        table.data(9+3*numConds+6,2) = NaN;
        
        %set column names
        table.colNames = {'All Trials', ['Last ',num2str(lastX),' Trials']};
        
        %generate strings for each condition
        [condStrings] = generateCondStrings(numConds);
        
        %set row names
        table.rowNames = ['Elapsed Time','greyFac','nTrials','nRewards','Percent Correct','Percent Left','Percent White',...
            'Trials Per Minute','Rewards Per Minute',condStrings.percCorr,condStrings.trials,condStrings.rewards,...
            'Mean Trial Duration','Std of Trial Duration','Rewards Received','Left Peak Ratio','Left Lag',...
            'White Peak Ratio','White Lag'];
    end
end