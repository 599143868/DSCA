
clc
clear
close all
DGnum = 10;
A = [0.2697e2 0.2113e2 0
     0.1184e3 0.1865e1 0.1365e2
     0.3979e2 -0.5914e2 -0.2875e1
     0.1983e1 0.5285e2 0.2668e3
     0.1392e2 0.9976e2 -0.5399e2
     0.5285e2 0.1983e1 0.2668e3
     0.1893e2 0.4377e2 -0.4335e2
     0.1983e1 0.5285e2 0.2668e3
     0.8853e2 0.1530e2 0.1423e2
     0.1397e2 -0.6113e2 0.4671e2
     ];
 
B = [-0.3975e0 -0.3059e0 0
     -0.1269e1 -0.3988e-1 -0.1980e0
     -0.3116e0 0.4864e0 0.3389e-1
     -0.3114e-1 -0.6348e0 -0.2338e1
     -0.8733e-1 -0.5206e0 0.4462e0
     -0.6348e0 -0.3114e-1 -0.2338e1
     -0.1325e0 -0.2267e0 0.3559e0
     -0.3114e-1 -0.6348e0 -0.2338e1
     -0.5675e0 -0.4514e-1 -0.1817e-1
     -0.9938e-1 0.5084e0 -0.2024e0
    ];

C = [0.2176e-2 0.1861e-2 0
     0.4194e-2 0.1138e-2 0.1620e-2
     0.1457e-2 0.1176e-4 0.8035e-3
     0.1049e-2 0.2758e-2 0.5935e-2
     0.1066e-2 0.1597e-2 0.1498e-3
     0.2758e-2 0.1049e-2 0.5935e-2
     0.1107e-2 0.1165e-2 0.2454e-3
     0.1049e-2 0.2758e-2 0.5935e-2
     0.1554e-2 0.7033e-2 0.6121e-3
     0.1102e-2 0.4164e-4 0.1137e-2
    ];

E = [0.2697e-1 0.2113e-1 0
     0.1184e0 0.1865e-2 0.1365e-1
     0.3979e-1 -0.5914e-1 -0.2876e-2
     0.1983e-2 0.5285e-1 0.2668e0
     0.1392e-1 0.9976e-1 -0.5399e-1
     0.5285e-1 0.1983e-2 0.2668e0
     0.1893e-1 0.4377e-1 -0.4335e-1
     0.1983e-2 0.5285e-1 0.2668e0
     0.8853e-1 0.1423e-1 0.1423e-1
     0.1397e-1 -0.6113e-1 0.4671e-1
    ];

F = [-0.3975e1 -0.3059e1 0 
     -0.1269e2 -0.3988e0 -0.1980e1
     -0.3116e1 0.4864e1 0.3389e0
     -0.3114e0 -0.6348e1 -0.2338e2
     -0.8733e0 -0.5206e1 0.4462e1
     -0.6348e1 -0.3114e0 -0.2338e2
     -0.1325e1 -0.2267e1 0.3559e1
     -0.3114e0 -0.6348e1 -0.2338e2
     -0.5675e1 -0.1817e0 -0.1817e0
     -0.9938e0 0.5084e1 -0.2024e1
    ];
Pmax = [250,230,500,265,490,265,500,265,440,490];
Pmin = [100,50,200,90,190,85,200,99,130,200];
FuelSwitchingPoint = [100,196,250,  0;
                      50 ,114,157,230;
                      200,332,388,500;
                      90 ,138,200,265;
                      190,338,407,490;
                      85 ,138,200,265;
                      200,331,391,500;
                      99 ,138,200,265;
                      130,213,370,440;
                      200,362,407,490];

FuelType = [2,3,3,3,3,3,3,3,3,3];
                  
M = 6;
Pd = 2700;

for i = 1:DGnum
    for fuel = 1:FuelType(i)
        K(i,fuel) = ceil(abs(F(i,fuel))*(FuelSwitchingPoint(i,fuel+1)-FuelSwitchingPoint(i,fuel))/pi*M);
    end
