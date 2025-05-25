function root = newtonMethod( x0, tol, maxIter)
    % newtonMethod 使用牛顿法求解方程的根
    % func: 函数句柄，表示要找到根的函数
    % dfunc: 函数句柄，表示func的导数
    % x0: 初始猜测值
    % tol: 容差，当两次迭代的差值小于tol时停止
    % maxIter: 最大迭代次数

    x = x0; % 初始化x为初始猜测值
    for i = 1:maxIter
        y = func(x); % 计算当前x的函数值
        dy = dfunc(x); % 计算当前x的导数值
        x_new = x - y/dy; % 牛顿法迭代公式
        if abs(x_new - x) < tol % 检查是否满足停止条件
            root = x_new; % 返回根
            return;
        end
        x = x_new; % 更新x为新的值
    end
    root = x; % 如果达到最大迭代次数，返回最后一个x值
    warning('牛顿法未在最大迭代次数内收敛');
end