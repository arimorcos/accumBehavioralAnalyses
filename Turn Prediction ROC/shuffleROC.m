function [shuffleMean, shuffleSTD, data] = shuffleROC(binParam,nSim)
%shuffleROC.m function to shuffle trial labels to create shuffled ROC 
%
%binParam - parameters output by binRunParam.m
%nSim - number of simulations

%get nBins
nBins = length(binParam.binDataTurnAll);

%initialize array
data.xVel = zeros(nSim,nBins);
data.theta = zeros(nSim,nBins);

for i = 1:nSim %for each simulation
    
    for j = 1:nBins %for each bin
        
        if length(unique(binParam.binDataTurnAll{j})) == 1 
            data.xVel(i,j) = NaN;
            data.theta(i,j) = NaN;
            continue;
        end
        
        %shuffle turnLabels
        tempTurns = randsample(...
            binParam.binDataTurnAll{j},length(binParam.binDataTurnAll{j})); %resample turn labels, keeping internal statistics constant
        
        %perform ROC on shuffled data
        [~,~,~,data.xVel(i,j)] = perfcurve(tempTurns,...
            binParam.binDataXVelAll{j},0);
        [~,~,~,data.theta(i,j)] = perfcurve(tempTurns,...
            binParam.binDataThetaAll{j},1);
        
    end
    display(['Shuffle Iteration: ',num2str(i)]);
    
end

shuffleMean.xVel = mean(data.xVel);
shuffleSTD.xVel = std(data.xVel);
shuffleMean.theta = mean(data.theta);
shuffleSTD.theta = std(data.theta);