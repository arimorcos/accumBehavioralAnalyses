function plotDecisionPDFs(mazePatterns,params)
%loops through each maze pattern and plots the pdfs 
%
%INPUTS
%mazePatterns - mazePatterns array
%params - set of parameters for predict decision
%
%ASM 4/15

downsample = 4;

if ~isstruct(params)
    newParams.weightSlope = params(1);
    newParams.weightOffset = params(2);
	% newParams.weightFac = params(1:6);
    newParams.bias_mu = params(3);
    newParams.bias_sigma = params(4);
    newParams.noise_s = params(5);
    newParams.noise_a = params(6);
    newParams.lambda = params(7);
    newParams.boundDist = params(8);
    newParams.prevTurnWeight = params(9);
    params = newParams;
end

segRanges = 0:80:480;

%get unique parameters
mazePatterns = unique(mazePatterns,'rows');

%get nPatterns
nPatterns = size(mazePatterns,1);

% get nrows and columns
[nRows,nCol] = calcNSubplotRows(nPatterns);
bins = -50:5:600;

%create figure 
figH = figure;

%loop through each pattern
for patInd = 1:nPatterns
   
    %create subplot
    axH = subplot(nRows,nCol,patInd);
    
    %get decision info
    [~, tracePDF,xVals] = predictDecision(mazePatterns(patInd,:),params,bins,1);
    
    %downsample
    if downsample > 1 && round(downsample) == downsample
        keepInd = 1:downsample:length(xVals);
        tracePDF = tracePDF(keepInd,:);
        xVals = xVals(keepInd);
    end
    
    %filter based on boundDist
    boundThresh = 1.2*params.boundDist;
    keepInd = xVals >= -1*boundThresh & xVals <= boundThresh;
    
    %plot
    imagescnan(bins,xVals(keepInd),tracePDF(keepInd,:));
    
    %delete ticks 
    axH.XTick = [];
    axH.YTick = [];
    axH.Title.String = num2str(mazePatterns(patInd,:));
    
    %add lines for segRanges
    for i = 1:length(segRanges)
        line([segRanges(i) segRanges(i)],[min(xVals(keepInd)) max(xVals(keepInd))],...
            'Color','k','LineStyle','--','LineWidth',1);
    end
    
    %add chance line 
    line([min(bins) max(bins)], [0 0],...
        'Color','r','LineStyle','--');
    
end