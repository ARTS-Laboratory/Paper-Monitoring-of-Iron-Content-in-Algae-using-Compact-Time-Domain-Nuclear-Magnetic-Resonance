clear; close all; clc;

R2vals = [6.19 11.27 15.28 39.65; 17.87 41.58 190.85 NaN; 3.94 6.52 40.97 98.17];
MPvals = [0.065 0.131 0.183 0.497; 0.216 0.522 2.477 NaN; 0.036 0.070 0.514 1.252];

locs = 1:4;

hold on
for i = 1:3

    switch i
        case 1
            c = [0 0.4470 0.7410];
        case 2
            c = [0.4940 0.1840 0.5560];
        case 3
            c = [0.9290 0.6940 0.1250];
    end

    yyaxis left
    h(1) = plot(locs,R2vals(i,:));
    ylabel('R2 value (s^{-1})')
    ax = gca; ax.YColor = 'k'; ax.FontName = 'times'; ax.FontSize = 7;
    yyaxis right
    h(2) = plot(locs,MPvals(i,:),'o-','Color',c,'LineWidth',2);
    ax = gca; ax.YColor = 'k'; ax.FontName = 'times'; ax.FontSize = 7;
    ylabel('estimated MP concentration (mg/mL)')
    ylim([-0.1,2.6])
    delete(h(1))
end
yyaxis left
yticks(0:0.2:1)
yticklabels({'','40','80','120','160','200'})
grid on; box on;
xlim([0.25,4.75])
xticks(0:1:5)
xticklabels({'','','','',''})
lgd = legend({'A-003','A-039','A-028'});
lgd.Location = 'northwest';

f = gcf;
f.Units = 'inches';
f.Position(3:4) = [6,3];
% exportgraphics(ax,'mp_conc.png','Resolution',300)

