%saveFolder
saveFolder = '/Users/arimorcos/Data/Analyzed Data/151105_currTurn_prevTurn';

%get list of datasets
procList = getProcessedList();
nDataSets = length(procList);
allCurrTurn = [];
allPrevTurn = [];

%get deltaPLeft
for dSet = 1:nDataSets
    %dispProgress
    dispProgress('Processing dataset %d/%d',dSet,dSet,nDataSets);
    
    %load in data
    loadProcessed(procList{dSet}{:},[],'oldDeconv_smooth10');
    
    currTurn = getCellVals(imTrials,'result.leftTurn');
    prevTurn = getCellVals(imTrials,'result.prevTurn');
    allCurrTurn = cat(2,allCurrTurn,currTurn);
    allPrevTurn = cat(2,allPrevTurn,prevTurn);
    
    %save
    saveName = fullfile(saveFolder,sprintf('%s_%s_currPrevTurn.mat',procList{dSet}{:}));
    save(saveName,'prevTurn','currTurn');
end

%save 
save('allMice_currTurn_prevTurn','allCurrTurn','allPrevTurn');