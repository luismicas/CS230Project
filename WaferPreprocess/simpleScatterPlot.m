function simpleScatterPlot(x,y,z,fname)
pointsize = 12;

figure('Name',fname,'pos',[100 100 1100 900]);
scatter(x,y, pointsize,z,'filled','square');
xlim([min(x)*1.1 max(x)*1.1])
ylim([min(y)*1.1 max(y)*1.1])
title(fname);

colormap(jet);
colormap jet
colorbar
grid on

end

