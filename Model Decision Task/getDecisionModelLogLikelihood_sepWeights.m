function [logLikelihood] = getDecisionModelLogLikelihood(dataCell,params)

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

%get turns
leftTurns = getCellVals(dataCell,'result.leftTurn');
prevTurn = getCellVals(dataCell,'result.prevTurn');

%get posBins
posBins = -50:5:600;

%get unique patterns
uniquePatterns = unique(mazePatterns,'rows');

%loop through each and test
try
    decision = nan(1,length(dataCell));
    for trial = 1:size(uniquePatterns,1)
        leftVal = predictDecision_sepWeights(uniquePatterns(trial,:),...
            params, posBins, 1);
        matchLeft = ismember(mazePatterns,uniquePatterns(trial,:),'rows')' &...
            prevTurn;
        decision(matchLeft) = leftVal;
        
        rightVal = predictDecision_sepWeights(uniquePatterns(trial,:),...
            params, posBins, 0);
        matchRight = ismember(mazePatterns,uniquePatterns(trial,:),'rows')' &...
            ~prevTurn;
        decision(matchRight) = rightVal;
    end
    
    %fix based on leftTurns
    flipInds = ~leftTurns;
    decision(flipInds) = 1 - decision(flipInds);
    
    %get accuracy
    logLikelihood = -1*sum(log(decision));
catch
    logLikelihood = 1e9;
end
