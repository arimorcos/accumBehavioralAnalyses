function [logLikelihood] = getDecisionModelLogLikelihood(dataCell,params)

if ~isstruct(params)
    newParams.weightSlope = params(1);
    newParams.weightOffset = params(2);
	% newParams.weightFac = params(1:6);
    newParams.bias_mu = params(3);
    newParams.bias_sigma = params(4);
%     newParams.noise_s = params(5);
%     newParams.noise_a = params(6);
    newParams.lambda = params(5);
    newParams.boundDist = params(6);
    newParams.prevTurnWeight = params(7);
    newParams.weightScale = params(8);
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
        leftVal = predictDecision(uniquePatterns(trial,:),...
            params, posBins, 1);
        matchLeft = ismember(mazePatterns,uniquePatterns(trial,:),'rows')' &...
            prevTurn;
        decision(matchLeft) = leftVal;
        
        rightVal = predictDecision(uniquePatterns(trial,:),...
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
