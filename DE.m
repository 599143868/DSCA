function Best_Cost = DE()
% dbstop if error
% close all;
% clear ;
% clc;
NP=60;       % 种群规模
D=10;        % 染色体长度
MAX_ITER=200;
F0=0.1;
CR=0.2;

MinX=[100,50,200,90,190,85,200,99,130,200];
MaxX=[250,230,500,265,490,265,500,265,440,490];
Pd=2700;
% yz=10^-6;
 
x=zeros(NP,D);    % 初始种群
v=zeros(NP,D);    % 变异种群
u=zeros(NP,D);    % 选择种群
%-----------------------种群初始化--------------------------
for i=1:1:D
x(:,i)=MinX(i)+(MaxX(i)-MinX(i))*rand(NP,1);    
end

x = Projection(x,MinX,MaxX,Pd); 
 
for i=1:NP
Best(i,:)=x(i,:);% 每个位置最优个体 之后不断更新
ob(i)=objfun(Best(i,:));
end

%          差分进化循环
for k=1:MAX_ITER
%----------------------变异-------------------------- 
    for m=1:NP
        r1=randi([1,NP],1,1);
        while(r1==m)
            r1=randi([1,NP],1,1);
        end
        
        r2=randi([1,NP],1,1);
        while(r2==r1)||(r2==m)
            r2=randi([1,NP],1,1);
        end
        
        r3=randi([1,NP],1,1);
        while(r3==m)||(r3==r2)||(r3==r1)
            r3=randi([1,NP],1,1);
        end
        %  产生不同的r1,r2,r3
        
        v(m,:)=x(r1,:)+F0*(x(r2,:)-x(r3,:));
 
    end   
 %----------------------交叉-------------------------- 
    r=randi([1,D],1,1);   % 这个交叉针对整个种群
    for n=1:D
        cr=rand;
        if (cr<=CR)||(n==r)  %必有一条纵向基因遗传自变异体
            u(:,n)=v(:,n);
        else
            u(:,n)=x(:,n);
        end
    end    
%----------------------调整使其满足约束条件-------------------------- 
    u = Projection(u,MinX,MaxX,Pd);

    % 计算新的适应度
    for m=1:NP
        ob_1(m)=objfun(u(m,:));
    end
%---------------------- 选择--------------------------    
    for m=1:NP
        if ob_1(m)<ob(m)
            x(m,:)=u(m,:);
        else
            x(m,:)=x(m,:);
        end       
    end
    % 现在x为经过选择后的种群
    for m=1:NP
        ob(m)=objfun(x(m,:));        
    end
    Cost_curve(k) = min(ob);
end
Best_Cost = min(Cost_curve);
end

function x = Projection(x,MinX,MaxX,Pd)
[NP,D] = size(x);
for i=1:NP
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
end
