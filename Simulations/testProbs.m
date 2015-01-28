numLoops = 10000;

%discrete control
vr.condProbs(1,:) = [1 0 0 0];
vr.condProbs(2,:) = [0.7 0.3 0 0];
vr.condProbs(3,:) = [0.7 0.3 0 0]; %condition probabilities for the up to 1-3 condition. Must add up to 1
vr.condProbs(4,:) = [2/7 2/7 2/7 1/7]; %condition probabilities for the all condition. Must add up to 1
vr.intGraded = 3; %0 - only 0-6, 1 - up to 1-5, 2- up to 2-4 3 - all
vr.numSeg = 6;

% %fix condprobs
% modNum = vr.condProbs(:,4)/2;
% vr.condProbs(:,4) = modNum;
% vr.condProbs = vr.condProbs + repmat(modNum/4,1,4);

y = zeros(1,numLoops);
for i=1:numLoops
    vr.cuePos = randi(2);
    if vr.cuePos == 1
        vr.numLeft = randsample((vr.numSeg/2):vr.numSeg,1,true,fliplr(vr.condProbs(vr.intGraded+1,:)));
    else
        vr.numLeft = randsample(0:(vr.numSeg/2),1,true,vr.condProbs(vr.intGraded+1,:));
    end
    vr.leftDotLoc = sort(randsample(vr.numSeg,vr.numLeft)); %generate which segments will be white
    y(i) = vr.numLeft;
end

disp(['0-6: ',num2str(sum(y==0)/numLoops)]);
disp(['1-5: ',num2str(sum(y==1)/numLoops)]);
disp(['2-4: ',num2str(sum(y==2)/numLoops)]);
disp(['3-3: ',num2str(sum(y==3)/numLoops)]);
disp(['4-2: ',num2str(sum(y==4)/numLoops)]);
disp(['5-1: ',num2str(sum(y==5)/numLoops)]);
disp(['6-0: ',num2str(sum(y==6)/numLoops)]);
figure;hist(y,7);