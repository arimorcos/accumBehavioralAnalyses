%saveFolder
saveFolder = '/Users/arimorcos/Data/Analyzed Data/160207_vogel_prev_curr_model';

%get list of datasets
procList = getProcessedList();
nDataSets = length(procList);
clear mdl

%get deltaPLeft
for dSet = 1:nDataSets
    %dispProgress
    dispProgress('Processing dataset %d/%d',dSet,dSet,nDataSets);
    
    %load in data
    loadProcessed(procList{dSet}{:},[],'oldDeconv_smooth10');
    
    tmp = get_prev_curr_turn_model(imTrials);
    mdl{dSet} = tmp;
end

%save 
save('all_mice_prev_curr_models','mdl');