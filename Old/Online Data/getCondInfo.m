%getCondInfo.m

%function to use leftMazes and whiteMazes to determine the proper string
%for each condition

function [condInfo] = getCondInfo(leftMazes,whiteMazes)

condInfo = cell(1,length(leftMazes));

for i=1:length(leftMazes)
    if whiteMazes(i) == 1
        condInfo{i} = 'White ';
    else
        condInfo{i} = 'Black ';
    end
    if leftMazes(i) == 1
        condInfo{i} = [condInfo{i},'Left'];
    else
        condInfo{i} = [condInfo{i},'Right'];
    end
end
end