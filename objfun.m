function f = objfun(x)
f = 0;
for i = 1:size(x,2)
    f = f + cal_objvalue(x(i),i);
end
end