end

for i = 1:DGnum
    for fuel = 1:FuelType(i)
        for m = 1:K(i,fuel)
            Pmin_mi(m,fuel,i) = FuelSwitchingPoint(i,fuel) + (m-1)*pi/(M*abs(F(i,fuel)));
            if m ~= K(i,fuel)
                Pmax_mi(m,fuel,i) = FuelSwitchingPoint(i,fuel) + m*pi/(M*abs(F(i,fuel)));
            else
                Pmax_mi(m,fuel,i) = FuelSwitchingPoint(i,fuel+1);
            end
        end
    end
end

for i = 1:DGnum    
    for fuel = 1:FuelType(i)
        for m = 1:K(i,fuel)
            bmi(m,fuel,i) = (cal_objvalue(Pmax_mi(m,fuel,i),i)-cal_objvalue(Pmin_mi(m,fuel,i),i)) / (Pmax_mi(m,fuel,i)-Pmin_mi(m,fuel,i));
            cmi(m,fuel,i) = cal_objvalue(Pmin_mi(m,fuel,i),i) - bmi(m,fuel,i)*Pmin_mi(m,fuel,i);
        end
    end
end
%% 变量
P = sdpvar(1,DGnum,'full'); 
Pmi = sdpvar(size(Pmax_mi,1)*max(FuelType),DGnum,'full');                       
Umi = binvar(size(Pmax_mi,1)*max(FuelType),DGnum,'full');
%% 目标函数
Objective = 0;
for i = 1:DGnum    
    for fuel = 1:FuelType(i)
        for m = 1:K(i,fuel)
            if fuel == 1
                Objective = Objective + (bmi(m,fuel,i)*Pmi(m,i)+cmi(m,fuel,i)*Umi(m,i));    %Pmi(m,i) %Umi(m,i)
            else
                Objective = Objective + (bmi(m,fuel,i)*Pmi(m+sum(K(i,1:fuel-1)),i)+cmi(m,fuel,i)*Umi(m+sum(K(i,1:fuel-1)),i)); %Pmi(m+sum(K(i,1:fuel-1)),i)  %Umi(m+sum(K(i,1:fuel-1)),i) 
            end    
        end
    end
end
%% 约束条件
Constraints = [];
for i = 1:DGnum
    Constraints = [Constraints,P(i)==sum(Pmi(1:sum(K(i,:)),i))];
end
for i = 1:DGnum    
    for fuel = 1:FuelType(i)
        for m = 1:K(i,fuel)
            if fuel == 1
                Constraints = [Constraints,Pmin_mi(m,fuel,i)*Umi(m,i) <= Pmi(m,i)];
                Constraints = [Constraints,Pmax_mi(m,fuel,i)*Umi(m,i) >= Pmi(m,i)];
            else
                Constraints = [Constraints,Pmin_mi(m,fuel,i)*Umi(m+sum(K(i,1:fuel-1)),i) <= Pmi(m+sum(K(i,1:fuel-1)),i)];
                Constraints = [Constraints,Pmax_mi(m,fuel,i)*Umi(m+sum(K(i,1:fuel-1)),i) >= Pmi(m+sum(K(i,1:fuel-1)),i)];
            end
        end
    end
end
for i = 1:DGnum
    Constraints = [Constraints,sum(Umi(1:sum(K(i,:)),i))==1];
end
for i = 1:DGnum
    Constraints = [Constraints,P(i)>=Pmin(i),P(i)<=Pmax(i)];
end
Constraints = [Constraints,sum(P)==Pd];

%% 求解
% options = sdpsettings('verbose',1,'debug',1,'solver','gurobi','savesolveroutput',1,'savesolverinput',1);
sol = optimize(Constraints,Objective);

if sol.problem == 0
    result = value(P);
else
    disp('Hmm, something went wrong!');
	sol.info
	yalmiperror(sol.problem)
 end

Cost = objfun(result);




