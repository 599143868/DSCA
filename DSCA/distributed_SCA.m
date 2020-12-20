% function [solution,objv_min] = distributed_SCA(Pd,upper,lower)
clc
clear
DGnum = 10;
Pd = 2700;
upper = [250,230,500,265,490,265,500,265,440,490];
lower = [100,50,200,90,190,85,200,99,130,200];
max_iter = 300000;
initial_x = upper;
initial_x = initial_x*(Pd/sum(initial_x));
stepsize = 1.0;
omega = 0.99;
tao = 2;
X = zeros(DGnum,max_iter);
objv_min = 1e8;
Objv_min = 1e8*ones(1,max_iter);
index_min = 0;

for i = 1:1:max_iter       
    objv(i) = objfun(initial_x);
    if objv_min > objv(i)
        objv_min = objv(i);
        index_min = i;
        x_min = initial_x;
    end
    Objv_min(i) = objv_min;
    
    if i==2000
        tao = 16;
        initial_x = x_min;
    elseif i== 100000
        tao = 50;
        initial_x = x_min;
    elseif i== 250000
        tao = 100;
        initial_x = x_min;
    end
    
    grad = [];
    for DG = 1:1:DGnum
        grad(end+1) = cal_gradvalue(initial_x(DG),DG);
    end
    for DG = 1:1:DGnum
        x(DG) = local_opti((tao*initial_x(DG)-grad(DG))/tao,DG);
    end
    tic;
    x = BGD(x,upper,lower,Pd); 
    t(i) = toc;
    X(:,i) = initial_x;  %Record the solution.
    for DG = 1:1:DGnum
        initial_x(DG) = initial_x(DG) + stepsize*(x(DG)-initial_x(DG));  
    end
        
    zeta = 1;temp_x = initial_x;
    while(1)
        differentiability = [];
        for DG = 1:1:DGnum
            differentiability(end+1) = check_differentiability(temp_x(DG),DG);
        end
        
        if sum(differentiability)==DGnum
            initial_x = temp_x;
            break;
        end 
        
        for DG = 1:1:DGnum
            if differentiability(DG) == 0
                disp('found nondifferentiable point.')
                perturbation(DG) = (omega^zeta)*stepsize*(X(DG,i)-x(DG)); 
            else
                perturbation(DG) = 0;
            end
        end
        temp_x = temp_x + perturbation;
        zeta = zeta + 1;
    end

end
AA_plot = AA();
figure(1)
loglog(1:length(AA_plot),AA_plot,'color',[0.4660 0.6740 0.1880],'LineStyle',':','LineWidth',2);hold on;
loglog(1:max_iter,Objv_min,'color',[0.8500 0.3250 0.0980],'LineStyle',':','LineWidth',2);hold on;
grid on;
set(gca,'YLim',[620 700]);
xlabel('Iterations');ylabel('Total Generation Cost($/h)');
text(60,627,['(',num2str(length(AA_plot)),',',num2str(626.7090),')']);
text(100000,628,['(','3e5',',',num2str(Objv_min(max_iter)),')']);
legend('AA','DSCA');

