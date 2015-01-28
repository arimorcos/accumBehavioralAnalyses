function wallRunInd = findStraightRunning(data,velThresh,posThresh)
%findStraightRunning.m Searches for periods where mouse runs straight into
%wall
%
%ASM 10/13

if nargin < 3; posThresh = 10; end
if nargin < 2; velThresh = 20; end

%get x and y velocity
xVel = data(5,:);
yVel = data(6,:);

%calculate total velocity
tVel = sqrt(xVel.^2 + yVel.^2);
tVel = tVel(1:end-1);

%get change in yPosition
yPosChange = diff(data(3,:));
xPosChange = diff(data(2,:));
totalChange = abs(xPosChange) + abs(yPosChange);


%find periods of straight running
fastRunInd = tVel >= velThresh;

%find periods of no position change
noChangeInd = totalChange <= posThresh;

%find periods of both
wallRunInd = fastRunInd & noChangeInd;

%plot
figure; 
plot(wallRunInd);
