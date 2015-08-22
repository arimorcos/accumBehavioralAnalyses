function perf = getMousePerformanceAllAcc(mouse)
%getMousePerformanceAllAcc.m Grabs the maze name, session #, and accuracy
%
%INPUTS
%mouse - mouse name
%
%OUPTUTS
%perf - structure containing cell of maze names, session # and accuracy
%
%ASM 8/15

%get path
path = sprintf('D:\\DATA\\Ari\\Archived Mice\\%s',mouse);

%get list of all
fileList = dir2cell(sprintf('%s%s*Cell*.mat',path,filesep));

%remove red
fileList = fileList(cellfun(@isempty,strfind(fileList,'red')));

%append directory to each file
fileList = cellfun(@(x) fullfile(path,x),fileList,'uniformOutput',false);

%remove big files 
fileList = fileList(cellfun(@getFileSize,fileList) < 1e7);

%get nFiles
nFiles = length(fileList);

%initialize
mazeName = cell(nFiles,1);
accuracy = nan(nFiles,1);
keep = true(nFiles,1);
intGraded = nan(nFiles,1);

%loop through
for file = 1:nFiles
    
    %display progress
    dispProgress('Processing %d/%d',file,file,nFiles);
    
    %load in data
    data = load(fileList{file},'dataCell');
    dataCell = data.dataCell;
    
    %check if empty
    if isempty(dataCell)
        keep(file) = false;
        continue;
    end
    
    %get accuracy
    accuracy(file) = 100*sum(getCellVals(dataCell,'result.correct'))/length(dataCell);
    
    %get name
    mazeName{file} = dataCell{1}.info.name;
    
    %get session time
    sessionTime = dnum2secs(dataCell{end}.time.stop - dataCell{1}.time.start)/60;
    if sessionTime < 25 %remove sessions less than 25 minutes
        keep(file) = false;
    end
    
    if strfind(mazeName{file},'Maze10_')
        
        %data file
        dataFile = strrep(fileList{file},'_Cell','');
        data = load(dataFile,'exper');
        exper = data.exper;
        
        %find line with intGraded
        matchToken = regexpi(exper.codeText,'.*vr.intGraded.*=.*(\d);.*','tokens');
        matchToken = cat(1,matchToken{:});
        if isempty(matchToken)
            keep(file) = false;
            continue;
        end
        intGraded(file) = str2double(matchToken{1});
        
    end
end

%add to structure
perf.mazeName = mazeName(keep);
perf.accuracy = accuracy(keep);
perf.intGraded = intGraded(keep);

%save
saveName = sprintf('D:\\DATA\\Analyzed Data\\150803_mousePerformance\\%s',mouse);
save(saveName,'perf');