function [f, gof] = data_fitting_lambda(data, title_name,figure_num)
% 创建一个二元多项式拟合模型
% ft = fittype('poly22'); % 这里'poly11'表示一个一次多项式拟合
% t = -1/lambda * ln(1 - lambda*(x-x0)/v0x)
x0 = row_leave_shaft(2);
y0= row_leave_shaft(1);
v0x = -54.2981;
v0y = 3.2530;
g=9.81;

ft = fittype( @(lambda, x) y0 - g/lambda * (-1/lambda * log(1 - lambda*(x-x0)/v0x)) ...
   + 1/lambda * (v0y + g/lambda) * (1 - exp(lambda * (-1/lambda * ln(1 - lambda*(x-x0)/v0x))))...
   , 'independent', 'x',...
     'dependent', 'y' );

% 拟合数据
% 字段       值
% 
% sse        误差平方和
% 
% rsquare    R 方（决定系数）
% 
% dfe        误差自由度
% 
% adjrsquare 自由度调整后的决定系数
% 
% rmse       均方根误差（标准误差）

[f, gof] = fit([data(:,1), data(:,2)], data(:,3), ft);

% 显示拟合结果


figure(figure_num)
scatter3(data(:,1),data(:,2),data(:,3));
hold on
% 
% % 绘制拟合曲面
% hold on;
x = data(:,1);
z = data(:,2);
y = data(:,3);
[xGrid, zGrid] = meshgrid(linspace(min(x), max(x), 100), linspace(min(z), max(z), 100));
yGrid = feval(f, [xGrid(:), zGrid(:)]);
yGrid = reshape(yGrid, size(xGrid));
mesh(xGrid, zGrid, yGrid);

% 设置图形属性
xlabel('vel'); % 添加y轴标签
ylabel('angle');
zlabel('y');
title(title_name);
zlim([-30 40])
legend('原始数据', '拟合曲面');