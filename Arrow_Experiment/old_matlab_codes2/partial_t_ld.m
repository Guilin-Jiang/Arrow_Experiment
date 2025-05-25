function partial_t_ld = partial_t_ld(ld, x0,v0x)

partial_t_ld = -ld^(-2) * log (1 - (x - x0)/v0x * ld) ...
     + (1/ld) * x0/(x0 - ld*(x-x0)) * (1-x/x0);



