function dydt = myODE(t, y)
   
    % 从y中提取变量
    x = y(1);
    y = y(2);
    u = y(3);
    v = y(4);

    ld=1e-4;
    
    dydt = zeros(4,1);
    dydt(1) = u;

    dydt(2) = v;

    dydt(3) = -ld * u;

    dydt(4) = -ld * v -g;

end







