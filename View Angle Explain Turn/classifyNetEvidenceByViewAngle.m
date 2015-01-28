function classifierOut = classifyNetEvidenceByViewAngle(dataCell,varargin)
%classifyNetEvidenceByViewAngledataCell.m Classifies which net evidence condition a given bin
%of each segment is. Classifies all segments equally.
%
%INPUTS
%dataCell - dataCell containing imaging information
%shouldPlot - should plot data
%
%OUTPUTS
%accuracy - nSeg x nBins array containing accuracy for each bin of each
%   segment
%classGuess - nTrials x nBins x nSeg array of classifier guesses
%realClass - nTrials x nSeg array of actual net evidence
%
%ASM 9/14

nShuffles = 100;
shouldShuffle = false;
range = [0.5 1];
conditions = {'','result.leftTurn==1','result.leftTurn==0'};
segRanges = 0:80:480;


%process varargin
if nargin > 1 || ~isempty(varargin)
    if isodd(length(varargin))
        error('Must provide a name and value for each argument');
    end
    for argInd = 1:2:length(varargin) %for each argument
        switch lower(varargin{argInd})
            case 'nshuffles'
                nShuffles = varargin{argInd+1};
            case 'shouldshuffle'
                shouldShuffle = varargin{argInd+1};
            case 'range'
                range = varargin{argInd+1};
            case 'conditions'
                conditions = varargin{argInd+1};
            case 'segranges'
                segRanges = varargin{argInd+1};
        end
    end
end

%loop through each condition
for condInd = 1:length(conditions)
    
    %filter subset
    dataSub = getTrials(dataCell,conditions{condInd});
    
    %get dataVals
    binnedDat = cellfun(@(x) x.binnedDat,dataSub,'UniformOutput',false);
    binnedDat = cat(3,binnedDat{:});
    
    %get theta (nBins x nTrials)
    theta = squeeze(binnedDat(4,:,:));
    
    %get yPos
    yPos = dataSub{1}.yPosBins;
    
    %get nBins
    [nBins,nTrials] = size(theta);
    
    %get netEv
    netEvidence = getNetEvidence(dataSub);
    
    %get nSeg
    nSeg = size(netEvidence,2);
%     netEv = zeros(size(theta));
%     for trialInd = 1:nTrials
%         for segInd = 1:nSeg
%             %get ind 
%             binInd = yPos >= segRanges(segInd) & yPos < segRanges(segInd+1);
%             %store
%             netEv(binInd,trialInd) = netEvidence(trialInd,segInd);
%         end
%         binInd = yPos > segRanges(nSeg+1);
%         netEv(binInd,trialInd) = netEvidence(trialInd,nSeg);
%     end          
    
    %divide into segments
    segTheta = [];
    for segInd = 1:nSeg
        tempTheta = [];
        for trialInd = 1:nTrials
            %get ind
            binInd = yPos >= segRanges(segInd) & yPos < segRanges(segInd+1);
            
            %get tempTheta
            tempTheta = cat(2,tempTheta,theta(binInd,trialInd));
        end
        segTheta = cat(3,segTheta,tempTheta);
    end %segTheta - nBinsPerSeg x nTrials x nSeg
    
    %get nBinsPerSeg
    nBinsPerSeg = size(segTheta,1);
    
    %calculate
    [accuracy,classGuess,realClass,distances,distClasses] = getNetEvAcc(segTheta,nSeg,...
        netEvidence,nBinsPerSeg,nTrials,range);
    

    %shuffle
    if shouldShuffle
        %initialize
        shuffleAccuracy = zeros(nSeg,1,nShuffles);
        shuffleGuess = zeros(nTrials,1,nSeg,nShuffles);
        shuffleDistances = cell(1,nShuffles);
        
        for shuffleInd = 1:nShuffles
            dispProgress('Performing shuffle %d/%d',shuffleInd,shuffleInd,nShuffles);
            %generate random netEv conditions
            randClass = shuffleLabels(realClass);
            
            [shuffleAccuracy(:,:,shuffleInd),shuffleGuess(:,:,:,shuffleInd),...
                ~,shuffleDistances{shuffleInd}] =...
                getNetEvAcc(segTheta,nSeg,randClass,nBinsPerSeg,nTrials,range);
        end
    else
        shuffleAccuracy = [];
        shuffleGuess = [];
        shuffleDistances = {};
    end
    
    %save to classifier out
    classifierOut(condInd).shuffleAccuracy = shuffleAccuracy;
    classifierOut(condInd).shuffleGuess = shuffleGuess;
    classifierOut(condInd).accuracy = accuracy;
    classifierOut(condInd).classGuess = classGuess;
    classifierOut(condInd).realClass = realClass;
    classifierOut(condInd).shuffleDistances = shuffleDistances;
    classifierOut(condInd).distances = distances;
    classifierOut(condInd).distClasses = distClasses;
    
end



function randClass = shuffleLabels(realClass)

randClass = zeros(size(realClass));

for i = 1:size(realClass,2) %for each segment
    randClass(:,i) = randsample(realClass(:,i),size(realClass,1));
end


function [accuracy,classGuess,realClass,distances,distClasses] = getNetEvAcc(segTraces,nSeg,...
    realClass,nBins,nTrials,range)

%initialize outputs
accuracy = zeros(nSeg,1);
tempClassGuess = zeros(nTrials,nBins,nSeg);
classGuess = zeros(nTrials,1,nSeg);
distances = cell(1,nSeg);
distClasses = cell(1,nSeg);


%loop through each segment and get accuracy
for segInd = 1:nSeg    
    
    %get tempTraces
    tempTraces = segTraces(:,:,segInd);
    
    %permute
    tempTraces = permute(tempTraces,[3 1 2]);
    
    %calculate accuracy
    [~,tempClassGuess(:,:,segInd),distances{segInd},distClasses{segInd}] =...
        getClassifierAccuracyNew(tempTraces,realClass(:,segInd));
    
    %get bin range
    binRange = round(range*nBins);
    
    classGuess(:,1,segInd) = mode(tempClassGuess(:,binRange(1):binRange(2),segInd),2);
    accuracy(segInd,1) = 100*sum(classGuess(:,1,segInd) == realClass(:,segInd))/size(classGuess,1);
    
    %sort distances
    distances{segInd}=mean(distances{segInd}(:,binRange(1):binRange(2),:),2);
end