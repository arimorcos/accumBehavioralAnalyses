function [perf,nLeft,nTrials] = getPerf(dataCell)

nSeg = 6;

perf = nan(nSeg+1,1);

nTrials = nan(nSeg+1,1);
nLeft = nan(nSeg+1,1);

for nLeftSeg = 0:nSeg
    nTrials(nLeftSeg+1) = sum(findTrials(...
        dataCell,sprintf('maze.numLeft==%d',nLeftSeg)));
    nLeft(nLeftSeg+1) = sum(findTrials(dataCell,...
        sprintf('result.leftTurn==1;maze.numLeft==%d',nLeftSeg)));
    perf(nLeftSeg+1) = nLeft(nLeftSeg+1)/nTrials(nLeftSeg+1);
end