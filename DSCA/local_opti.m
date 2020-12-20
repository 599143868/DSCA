function x = local_opti(symmetry_axis,DG)
upper = [250,230,500,265,490,265,500,265,440,490];
lower = [100,50,200,90,190,85,200,99,130,200];
if symmetry_axis <= lower(DG)
    x = lower(DG);
elseif symmetry_axis >= upper(DG)
    x = upper(DG);
else 
    x = symmetry_axis;
end