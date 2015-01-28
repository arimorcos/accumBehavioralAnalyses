
ranges = [0 80 160 240 320 400 480]; %maze ranges
nBins = 100;
nSim = 10;
shuffle = true;
breakEv = false;

%get run parameters (evidence, yPos, theta, xVel)
[runParam, segmented] = getRunParam(dataCell, ranges);

%bin parameters
binParam = binRunParam(runParam,nBins,segmented);

%perform roc at each bin for xVel and theta


if breakEv
    AUCXVelEv = zeros(size(binParam.binDataTurnEv,1),nBins);
    AUCThetaEv = zeros(size(binParam.binDataTurnEv,1),nBins);
    for i=1:nBins %for each bin
        for j=1:size(binParam.binDataTurnEv,1) %for each evidence amount
            if isempty(binParam.binDataTurnEv{j,i}) ||...
                    length(unique(binParam.binDataTurnEv{j,i})) == 1
                AUCXVelEv(j,i) = NaN;
                AUCThetaEv(j,i) = NaN;
                continue;
            end
            [~,~,~,AUCXVelEv(j,i)] = perfcurve(binParam.binDataTurnEv{j,i},...
                binParam.binDataXVelEv{j,i},0);
            [~,~,~,AUCThetaEv(j,i)] = perfcurve(binParam.binDataTurnEv{j,i},...
                binParam.binDataThetaEv{j,i},1);
        end
    end
else
    AUCXVel = zeros(1,nBins);
    AUCTheta = zeros(1,nBins);
    for i=1:nBins %for each bin
        
        if length(unique(binParam.binDataTurnAll{i})) == 1 
            AUCXVel(i) = NaN;
            AUCTheta(i) = NaN;
            continue;
        end
        [~,~,~,AUCXVel(i)] = perfcurve(binParam.binDataTurnAll{i},...
            binParam.binDataXVelAll{i},0);
        [~,~,~,AUCTheta(i)] = perfcurve(binParam.binDataTurnAll{i},...
            binParam.binDataThetaAll{i},0);
    end
end

if shuffle
    %perform shuffle
    [shuffleMean, shuffleSTD] = shuffleROC(binParam,nSim);
end

%%
%plot ROC over time 
figure;
if breakEv
    axes;
    hold on;
    for i = 1:size(AUCXVelEv,1)
        velLine(i) = patchline(binParam.meanYPosAll,AUCXVelEv(i,:),'edgecolor','r',...
            'edgealpha',i/size(AUCXVelEv,1),'linewidth',2);
        thetaLine(i) = patchline(binParam.meanYPosAll,AUCThetaEv(i,:),'edgecolor','b',...
            'edgealpha',i/size(AUCXVelEv,1),'linewidth',2);
    end
else
    plot(binParam.meanYPosAll,AUCXVel,'r');
    hold on;
    plot(binParam.meanYPosAll,AUCTheta,'b');
end
if shuffle
    hold on;
    h(1:2) = shadedErrorBar(binParam.meanYPosAll,shuffleMean.xVel,shuffleSTD.xVel,'--r');
    h(3:4) = shadedErrorBar(binParam.meanYPosAll,shuffleMean.theta,shuffleSTD.theta,'--b');
    legend([velLine(1) thetaLine(1) h([1 3]).mainLine],...
        {'X Velocity','Theta','X Velocity (Shuffled)','Theta (Shuffled)'});
    
else
    legend({'X Velocity','Theta'});
end
xlabel('Y Position');
ylabel('Area Under ROC Curve');
ylim([0 1]);
