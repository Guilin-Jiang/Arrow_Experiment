function y = y_traj(x,ld, x0,v0x, y0, v0y)
g = 9.81;

y = y0 + g./ld.^2 .* log(1 - ld.*(x-x0)./v0x) + (v0y + g/ld) .* (x-x0)/v0x;





