%getWhiteMazes.m

%function to convert whiteMazes into array

%ASM 6/13/12

function [whiteMazes] = getWhiteMazes(exper)
    whiteMazes = zeros(1,length(exper.variables.whiteMazes));
    for k = 1:length(exper.variables.whiteMazes)
        whiteMazes(1,k) = str2double(exper.variables.whiteMazes(k));
    end
end