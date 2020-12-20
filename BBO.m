% Clarify: this code is developed from https://github.com/smkalami/ypea113-biogeography-based-optimization/blob/master/BBO/bbo.m

% clc;
% clear;
% close all;
function Best_Cost = BBO()
%% Problem Definition

CostFunction = @(x) objfun(x);        % Cost Function

nVar = 10;             % Number of Decision Variables

VarSize = [1 nVar];   % Decision Variables Matrix Size

MinX = [100,50,200,90,190,85,200,99,130,200];         % Decision Variables Lower Bound
MaxX = [250,230,500,265,490,265,500,265,440,490];         % Decision Variables Upper Bound
Pd = 2700;
%% BBO Parameters

MaxIt = 200;          % Maximum Number of Iterations

nPop = 60;            % Number of Habitats (Population Size)

KeepRate = 0.2;                   % Keep Rate
nKeep = round(KeepRate*nPop);     % Number of Kept Habitats

nNew = nPop-nKeep;                % Number of New Habitats

% Migration Rates
mu = linspace(1, 0, nPop);          % Emmigration Rates
lambda = 1-mu;                    % Immigration Rates

alpha = 0.9;

pMutation = 0.1;

sigma = 0.02*(MaxX-MinX);

%% Initialization

% Empty Habitat
habitat.Position = [];
habitat.Cost = [];

% Create Habitats Array
pop = repmat(habitat, nPop, 1);

% Initialize Habitats
for i = 1:nPop
    pop(i).Position = unifrnd(MinX, MaxX, VarSize);
    pop(i).Position = Projection(pop(i).Position,MinX,MaxX,Pd);
    pop(i).Cost = CostFunction(pop(i).Position);
end

% Sort Population
[~, SortOrder] = sort([pop.Cost]); 
pop = pop(SortOrder);              

% Best Solution Ever Found
BestSol = pop(1);

% Array to Hold Best Costs
BestCost = zeros(MaxIt, 1);

%% BBO Main Loop

for it = 1:MaxIt
    
    newpop = pop;
    for i = 1:nPop
        for k = 1:nVar
            % Migration
            if rand <= lambda(i)
                % Emmigration Probabilities
                EP = mu;
                EP(i) = 0;
                EP = EP/sum(EP);
                
                % Select Source Habitat
                j = RouletteWheelSelection(EP);
                
                % Migration
                newpop(i).Position(k) = pop(i).Position(k) ...
                    +alpha*(pop(j).Position(k)-pop(i).Position(k));
                
            end
            
            % Mutation
            if rand <= pMutation
                newpop(i).Position(k) = newpop(i).Position(k)+sigma(k)*randn;
            end
        end
        
        % Apply Lower and Upper Bound Limits
        newpop(i).Position = max(newpop(i).Position, MinX);
        newpop(i).Position = Projection(newpop(i).Position,MinX,MaxX,Pd);
        newpop(i).Position = min(newpop(i).Position, MaxX);
        
        % Evaluation
        newpop(i).Cost = CostFunction(newpop(i).Position);
    end
    
    % Sort New Population
    [~, SortOrder] = sort([newpop.Cost]);
    newpop = newpop(SortOrder);
    
    % Select Next Iteration Population
    pop = [pop(1:nKeep)
         newpop(1:nNew)];
     
    % Sort Population
    [~, SortOrder] = sort([pop.Cost]);
    pop = pop(SortOrder);
    
    % Update Best Solution Ever Found
    BestSol = pop(1);
    
    % Store Best Cost Ever Found
    BestCost(it) = BestSol.Cost;
    
    % Show Iteration Information
    %disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
    
end
Best_Cost = min(BestCost);
end
%% Results

% figure;
% %plot(BestCost, 'LineWidth', 2);
% semilogy(BestCost, 'LineWidth', 2);
% xlabel('Iteration');
% ylabel('Best Cost');
% grid on;

function j = RouletteWheelSelection(P)

    r = rand;
    C = cumsum(P);
    j = find(r <= C, 1, 'first');

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
        for j=1:D 
            if(x(i,j)<MinX(j))
                x(i,j)=MinX(j);
            elseif(x(i,j)>MaxX(j)) 
                x(i,j)=MaxX(j);
            end
        end      
    end
end
end