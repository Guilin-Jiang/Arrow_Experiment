
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%run data_processing_new first!%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
alpha_resi = zeros(total_number_release,2);
ab_vals = [1, 1e-6;
    1, 1e-6;
    1, 1e-4;
    1, 1e-5;
    1, 1e-6;
    1, 1e-3;
    1e-4, 1e-6;
    1, 1e-6;
    1, 1e-6;
    1, 1e-6;];

for release_number = 1:10
    disp(release_number);
    coordinates_shaft = coordinates_shaft_cell{release_number};
    row_id_leave_string_shaft = row_id_leave_string_shaft_array(release_number);
    data_x = [coordinates_shaft(row_id_leave_string_shaft-2:end,2)];
    data_y = [coordinates_shaft(row_id_leave_string_shaft-2:end,1)];
    v0x = velocities(release_number, 2);
    v0y = velocities(release_number, 1);
    x0 = row_leave_shaft(2);
    y0 = row_leave_shaft(1);

    dist = 68;
    g=9.81;

    t_no_drag = 0:0.01:abs(dist/v0x);
    y_tra_no_drag = @(v0y,t) y0 + v0y.*t - 0.5*g*t.^2;
    angle_initial = 4.7/180*pi;
    v0_initial = 58;
    x_no_drag = -v0_initial * cos(angle_initial)*t_no_drag;
    y_no_drag = y_tra_no_drag(v0_initial * sin(angle_initial), t_no_drag);

    ld = 10;
    % ld_new = 1e-5;
    % myFuncWithParams = @(ld) g_ld(data_x, data_y, ld, x0,v0x, y0, v0y);
    %
    % % 求解
    % root = fzero(myFuncWithParams, ld);
    %
    % % 显示结果
    % disp(root);
    a = ab_vals(release_number,1);
    b = ab_vals(release_number,2);
    tol = 1e-15;
    maxIter = 100000;
    [ld, num_iteration] = bisectionMethod(a, b, tol, maxIter, data_x, data_y, ld, x0,v0x, y0, v0y);
    f0 = g_ld(data_x, data_y, ld, x0,v0x, y0, v0y);
    alpha_resi(release_number,:) = [ld, f0];
    disp([ld, f0, num_iteration]);

    % for i = 1:maxIter
    %
    %     g = g_ld(data_x, data_y, ld, x0,v0x, y0, v0y); % 计算当前x的函数值
    %     g_new = g_ld(data_x, data_y, ld_new, x0,v0x, y0, v0y); % 计算当前x的导数值
    %     dg = (g_new - g)/(ld_new - ld);
    %     ld_new = ld - g/dg; % 牛顿法迭代公式
    %     if abs(ld_new - ld) < tol % 检查是否满足停止条件
    %         root = ld_new; % 返回根
    %         continue;
    %     end
    %     ld = ld_new ; % 更新x为新的值
    % end
    % root = ld; % 如果达到最大迭代次数，返回最后一个x值
    % warning('牛顿法未在最大迭代次数内收敛');

    figure(release_number)
    plot(data_x, data_y,'bo', 'MarkerSize', 8, 'DisplayName', '原始数据');

    % 绘制拟合曲线
    hold on; % 保持当前图形，以便在同一图上绘制拟合曲线

    % plot(x_no_drag, y_no_drag,'b<', 'MarkerSize', 8, 'DisplayName', '无阻力');

    xfit = linspace(min(data_x), max(data_x), 100); % 生成更密集的x值，用于绘制平滑的拟合曲线
    yfit = y_traj(xfit,ld,x0,v0x,y0,v0y); % 计算拟合曲线的y值
    plot(xfit, yfit, 'r-', 'LineWidth', 2, 'DisplayName', '拟合曲线'); % 绘制红色拟合曲线
    % plot(x_no_drag, y_no_drag, 'b-', 'LineWidth', 2, 'DisplayName', 'no drag'); % 绘制红色拟合曲线

    % 添加图例和标签
    legend show;
    xlabel('x');
    ylabel('y');
    title('非线性拟合效果');
    hold off; % 取消保持状态

    % plot(data_x(1):)

end
