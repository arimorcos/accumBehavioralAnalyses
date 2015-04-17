function plotRegressionModelStruc(regStruct)
%plotRegressionModelStruc.m Plots output of analyzeMultipleMiceSimpleRegression
%
%ASM 4/15

%get mice 
mouseNames = fieldnames(regStruct);

%convert to array 
quarterArray = nan(3,length(mouseNames),2);
halfArray = nan(3,length(mouseNames),2);
mouseInd = nan(3,length(mouseNames));
for mouse = 1:length(mouseNames)
   quarterArray(1,mouse,1) = regStruct.(mouseNames{mouse}).allTrials.quarterTrain.accuracy;
   quarterArray(2,mouse,1) = regStruct.(mouseNames{mouse}).medTrials.quarterTrain.accuracy;
   quarterArray(3,mouse,1) = regStruct.(mouseNames{mouse}).hardTrials.quarterTrain.accuracy;
   
   quarterArray(1,mouse,2) = regStruct.(mouseNames{mouse}).allTrials.quarterTrain.naiveAccuracy;
   quarterArray(2,mouse,2) = regStruct.(mouseNames{mouse}).medTrials.quarterTrain.naiveAccuracy;
   quarterArray(3,mouse,2) = regStruct.(mouseNames{mouse}).hardTrials.quarterTrain.naiveAccuracy;
   
   halfArray(1,mouse,1) = regStruct.(mouseNames{mouse}).allTrials.halfTrain.accuracy;
   halfArray(2,mouse,1) = regStruct.(mouseNames{mouse}).medTrials.halfTrain.accuracy;
   halfArray(3,mouse,1) = regStruct.(mouseNames{mouse}).hardTrials.halfTrain.accuracy;
   
   halfArray(1,mouse,2) = regStruct.(mouseNames{mouse}).allTrials.halfTrain.naiveAccuracy;
   halfArray(2,mouse,2) = regStruct.(mouseNames{mouse}).medTrials.halfTrain.naiveAccuracy;
   halfArray(3,mouse,2) = regStruct.(mouseNames{mouse}).hardTrials.halfTrain.naiveAccuracy;
   
   mouseInd(:,mouse) = mouse;
   
end

groups = nan(3,length(mouseNames));
groups(1,:) = 1;
groups(2,:) = 2;
groups(3,:) = 3;

mouseInd(1,:) = mouseInd(1,:) - 0.2;
mouseInd(3,:) = mouseInd(3,:) + 0.2;

halfArrayAcc = halfArray(:,:,1);
halfArrayNaive = halfArray(:,:,2);
quarterArrayAcc = quarterArray(:,:,1);
quarterArrayNaive = quarterArray(:,:,2);


%plot 
figH = figure; 

%quarter train 
axQuarter = subplot(2,1,1);
hold(axQuarter,'on');
scatQuartAcc = gscatter(mouseInd(:),quarterArrayAcc(:),groups(:),[],'o',15,'off');
scatQuartNaive = gscatter(mouseInd(:),quarterArrayNaive(:),groups(:),[],'x',15,'off');
legend(scatQuartAcc,{'All Trials','Medium Trials','Hard Trials'},'Location','Best');
axQuarter.XTick = 1:length(mouseNames);
axQuarter.XTickLabel = mouseNames;
axQuarter.YLabel.String = 'Accuracy';
axQuarter.Title.String = 'Quarter Train';
axQuarter.YLim = [0.5 1];

%half train 
axHalf = subplot(2,1,2);
hold(axHalf,'on');
gscatter(mouseInd(:),halfArrayAcc(:),groups(:),[],'o',15,'off');
gscatter(mouseInd(:),halfArrayNaive(:),groups(:),[],'x',15,'off');
axHalf.XTick = 1:length(mouseNames);
axHalf.XTickLabel = mouseNames;
axHalf.XLabel.String = 'Mouse';
axHalf.YLabel.String = 'Accuracy';
axHalf.Title.String = 'Half Train';
axHalf.YLim = [0.5 1];