%analyzeBehaviorCum

%This is a function to analyze the behavioral data for all animals over all 
%days. It computes several factors:
%
%Number of rewards received
%Amount of water earned
%Amount of water to give
%Total number of trials, 
%Average trial time
%Number of trials in each condition 
%Percent of trials in which a reward was given
%Percent of each condition in which a reward was given
%Percent left turns
%Session time
%Session number
%Rewards and trials per minute
%Mean +- std trial duration
%MazeID
%TimeError (should only apply to AM001-AM004)

%All written to behavRes structure

%This function can also output figures summarizing data in various ways
%based on the fig input:
%0 - does not display any figures -- only displays array
%1 - displays basic figure with percRewards over days, trials/rewards per
%min and a table. This should be the default function.
%2 - same as 1, but shows mean trial time instead of trials/rewards per min
%3 - plots nTrials and percRewards over the entire session with a sliding 5 minute window
%4 - plots end positions for each condition on a given date, specified in
%the beginning of the function
%5 - shows a video of the trace from a given day on a given trial(s),
%specified in the beginning of the function
%6 - displays all figures

%This function can be told to analyze only specific animals by inputing a
%string with the start and stop animals. If only the start animal string is
%inputted, it will only analyze that animal

%To increaase speed, this function also saves a file titled
%'Processed_(animal name).' This file contains all the processed data for
%previous sessions, so the function does not have to compute it every time
%it runs for each animal. The file is saved in the animal's folder.

%ASM 3/10/12 - 3/28/12

function [behavRes] = analyzeBehaviorCum(fig, startAn, stopAn) %#ok<STOUT>

%Show date or session
xTickSession = 0; %if 0, will automatically change after 10 days, if 1 will showSession always, and if 2 will showDate always

%lastDate to only do last date
lastDate = false;

%Choose date for end plots and/or video
datePlot = '120422';
dateVid = '120313';
dateInSession = '120507';
useSessionDate = false;

%Video settings
numVidTrials = 2;
whichVidTrial = .5;
fps = 10;
outfile = 'mousePaths.avi'; 
saveMovie = false;

