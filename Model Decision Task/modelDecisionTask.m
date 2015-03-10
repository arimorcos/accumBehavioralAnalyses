function [modelFits] = modelDecisionTask(dataCell)
%modelDecisionTask.m Models the decision task using the drift-diffusion
%model. 
%
%INPUTS
%dataCell - dataCell containing behavioral information. Can be from
%   multiple days. 
%
%OUTPUTS
%modelFits - structure containing model fits 
%
%
%ASM 2/15

%ensure contains integration data 
assert(isfield(dataCell{1}.maze),'numLeft','dataCell must contain integration data');

%get posBins
posBins = -50:5:600;

%initialize parameters 
params.noise = 0.2;
params.boundDist = 1;
params.bias = 0;
params.expScale = 100;

%define parameters to fit 