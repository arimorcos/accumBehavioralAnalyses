function [accuracy,decision,correct] = getDecisionModelAccuracy(dataCell,params)

if ~isstruct(params)
    newParams.weightSlope = params(1);
    newParams.weightOffset = params(2);
    newParams.bias_mu = params(3);
    newParams.bias_sigma = params(4);
    newParams.noise_s = params(5);
    newParams.noise_a = params(6);
    newParams.lambda = params(7);
    newParams.boundDist = params(8);
    newParams.prevTurnWeight = params(9);
    params = newParams;
end

%get mazePatterns
mazePatterns = getMazePatterns(dataCell);
uniquePatterns = unique(mazePatterns,'rows');

%get turns
leftTurns = getCellVals(dataCell,'result.leftTurn');
prevTurn = getCellVals(dataCell,'result.prevTurn');

%get posBins
posBins = -50:5:600;

decision = nan(1,length(dataCell));
for trial = 1:size(uniquePatterns,1)
    leftVal = predictDecision(uniquePatterns(trial,:),...
        params, posBins, 1);
    matchLeft = ismember(mazePatterns,uniquePatterns(trial,:),'rows')' &...
        prevTurn;
    decision(matchLeft) = leftVal;
%     disp(leftVal)
    
    rightVal = predictDecision(uniquePatterns(trial,:),...
        params, posBins, 0);
    matchRight = ismember(mazePatterns,uniquePatterns(trial,:),'rows')' &...
        ~prevTurn;
    decision(matchRight) = rightVal;
end

rectDecision = round(decision);
correct = leftTurns == rectDecision;
accuracy = sum(correct)/length(rectDecision);
