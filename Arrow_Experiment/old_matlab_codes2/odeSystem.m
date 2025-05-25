% 定义常微分方程组
function dydt = odeSystem(t, f, lambda)
    % 定义常数

    g = 9.80665; % 重力加速度

    % 从状态向量中提取变量
    x = f(1);
    y = f(2);
    u = f(3);
    v = f(4);

    % 计算导数
    dxdt = u;
    dydt = v;
    dudt = -lambda * u;
    dvdt = -lambda * v - g;

    % 将导数组合成一个向量
    dydt = [dxdt; dydt; dudt; dvdt];
end
