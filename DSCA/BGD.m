%% flooding version
function x = BGD(x,upper,lower,Pd)
DGnum = size(x,2);
delta = Pd - sum(x);
while(delta>=1e-5) 
   x = x + delta/DGnum;
   for i = 1:DGnum
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
% PL = [200,200,400,200,300,200,300,200,350,350];
% delta = 1;
% while(delta>=1e-5) 
% 
% Mismatch_former = PL-x;

%% Line Topology      Line/Fully Conn. Select one.
% while(1)
%    %Line
%    Mismatch(1) = 0.7*Mismatch_former(1) + 0.3*Mismatch_former(2);
% for i = 2:9
%    Mismatch(i) = 0.4*Mismatch_former(i) + 0.3*Mismatch_former(i-1) + 0.3*Mismatch_former(i+1);  
% end
%    Mismatch(10) = 0.7*Mismatch_former(10) + 0.3*Mismatch_former(9);
%    if max(abs(Mismatch - Mismatch_former))<1e-5
%         break;
%    end
%    Mismatch_former = Mismatch;
% end   

%% Fully Connected Topology
% while(1)
% for i = 1:DGnum
%    Mismatch(i) = mean(Mismatch_former);
% end
%    if max(abs(Mismatch - Mismatch_former))<1e-5
%         break;
%    end
%    Mismatch_former = Mismatch;
% end 

%%
% x = x+Mismatch;
%    for i = 1:DGnum
%         if x(i) <= lower(i)
%             x(i) = lower(i);
%         elseif x(i) >= upper(i)
%             x(i) = upper(i);
%         end
%    end
%    delta = Pd - sum(x); 
% end   
% end