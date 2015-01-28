function [out, pVals, tDist] = firstLastSeg(dataCell)
%firstLastSeg.m function to analyze whether the first or last segment
%predicts behavior better than expected

%find trials in which the first/last segment is left/right
if isfield(dataCell{1}.maze,'numLeft')
    lastSegLeft = cellfun(@(x) ismember(6,x.maze.leftDotLoc),dataCell);
    lastSegRight = ~lastSegLeft;
    firstSegLeft = cellfun(@(x) ismember(1,x.maze.leftDotLoc),dataCell);
    firstSegRight = ~firstSegLeft;
    
    %find left/right trials
    leftTrials = findTrials(dataCell,'maze.leftTrial == 1')';
    rightTrials = findTrials(dataCell,'maze.leftTrial == 0')';
elseif isfield(dataCell{1}.maze,'numWhite')
    lastSegLeft = cellfun(@(x) ismember(6,x.maze.whiteDots),dataCell);
    lastSegRight = ~lastSegLeft;
    firstSegLeft = cellfun(@(x) ismember(1,x.maze.whiteDots),dataCell);
    firstSegRight = ~firstSegLeft;
    
    %find left/right trials
    leftTrials = findTrials(dataCell,'maze.whiteTrial == 1')';
    rightTrials = findTrials(dataCell,'maze.whiteTrial == 0')';
end


%get (4) data subsets in which first/last segments predict/do not predict
%correct answer
lastSegCorrInd = (lastSegLeft & leftTrials) | (lastSegRight & rightTrials);
lastSegWrongInd = (lastSegRight & leftTrials) | (lastSegLeft & rightTrials);
firstSegCorrInd = (firstSegLeft & leftTrials) | (firstSegRight & rightTrials);
firstSegWrongInd = (firstSegRight & leftTrials) | (firstSegLeft & rightTrials);

lastSegCorrTrials = dataCell(lastSegCorrInd);
lastSegWrongTrials = dataCell(lastSegWrongInd);
firstSegCorrTrials = dataCell(firstSegCorrInd);
firstSegWrongTrials = dataCell(firstSegWrongInd);

dLengths = [length(lastSegCorrTrials) length(lastSegWrongTrials) ...
    length(firstSegCorrTrials) length(firstSegWrongTrials)];

%calculate percent correct in each of the four conditions
out.lastSegCorrPerc = 100*sum(getCellVals(lastSegCorrTrials,'result.correct'))/...
    length(lastSegCorrTrials);
out.lastSegWrongPerc = 100*sum(getCellVals(lastSegWrongTrials,'result.correct'))/...
    length(lastSegWrongTrials);
out.firstSegCorrPerc = 100*sum(getCellVals(firstSegCorrTrials,'result.correct'))/...
    length(firstSegCorrTrials);
out.firstSegWrongPerc = 100*sum(getCellVals(firstSegWrongTrials,'result.correct'))/...
    length(firstSegWrongTrials);

%perform shuffles
results = getCellVals(dataCell,'result.correct');
tDist = sampleTrials(results,dLengths);
tDist = sort(tDist,2); %sort tDist

%find pVals 
tempPCell{1} = find(out.lastSegCorrPerc > tDist(1,:),1,'last');
tempPCell{2} = find(out.lastSegWrongPerc > tDist(2,:),1,'last');
tempPCell{3} = find(out.firstSegCorrPerc > tDist(3,:),1,'last');
tempPCell{4} = find(out.firstSegWrongPerc > tDist(4,:),1,'last');

for i=1:length(tempPCell)
    if isempty(tempPCell{i})
        tempP(i) = 0;
    else
        tempP(i) = tempPCell{i};
    end
end

%make pVals less than .5
tempP = tempP/size(tDist,2);
tempP(tempP>.5) = 1-tempP(tempP>.5);

pVals.lastSegCorrPerc = tempP(1);
pVals.lastSegWrongPerc = tempP(2);
pVals.firstSegCorrPerc = tempP(3);
pVals.firstSegWrongPerc = tempP(4);

end

function tDist = sampleTrials(results,dLengths)

%nSim
nSim = 10000;

%calculate number of overall shuffles to do
nShuffles = length(dLengths);

tDist = zeros(nShuffles,nSim);

for i=1:nShuffles %for each shuffle (dataset)
    sampArray = [ones(1,dLengths(i)) zeros(1,size(results,2)-dLengths(i))];
    for j=1:nSim; %for each simulation
        ind = boolean(randsample(sampArray,size(results,2),false)); %generate random trial indices
        dataSub = results(ind);
        tDist(i,j) = 100*sum(dataSub)/length(dataSub);
    end
end
end
