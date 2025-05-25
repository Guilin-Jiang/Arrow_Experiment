clear;

tspan = [0:1e-5: 1.1]; % 时间跨度
    % % 从y中提取变量
    phi0 = 0;
    initial_angle = 5; %degree
    theta0 = deg2rad(90-initial_angle);
    V0 = 64;
    THETA0 = theta0;
    PHI0 = phi0;
    omega_phi0 = 0;
    omega_theta0 = 0;
    x0 = 0;
    y0 = 0;
    z0 = 1.5;


y_initial = [phi0; theta0; V0; THETA0; PHI0; omega_phi0; omega_theta0;x0;y0;z0]; % 初始条件


[t, y] = ode45(@myODE, tspan, y_initial);
[t_no_drag, y_no_drag] = ode45(@myODE_no_drag, tspan, y_initial);


phi = y(:,1);
theta = y(:,2);
THETA = y(:,4);
PHI = y(:,5);
x = y(:,8);
z = y(:,end);

n1 = sin(theta).*cos(phi);
n2 = sin(theta).*sin(phi);
n3 = cos(theta);

v1 = sin(THETA).*cos(PHI);
v2 = sin(THETA).*sin(PHI);
v3 = cos(THETA);



gamma = acos(v1.*n1 + v2.*n2 + v3.*n3);

plot(t, gamma);
xlabel('Time (s)');
ylabel('\gamma (rad)');
title('Gamma vs. Time');


distance = 68;
differences = abs(x - distance);

% 找到最小差值的索引
[diff_x, index] = min(differences);
V0
initial_angle
diff_x
height = z(index)




figure(2)
% axis equal;
plot(y(:,end-2),y(:,end));
hold on
plot(y_no_drag(:,end-2),y_no_drag(:,end),'r-.', 'LineWidth', 2, 'DisplayName', '拟合曲线');
plot(68.5,1.2,'o');
ylim([0,4]);
xlim([0,70]);
xlabel('X (m)');
ylabel('Y (m)');
title('projectile');
