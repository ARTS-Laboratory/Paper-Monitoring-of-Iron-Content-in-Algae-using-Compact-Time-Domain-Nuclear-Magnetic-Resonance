clear; close all; clc;

folder = 'C:\Users\parke\OneDrive\Documents\GitHub\Paper-Monitoring-of-Iron-Content-in-Algae-using-Compact-Time-Domain-Nuclear-Magnetic-Resonance\data\new\files\';
load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\syntheticData\dataForFunc\time.mat

files = dir(fullfile(folder));
fsize = 7;

plotT2 = 0;

decayData = ones(3955,20);
for i = 3:height(files)
    ref = files(i).name;
    fullname = strcat(folder,ref);
    mat = readmatrix(fullname);
    decayData(:,i-2) = mat(:,2); 
end

T2time = 0.5*exp(-1)*ones(1,1000);
d = linspace(0,5,1000);

initAmp = 0.5*ones(1,1000);
dIA = linspace(0,1,1000);

rates = ones(20,1);
p = [1 6 11 16];
for i = 1:width(decayData)

    decay = decayData(:,i);
    
    if plotT2
        if sum(p == i) == 1
            figure(1)
            hold on
            plot(time,decay)
        end
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

if plotT2

    plot(d,T2time,'k--')
    plot(dIA,initAmp,'k--')

    xlabel('time (s)')
    ylabel('amplitude (V)')
    xticks(0:1:5)
    grid on; box on;
    ax = gca; ax.FontSize = fsize; ax.FontName = 'serif';
    lgd = legend({'0','1','3','5'});
    lgd.Title.String = 'distance (m)';
    lgd.ItemTokenSize = [15,15];
    
    text(1.05,0.505,'initial amplitude','FontSize',fsize,'FontName','serif')
    text(2.25,0.21,'~ 37% of initial','FontSize',fsize,'FontName','serif')

    f = gcf;
    f.Units = 'inches';
    f.Position(3:4) = [3.5,3];
    pbaspect([1 0.8 1])
    % exportgraphics(ax,'t2_curves.pdf')
end

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

mdl1 = fitlm(distances(1:3),abs(muRates(1:3)));
rsquared1 = mdl1.Rsquared.Ordinary;

coeffs1 = table2array(mdl1.Coefficients);
m1 = coeffs1(2,1);
b1 = coeffs1(1,1);

d1 = linspace(0,3,1000);
yhat1 = m1*d1 + b1;

sz = 50;

figure
hold on
scatter(distances,1./abs(muRates),sz,'LineWidth',1)
plot(d,1./yhat,'k-.','LineWidth',1)
plot(d1,1./yhat1,'k:','LineWidth',1)
plot(linspace(3,5,1000),1./yhat1(end)*ones(1,1000),'k:','LineWidth',1)
xlabel('distance from algae mat (m)')
ylabel('T2 time (s)')
xlim([-0.5,5.5])
xticks(0:1:5)
yticks(1.2:0.02:1.26)
% yticks(0.8:0.01:0.83);
text(2.2,1.23,sprintf('R^{2} = %.3f',rsquared),'Color','black','fontname','serif','FontSize',fsize)
text(1.4,1.245,sprintf('R^{2} = %.3f',rsquared1),'Color','black','fontname','serif','FontSize',fsize)
grid on; box on;
ax = gca; ax.FontSize = fsize; ax.FontName = 'serif';

lgd = legend({'sample mean','linear fit (standard)','linear fit (assuming saturation)'});
lgd.Location = 'southeast';

f = gcf;
f.Units = 'inches';
f.Position(3:4) = [3.5,3];
pbaspect([1,0.8,1])
% exportgraphics(ax,'rate_vs_distance.jpg','Resolution',300)