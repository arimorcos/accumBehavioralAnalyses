function [decision, trace] = predictDecision(mazePattern, params, yPosBins, prevTurn, segRange)
%predictDecsision.m Predicts a mouse's decision using a drift-diffusion
%model given a maze-pattern and the input parameters 
%
%INPUTS
%mazePattern - 1 x nSeg array of mazePattern 
%params - structure containing input parameters
%   noise_a - sigma for normal distribution centered at 0. Noise is applied
%       at each bin.
%   noise_s - sigma for normal distribution centered at 0 for stimulus.
%   boundDist - distance to decision bound. 
%   bias - offset term for initial bias. Can be positive or negative. 
%   expScale - scale factor for segment weighting exponential with shape
%       1/exp(x/expScale)
%   tau - decay term for equation N = N0exp(-t/tau) 
%yPosBins - position values for each bin
%segRange - segRanges
%
%OUTPUT
%decision - binary variable for left or right turn 
%
%ASM 2/15

if nargin < 5 || isempty(segRange)
    segRange = 0:80:400;
end

%get nSeg
nSeg = length(mazePattern);

%convert mazePattern zeros to -1 
mazePattern(mazePattern==0) = -1;

%create distribution
normDist_a = makedist('Normal','sigma',params.noise_a);
normDist_s = makedist('Normal','sigma',params.noise_s);
normDist_lambda = makedist('Normal','sigma',abs(1-params.lambda),'mu',1);
normDist_bias = makedist('Normal','sigma',params.bias_sigma,'mu',params.bias_mu);

%generate primacy function
% weightingScale = 1e2;
% x = 1:nSeg*weightingScale;
% y = 1./exp(x/params.expScale);
% weightFac = y(round(linspace(1,nSeg*weightingScale,nSeg)));
% weightFac = 1./exp((1:nSeg)/params.expScale);
% weightFac = weightFac/sum(weightFac); %normalize to 0 and 1
weightFac = params.weightSlope*(1:nSeg) + params.weightOffset;
if any(weightFac < 0)
    weightFac = weightFac + abs(min(weightFac));
end
weightFac = weightFac/sum(weightFac);
% weightFac = params.weightFac;

%get nBins 
nBins = length(yPosBins);

%convert prevTurn to -1 if right
prevTurn(prevTurn==0) = -1;

%simulate 
trace = nan(nBins,1);
trace(1) = random(normDist_bias) + params.prevTurnWeight*prevTurn;
reachedBound = false;
currSeg = 1;
for binInd = 2:nBins 
    
    %initialize 
    tempVal = trace(binInd-1);
    
    %add drift 
    if params.lambda < 1 
        if sign(tempVal) == 1
            tempVal = tempVal - abs(random(normDist_lambda));
        else
            tempVal = tempVal + abs(random(normDist_lambda));
        end
    else
        if sign(tempVal) == 1
            tempVal = tempVal + abs(random(normDist_lambda));
        else
            tempVal = tempVal - abs(random(normDist_lambda));
        end
    end
    
    %add noise 
    tempVal = tempVal + random(normDist_a);
    
    %check if at segment boundary 
    if ~reachedBound && binInd == find(yPosBins >= segRange(currSeg),1,'first') %if matches current segment 
        
        %add segment information 
        tempVal = tempVal + mazePattern(currSeg)*weightFac(currSeg);
        
        %add noise
        tempVal = tempVal + random(normDist_s);
        
        %increment current segment 
        currSeg = min(currSeg + 1,nSeg);
        
    end
    
    %check if reached bound 
    if abs(tempVal) >= params.boundDist
        reachedBound = true;
    end
    
    %store 
    trace(binInd) = tempVal;
    
end

%get decision 
decision = sign(trace(end));







