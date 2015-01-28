ranges = [0 80 160 240 320 400 480]; %maze ranges
nBins = 100;
nSim = 10;
shuffle = true;
breakEv = true;

%get run parameters (evidence, yPos, theta, xVel)
[runParam, segmented] = getRunParam(dataCell, ranges);

%bin parameters
binParam = binRunParam(runParam,nBins,segmented);

%run leave one out decode
trajDecode = turnTrajDecode(binParam, nBins);

%% plot
figH = figure;

trajAxes = axes;
hold on;
plot(binParam.meanYPosAll,trajDecode.accXVel,'r');
plot(binParam.meanYPosAll,trajDecode.accTheta,'b');
legend({'XVel','Theta'});
xlabel('Y Position');
ylabel('Classifier Accuracy');
ylim([0 100]);
line(get(trajAxes,'xlim'),[50 50],'Color','k','Linestyle','--');