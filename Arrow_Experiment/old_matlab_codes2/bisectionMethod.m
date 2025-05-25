function [root , i]= bisectionMethod(a, b, tol, maxIter, data_x, data_y, ld, x0,v0x, y0, v0y)
    % bisectionMethod 使用二分法求解方程的根
    % func: 函数句柄，表示要找到根的函数
    % a, b: 区间端点，根必须位于这个区间内
    % tol: 容差，当区间长度小于tol时停止
    % maxIter: 最大迭代次数
    ga = g_ld(data_x, data_y, a, x0,v0x, y0, v0y);
    gb = g_ld(data_x, data_y, b, x0,v0x, y0, v0y);
    
    % 如果同号，则
    if ga * gb > 0
        disp('函数在区间端点的值必须异号');
        ld_vals = [1000,500,100,50,10,5,3,1,0.5,0.1,0.05,0.01,0.001,1e-4,1e-5,1e-6];
        g_vals = zeros(length(ld_vals),1);
        for i=1:length(ld_vals)
           g_vals(i) = g_ld(data_x, data_y, ld_vals(i), x0,v0x, y0, v0y);
        end
        disp(g_vals);
        root = NaN;
        return;
    end

    for i = 1:maxIter
        c = (a + b) / 2; % 计算区间中点
        gc = g_ld(data_x, data_y, c, x0,v0x, y0, v0y); % 计算中点的函数值
        if i>1000
            if abs(gc) < 1e-14 || abs(b - a) / 2 < tol % 检查是否满足停止条件
                root = c; % 返回根
                return;
            end
        end
        if g_ld(data_x, data_y, a, x0,v0x, y0, v0y) * gc < 0
            b = c; % 更新区间
        else
            a = c; % 更新区间
        end
    end
    root = (a + b) / 2; % 如果达到最大迭代次数，返回最后一个区间中点
    warning('二分法未在最大迭代次数内收敛');
end