% clc
% clear
function Objvalue = AA()
DGnum = 10;
upper = [250,230,500,265,490,265,500,265,440,490];
lower = [100,50,200,90,190,85,200,99,130,200];
Pd = 2700;
max_iter = 200;
%初始点
initial_x = upper;
initial_x = initial_x*(Pd/sum(initial_x));
x = initial_x;
%AA参数
r = [10,1,0.1,0.01,0.001];
s = r*Pd/100;

for k = 1:max_iter

    Objvalue(k,:) = objfun(x);
    X(k,:) = x;
    
%% step1 Bids Evaluation估标    
for i = 1:DGnum
    for j = 1:length(s)
        if x(i)+s(j) <=upper(i) && x(i)+s(j)>=lower(i) 
            pai(i,j) = cal_objvalue(x(i)+s(j),i)-cal_objvalue(x(i),i);
        else
            pai(i,j) = 0;
        end
        if x(i)-s(j) <=upper(i) && x(i)-s(j)>=lower(i) 
            miu(i,j) = cal_objvalue(x(i),i)-cal_objvalue(x(i)-s(j),i);
        else
            miu(i,j) = 0;
        end
    end
end

%% step2 Consensus一致

%% Fully Connexted全连接版本

for i = 1:DGnum
    [paimin(i,:),paimin_index(i,:)] = min(pai);
    [miumax(i,:),miumax_index(i,:)] = max(miu);
end


%% Line线版本

% paimin_former = ones(DGnum,length(r));
% miumax_former = ones(DGnum,length(r));
% pai_stored = pai;
% miu_stored = miu;
% pai_stored_former = pai;
% miu_stored_former = miu;
% 
%     [pai_stored(1,:),pai_stored_index(1,:)] = min(pai_stored_former(1:2,:));
%     [miu_stored(1,:),miu_stored_index(1,:)] = max(miu_stored_former(1:2,:));
% for i = 2:(DGnum-1)
%     [pai_stored(i,:),pai_stored_index(i,:)] = min(pai_stored_former(i-1:i+1,:));
%     pai_stored_index(i,:) = pai_stored_index(i,:)+i-2;
%     [miu_stored(i,:),miu_stored_index(i,:)] = max(miu_stored_former(i-1:i+1,:));
%     miu_stored_index(i,:) = miu_stored_index(i,:)+i-2;
% end
%     [pai_stored(DGnum,:),pai_stored_index(DGnum,:)] = min(pai_stored_former(DGnum-1:DGnum,:));
%     [miu_stored(DGnum,:),miu_stored_index(DGnum,:)] = max(miu_stored_former(DGnum-1:DGnum,:));
%     pai_stored_index(DGnum,:) = pai_stored_index(DGnum,:)+DGnum-2;
%     miu_stored_index(DGnum,:) = miu_stored_index(DGnum,:)+DGnum-2;
%     pai_stored_former = pai_stored;
%     pai_stored_index_former = pai_stored_index;
%     miu_stored_former = miu_stored;    
%     miu_stored_index_former = miu_stored_index;
%     
% l=0;
% while(1)
%     l = l + 1;
%     [pai_stored(1,:),index] = min(pai_stored_former(1:2,:));
%     for q = 1:length(r)
%     pai_stored_index(1,q) = pai_stored_index_former(1+index(q)-1,q);
%     end
%     
%     [miu_stored(1,:),index] = max(miu_stored_former(1:2,:));
%     for q = 1:length(r)
%     miu_stored_index(1,q) = miu_stored_index_former(1+index(q)-1,q);
%     end
%        
% for i = 2:(DGnum-1)
%     
%     [pai_stored(i,:),index] = min(pai_stored_former(i-1:i+1,:));
%     for q = 1:length(r)
%     pai_stored_index(i,q) = pai_stored_index_former(i+index(q)-2,q);
%     end
%     
%     [miu_stored(i,:),index] = max(miu_stored_former(i-1:i+1,:));
%      for q = 1:length(r)
%     miu_stored_index(i,q) = miu_stored_index_former(i+index(q)-2,q);
%      end
%     
% end
%     [pai_stored(DGnum,:),index] = min(pai_stored_former(DGnum-1:DGnum,:));
%     for q = 1:length(r)
%     pai_stored_index(DGnum,q) = pai_stored_index_former(DGnum+index(q)-2,q);
%     end
%     
%     [miu_stored(DGnum,:),index] = max(miu_stored_former(DGnum-1:DGnum,:));
%     for q = 1:length(r)
%     miu_stored_index(DGnum,q) = miu_stored_index_former(DGnum+index(q)-2,q);
%     end
%     
%     if isequal(pai_stored,pai_stored_former) && isequal(miu_stored,miu_stored_former)
%         break;
%     end    
%     pai_stored_former = pai_stored;
%     pai_stored_index_former = pai_stored_index;
%     miu_stored_former = miu_stored; 
%     miu_stored_index_former = miu_stored_index;
% end
% paimin = pai_stored;
% paimin_index = pai_stored_index;
% miumax = miu_stored;
% miumax_index = miu_stored_index;


delta = miumax(1,:) - paimin(1,:);
[delta_sorted,order] = sort(delta,'descend');


%% step3 multiswap多交换
stopping_criteria = 1;
notebook = [];
for j = 1:length(r)    
    if (isempty(find(notebook == paimin_index(1,order(j))))) && (isempty(find(notebook == miumax_index(1,order(j))))) && (paimin_index(1,order(j))~=miumax_index(1,order(j))) && (paimin(1,order(j))>0) && (miumax(1,order(j))>0) && (delta(order(j))>0) 
        x(paimin_index(1,order(j))) = x(paimin_index(1,order(j))) + s(order(j));
        x(miumax_index(1,order(j))) = x(miumax_index(1,order(j))) - s(order(j));
        notebook(end+1) = paimin_index(1,order(j));
        notebook(end+1) = miumax_index(1,order(j));
        stopping_criteria = 0;
    end
end
if stopping_criteria == 1
    break;
end
Notebook(k,1:length(notebook))=notebook;

end
end
% min(Objvalue);
% plot(Objvalue);



