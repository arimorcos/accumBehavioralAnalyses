function [dipInfo,dipStartsTrials,dipLengths,rewBet] = findDips(dataCell)
%findDips.m Searches trials for dips in behavioral performance
%
%Takes in dataCell, which is a cell array of trials to calculate
%performance
%
%ASM 11/3/12

winSize = 10; %number of trials in window
prevTrialThresh = 15; %number of trials in which performance must be good before dip
dipThresh = 10; %min length of the dip
biasThresh = .1; %threshold for difference between trials and turns which designates a bias
peakThresh = .7; %threshold for good performance
numPrevTrials = 10; %number of previous trials to output

%check if too few trials
minTrials = prevTrialThresh + dipThresh; %minimum number of trials to detect one dip
numTrials = length(dataCell);
if numTrials < minTrials
    dipInfo = {}; %set dipInfo to an empty cell
    dipStartsTrials = [];
    rewBet = [];
    dipLengths = [];
    return;
end

%calculate sliding window of performance
numWins = numTrials - winSize + 1;

%initialize arrays
percCorr = zeros(1,numWins);
percLeft = zeros(1,numWins);
percWhite = zeros(1,numWins);
percLeftTrials = zeros(1,numWins);
percWhiteTrials = zeros(1,numWins);
biasDir = zeros(1,numWins); 
biasCol = zeros(1,numWins); 
winDur = zeros(1,numWins);

for i = 1:numWins
    dataCellSub = dataCell(i:(i+winSize-1)); %create data subset of only trials in given window
    
    numRew = sum(getCellVals(dataCellSub,'result.correct==1')); %get number of rewards in window
    percCorr(i) = numRew/winSize; %calculate percent correct
    
    numLeft = sum(getCellVals(dataCellSub,'result.leftTurn == 1')); %get number of left turns
    percLeft(i) = numLeft/winSize; %calculate percent left turns
    
    numLeftTrials = sum(getCellVals(dataCellSub,'maze.leftTrial == 1')); %get number of left trials
    percLeftTrials(i) = numLeftTrials/winSize; %calculate percent left trials
    
    numWhite = sum(getCellVals(dataCellSub,'result.whiteTurn == 1')); %get number of white turns
    percWhite(i) = numWhite/winSize; %calculate percent white turns
    
    numWhiteTrials = sum(getCellVals(dataCellSub,'maze.whiteTrial == 1')); %get number of white trials
    percWhiteTrials(i) = numWhiteTrials/winSize; %calculate percent white trials
    
    %determine if bias is present 
    leftNorm = percLeft(i) - percLeftTrials(i);
    whiteNorm = percWhite(i) - percWhiteTrials(i);
    
    if abs(leftNorm) > biasThresh
        if leftNorm > 0 
            biasDir(i) = 1; %1 - more left turns
        elseif leftNorm < 0 
            biasDir(i) = 2; %2 - more right turns
        end
    end
    
    if abs(whiteNorm) > biasThresh
        if whiteNorm > 0 
            biasCol(i) = 1; %1 - more white turns
        elseif whiteNorm < 0
            biasCol(i) = 2; %2 - more black turns
        end
    end
    
    %determine window duration in seconds
    dur = dataCellSub{end}.time.stop - dataCellSub{1}.time.start;
    winDur(i) = 3600*hour(dur) + 60*minute(dur) + second(dur);
    
end

%find dip starts and number of dips
peaks = find(percCorr > peakThresh); %find the windows in which performance is above a threshold
peakChange = diff(peaks);
dipLengths = peakChange(peakChange > dipThresh);
dipStarts = peaks(peakChange > dipThresh); %find dips which are longer than peaks
dipStartsTrials = dipStarts + winSize - 1; %adjust to where the dip begins in trials
numDips = length(dipStarts); %find numDips

%find biases in those windows
dipBiasDir = biasDir(dipStarts+0.5*dipThresh);
dipBiasCol = biasCol(dipStarts+0.5*dipThresh);

%find previous 5 trials presented to mouse before dip
dipInfo = cell(1,numDips);
for i = 1:numDips
    dipInfo{i}.prevTrials = dataCell(dipStartsTrials(i)-numPrevTrials:dipStartsTrials(i)-1);
    dipInfo{i}.dipTrials = dataCell(dipStartsTrials(i):dipStartsTrials(i) + dipThresh);
    dipInfo{i}.biasCol = dipBiasCol(i);
    dipInfo{i}.biasDir = dipBiasDir(i);
    
    rewTrials = dataCell(getCellVals(dataCell(1:dipStartsTrials(i)-1),'result.correct==1'));
    dipInfo{i}.prevRewTrials = rewTrials(end-4:end);
end

start = 1;
rewBet = zeros(1,numDips);
for i=1:numDips
    try
        rewBet(i) = sum(getCellVals(dataCell(start:dipStartsTrials(i)),'result.rewardSize'));
    catch
        rewBet(i) = NaN;
        continue;
    end
end

end
    
    

