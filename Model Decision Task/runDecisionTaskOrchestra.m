function searchOut = runDecisionTaskOrchestra(trainData, saveFile)

fprintf('Entered matlab\n');

%get seed
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
% searchOut = fminsearch(@(x) 1-getDecisionModelAccuracy(trainData, x),...
%     seed);

searchOut = seed;

%save to text
fprintf('this is the saveFile: %s\n',saveFile);
fid = fopen(saveFile,'w+');
fprintf(fid,'%d %d %d %d %d %d %d %d %d\n',searchOut);
fclose(fid);

end