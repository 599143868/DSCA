
function Best_Cost = PSO()
fitness = @objfun;
NP = 60;
c1 = 2;  c2 = 2;% c1,c2：学习因子
wmax = 0.8; % wmax：惯性权重最大值
wmin = 0.6; % wmin：惯性权重最小值
MAX_ITER = 100; % M：最大迭代次数
D = 10; % D：搜索空间维数
% N：初始化群体个体数目
MinX=[100,50,200,90,190,85,200,99,130,200];
MaxX=[250,230,500,265,490,265,500,265,440,490];
Pd=2700;

% 初始化种群的个体（可以在这里限定位置和速度的范围）
for i=1:1:D
x(:,i)=MinX(i)+(MaxX(i)-MinX(i))*rand(NP,1);    
end

for i = 1:NP
    for j=1:D
        v(i,j) = randn; % 随即初始化速度
    end
    while(1)
        S=sum(x(i,:));
        delta=Pd-S;
        if abs(delta)<1e-3
            break;          
        end
        x(i,:)=x(i,:)+delta/D;
        for j=1:D %检查是否越界
            if(x(i,j)<MinX(j))
                x(i,j)=MinX(j);
            elseif(x(i,j)>MaxX(j)) 
                x(i,j)=MaxX(j);
            end
         end
     end
end

%先计算各个粒子的适应度，并初始化个体最优解pi和整体最优解pg %
%初始化pi %
for i = 1:NP
    p(i) = fitness(x(i,:)) ;
    y(i,:) = x(i,:) ;
end
%初始化pg %
pg = x(NP,:) ;
%得到初始的全局最优pg %
for i = 1:(NP-1)
    if fitness(x(i,:)) < fitness(pg)
        pg = x(i,:) ;
    end
end
 
%主循环函数，进行迭代，直到达到精度的要求 %
for k = 1:MAX_ITER
    for j = 1:NP
        fv(j) = fitness(x(j,:)) ;
    end
    fvag = sum(fv)/NP ;
    fmin = min(fv);
    for i = 1:NP    %更新函数,其中v是速度向量，x为位置,i为迭代特征
        if fv(i) <= fvag
            w = wmin+(fv(i)-fmin)*(wmax-wmin)/(fvag-fmin) ;   %依据早熟收敛程度和适应度值进行调整
        else
            w = wmax ;
        end
        v(i,:) = w*v(i,:)+c1*rand*(y(i,:)-x(i,:))+c2*rand*(pg-x(i,:)) ;
        x(i,:) = x(i,:)+v(i,:) ;
        
        while(1)
        S=sum(x(i,:));
        delta=Pd-S;
        if abs(delta)<1e-3
            break;          
        end
        x(i,:)=x(i,:)+delta/D;
        for j=1:D %检查是否越界
            if(x(i,j)<MinX(j))
                x(i,j)=MinX(j);
            elseif(x(i,j)>MaxX(j)) 
                x(i,j)=MaxX(j);
            end
         end
        end
           
        if fitness(x(i,:)) < p(i)
            p(i) = fitness(x(i,:)) ;
            y(i,:) = x(i,:) ;
        end
        if p(i) < fitness(pg)
            pg = y(i,:) ;
        end
    end
    
     Cost_curve(k) = fitness(pg) ;
end
 
%给出最后的计算结果 %
% xm = pg' ;
% fv = fitness(pg) ;
Best_Cost = min(Cost_curve);
end
