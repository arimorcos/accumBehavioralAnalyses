nBins = 100;
ranges = [0 80 160 240 320 400 480]; %maze ranges

%get run parameters (evidence, yPos, theta, xVel)
[runParam, segmented] = getRunParam(dataCell, ranges);

%normalize thetaAll to 0
runParam.thetaAll = runParam.thetaAll - 90;


%bin parameters
binParam = binRunParam(runParam,nBins,false);

%run leave one out single trial decode
singleTrajDecode = turnTrajSingleTrialDecode(binParam,nBins);


%% plot
% numPlot = 1;
% 
% figH = figure;
% trajAxes = axes;
% hold on;
% colors = distinguishable_colors(numPlot);
% set(trajAxes,'ColorOrder',colors);
% 
% %choose sims to plot
% plotInd = randsample(1:size(singleTrajDecode.accTheta,1),numPlot);
% 
% xVelPlots = plot(binParam.meanYPosAll,singleTrajDecode.accXVel(plotInd,:),'--');
% thetaPlots = plot(binParam.meanYPosAll,singleTrajDecode.accTheta(plotInd,:),'-');
% legend([xVelPlots(1),thetaPlots(1)],{'XVel','Theta'});
% xlabel('Y Position');
% ylabel('Classifier Accuracy');
% ylim([0 1]);

%% analyze

%find changes
diffXVel = diff(singleTrajDecode.accXVel,1,2);
diffTheta = diff(singleTrajDecode.accTheta,1,2);

%calculate frequency
freqXVel = sum(diffXVel ~= 0);
freqTheta = sum(diffTheta ~= 0);

%find accuracy on flip trials
threshBin = round(.7*(nBins-1));
trialAcc = zeros(2,length(singleTrajDecode.uniqueTrials));
for i=1:length(singleTrajDecode.uniqueTrials) %for each trial
    if sum(diffXVel(i,threshBin:end) ~= 0 | diffTheta(i,threshBin:end) ~= 0) > 0 %if flip
        trialAcc(2,i) = 1; %mark as flip trial
    end
    trialAcc(1,i) = dataCell{singleTrajDecode.uniqueTrials(i)}.result.correct;
end

%break into subsets
flipSub = trialAcc(1,trialAcc(2,:)==1);
constSub = trialAcc(1,trialAcc(2,:)==0);
flipAcc = 100*sum(flipSub)/length(flipSub);
constAcc = 100*sum(constSub)/length(constSub);

%plot
figH = figure;
freqAxes = axes;
hold on;
plot(freqXVel,'b');
plot(freqTheta,'r');
xlabel('Diff Bin #');
ylabel('Count');
legend('X Velocity','Theta');
text(nBins/2,max(get(freqAxes,'ylim'))-1,...
    ['nTrials = ',num2str(length(singleTrajDecode.uniqueTrials)),'  Flip Accuracy: ',...
    num2str(flipAcc),'  No Flip Accuracy: ',num2str(constAcc)],'HorizontalAlignment',...
    'Center','VerticalAlignment','Top');

