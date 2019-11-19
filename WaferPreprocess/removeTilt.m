function [Z_lt1,plane] = removeTilt(x,y,ECS)

map = [x y ECS];

% Fit Plane
cm1 = mean(map,1);
cm1(:,1:2) = 0;
meanMap1 = bsxfun(@minus,map,cm1);
[U,S,V] = svd(meanMap1,0);
diag(S);
P = V(:,3);
Z_pl1 = (dot(P,cm1) - P(1)*x - P(2)*y)/P(3);
plane = [x,y,Z_pl1];

% Map less tilt
Z_lt1 = ECS-Z_pl1;
Z_lt1 = Z_lt1- mean([max(Z_lt1) min(Z_lt1)]);
mapLessTilt1 = map-plane;
end

