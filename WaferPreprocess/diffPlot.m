function [coarseX,coarseY,coarseZ] = diffPlot(x,y,ECS,coarseStep)
differentials = false;
radius = 150000;
fill = false;
% Need to fit the raw data to a grid to get a consisten differential
% spacing. The fit step size is determined by the "coarseStep" input

xlin = linspace (min(x),max(x),floor((max(x)-min(x))/coarseStep));
ylin = linspace (min(y),max(y),floor((max(y)-min(y))/coarseStep));
[coarseZ,coarseX,coarseY]=gridfit(x,y,ECS,xlin,ylin,'smoothness',[3 5]); %,'smoothness',[3 10]);

if fill
    for i = 1:length(ylin)
        for j = 1:length(xlin)
            if xlin(j)^2+ylin(i)^2 > radius^2
                masknan (i,j)= nan;
                mask0   (i,j)= 0;
            else
                masknan (i,j)= 1;
                mask0   (i,j)= 1;
            end
        end
    end
    
    coarseZ = coarseZ.*masknan;
    simpleMesh(coarseX,coarseY,coarseZ,'Grid Fit Map');
end

if differentials
    diffy = diff(coarseZ,1,1); % Calculate Differential in Y
    diffx = diff(coarseZ,1,2); % Calculate Differential in X
    simpleMesh(coarseX(1:end-1,:),coarseY(1:end-1,:),diffy,'Y Differential');
    simpleMesh(coarseX(:,1:end-1),coarseY(:,1:end-1),diffx,'X Differential');
    
    maxDiffx = max(abs(diffx),[],1);
    
    figure
    plot(coarseX(:,1:end-1),maxDiffx)
    grid on
    title('Absolute (Max X-Differential) Profile');
    xlabel('X Stage Position');
    ylabel('Max Z Change (um)');
    peakDiff = max(maxDiffx)
end

end

