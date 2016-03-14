%saveFolder
saveFolder = '/mnt/7A08079708075215/DATA/Analyzed Data/160207_vogel_prev_curr_model';

%get list of datasets
procList = getProcessedList();
nDataSets = length(procList);
clear mdl
clear interactions_mdl

%get deltaPLeft
for dSet = 1:nDataSets
    %dispProgress
    dispProgress('Processing dataset %d/%d',dSet,dSet,nDataSets);
    
    %load in data
    loadProcessed(procList{dSet}{:},[],'oldDeconv_smooth10');
    
    [mdl{dSet}, interactions_mdl{dSet}] = get_prev_curr_turn_model(imTrials);

end

%save 
save('all_mice_prev_curr_models','mdl','interactions_mdl');