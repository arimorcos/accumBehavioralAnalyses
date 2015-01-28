function out = turnTrajSingleTrialDecode(binParam,nBins)
%performs a single trial, leave one out decode similar to that in
%turnTrajDecode, but maintains trial identity throughout

out.uniqueTrials = unique(vertcat(binParam.binDataTrialIDAll{:}));
nUniqueTrials = length(out.uniqueTrials);
out.accTheta = zeros(nUniqueTrials,nBins);
out.accXVel = zeros(nUniqueTrials,nBins);

for j = 1:nUniqueTrials % for each simulation
    
    %choose trial to remove
    trialID = out.uniqueTrials(j);
    
    for i = 1:nBins %for each bin
        
        %check whether it has all trials
        if nUniqueTrials ~= length(unique(binParam.binDataTrialIDAll{i})) %if doesn't have all trials
            out.accTheta(j,i) = NaN;
            out.accXVel(j,i) = NaN;
            continue;
        end
            
        %remove one trial and store both subset and test        
        ind = binParam.binDataTrialIDAll{i} == trialID;
        testTheta = mean(binParam.binDataThetaAll{i}(ind));
        testXVel = mean(binParam.binDataXVelAll{i}(ind));
        testTurnResult = binParam.binDataTurnAll{i}(ind);
        if length(unique(testTurnResult)) > 1
            error('different turns');
        else
            testTurnResult = testTurnResult(1);
        end
        subThetaLeft = binParam.binDataThetaAll{i}((1-ind) & binParam.binDataTurnAll{i});
        subXVelLeft = binParam.binDataXVelAll{i}((1-ind) & binParam.binDataTurnAll{i});
        subThetaRight = binParam.binDataThetaAll{i}((1-ind) & (1-binParam.binDataTurnAll{i}));
        subXVelRight = binParam.binDataXVelAll{i}((1-ind) & (1-binParam.binDataTurnAll{i}));
        
        %calculate mean value of subsets
        meanThetaLeft = mean(subThetaLeft);
        meanThetaRight = mean(subThetaRight);
        meanXVelLeft = mean(subXVelLeft);
        meanXVelRight = mean(subXVelRight);
        
        %check which is closer for theta
        if abs(meanThetaLeft - testTheta) < abs(meanThetaRight - testTheta) %if closer to left than right
            predTheta = 1;
        elseif abs(meanThetaLeft - testTheta) > abs(meanThetaRight - testTheta) %if closer to right than left
            predTheta = 0;
        else %if equal
            predTheta = randi([0 1]);
        end
        
        %check which is closer for xVel
        if abs(meanXVelLeft - testXVel) < abs(meanXVelRight - testXVel) %if closer to left than right
            predXVel = 1;
        elseif abs(meanXVelLeft - testXVel) > abs(meanXVelRight - testXVel) %if closer to right than left
            predXVel = 0;
        else %if equal
            predXVel = randi([0 1]);
        end
        
        %check whether prediction is accurate
        out.accXVel(j,i) = testTurnResult == predXVel;
        out.accTheta(j,i) = testTurnResult == predTheta;
    end
end