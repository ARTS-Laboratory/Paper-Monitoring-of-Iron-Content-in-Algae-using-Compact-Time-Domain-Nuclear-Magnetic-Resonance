clear; close all; clc

load C:\Users\parke\OneDrive\Documents\GitHub\Paper-Monitoring-of-Iron-Content-in-Algae-using-Compact-Time-Domain-Nuclear-Magnetic-Resonance\data\waterData.mat

waterData = table2array(waterData);

time = waterData(:,1);
t2Data = waterData(:,2:end);

w = width(t2Data);
rates = ones(1,w);
% rates = ones(1,4);

% hold on
s = 1;
ix = 1;
for i = 1:w
    % figure
    % plot(time(s:end),t2Data(s:end,i))
    mdl = fit(time(s:end),t2Data(s:end,i),'exp1');
    % rates(i) = mdl.b;
    rates(ix) = mdl.b;
    f = mdl.a*exp(mdl.b*time);
    % hold on
    % plot(time,f,'k','LineWidth',2)
    ix = ix + 1;
end

distances = [0,0,0,1,1,1,3,3,3,5,5,5];
% distances = [0,1,3,5];
mdl = fitlm(distances,abs(rates));
params = table2array(mdl.Coefficients);
m = params(2,1); b = params(1,1);
d = linspace(0,5,1000);

sz = 100;
figure 
scatter(distances,abs(rates),sz,'k^')
hold on
plot(d,m*d+b,'k--','LineWidth',2)
xlabel('distance (m)')
ylabel('decay rate (V/s)')
grid on; box on;
lgd = legend;
lgd.String = {'linear fit','observation'};
ax = gca; ax.FontSize = 15;
% title(sprintf('R^2 = %.2f',mdl.Rsquared.ordinary))