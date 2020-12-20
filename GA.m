% clc
% clear
function Best_Cost = GA()
%population size
NP=60;
%chrome length
D = 10;
%crossover probobility
pc = 0.6;
%mutation probobility
pm = 0.01;

MinX=[100,50,200,90,190,85,200,99,130,200];
MaxX=[250,230,500,265,490,265,500,265,440,490];
Pd=2700;

%Maximum Iteration Number
MAX_ITER = 200;
%initialize the population
for i = 1:NP
x(i,:)=MinX+(MaxX-MinX).*rand(1,D);    
end
%let the population meet the constraints
x = Projection(x,MinX,MaxX,Pd);

for k=1:MAX_ITER
    x_new = selection(x);
    x_new = crossover(x_new,pc);
    x_new = mutation(x_new,pm);
    x = Projection(x_new,MinX,MaxX,Pd);
    for i=1:NP
    ob(i)=objfun(x(i,:));    
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

function x_new = selection(x) %Stochastic Tournament
NP = size(x,1);
for i=1:NP
    ob(i)=objfun(x(i,:));    
end
for i=1:NP
Sequence = randperm(NP);
index1 = Sequence(1);index2 = Sequence(2);
    if ob(index1) <= ob(index2)
        x_new(i,:) = x(index1,:);
    else
        x_new(i,:) = x(index2,:);
    end
end
end

function [x_new] = crossover(x,pc) %Arithmetic Crossover
NP = size(x,1);
for i = 1:2:NP-1
    if(rand<pc)
        rate = rand;
        x_new(i,:) = rate*x(i,:)+(1-rate)*x(i+1,:);
        x_new(i+1,:) = (1-rate)*x(i,:)+rate*x(i+1,:);
    else
        x_new(i,:) = x(i,:);
        x_new(i+1,:) = x(i+1,:);
    end
end
end

function [x_new] = mutation(x,pm) %Mutation
[NP,D] = size(x);
x_new = x;
for i = 1:NP
    if(rand<pm)
        index_a = randi([1,D]);%random select where the mutation happens 
        value = x_new(i,index_a);
        value_bin = decimal2binary(value,index_a,D);
        index_b = randi([1,D]); 
        value_bin(index_b) = abs(value_bin(index_b)-1); %negation
        value = binary2decimal(value_bin,index_a,D);
        x_new(i,index_a) = value;
    end
end
end

%Binary to Decimal Convertion
function pop2 = binary2decimal(pop,index,chromlength)

Pmax = [250;230;500;265;490;265;500;265;440;490];
Pmin = [100;50;200;90;190;85;200;99;130;200];

[px,py]=size(pop);
for i = 1:py
    pop1(:,i) = 2.^(py-i).*pop(:,i);
end

temp = sum(pop1,2);

base = power(2,chromlength) - 1;
pop2 = temp*(Pmax(index)-Pmin(index))/base + Pmin(index);
end

%Decimal to binary converter
function pop = decimal2binary(p,index,chromlength)

Pmax = [250;230;500;265;490;265;500;265;440;490];
Pmin = [100;50;200;90;190;85;200;99;130;200];

y = size(p,1);

base = power(2,chromlength) - 1;


for i = 1:y
temp = (p(i)-Pmin(index))*base/(Pmax(index)-Pmin(index));
pop(i,:) = bitget(round(temp),chromlength:-1:1);
end
end




