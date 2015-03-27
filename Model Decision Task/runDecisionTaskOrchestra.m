function searchOut = runDecisionTaskOrchestra(dataLoc)

fprintf('Entered matlab\n');

%load train data
fprintf('Loading trainData...');
load(dataLoc,'trainData');
fprintf('Complete\n');

%get job number 
% lsfid = str2num(getenv('LSB_JOBINDEX'));
saveFileTXT = '/home/asm27/decisionTaskOut/decisionTaskFit.txt';

%get seed
rng(sum(100*clock));
seed = [randn ...%weight slope
    0.5*randn ... %weight offset
    randn ... %bias_mu
    2*rand ... %bias_sigma
    2*rand ... %noise_s
    0.5*rand ... %noise_a
    2*rand ... %lambda
    8*rand ... %boundDist
    4*rand ... %prevTurnWeight
    ];

%run fminsearch
fprintf('Getting minimum...\n');
options.Display = 'iter';
searchOut = fminsearch(@(x) getDecisionModelLogLikelihood(trainData, x),...
     seed, options);
%searchOut = seed;
fprintf('Complete\n');

%save to text
fprintf('this is the saveFile: %s\n',saveFileTXT);
fid = fopen(saveFileTXT,'a+');
fprintf(fid,'%d, %d, %d, %d, %d, %d, %d, %d, %d\n',searchOut);
fclose(fid);

end