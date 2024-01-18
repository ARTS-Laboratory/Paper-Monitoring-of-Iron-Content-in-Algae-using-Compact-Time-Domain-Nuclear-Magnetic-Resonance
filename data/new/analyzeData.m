clear; close all; clc;

cd C:\Users\parke\OneDrive\Documents\ARTS\SPIE_2024\figures
folder = 'C:\Users\parke\OneDrive\Documents\GitHub\Paper-Monitoring-of-Iron-Content-in-Algae-using-Compact-Time-Domain-Nuclear-Magnetic-Resonance\data\new\files\';
load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\syntheticData\dataForFunc\time.mat

files = dir(fullfile(folder));

fsize = 7;

decayData = ones(3955,20);
for i = 3:height(files)
    ref = files(i).name;
    fullname = strcat(folder,ref);
    mat = readmatrix(fullname);
    decayData(:,i-2) = mat(:,2); 
end

rates = ones(20,1);
p = [1 6 11 16];
for i = 1:width(decayData)

    decay = decayData(:,i);
    if sum(p == i) == 1
        figure(1)
        hold on
        plot(time,decay)
    end

    lessVec = decay < exp(-3);
    locs = find(lessVec == 1);
    s = locs(1);

    newtime = time(1:s);
    decay = decay(1:s);
    mdl = fit(newtime,decay,'exp1');
    rates(i) = mdl.b;
    f = mdl.a*exp(mdl.b*newtime);
end
xlabel('time (s)')
ylabel('amplitude (V)')
xticks(0:1:5)
grid on; box on;
ax = gca; ax.FontSize = fsize; ax.FontName = 'times';
lgd = legend({'0','1','3','5'});
lgd.Title.String = 'distance (m)';
lgd.ItemTokenSize = [15,15];

f = gcf;
f.Units = 'inches';
f.Position(3:4) = [4,3];
% exportgraphics(ax,'t2_curves.png','Resolution',300)


rates0 = rates(1:5);
rates1 = rates(6:10);
rates3 = rates(11:15);
rates5 = rates(16:20);
ratesMat = [rates0 rates1 rates3 rates5];
muRates = mean(ratesMat);

distances = [0 1 3 5];
mdl = fitlm(distances,abs(muRates));
rsquared = mdl.Rsquared.Ordinary;

coeffs = table2array(mdl.Coefficients);
m = coeffs(2,1);
b = coeffs(1,1);

d = linspace(0,5,1000);
yhat = m*d + b;
sz = 50;

figure
hold on
scatter(distances,1./abs(muRates),sz,'LineWidth',1)
plot(d,1./yhat,'k--','LineWidth',1)
xlabel('distance (m)')
ylabel('T_2 time (s)')
xticks(0:1:5)
yticks(1.2:0.02:1.26)
% yticks(0.8:0.01:0.83);
text(2.5,0.8125,sprintf('R^{2} = %.3f',rsquared),'Color','black','fontname','times','FontSize',fsize)
grid on; box on;
ax = gca; ax.FontSize = fsize; ax.FontName = 'times';
lgd = legend({'sample mean','linear fit'});
lgd.Location = 'northwest';

f = gcf;
f.Units = 'inches';
f.Position(3:4) = [4,3];
% exportgraphics(ax,'rate_vs_distance.png','Resolution',300)