%%%%%%%%%%%%% access token
accessToken = '2c0eeb9f-34e5-46b9-8498-0d45ffa57d36';

%%%%%%%%%%%%% Create experiment name
currExpName = 'Optimize decision task linear fit medTrain';
currExpDate = datestr(now,'yymmdd-HH:MM:SS');
currExp = sprintf('%s %s',currExpName,currExpDate);

%%%%%%%%%%%%% set up parameters
parameters = {struct('name', 'noise_a', 'type', 'float', 'min', 2^-15, 'max', 2^-2, 'size', 1),...
              struct('name', 'noise_s', 'type', 'float', 'min', 2^-15, 'max', 2^1, 'size', 1),...
              struct('name', 'boundDist', 'type', 'float', 'min', 2^-15, 'max', 2^3, 'size', 1),...
              struct('name', 'bias_mu', 'type', 'float', 'min', -2, 'max', 2, 'size', 1),...
              struct('name', 'bias_sigma', 'type', 'float', 'min', 2^-15, 'max', 2, 'size', 1),...
              struct('name', 'weightSlope', 'type', 'float', 'min', -2^3, 'max', -2^-15, 'size', 1),...
              struct('name', 'weightOffset', 'type', 'float', 'min', -1, 'max', 1, 'size', 1),...
              struct('name', 'prevTurnWeight', 'type', 'float', 'min', 2^-15, 'max', 4, 'size', 1),...
              struct('name', 'lambda', 'type', 'float', 'min', 2^-15, 'max', 2, 'size', 1)};
          
outcome.name = 'accuracy';

%%%%%%%%%%%%%%% get trainCell 
trainCell = medTrials(1:500);

nIter = 300;

regTerm = 0.1;

%%%%%%%%%%%%% create whetlab object
scientist = whetlab(currExp, 'Optimize decision making task linear fit medTrain',...
    parameters, outcome, true, accessToken);

%%%%%%%%%%%%%%%%%%%% optimize
%%
for iterNum = 1:nIter
    
    %get suggestion
    job = scientist.suggest();
    
    %run job
%     logLikelihood = getDecisionModelLogLikelihood(trainCell,job);
    accuracy = getDecisionModelAccuracy(trainCell,job);
    
    %add regularization 
    params = job;
    params = rmfield(params,'result_id_');
    params = cell2mat(struct2cell(params));
    cost = norm(params); 
    
    %update accuracy 
%     regLogLikelihood = -1*logLikelihood - regTerm*cost;
    
    %update 
    scientist.update(job,accuracy); 
    
end
