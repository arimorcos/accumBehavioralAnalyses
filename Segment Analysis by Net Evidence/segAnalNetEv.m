function [segBreakdown, labels, pooledVals, pSeg, pPool, handles] = segAnalNetEv(dataCell,subset)
%segAnalNetEv.m Analyzes segment contribution to mouse's decision by
%breaking down probability each segment predicts mouse's turn as a function
%of the net evidence previously accumulated. 
%
%INPUTS
%dataCell - 1 x nTrials dataCell
%subset - subset of trial conditions to analyze. If empty, all
%
%OUTPUTS
%segBreakdown - nSeg x nEvCombinations array containing the probability of
%   each segment at each net evidence value predicting eventual turn 
%labels - 1 x nEvCombinations array containing net evidence values for each
%   label
%pooledVals - 1 x nSeg array containing the probability each segment
%   predicts eventual turn independent of net evidence
%handles - structure of figure handles
%
%ASM 10/13

%find out if white or left
if isfield(dataCell{1}.maze,'numLeft')
    flagLeft = true;
elseif isfield(dataCell{1}.maze,'numWhite')
    flagLeft = false;
else
    error('Fields don''t contain either left data or white data');
end

%get nSeg
if flagLeft
    nSeg = max(getCellVals(dataCell,'maze.numLeft'));
else
    nSeg = max(getCellVals(dataCell,'maze.numWhite'));
end

%get subset
if nargin < 2 || isempty(subset)
    subset = 0:nSeg;
end
%create string
if flagLeft
    string = ['maze.numLeft == ',num2str(subset(1))];
else
    string = ['maze.numWhite == ',num2str(subset(1))];
end
for i = 2:length(subset)
    string = [string,', ',num2str(subset(i))];
end    
dataSub = getTrials(dataCell,string);

%get nTrials
nTrials = length(dataSub);


%get turn directions
if flagLeft
    mouseTurns = getCellVals(dataSub,'result.leftTurn');
else
    mouseTurns = getCellVals(dataSub,'result.whiteTurn');
end

%get segment patterns
segPattern = zeros(nTrials,nSeg); %initialize
for i = 1:nTrials %for each trial
    if flagLeft
        segPattern(i,dataSub{i}.maze.leftDotLoc) = 1; %set values where left to 1
    end
end

%reset nSeg
nSeg = size(segPattern,2);



%initialize final array
labels = -nSeg:nSeg;
segBreakdown = nan(nSeg,length(labels));

%get cumsum
segCumSumPatt = segPattern;
segCumSumPatt(segCumSumPatt == 0) = -1;
evVals = cumsum(segCumSumPatt,2);

%break up evidence 
for i = 1:nSeg %for each segment
    
    %check if first segment
    if i == 1
        segBreakdown(i,labels == 0) = mean(segPattern(:,1)' == mouseTurns);
        continue;
    end
        
    %get number of unique values
    uniqueEvVal = unique(evVals(:,i-1));
    
    %cycle through each unique val and get probability of match
    for j = 1:length(uniqueEvVal) %for each evidence value
        
        %get indices
        evInd = evVals(:,i-1) == uniqueEvVal(j);
        
        %take subset of mouseTurns and segment id
        segSub = segPattern(evInd,i);
        turnSub = mouseTurns(evInd);
        
        %set mean of mouseTurn match segment
        segBreakdown(i,labels == uniqueEvVal(j)) = ...
            mean(segSub' == turnSub);
    end
end

%remove columns with all nan
shouldKeepCol = true(1,size(segBreakdown,2));
for i = 1:size(segBreakdown,2) %for each column
    if all(isnan(segBreakdown(:,i))) %if all values nan
        shouldKeepCol(i) = false;
    end
end
segBreakdown = segBreakdown(:,shouldKeepCol);
labels = labels(shouldKeepCol);

%get pSeg
pSeg = anova1(segBreakdown',[],'off');

%get pooledVals
% segPatPool = segPattern;
% segPatPool(segPatPool == -1) = 0;
segPatPool = double(segPattern == repmat(mouseTurns',1,numel(segPattern)/numel(mouseTurns)));
pooledVals = mean(segPatPool);
pPool = anova1(segPatPool,[],'off');

%plot
plotSegNetEv(segBreakdown,labels,pooledVals,pSeg,pPool);

%calcRandChancePredict
nTrialSub = zeros(1,nSeg+1);
chanceProb = 0:nSeg;
chanceProb = max(chanceProb,nSeg - chanceProb)/nSeg;
for i = 0:nSeg %for each seg
    nTrials(i+1) = sum(findTrials(dataSub,sprintf('maze.numLeft == %d',i)));
end
totTrials = sum(nTrials);
chance = sum((nTrials./totTrials).*chanceProb);
disp(chance);
