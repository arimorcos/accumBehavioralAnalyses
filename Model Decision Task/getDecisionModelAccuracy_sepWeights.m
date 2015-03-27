function [accuracy,traces, correct] = getDecisionModelAccuracy_sepWeights(dataCell,params)

if ~isstruct(params)
    % newParams.weightSlope = params(1);
    % newParams.weightOffset = params(2);
	newParams.weightFac = params(1:6);
    newParams.bias_mu = params(7);
    newParams.bias_sigma = params(8);
    newParams.noise_s = params(9);
    newParams.noise_a = params(10);
    newParams.lambda = params(11);
    newParams.boundDist = params(12);
    newParams.prevTurnWeight = params(13);
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

try
    decision = nan(1,length(dataCell));
    for trial = 1:size(uniquePatterns,1)
        leftVal = predictDecision_sepWeights(uniquePatterns(trial,:),...
            params, posBins, 1);
        matchLeft = ismember(mazePatterns,uniquePatterns(trial,:),'rows')' &...
            prevTurn;
        decision(matchLeft) = leftVal;
    %     disp(leftVal)

        rightVal = predictDecision_sepWeights(uniquePatterns(trial,:),...
            params, posBins, 0);
        matchRight = ismember(mazePatterns,uniquePatterns(trial,:),'rows')' &...
            ~prevTurn;
        decision(matchRight) = rightVal;
    end

    rectDecision = round(decision);
    correct = leftTurns == rectDecision;
    accuracy = sum(correct)/length(rectDecision);
catch 
    accuracy = NaN;
    traces = NaN;
    correct = NaN;
end
