function y = pp_y_ld(xi, ld,x0,v0x)
%second derivative of y with respect to lambda
g = 9.81;
y = 6 * g/ld^4 * log(1 - ld*(xi - x0)/v0x) + 2*g/ld^3 * (xi - x0)/v0x;
