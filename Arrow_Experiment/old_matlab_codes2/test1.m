
data = [   -0.2359    0.0768
   -0.2427    0.0773
   -0.2494    0.0778
   -0.2563    0.0783
   -0.2629    0.0787
   -0.2697    0.0791
   -0.2764    0.0795
   -0.2829    0.0799
   -0.2897    0.0803
   -0.2964    0.0806
   -0.3030    0.0810
   -0.3097    0.0814
   -0.3163    0.0818
   -0.3229    0.0822
   -0.3294    0.0827
   -0.3361    0.0831
];
% starting_id_fit = row_id_leave_string_shaft;
% x = coordinates_shaft(starting_id_fit:end,1);
% y = coordinates_shaft(starting_id_fit:end,2);

x = data(:,1);
y = data(:,2);

x0 = x(1);
y0 = y(1);



v0x = velocities(release_number,2);
v0y = velocities(release_number,1);
g=9.81;
m = 21.1e-3;

% y0 - g/lambda * (-1/lambda * ln(1 - lambda*(x-x0)/v0x)) ...
   % + 1/lambda * (v0y + g/lambda) * 
ft = fittype( @(lambda, x) y0 - g/lambda * (-1/lambda * log(1 - lambda*(x-x0)/v0x)) ...
   + 1/lambda * (v0y + g/lambda) * (1 - exp(-lambda * (-1/lambda * log(1 - lambda*(x-x0)/v0x))))...
   , 'independent', 'x',...
     'dependent', 'y' );
% ft = fittype(@(a, b, c, x) a*x.^2 + b*sin(x) + c, 'independent', 'x', 'dependent', 'y');

[curve, goodness] = fit(x, y, ft);



% 绘制原始数据点
figure; % 创建一个新的图形窗口
plot(x, y, 'bo', 'MarkerSize', 8, 'DisplayName', '原始数据'); % 绘制蓝色圆圈标记的数据点

% 绘制拟合曲线
hold on; % 保持当前图形，以便在同一图上绘制拟合曲线
xfit = linspace(min(x), max(x), 100); % 生成更密集的x值，用于绘制平滑的拟合曲线
yfit = feval(curve, xfit); % 计算拟合曲线的y值
plot(xfit, yfit, 'r-', 'LineWidth', 2, 'DisplayName', '拟合曲线'); % 绘制红色拟合曲线

% 添加图例和标签
legend show;
xlabel('x');
ylabel('y');
title('非线性拟合效果');
hold off; % 取消保持状态
curve
lambda = curve(2);
alpha = curve(2)*m;
dist = 68.5;
t = -1/lambda * log(1 - lambda*(dist)/v0x)




