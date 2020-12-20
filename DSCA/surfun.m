function f = surfun(initial_x,tao,DG,x)
    f = cal_objvalue(initial_x(DG),DG)   + cal_gradvalue(initial_x(DG),DG)  *(x-initial_x(DG))   + tao/2 * power((x-initial_x(DG)),2);
end