function plotMouseProgressByMaze(perf)
%plotMouseProgressByMaze.m Plots mouse progress by maze up to maze10
%
%INPUTS
%perf - output of getMousePerformanceByMaze
%
%ASM 8/15

intGraded = perf.intGraded;
intGraded = max(0,intGraded - 1);

%convert to group 
mazeNames = perf.mazeName;
mazeNames = cellfun(@(x,y) convertMazeToGroup(x,y),mazeNames,num2cell(intGraded));

%get accuracy
accuracy = perf.accuracy;

%get colors 
colors = getColors();

%crop 
lastInd = find(intGraded == max(intGraded),1,'first');
if ~isempty(lastInd)
    mazeNames = mazeNames(1:lastInd);
    accuracy = accuracy(1:lastInd);
end

%create figure 
figH = figure;
axH = axes;
hold(axH,'on');

%plot line
plotH = plot(1:length(mazeNames),accuracy);
plotH.Color = 'k';
plotH.LineWidth = 1;

%scatter
symGroups = 'ooooooodo^sp';
scatH = gscatter(1:length(mazeNames),accuracy,mazeNames,colors,symGroups,15,false);
for i = 1:length(scatH)
    scatH(i).MarkerFaceColor = scatH(i).Color;
end

%add chance line
lineH = line(axH.XLim,[50 50]);
lineH.Color = 'k';
lineH.LineStyle = '--';
uistack(lineH,'bottom');

%beauitfy 
beautifyPlot(figH,axH);

%label
axH.XLabel.String = 'Session Number';
axH.YLabel.String = 'Performance';
axH.XLim = [0 length(mazeNames) + 1];

end

function group = convertMazeToGroup(name,intGraded)

switch name
    case 'Maze1_40_Spatial_cutTurn'
        group = 1;
    case 'Maze1_Spatial_cutTurn'
        group = 1;        
    case 'Maze2_Spatial_cutTurn'
        group = 2;        
    case 'Maze3_Spatial_cutTurn'
        group = 3;
    case 'Maze4_Spatial_cutTurn'
        group = 4;
    case 'Maze5_Spatial_2T_cutTurn'
        group = 5;
    case 'Maze6_Spatial_2TGW_Crutch_cutTurn'
        group = 6;
    case 'Maze7b_Spatial_FixedDelay50_cutTurn'
        group = 7;
    case 'Maze9a_Spatial_Discrete_50_cutTurn'
        group = 7;
    case 'Maze10_Spatial_Discrete_100Delay_cutTurn'
        group = 8 + intGraded;
    otherwise 
        error('Can''t interpret %s',name);
end

end

function colors = getColors()

colors = nan(12,3);
colors(1,:) = [1 0 0];
colors(2,:) = [0 0 1];
colors(3,:) = [0 0 0];
colors(4,:) = [1 0 1];
colors(5,:) = [1 .2 0.051];
colors(6,:) = [0 1 1];
colors(7,:) = [0.25 0 1];
colors(8:12,:) = repmat([0 1 0],5,1);
end