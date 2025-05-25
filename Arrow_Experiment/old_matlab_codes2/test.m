% 定义自变量和因变量
x = 0:0.1:10;
y = sin(x) + rand(size(x)) * 0.1;

% 定义步长序列
stepSizes = [0.5, 1, 2, 5, 10];

% 调用函数并获取相关系数
correlationCoefficients = linearFitWithStepSizes(x, y, stepSizes);