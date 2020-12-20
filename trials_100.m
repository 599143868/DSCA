clc
clear

t0 = cputime;
for i = 1:100
    i = i
    best_totalcost_BBO(i) = BBO();
    
end
t_BBO = (cputime-t0)/100;
t0 = cputime;
for i = 1:100
    i = i
    best_totalcost_DE(i) = DE();
    
end
t_DE = (cputime-t0)/100;
t0 = cputime;
for i = 1:100
    i = i
    
    best_totalcost_PSO(i) = PSO();
end
t_PSO = (cputime-t0)/100;
t0 = cputime;
for i = 1:100
    i = i
    
    best_totalcost_GA(i) = GA();
end
t_GA = (cputime-t0)/100;

ave_BBO = mean(best_totalcost_BBO);
max_BBO = max(best_totalcost_BBO);
min_BBO = min(best_totalcost_BBO);

ave_DE = mean(best_totalcost_DE);
max_DE = max(best_totalcost_DE);
min_DE = min(best_totalcost_DE);

ave_PSO = mean(best_totalcost_PSO);
max_PSO = max(best_totalcost_PSO);
min_PSO = min(best_totalcost_PSO);

ave_GA = mean(best_totalcost_GA);
max_GA = max(best_totalcost_GA);
min_GA = min(best_totalcost_GA);

figure(1)


plot(best_totalcost_GA,'color',[0 0.5 0],'LineStyle','none','Marker','o','LineWidth',3);
hold on;
h1 = refline(0,ave_GA);
set(h1,'color',[0 0.5 0],'LineWidth',3,'LineStyle','--');

plot(best_totalcost_PSO,'color',[1 0.5 0],'LineStyle','none','Marker','o','LineWidth',3);
hold on;
h1 = refline(0,ave_PSO);
set(h1,'color',[1 0.5 0],'LineWidth',3,'LineStyle','--');

plot(best_totalcost_DE,'color',[0.3 0.5 0.7],'LineStyle','none','Marker','p','LineWidth',3);
hold on;
h2 = refline(0,ave_DE);
set(h2,'color',[0.3 0.5 0.7],'LineWidth',3,'LineStyle','--');

plot(best_totalcost_BBO,'color',[0.1 0.5 0.9],'LineStyle','none','Marker','p','LineWidth',3);
hold on;
h2 = refline(0,ave_BBO);
set(h2,'color',[0.1 0.5 0.9],'LineWidth',3,'LineStyle','--');

legend('GA','GA(Avg)','PSO','PSO(Avg)','DE','DE(Avg)','BBO','BBO(Avg)');
xlabel('\fontsize{14}Trials');ylabel('\fontsize{14}Total Cost($/h)');
set(gcf,'unit','centimeters','position',[10 5 20 16]);
set(gcf, 'PaperSize', [20 16]);