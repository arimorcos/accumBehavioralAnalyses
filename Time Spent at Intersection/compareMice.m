%script to compare mouse time at intersection and stem

%thresh
thresh = 0.85;

%get number of old/new mice
nOld = length(oldMice);
nNew = length(newMice);

%initialize
oldMeans = zeros(2,nOld);
newMeans = zeros(2,nNew);

%loop through each of the old mice
for i = 1:nOld 
    
    %get tInfo
    [tInfo] = getMazeTimeBreakdown(oldMice{i},thresh);
    
    %get mean time
    oldMeans(1,i) = mean(tInfo.stemTimes);
    oldMeans(2,i) = mean(tInfo.tTimes);
    
end

%loop through each of the new mice
for i = 1:nNew 
    
    %get tInfo
    [tInfo] = getMazeTimeBreakdown(newMice{i},thresh);
    
    %get mean time
    newMeans(1,i) = mean(tInfo.stemTimes);
    newMeans(2,i) = mean(tInfo.tTimes);
    
end

%take mean and std
oldMean = mean(oldMeans,2);
newMean = mean(newMeans,2);
oldSTD = std(oldMeans,0,2);
newSTD = std(newMeans,0,2);

%get diff
diffOld = oldMeans(1,:) - oldMeans(2,:);
diffNew = newMeans(1,:) - newMeans(2,:);

%significance
[~,pStem] = ttest2(oldMeans(1,:),newMeans(1,:));
[~,pInt] = ttest2(oldMeans(2,:),newMeans(2,:));
[~,pDiff] = ttest2(diffOld,diffNew);

%%%%%% plot
figure;
barwitherr([oldSTD,newSTD],cat(2,oldMean,newMean));
set(gca,'xTickLabel',{'Stem','Intersection'});
xlabel('Maze Region');
ylabel('Time Spent(s)');
legend({'Old Mice','New Mice'});

text(1.5,10,sprintf('pStem = %f\npIntersection = %f\npDiff = %f',pStem,pInt,pDiff));
