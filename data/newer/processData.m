clear; close all; clc;

cd C:\Users\parke\OneDrive\Documents\GitHub\Paper-Monitoring-of-Iron-Content-in-Algae-using-Compact-Time-Domain-Nuclear-Magnetic-Resonance\data\newer
load time.mat

factor = 1;

% options
bulk = 1;
spinechos = 0;
tap = 0;

if bulk
    % bulk of data
    bulkData = table2array(readtable('aggregate.xlsx'));
    bulkData = bulkData*factor;
    afterSep = table2array(readtable('algae_after_sep.csv'));
    
    % filter
    N = 10;
    bulkData = movmedian(bulkData,N);
    afterSep = movmedian(afterSep,N);
    
    % extract data
    diT2 = bulkData(:,1);
    algaeT2 = bulkData(:,2);
    take1 = bulkData(:,3);
    take2 = bulkData(:,4);
    take3 = bulkData(:,5);
    
    % downsample
    M = 20;
    tDown = downsample(time,M);
    diT2down = downsample(diT2,M);
    
    % make plot
    hold on
    plot(time,algaeT2,'LineWidth',1)
    plot(time,afterSep,'LineWidth',1)
    plot(tDown,diT2down,'k--','LineWidth',1)
end

if spinechos
    s = 1650;
    spinEchos = table2array(readtable('spin_echos.xlsx'))*factor;
    fs = 300e3;
    spinEchos = spinEchos(1:s);
    timeSE = (0:numel(spinEchos)-1)/fs;

    % spin echoes
    figure
    plot(timeSE*1e3,spinEchos)
    xlabel('time (ms)')
    ylabel('amplitude (V)')
    grid on; box on;
end

if tap
    % tap water
    tapT2 = table2array(readtable('tap_t2.csv'))*factor;

    % filter
    N = 10;
    tapT2 = movmedian(tapT2,N);

    % make plot
    figure
    plot(time,tapT2,'LineWidth',1)
    xlabel('time (s)')
    ylabel('amplitude (V)')
    grid on; box on;
end