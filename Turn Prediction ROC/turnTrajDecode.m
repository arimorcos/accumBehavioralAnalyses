function out = turnTrajDecode(binParam, nBins)
%performs leave one out prediction by calculating mean trajectories leaving
%a single trial out and then testing prediction accuracy by looking at
%shortest distance to mean

out.accTheta = zeros(1,nBins);
out.accXVel = zeros(1,nBins);
out.allTheta = cell(1,nBins);
out.allXVel = cell(1,nBins);

for i = 1:nBins %for each bin
    
    nSim = length(binParam.binDataThetaAll{i});
    binPredCorrXVel = zeros(1,nSim);
    binPredCorrTheta = zeros(1,nSim);
    
    parfor j = 1:nSim % for each simulation
        
        %remove one value and store both subset and test
        ind = zeros(1,nSim);
        ind(randi(nSim)) = 1;
        ind = logical(ind)';
        testTheta = binParam.binDataThetaAll{i}(ind);
        testXVel = binParam.binDataXVelAll{i}(ind);
        testTurnResult = binParam.binDataTurnAll{i}(ind);
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
        binPredCorrXVel(j) = testTurnResult == predXVel;
        binPredCorrTheta(j) = testTurnResult == predTheta;
    end
    
    out.accTheta(i) = 100*sum(binPredCorrTheta)/nSim;
    out.accXVel(i) = 100*sum(binPredCorrXVel)/nSim;
    out.allTheta{i} = binPredCorrTheta;
    out.allXVel{i} = binPredCorrXVel;
end
            
        