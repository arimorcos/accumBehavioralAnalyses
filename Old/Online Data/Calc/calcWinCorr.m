%calcWinCorr.m

%function to look at the cross-correlagram between left/white turns and
%fraction left/white trials

function [corrRes] = calcWinCorr(procWinData)
    
    %remove NaNs if present
    wt = procWinData.winPercWhite(isfinite(procWinData.winPercWhite));
    fw = procWinData.winFracWhite(isfinite(procWinData.winFracWhite));
    lt = procWinData.winPercLeft(isfinite(procWinData.winPercLeft));
    fl = procWinData.winFracLeft(isfinite(procWinData.winFracLeft));
    
    %calculate theoretical max
    maxCorr = max(xcorr(lt,lt));
    
    %compute correlegrams 
    [whiteCorr whiteLag] = xcorr(wt,fw);
    [leftCorr leftLag] = xcorr(lt,fl);
    
    %calculate maximums
    [leftMax leftInd] = max(leftCorr);
    [whiteMax whiteInd] = max(whiteCorr);
    
    %calculate lag percentage
    corrRes.leftLag = leftLag(leftInd)/max(leftLag);
    corrRes.whiteLag = whiteLag(whiteInd)/max(whiteLag);
    
    %calculate peak ratio
    corrRes.leftPeak = leftMax/maxCorr;
    corrRes.whitePeak = whiteMax/maxCorr;    
    
end