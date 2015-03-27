function [decision, tracePDF] = predictDecision_sepWeights(mazePattern, params, yPosBins, prevTurn, segRange)
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
%decision - probability of left turn 
%
%ASM 2/15

if nargin < 5 || isempty(segRange)
    segRange = 0:80:400;
end

%get nSeg
nSeg = length(mazePattern);

%convert mazePattern zeros to -1
mazePattern(mazePattern==0) = -1;

%convert prevTurn to -1 if right
prevTurn(prevTurn==0) = -1;

%create distribution
normDist_a = makedist('Normal','sigma',params.noise_a);
normDist_s = makedist('Normal','sigma',params.noise_s);
normDist_pos_lambda = makedist('Normal','sigma',params.noise_a,'mu',log2(params.lambda));
normDist_neg_lambda = makedist('Normal','sigma',params.noise_a,'mu',log2(params.lambda));
normDist_bias = makedist('Normal','sigma',params.bias_sigma,'mu',params.bias_mu + ...
    params.prevTurnWeight*prevTurn);

%generate xValues for each
nBins = 1e4;
xVals = linspace(-5*params.boundDist, 5*params.boundDist, nBins);
xStep = mean(diff(xVals));

%get pdfs
posLambdaPDF = pdf(normDist_pos_lambda,xVals)'*xStep;
negLambdaPDF = pdf(normDist_neg_lambda,xVals)'*xStep;
aNoisePDF = pdf(normDist_a,xVals)'*xStep;
sNoisePDF = pdf(normDist_s,xVals)'*xStep;

%generate primacy function
% weightingScale = 1e2;
% x = 1:nSeg*weightingScale;
% y = 1./exp(x/params.expScale);
% weightFac = y(round(linspace(1,nSeg*weightingScale,nSeg)));
% weightFac = 1./exp((1:nSeg)/params.expScale);
% weightFac = weightFac/sum(weightFac); %normalize to 0 and 1
% weightFac = params.weightSlope*(1:nSeg) + params.weightOffset;
% if any(weightFac < 0)
    % weightFac = weightFac + abs(min(weightFac));
% end
% weightFac = weightFac/sum(weightFac);
weightFac = params.weightFac;

%get nBins
nSpatialBins = length(yPosBins);

%simulate
tracePDF = nan(nBins,nSpatialBins);
tracePDF(:,1) = pdf(normDist_bias, xVals)*xStep;
currSeg = 1;
for binInd = 2:nSpatialBins
    
    %initialize
    tempPDF = tracePDF(:,binInd-1);
    
    %exclude any density that has reached bound
    pastBoundInd = abs(xVals) >= params.boundDist;
    excludeProb = tempPDF(pastBoundInd);
    tempPDF(pastBoundInd) = 0;
    
    %add drift
%     if params.lambda < 1
%         if sign(tempPDF) == 1
%             tempPDF = combinePDFsFFT(tempPDF,negLambdaPDF);
%         else
%             tempPDF = combinePDFsFFT(tempPDF,posLambdaPDF);
%         end
%     else
%         if sign(tempPDF) == 1
%             tempPDF = combinePDFsFFT(tempPDF,posLambdaPDF);
%         else
%             tempPDF = combinePDFsFFT(tempPDF,negLambdaPDF);
%         end
%     end
    
    %add noise
    tempPDF = combinePDFsFFT(tempPDF,aNoisePDF);
    
    %check if at segment boundary
    if binInd == find(yPosBins >= segRange(currSeg),1,'first') %if matches current segment
        
        %add segment information
        tempPDF = combinePDFsFFT(tempPDF, normpdf(xVals, ...
            mazePattern(currSeg)*weightFac(currSeg), 0.01)'*xStep);
        
        %add noise
        tempPDF = combinePDFsFFT(tempPDF,sNoisePDF);
        
        %increment current segment
        currSeg = min(currSeg + 1,nSeg);
        
    end
    
    %add excluded density back in
    tempPDF(pastBoundInd) = tempPDF(pastBoundInd) + excludeProb;
    
    %store
    tracePDF(:,binInd) = tempPDF;
    
end

%get decision
decision = sum(tracePDF(ceil(length(xVals)/2):end,end));
end



