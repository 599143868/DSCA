%% two versions (flooding protocol based, average consensus protocol based) of BGD are provided, you can use them freely.

%% flooding version
function x = BGD(x,upper,lower,Pd)  
DGnum = size(x,2);       % number of agents
delta = Pd - sum(x);     % the local load and power output are shared among agents via the flooding protocol, and each agent calculates the total supply-demand mismatch, i.e., delta
while(delta>=1e-5)       % when the total supply-demand mismatch is less than a preset threshold, BGD stops
   x = x + delta/DGnum;  % each agent update local output to meet the supply-demand constraint
   for i = 1:DGnum       % local generation constraints projection
        if x(i) <= lower(i)
            x(i) = lower(i);
        elseif x(i) >= upper(i)
            x(i) = upper(i);
        end
   end
   delta = Pd - sum(x); 
end   
end

%% average consensus version
% function x = BGD(x,upper,lower,Pd)
% PL = [200,200,400,200,300,200,300,200,350,350];   % local load, they can be set freely, but their sum should be equal to Pd as the problem should be feasible
% delta = 1;  % initialize delta
% while(delta>=1e-5) % when the total supply-demand mismatch is less than a preset threshold, BGD stops
% 
% Mismatch_former = PL-x;  % each agent calculates the initial local supply-demand mismatch

%% Line Topology      Line/Fully Conn. Select one.
% while(1)
%    %Line
%    Mismatch(1) = 0.7*Mismatch_former(1) + 0.3*Mismatch_former(2);      % the edge weight is set to 0.3
% for i = 2:9
%    Mismatch(i) = 0.4*Mismatch_former(i) + 0.3*Mismatch_former(i-1) + 0.3*Mismatch_former(i+1);  
% end
%    Mismatch(10) = 0.7*Mismatch_former(10) + 0.3*Mismatch_former(9);
%    if max(abs(Mismatch - Mismatch_former))<1e-5   % when the Mismatch update between two adjacent iterations is less than a preset threshold, the operation detecting the average supply-demand mismatch stops
%         break;
%    end
%    Mismatch_former = Mismatch;  % update Mismatch_former
% end   

%% Fully Connected Topology         Line/Fully Conn. Select one.
% while(1)
% for i = 1:DGnum
%    Mismatch(i) = mean(Mismatch_former);  % the edge weight is set to 0.1 among 10 agents, and we use mean() for simplicity
% end
%    if max(abs(Mismatch - Mismatch_former))<1e-5   % when the Mismatch update between two adjacent iterations is less than a preset threshold, the operation detecting the average supply-demand mismatch stops
%         break;
%    end
%    Mismatch_former = Mismatch;  % update Mismatch_former
% end 

%%
% x = x+Mismatch;           % each agent update local output to meet the supply-demand constraint
%    for i = 1:DGnum        % local generation constraints projection
%         if x(i) <= lower(i)
%             x(i) = lower(i);
%         elseif x(i) >= upper(i)
%             x(i) = upper(i);
%         end
%    end
%    delta = Pd - sum(x); 
% end   
% end
