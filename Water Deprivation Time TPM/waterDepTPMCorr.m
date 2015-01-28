%%script to run correlation for all current mice
% mouseDir = 'D:\Data\Ari\Current Mice';
% initials = 'AM';
mouseDir = 'Z:\HarveyLab\Laura\DATA\VR Current Mice';
initials = 'LD';

%change to dir
origDir = cd(mouseDir);

%get mouse names
mice = dir([initials,'*']);

%initialize cell arrays
waterDep = cell(1,length(mice));
TPM = cell(1,length(mice));

%cycle through each mouse and get data
for i=1:length(mice)
    
    [waterDep{i}, TPM{i}] = waterDepTPM(mice(i).name,mouseDir);

end

%remove Nan:
emptyFiles = cell2mat(cellfun(@(x) ~isnan(x(1)),TPM,'UniformOutput',false));
mice = mice(emptyFiles);
TPM = TPM(emptyFiles);
waterDep = waterDep(emptyFiles);

%concatenate all
allTPM = [];
allWaterDep = [];
for i=1:length(mice)
    allTPM = [allTPM TPM{i}];
    allWaterDep = [allWaterDep waterDep{i}];
end

%change back to original dir
cd(origDir);

%% make figure and plot data
squares = 1:10;
squares = squares.^2;
dist = squares - length(mice);
dist(dist < 0) = NaN;
[~,ind] = min(dist);

figure;
for i=1:length(mice)
    subplot(ind,ind,i);
    scatter(waterDep{i},TPM{i});
    [corr,p] = corrcoef(waterDep{i},TPM{i});
    currXLim = get(gca,'xlim');
    currYLim = get(gca,'ylim');
    xText = currXLim(1) + .05*diff(currXLim);
    yText = currYLim(1) + .05*diff(currYLim);
    tString = [num2str(corr(2)),'  p = ',num2str(p(2))];
    tBox = text(xText,yText,tString);
    if p(2) <= 0.05
        set(tBox,'color','g');
    else
        set(tBox,'color','r');
    end
    title(mice(i).name);
    lsline;
end
set(gcf,'NextPlot','add');
axes;
h1 = xlabel('Days Water Deprived');
h2 = ylabel('Trials Per Minute');
set(gca,'Visible','off');
set(h1,'Visible','on');
set(h2,'Visible','on');

figure;
scatter(allWaterDep,allTPM);
[corr,p] = corrcoef(waterDep{i},TPM{i});
currXLim = get(gca,'xlim');
currYLim = get(gca,'ylim');
xText = currXLim(1) + .05*diff(currXLim);
yText = currYLim(1) + .05*diff(currYLim);
tString = [num2str(corr(2)),'  p = ',num2str(p(2))];
tBox = text(xText,yText,tString);
if p(2) <= 0.05
    set(tBox,'color','g');
else
    set(tBox,'color','r');
end
title('All Mice');
lsline;
h1 = xlabel('Days Water Deprived)');
h2 = ylabel('Trials Per Minute');