%Change to proper directory
% if strcmpi(computer,'MACI64')
%     oldDir = cd('/Users/arimorcos/Dropbox/Ari/Current Mice');
% elseif strcmpi(computer,'PCWIN64')
%     oldDir = cd('D:\Ari Morcos\Dropbox\Ari\Current Mice');
% end
oldDir = cd('C:\DATA\Ari\Current Mice\');

%Amount dispensed 
singleWater = 4; % in uL
totalWater = 1000;

%Get list of folders in directory
folderList = dir('AM*'); 
for i=1:size(folderList,1) %convert string of last 3 characters (nums) into double in anNum array 
    anNum(i,1) = str2double(folderList(i).name(3:5)); 
end
if exist('startAn','var')
    startAn = str2double(startAn(3:5)); %convert start and stop into array if they exist
end
if exist('stopAn','var')
    stopAn = str2double(stopAn(3:5));
end

%If inputs are empty, designate them as lowest and highest values
if nargin == 2
    stopAn = startAn;
end
if nargin < 2
    startAn = min(anNum);
    stopAn = max(anNum);
end
if nargin < 1
    fig = 1;
end

%Create waitbar
progressBar = waitbar(0,'Please wait...');

%Go to each file from the current date and compare
for i=1:size(folderList,1) %For each animal
    if str2double(folderList(i).name(3:5)) < startAn || str2double(folderList(i).name(3:5)) > stopAn
        continue;
    end
    rootDir = cd(folderList(i).name); %change to directory
    fileList = what;    %get list of files (days)
    fileList.mat = fileList.mat(strncmpi(folderList(i).name,fileList.mat,4)); %remove processed file from list
    
    procFileName = ['Processed_',folderList(i).name,'.mat'];
    if exist(procFileName,'file') == 2 %if processed file exists, load all variables
       load(procFileName);
       fileStart = size(numTrials,2)+1;
       if size(numTrials,2) >= size(fileList.mat,1)
           newData = false;
       else
           newData = true;
       end
    else
        fileStart = 1;
        newData = true;
    end
    if fig == 4 || fig == 5
        fileStart = 1;
        newData = true;
    end
    
    %Determine if datePlot
    if (fig == 3 || fig == 6) && ~useSessionDate
        dateInSession = fileList.mat{end};
        dateInSession = dateInSession(7:12);
    end
    if fig == 3
        fileStart = 1;
    end
    
    if lastDate
        fileStart = size(fileList.mat,1); %#ok<UNRCH>
    end
    
    for j=fileStart:size(fileList.mat,1)
        
        [behavResTemp vars] = processData(fig,i,j,folderList,fileList,dateInSession,singleWater,totalWater);
        
        eval(['behavRes.',folderList(i).name,'.date',behavResTemp.fileName(7:12),'=behavResTemp.',folderList(i).name,'.date',behavResTemp.fileName(7:12),';']);
        
        if fig == 3
            break;
        end
        
        %process waitbar and update
        waitbar(j/size(fileList.mat,1),progressBar,['Animal: ', folderList(i).name,'   File: ', num2str(j),'/',num2str(size(fileList.mat,1))]);
    end
    
    %Save file with all processed data
    if newData
        varsToSave = {'sessionTime','numRewards','numTrials','cond1Trials','cond2Trials',...
            'cond3Trials','cond4Trials','percRewards','rewardsPerMin','trialsPerMin',...
            'meanTrialDur','percRewardsCond1','percRewardsCond2','numRewardsCond1',...
            'numRewardsCond2','numRewardsCond3','percRewardsCond3','numRewardsCond4',...
            'percRewardsCond4','mazeIDs','percLeft','timeError','stdTrialDur',...
            'percRewardsFirstQuart','percRewardsSecondQuart','percRewardsThirdQuart',...
            'percRewardsFourthQuart','percRewTower','percRewNoTower','cond5Trials','cond6Trials',...
            'cond7Trials','cond8Trials','percRewardsCond5','percRewardsCond6','percRewardsCond7',...
            'percRewardsCond8','numRewardsCond5','numRewardsCond6','numRewardsCond7','numRewardsCond8'};
        save(['Processed_',folderList(i).name,'.mat'],'-struct','vars',varsToSave{:});
    end
    
    %Change back to original directory
    cd(rootDir);
    
    %Make figure for each animal
    if fig == 1 || fig == 2 || fig == 6 
        %Determine if mazeIDs are continuous
        mazeIDCont = 0; %#ok<*NASGU>
        for j=1:size(mazeIDs,2)-1
            if mazeIDs(j+1)<mazeIDs(j)
                mazeIDCont = j+1;
            end
        end
        figure('Name',folderList(i).name,'NumberTitle','off');
        
        %Make percent rewards plot
        subplot(2,2,1); %rewards plot
        cmap = colormap(hsv(max(mazeIDs))); %create color map with same number of colors as mazeIDs
        hold on;
        
        %determine x and y coordinates for lines along with cmap
        lineX(:,2) = (1:size(fileList.mat,1))';
        lineX(:,1) = lineX(:,2)-1;
        lineY(:,2) = percRewards(lineX(:,2));
        lineY(:,1) = cat(1,0,percRewards(lineX(2:end,1))');
        
        for j = min(mazeIDs):max(mazeIDs)
            if sum(mazeIDs == j) == 0
                continue;
            end
            xLines = lineX(find(mazeIDs==j)',:);
            yLines = lineY(find(mazeIDs==j)',:);
            for k = 1:size(xLines,1)
                line(xLines(k,:),yLines(k,:),'Color',cmap(j,:));
            end
        end
        
        k = 1;
        for j = min(mazeIDs):max(mazeIDs)
            if sum(mazeIDs == j) == 0 
                continue;
            end
            %plot lines and scatter
            h(k) = scatter(find(mazeIDs == j), percRewards(mazeIDs == j),40,...
                'filled','MarkerFaceColor',cmap(j,:),'MarkerEdgeColor',cmap(j,:));
            legendNames{k} = ['Maze ', num2str(j)]; %plot maze IDs
            k = k + 1;
        end
        
        legend(h,legendNames,'Location','NorthWest','FontSize',6);
        set(gca,'XTick',1:size(fileList.mat,1));
        if (xTickSession == 0 && size(fileList.mat,1)<10) || xTickSession == 2 
            set(gca,'XTickLabel',cellfun(@(x) x(7:12), fileList.mat, 'UniformOutput', false));
            xlabel('Date','FontSize',15);
        elseif (xTickSession == 0 && size(fileList.mat,1)>10) || xTickSession == 1
            set(gca,'XTickLabel',1:size(fileList.mat,1));
            xlabel('Session','FontSize',15);
        end
        ylim([0 100]);
        xlim([1 size(fileList.mat,1)]);
        title('Percent Reward Trials','FontSize',15);
        ylabel('Percent Trials (%)','FontSize',15);
        line([0 1000],[50 50],'Color','k','LineWidth',1,'LineStyle',':');
        text(size(fileList.mat,1)+.15,50,'Chance','FontSize',12);
        line([0 1000],[75 75],'Color','r','LineWidth',1,'LineStyle',':');
        text(size(fileList.mat,1)+.15,75,'Threshold','Color','r','FontSize',12);
        %Add n on top
        for k=1:size(fileList.mat)
            if percRewards(k) > 50
                text(k - .1,percRewards(k) - 5,['n=',num2str(numTrials(k))]);
            else
                text(k - .1,percRewards(k) + 5,['n=',num2str(numTrials(k))]);
            end
        end
        
        %Make trialsPerMin and rewardsPerMin if told
        if fig == 1
            subplot(2,2,2);
            if timeError
                plot(trialsPerMin(4:end),'-or');
                hold on;
                plot(rewardsPerMin(4:end),'-^b');
                set(gca,'XTick',1:size(fileList.mat,1));
                files = {fileList.mat{4:end}}; %#ok<*CCAT1>
                if (xTickSession == 0 && size(files,2)<10) || xTickSession == 2 
                    set(gca,'XTickLabel',cellfun(@(x) x(7:12), files, 'UniformOutput', false));
                    xlabel('Date');
                    xlim([1 size(files,2)]);
                elseif (xTickSession == 0 && size(files,2)>10) || xTickSession == 1
                    set(gca,'XTickLabel',4:size(files,2)+3);
                    xlabel('Session');
                    xlim([1 size(files,2)]);
                end
            else
                plot(trialsPerMin,'-or');
                hold on; 
                plot(rewardsPerMin,'-^b');
                set(gca,'XTick',1:size(fileList.mat,1));
                if (xTickSession == 0 && size(fileList.mat,1)<10) || xTickSession == 2 
                    set(gca,'XTickLabel',cellfun(@(x) x(7:12), fileList.mat, 'UniformOutput', false));
                    xlabel('Date','FontSize',15);
                elseif (xTickSession == 0 && size(fileList.mat,1)>10) || xTickSession == 1
                    set(gca,'XTickLabel',1:size(fileList.mat,1));
                    xlabel('Session','FontSize',15);
                end
            end
            title('Trials and Rewards Per Minute','FontSize',15);
            ylabel('Trials/Rewards Per Min','FontSize',15);
            legend('Trials Per Minute','Rewards Per Minute','Location','NorthWest');
        end
        
        %Make trial time plot if told
        if fig == 2
            if min(mazeIDs) ~= 1
                minJ = min(mazeIDs);
            else
                minJ = 2;
            end
            subplot(2,2,2); %trial time plot
            if timeError
                hold on;
                
                lineX(:,2) = (1:size(fileList.mat,1))';
                lineX(:,1) = lineX(:,2)-1;
                lineY(:,2) = meanTrialDur(lineX(:,2));
                lineY(:,1) = cat(1,0,meanTrialDur(lineX(2:end,1))');
                
                for j = min(mazeIDs):max(mazeIDs)
                    xLines = lineX(find(mazeIDs==j)',:);
                    yLines = lineY(find(mazeIDs==j)',:);
                    if j==1
                        xLines = xLines(4:end);
                        yLines = yLines(4:end);
                    end
                    for k = 1:size(xLines,1)
                        line(xLines(k,:),yLines(k,:),'Color',cmap(j,:));
                    end
                end
                
                for j=min(mazeIDs):max(mazeIDs)
                    xTimeInd = find(mazeIDs==j);
                    meanInd = meanTrialDur(mazeIDs==j);
                    stdInd = stdTrialDur(mazeIDs==j);
                    if j==1
                        xTimeInd = xTimeInd(xTimeInd>=4);
                        meanInd = meanInd(4:end);
                        stdInd = stdInd(4:end);
                    end
                    errorbar(xTimeInd,meanInd,stdInd,...
                        'o','LineStyle','none','Color',cmap(j,:),'MarkerFaceColor',cmap(j,:),...
                        'MarkerEdgeColor',cmap(j,:));
                end
                
                legend(legendNames);
                set(gca,'XTick',4:size(fileList.mat,1));
                files = {fileList.mat{4:end}};
                if (xTickSession == 0 && size(files,2)<10) || xTickSession == 2 
                    set(gca,'XTickLabel',cellfun(@(x) x(7:12), files, 'UniformOutput', false));
                    xlabel('Date','FontSize',15);
                    xlim([4 size(files,2)+3]);
                elseif (xTickSession == 0 && size(files,2)>10) || xTickSession == 1
                    set(gca,'XTickLabel',4:size(files,2)+3);
                    xlabel('Session','FontSize',15);
                    xlim([4 size(files,2)+3]);
                end
                ylim([min(meanTrialDur(4:end)-stdTrialDur(4:end))-20 ... 
                    max(stdTrialDur(4:end)+meanTrialDur(4:end))+20]);
            else 
                hold on;
                
                lineX(:,2) = (1:size(fileList.mat,1))';
                lineX(:,1) = lineX(:,2)-1;
                lineY(:,2) = meanTrialDur(lineX(:,2));
                lineY(:,1) = cat(1,0,meanTrialDur(lineX(2:end,1))');
                
                for j = min(mazeIDs):max(mazeIDs)
                    xLines = lineX(find(mazeIDs==j)',:);
                    yLines = lineY(find(mazeIDs==j)',:);
                    for k = 1:size(xLines,1)
                        line(xLines(k,:),yLines(k,:),'Color',cmap(j,:));
                    end
                end
                
                for j=min(mazeIDs):max(mazeIDs)
                    xTimeInd = find(mazeIDs==j);
                    meanInd = meanTrialDur(mazeIDs==j);
                    stdInd = stdTrialDur(mazeIDs==j);
                    errorbar(xTimeInd,meanInd,stdInd,...
                        'o','LineStyle','none','Color',cmap(j,:),'MarkerFaceColor',cmap(j,:),...
                        'MarkerEdgeColor',cmap(j,:));
                end
                
                legend(legendNames);
                set(gca,'XTick',1:size(fileList.mat,1));
                if (xTickSession == 0 && size(fileList.mat,1)<10) || xTickSession == 2 
                    set(gca,'XTickLabel',cellfun(@(x) x(7:12), fileList.mat, 'UniformOutput', false));
                    xlabel('Date','FontSize',15);
                elseif (xTickSession == 0 && size(fileList.mat,1)>10) || xTickSession == 1
                    set(gca,'XTickLabel',1:size(fileList.mat,1));
                    xlabel('Session','FontSize',15);
                end
                ylim([min(meanTrialDur-stdTrialDur)-20 ... 
                    max(stdTrialDur+meanTrialDur)+20]);        
            end

            title('Average Trial Time','FontSize',15);
            ylabel('Trial Time (s)','FontSize',15);
        end
        
        %Add table
        t = uitable('Units','Normalized','Position',[0.05 0.05 0.9 0.4]);
        tableData(:,1) = str2double(cellfun(@(x) x(7:12), fileList.mat, 'UniformOutput', false));
        tableData(:,2) = percRewards';
        tableData(:,3) = numTrials';
        tableData(:,4) = numRewards';
        tableData(:,5) = sessionTime';
        tableData(:,6) = rewardsPerMin';
        tableData(:,7) = trialsPerMin';
        tableData(:,8) = mazeIDs';
        tableData(:,9) = meanTrialDur';
        tableData(:,10) = percLeft';
        tableData(:,11) = percRewardsCond1';
        tableData(:,12) = percRewardsCond2';
        tableData(:,13) = percRewardsCond3';
        tableData(:,14) = percRewardsCond4';
        tableData(:,15) = percRewardsCond5';
        tableData(:,16) = percRewardsCond6';
        tableData(:,17) = percRewardsCond7';
        tableData(:,18) = percRewardsCond8';
        tableData(:,19) = cond1Trials';
        tableData(:,20) = cond2Trials';
        tableData(:,21) = cond3Trials';
        tableData(:,22) = cond4Trials';
        tableData(:,23) = cond5Trials';
        tableData(:,24) = cond6Trials';
        tableData(:,25) = cond7Trials';
        tableData(:,26) = cond8Trials';
        tableData(:,27) = percRewTower';
        tableData(:,28) = percRewNoTower';
        
        set(t,'Data',tableData,'ColumnName',{'Date','%Rewards','nTrials','nRewards',...
            'sessionTime(min)','rewardsPerMin','trialsPerMin','mazeID','meanTrialDur',...
            'percLeft','%RewardsCond1','%RewardsCond2','%RewardsCond3','%RewardsCond4'...
            '%RewardsCond5','%RewardsCond6','%RewardsCond7','%RewardsCond8',...
            'nCond1Trials','nCond2Trials','nCond3Trials','nCond4Trials',...
            'nCond5Trials','nCond6Trials','nCond7Trials','nCond8Trials','%RewardsTower',...
            '%RewardsNoTower'});
    end
    
    %Make figure for each animal of numTrials for each third of session
    if (fig == 3 || fig == 6)
        figure('Name',[folderList(i).name,'Within Session Data - ', dateInSession],'NumberTitle','off');
        
        xTimes = 1:size(winTrials,2);
        xTimes = xTimes/totTime;
        
        subplot(1,2,1),plot(xTimes,winTrials,'r');
        title('Trials Throughout Session')
        xlabel('Window Start (as fraction of total)');
        ylabel('Numer of Trials');
        xlim([0 1]);
        
        subplot(1,2,2),plot(xTimes,winPercRewards,'b');
        title('Percent Correct Throughout Session');
        xlabel('Window Start (as fraction of total)');
        ylabel('Percent Correct');
        ylim([0 100]);
        xlim([0 1]);
    end
    
    %Make plot of positions at trial end
    if fig == 4 || fig == 6
        endTrialFlag = false;
        subInd = 1;
        if sum(~isnan(cond4Trials)) == 1
            endTrialFlag = true;
            subInd = 2;
        end
        figure('Name',[folderList(i).name,'-Positions'],'NumberTitle','off');
        subplot(subInd,2,1);
        axis square;
        hold on;
        scatter(posCond1Rew(1,:),posCond1Rew(2,:),40,'xb');
        scatter(posCond1Err(1,:),posCond1Err(2,:),40,'xr');
        legend('Reward','Error');
        xlabel('X Position');
        ylabel('Y Position');
        title('Tower Left (White) Trial End Positions');
        ylimMin = -20-str2double(exper.variables.mazeWidth)-5;
        ylimMax = str2double(exper.variables.MazeLengthAhead) + str2double(exper.variables.mazeWidth)...
            + str2double(exper.variables.towerDistance) + 20;
        ylim([ylimMin ylimMax]);
        xlimCoord = (ylimMax-ylimMin)/2;
        xlim([-1*xlimCoord xlimCoord]);
        for j=1:size(exper.worlds{1}.objects,2)
            plot(exper.worlds{1}.objects{j}.x,exper.worlds{1}.objects{j}.y,'k');
        end

        subplot(subInd,2,2);
        axis square;
        hold on;
        scatter(posCond2Rew(1,:),posCond2Rew(2,:),40,'xb');
        scatter(posCond2Err(1,:),posCond2Err(2,:),40,'xr');
        legend('Reward','Error');
        xlabel('X Position');
        ylabel('Y Position');
        title('Tower Right (Green) Trial End Positions');
        xlim([-1*xlimCoord xlimCoord]);
        ylim([ylimMin ylimMax]);
        for j=1:size(exper.worlds{2}.objects,2)
            plot(exper.worlds{2}.objects{j}.x,exper.worlds{2}.objects{j}.y,'g');
        end
        
        if endTrialFlag
            subplot(subInd,2,3);
            axis square;
            hold on;
            scatter(posCond3Rew(1,:),posCond3Rew(2,:),40,'xb');
            scatter(posCond3Err(1,:),posCond3Err(2,:),40,'xr');
            legend('Reward','Error');
            xlabel('X Position');
            ylabel('Y Position');
            title('Tower Right (Green) Trial End Positions');
            xlim([-1*xlimCoord xlimCoord]);
            ylim([ylimMin ylimMax]);
            for j=1:size(exper.worlds{3}.objects,2)
                plot(exper.worlds{3}.objects{j}.x,exper.worlds{3}.objects{j}.y,'g');
            end
            
            subplot(subInd,2,4);
            axis square;
            hold on;
            scatter(posCond4Rew(1,:),posCond4Rew(2,:),40,'xb');
            scatter(posCond4Err(1,:),posCond4Err(2,:),40,'xr');
            legend('Reward','Error');
            xlabel('X Position');
            ylabel('Y Position');
            title('Tower Right (Green) Trial End Positions');
            xlim([-1*xlimCoord xlimCoord]);
            ylim([ylimMin ylimMax]);
            for j=1:size(exper.worlds{4}.objects,2)
                plot(exper.worlds{4}.objects{j}.x,exper.worlds{4}.objects{j}.y,'g');
            end
        end
    end
    
    %Make video of all trial paths
    if fig == 5 || fig == 6
        recFig = figure('Visible','off');
        winsize = get(recFig,'Position'); %get window size for movie
        winsize(1:2) = [0 0];
        cmapVid = colormap(hsv(numVidTrials));
        hold on;
        axis square;
        title('Mouse Paths');
        xlabel('X Position');
        ylabel('Y Position');
        ylimMin = -20-str2double(exper.variables.mazeWidth)-5;
        ylimMax = str2double(exper.variables.MazeLengthAhead) + str2double(exper.variables.mazeWidth)...
            + str2double(exper.variables.towerDistance) + 20;
        xlimCoord = (ylimMax-ylimMin)/2;
        xlim([-1*xlimCoord xlimCoord]);
        ylim([ylimMin ylimMax]);
        for j=1:size(exper.worlds{2}.objects,2)
            plot(exper.worlds{2}.objects{j}.x,exper.worlds{2}.objects{j}.y,'k','LineWidth',2);
        end
        m = 1;
        set(recFig,'Visible','off')
        for l=0.02:0.02:1
            k = 1;
            flag(1:size(vidPos,1)) = false;
            for j=2*round((whichVidTrial*size(vidPos,1)/2)/2)-1:2:(2*round((whichVidTrial*size(vidPos,1)/2)/2)-1+2*numVidTrials)-2
                if ~flag(j)
                    startPos(j) = 1;
                end
                flag(j) = true;
                stopPos(j) = floor(l*sum(~isnan(vidPos(j,:)))); %#ok<AGROW>
                plot(vidPos(j,startPos(j):stopPos(j)),vidPos(j+1,startPos(j):stopPos(j)),'Color',cmapVid(k,:));
                k = k + 1;
                startPos(j) = stopPos(j) + 1; %#ok<AGROW>
            end
            movieMat(:,m) = getframe(recFig,winsize); %get movie frame 
            m = m + 1;
        end
        close(recFig);
        
        %Play Movie
        movieFig = figure('Name',[folderList(i).name,'- Trial Paths'],'NumberTitle','off');
        % use 1st frame to get dimensions
        scrnsize = get(0,'ScreenSize');
        [h w] = size(movieMat(1).cdata);
        % resize figure based on frame's w x h, and place at (150, 150)
        set(movieFig,'Units','Normalized','Position', [150/scrnsize(3) 150/scrnsize(4) w/scrnsize(3) h/scrnsize(4)]);
        axis off
        % Place frames at bottom left
        movie(movieFig, movieMat,100,fps,[0 0 0 0]);
        
        %Save to avi
        if saveMovie
            movie2avi(movieMat,outfile, 'compression', 'none'); %#ok<UNRCH>
        end
    end
end

close(progressBar);

cd(oldDir);
end