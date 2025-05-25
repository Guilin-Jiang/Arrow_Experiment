function dydt = myODE(t, y)
    g = 9.81; % 重力加速度
    
    rho = 1.25;  %[kg/m^3]
    l = 0.625;   %[m]
    r = 2.63e-3; %[m]
    M = 21.3e-3; %[kg]
    I = 6.98e-4; %[kgm^2]
    I_3 = 2.81e-7;  %[kgm^2]

    C_D = 1.5; % 阻力系数1.5 for laminar and 2.6for turbulent
% The coefficients of
% proportionality αSWV = 40.2 [1/rad] and βSWV = 16.2 [1/rad] are used for SWV, whereas
% αGPV = 29.6 [1/rad] and βGPV = 11.1 [1/rad] are used for GPV
    alpha = 40.2; % 升力系数
    beta = 16.2; % 侧力系数
    I_omega_over_I = 0;% I_3 * omega_3 / I;


    % 计算D和E
    D = rho * pi * r^2 / M;
    E = rho * pi * r^2 * l / I;

    % test:
    I = 0;% 6.98e-4; %[kgm^2]
    I_3 = 0;%9.85;  %[kgm^2]
    C_D = 0;%1.5; % 阻力系数1.5 for laminar and 2.6for turbulent
    alpha = 0;%40.2; % 升力系数
    beta = 0;%16.2; % 侧力系数    

    % 从y中提取变量
    phi = y(1);
    theta = y(2);
    V = y(3);
    THETA = y(4);
    PHI = y(5);
    omega_phi = y(6);
    omega_theta = y(7);

    diff_phi = phi-PHI;

    Sp = 0.029;
    omega_3 = Sp * V / r;

    dydt = zeros(7,1);
    dydt(1) = omega_phi;

    dydt(2) = omega_theta;

    dydt(3) = -g*cos(THETA) - 0.5 * C_D * D * V^2;

    dydt(4) = (g*sin(THETA))/V + 0.5 * alpha * D * V * (sin(theta)*cos(THETA)*cos(diff_phi) - cos(theta)*sin(THETA));

    dydt(5) = 0.5 * alpha * D * V * (sin(theta)*sin(diff_phi)) / sin(THETA);

    beta_e_v = 0.5 * beta * E * V^2; 

    % d omega_phi/ dt
    dydt(6) = -2 * cot(theta) * omega_theta * omega_phi + (I_omega_over_I/ sin(theta)) * omega_theta ...
            - beta_e_v * (sin(THETA)*sin(diff_phi)) / sin(theta);

    % d omega_theta/ dt
    dydt(7) = sin(theta)*cos(theta) * omega_phi^2 - I_omega_over_I * omega_phi * sin(theta) ...
            + beta_e_v * (cos(theta)*sin(THETA)*cos(diff_phi) - sin(theta)*cos(THETA));

    % \frac{d x }{d t} & =V \sin \Theta \cos \Phi,\\
    dydt(8) = V * sin(THETA) * cos(PHI);

    % \frac{d y }{d t} & = V \sin \Theta \sin \Phi, \\
    dydt(9) = V * sin(THETA) * sin(PHI);

    % \frac{d z }{d t} & = V \cos \Theta.
    dydt(10) = V * cos(THETA);







end







