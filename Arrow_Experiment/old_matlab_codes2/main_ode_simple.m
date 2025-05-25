%read data from csv files

% 
% scaling_factor = 1e-2; % 比例尺不对需要scale
% 
% fitting_filename = 'orange22_8000_1215_xy.xlsx';
% date = '1215';
% arrow = 'orange22';
% frames_per_second = '8000';
% copy_num = 0;
% 
% for release_number = 10:10
%     [data_filename, time_filename, output_filename, filename_main] = setupFileNames(release_number, date, arrow, frames_per_second, copy_num);
%     data = readtable(data_filename,"EmptyValue",0);
% 
% 
%     data_time_leave = readtable(time_filename);
%     time_leave = [data_time_leave.s];
%     time_leave_string = data_time_leave.s(release_number);
% 
% 
% 
% 
%     % coordinates_shaft(:,2)：horizontal  % x___0_Y_ 平行于箭飞行方向
%     % coordinates_shaft(:,1)：vertical    % x___0_X_ 垂直于箭飞行方向
%     coordinates_shaft = [data.x___0_X_, data.x___0_Y_, data.time];
% 
%     % remove zeros
%     coordinates_shaft =  removeZeroRows(coordinates_shaft);
% 
%     [~, row_id_leave_string_shaft] = findRowsByColumnValue(coordinates_shaft, 3, time_leave_string);
% 
%     %flip y coordinates so that it represents the right trends
%     coordinates_shaft(:,1) = -coordinates_shaft(:,1);
% 
%     coordinates_shaft(:,1:2) = scaling_factor * coordinates_shaft(:,1:2);
% 
% end

% x, y
data_x = -(coordinates_shaft(:,2) - coordinates_shaft(1,2));
data_y = coordinates_shaft(:,1) - coordinates_shaft(1,1);

vel_initial = velocities(release_number, :);

% 初始条件
y0 = [data_x(1);data_y(1); abs(vel_initial(2)); abs(vel_initial(1))];
% 时间范围
tspan = [0, 0.02];

n = length(t);
y_exact = zeros(n,1);
for power = -1:5

    lambda = 10^(-power);
    % 创建一个匿名函数，将额外的参数传递给odeSystem
    odeFun = @(t, y) odeSystem(t, y, lambda);
    % 求解
    [t, y] = ode45(odeFun, tspan, y0);

    y_exact = y_traj(y(:,1),lambda, data_x(1), abs(vel_initial(2)),data_y(1), abs(vel_initial(1)));

    figure(10)
    plot(y(:,1),y(:,2), '-');
    hold on
    plot(y(:,1),y_exact, 'o');    
end




plot(data_x,data_y, '*');



% y_traj(x,ld, x0,v0x, y0, v0y)
    % plot(data_x,data_y, '*');

% % 绘制结果
% figure;
% subplot(2, 1, 1);
% plot(t, y(:, 1));
% title('x(t)');
% xlabel('时间 t');
% ylabel('x');
%
% subplot(2, 1, 2);
% plot(t, y(:, 2));
% title('y(t)');
% xlabel('时间 t');
% ylabel('y');