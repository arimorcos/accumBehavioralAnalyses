function [accuracy,traces, correct] = getDecisionModelAccuracy(dataCell,params)

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

%get turns
leftTurns = double(getCellVals(dataCell,'result.leftTurn'));
leftTurns(leftTurns==0) = -1;

%get posBins
posBins = -50:5:600;

try
    %loop through each and test
    correct = false(size(leftTurns));
    traces = nan(length(dataCell),length(posBins));
    parfor trial = 1:length(dataCell)
        [decision,traces(trial,:)] = predictDecision(mazePatterns(trial,:),...
            params, posBins, dataCell{trial}.result.prevTurn);
        correct(trial) = decision == leftTurns(trial);
        
        %     dispProgress('Testing model: trial %d/%d',trial,trial,length(dataCell));
    end
    
    %get accuracy
    accuracy = sum(correct)/length(correct);
catch
    accuracy = 0;
    traces = [];
end