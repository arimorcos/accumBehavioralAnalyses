%initCorrRes.m

%function to initialize corrRes

function [corrRes] = initCorrRes()
    corrRes.leftLag = NaN;
    corrRes.whiteLag = NaN;
    corrRes.leftPeak = NaN;
    corrRes.whitePeak = NaN;
end