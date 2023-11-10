clear; close all; clc;

load C:\Users\parke\OneDrive\Documents\GitHub\Paper-Monitoring-of-Iron-Content-in-Algae-using-Compact-Time-Domain-Nuclear-Magnetic-Resonance\preliminaryData.mat

time = data(:,1);
t2Data = data(:,2:end);

distances = [0,1,3,5];
rates = ones(1,4);
hold on
for i = 1:width(t2Data)
    plot(time,t2Data(:,i))
    mdl = fit(time,t2Data(:,i),'exp1');
    rates(i) = mdl.b;
end
xlabel('time (s)')
ylabel('voltage (V)')
grid on; box on;
lgd = legend;
lgd.Title.String = 'distance (m)';
lgd.String = {'0','1','3','5'};
ax = gca; ax.FontSize = 15;

mdl = fitlm(distances,abs(rates));
params = table2array(mdl.Coefficients);
m = params(2,1); b = params(1,1);
d = linspace(0,5,1000);
 
sz = 100;
figure 
plot(d,m*d+b,'k--','LineWidth',2)
hold on
scatter(distances,abs(rates),sz,'^','filled')
xlabel('distance (m)')
ylabel('decay rate (V/s)')
grid on; box on;
lgd = legend;
lgd.String = {'linear fit','observations'};
ax = gca; ax.FontSize = 15;
title(sprintf('R^2 = %.2f',mdl.Rsquared.ordinary))