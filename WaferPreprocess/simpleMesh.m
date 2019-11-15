function simpleMesh(X,Y,Z,fname)
figure('Name',fname,'pos',[100 100 1200 800]);
mesh(X,Y,Z)
hold on 
axis tight
grid('on');
colormap(jet);
xlabel('X Stage Position (um)');
ylabel('Y Stage Position (um)');
zlabel('Z Height (um)');
% xlim([-150000 150000])
% ylim([-150000 150000])
view([0 90]);
title(fname);
colorbar
hold off
end

