function gradvalue = cal_gradvalue(p, index)

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

Pmin = [100;50;200;90;190;85;200;99;130;200];

if index == 1 
    if p<=196
        type = 1;
    else
        type = 2;
    end
elseif index == 2
    if p<=114
        type = 2;
    elseif  p<=157
        type = 3;
    else
        type = 1;
    end
elseif index == 3
     if p<=332
        type = 1;
    elseif p<=388
        type = 3;
     else
        type =2; 
    end
elseif index == 4
     if p<=138
        type = 1;
    elseif p<=200
        type = 2;
    else
        type = 3;
    end
elseif index == 5
     if p<=338
        type = 1;
    elseif p<=407
        type = 2;
    else
        type = 3;
    end
elseif index == 6
     if p<=138
        type = 2;
    elseif p<=200
        type = 1;
    else
        type = 3;
    end
elseif index == 7
     if p<=331
        type = 1;
    elseif p<=391
        type = 2;
    else
        type = 3;
    end
elseif index == 8
     if p<=138
        type = 1;
    elseif p<=200
        type = 2;
    else
        type = 3;
    end
elseif index == 9
     if p<=213
        type = 3;     
    elseif p<=370
        type = 1;
    else
        type = 3;
    end
elseif index == 10
     if p<=362
        type = 1;
    elseif p<=407
        type = 3;     
    else
        type = 2;
     end
end

if (E(index,type)*sin(F(index,type)*(Pmin(index)-p))) > 0 
    gradvalue = B(index,type) + 2*C(index,type)*p - F(index,type)*E(index,type)*cos(F(index,type)*(Pmin(index)-p));
elseif (E(index,type)*sin(F(index,type)*(Pmin(index)-p))) < 0
    gradvalue = B(index,type) + 2*C(index,type)*p + F(index,type)*E(index,type)*cos(F(index,type)*(Pmin(index)-p));
end
end
