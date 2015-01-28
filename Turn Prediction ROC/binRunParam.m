function out = binRunParam(in,nBins,segmented)
    
    %create bins by linearly separating yPos
    out.yPosBinInd = linspace(min(in.yPosAll),max(in.yPosAll),nBins+1);
    
    
    if segmented
        %initialize arrays to have as many rows as there are evidence types
        %(nSeg + 1) and as many columns as there are bins (
        out.meanTheta = zeros(in.numSeg+1,nBins);
        out.meanXVel = zeros(size(out.meanTheta));
        out.stdTheta = zeros(size(out.meanTheta));
        out.stdXVel = zeros(size(out.meanTheta));
        out.binDataThetaEv = cell(size(out.meanTheta));
        out.binDataXVelEv = cell(size(out.meanTheta));
        out.binDataTurnEv = cell(size(out.meanTheta));
    end
    
    %initialize binDataAll cells
    out.binDataThetaAll = cell(1,nBins);
    out.binDataXVelAll = cell(1,nBins);
    out.binDataTurnAll = cell(1,nBins);
    out.binDataTrialIDAll = cell(1,nBins);
    out.meanYPosAll = zeros(1,nBins);
    uniqueTrials = unique(in.trialIDAll);
    nUnique = length(uniqueTrials);
    
    
    for i=1:nBins %for each bin
        
        %generate logical denoting which indices are at correct
        %position
        posInd = in.yPosAll >= out.yPosBinInd(i) & in.yPosAll < out.yPosBinInd(i+1);
        
        out.binDataThetaAll{i} = grpstats(in.thetaAll(posInd),in.trialIDAll(posInd));
        out.binDataXVelAll{i} = grpstats(in.xVelAll(posInd),in.trialIDAll(posInd));
        out.binDataTurnAll{i} = grpstats(in.turnAll(posInd),in.trialIDAll(posInd));
        out.meanYPosAll(i) = mean(in.yPosAll(posInd));
        out.binDataTrialIDAll{i} = grpstats(in.trialIDAll(posInd),in.trialIDAll(posInd));        
        disp(i);
        if segmented
            for k=1:in.numSeg+1 %for each amount of evidence

                %generate logical denoting amount of evidence
                evInd = in.evArrayAll == k-1;

                %get mean and std for theta and xvel
                out.meanTheta(k,i) = mean(in.thetaAll(posInd & evInd));
                out.meanXVel(k,i) = mean(in.xVelAll(posInd & evInd));
                out.stdTheta(k,i) = std(in.thetaAll(posInd & evInd));
                out.stdXVel(k,i) = std(in.xVelAll(posInd & evInd));

                %store all data for each bin
                out.binDataThetaEv{k,i} = in.thetaAll(posInd & evInd);
                out.binDataXVelEv{k,i} = in.xVelAll(posInd & evInd);
                out.binDataTurnEv{k,i} = in.turnAll(posInd & evInd);
            end
        end
    end
end