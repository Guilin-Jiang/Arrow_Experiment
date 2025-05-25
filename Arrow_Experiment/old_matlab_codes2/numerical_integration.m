% 参数设置
v = 60;           % 初始速度 (假设单位一致)
theta = pi / 72;  % 角度 (弧度制)
g = 9.81;         % 重力加速度

rho = 1.225;       % 空气密度 (kg/m^3)
Cd = 0.3;          % 阻力系数
d = 0.01;          % 箭的直径 (m)
A = pi * (d/2)^2;  % 箭的迎风面积 (m^2)
m = 0.02;          % 箭的质量 (kg)

% 计算 k 值
k = (1/(2*m)) * rho * Cd * A ;



% 设置 ode45 的选项，限制最大步长
options = odeset('RelTol',1e-6,'AbsTol',1e-8,'MaxStep',0.001); % 最大步长限制为0.001秒

% 时间区间
tspan = [0 1];  % 时间区间 [0, 1] 秒

% x方向速度函数
vx_t = @(t) v * cos(theta) ./ (k * t * v * cos(theta) + 1);

% 定义微分方程 dx/dt = vx(t)
dxdt = @(t, x) vx_t(t);

% 使用 ode45 求解x(t)
[t_x, x_t] = ode45(dxdt, tspan, 0);

% y方向速度函数
vy_t = @(t) sqrt(g/k) * tan(atan(v * sin(theta) / sqrt(g/k)) - sqrt(g * k) * t);

% 定义微分方程 dy/dt = vy(t)
dydt = @(t, y) vy_t(t);

% 使用 ode45 求解y(t)
[t_y, y_t] = ode45(dydt, tspan, 0);


% 绘制 x(t) 图
figure;
plot(t_x, x_t, 'r-.', 'LineWidth', 2);
title('x方向的位移');
xlabel('时间 (秒)');
ylabel('位移 x(t)');
grid on;

% 绘制 y(t) 图
figure;
plot(t_y, y_t, 'o-', 'LineWidth', 2);
title('y方向的位移');
xlabel('时间 (秒)');
ylabel('位移 y(t)');
grid on;

