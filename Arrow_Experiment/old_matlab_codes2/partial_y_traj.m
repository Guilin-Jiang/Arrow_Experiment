function partial_y = partial_y_traj(xi, ld,x0,v0x)
g = 9.81;
partial_y = -2*g/ld^3 * log(1 - ld*(xi - x0)/v0x) ...
          - g/ld^2 * (xi - x0) / (v0x - ld*(xi-x0)) - g/ld^2 * (xi - x0)/v0x;





