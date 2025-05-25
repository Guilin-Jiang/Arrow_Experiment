clear;close all;

% true for shaft, false for vane
plot_shaft = true;

mass = 21.91e-3;

% used to fit angles
stepSizes = [2:10];

num_forward_points = 5;
num_backward_points = 8;

scaling_factor = 1e-2;

plot_coordinates = true; % false:plot displacement

output_png_figure = false;

fitting_filename = 'orange22_8000_1215_xy.xlsx';
date = '1215';
arrow = 'orange22';
frames_per_second = '8000';

%use slope to clear data otherwise use residuals
use_slope = false;

plot_all_data = false;
plot_cleared_data = false;

total_number_release = 10;
velocities = zeros(total_number_release,2);
accelerations = cell(total_number_release, 2);
angles = zeros(total_number_release,9);
average_angles = zeros(total_number_release,1);

figure(1)
hold on;
figure(2)
hold on;
figure(3)
hold on;
figure(4)
hold on;

release_number  = 1;
% for vel_id=2:2
vel_id = 1;
% 1 for y coordinate (vertical); 2 for x
coordinate_id = vel_id;
% for release_number = 10:10
copy_num = 0;

%如果是副本
% copy_num = 2;
% file name pattern: 'blue03_01_8000_1031.csv'

[data_filename, time_filename, output_filename, filename_main] = setupFileNames(release_number, date, arrow, frames_per_second, copy_num);


data_time_leave = readtable(time_filename);
time_leave = [data_time_leave.s];
time_leave_string = data_time_leave.s(release_number);

data = readtable(data_filename,"EmptyValue",0);


disp(data_filename);

if(plot_shaft)
    coordinates_shaft = [data.x___0_X_, data.x___0_Y_, data.time];
else
    coordinates_shaft = [data.x___1_X_, data.x___1_Y_, data.time];
end

coordinates_shaft =  removeZeroRows(coordinates_shaft);
%flip y coordinates so that it represents the right trends

[~, row_id_leave_string_shaft] = findRowsByColumnValue(coordinates_shaft, 3, time_leave_string);

% coordinates_shaft(:,2)：horizontal
% coordinates_shaft(:,1)：vertical
coordinates_shaft(:,1) = -coordinates_shaft(:,1);

coordinates_shaft(:,1:2) = scaling_factor * coordinates_shaft(:,1:2);


[angles_shaft, correlationCoefficients_shaft] = linearFitWithStepSizes(row_id_leave_string_shaft, coordinates_shaft, stepSizes);
90-angles_shaft
angles(release_number,:) = 90-angles_shaft;

average = mean(90 - angles_shaft)
average_angles(release_number) = average;

display(correlationCoefficients_shaft)

starting_id = 20; %max(row_id_leave_string_shaft -num_backward_points, 1);
% ending_id = min(row_id_leave_string_shaft + num_forward_points, length(coordinates_shaft(:,1)));
ending_id = row_id_leave_string_shaft;

x_coor = coordinates_shaft(starting_id:ending_id,coordinate_id);


if plot_coordinates
    figure(1)
    plot(coordinates_shaft(starting_id:ending_id,2), coordinates_shaft(starting_id:ending_id,1), 'r.', 'MarkerSize', 12);
    hold on
    plot(coordinates_shaft(:,2), coordinates_shaft(:,1), 'b*', 'MarkerSize', 12);
    
end

if(plot_shaft)
    title('Shaft Coordinates'); % 添加标题
else
    title('Vane Coordinates'); % 添加标题
end
xlabel('X-axis'); % 添加x轴标签
ylabel('Y-axis'); % 添加y轴标签
%

row_leave_shaft = coordinates_shaft(row_id_leave_string_shaft-starting_id,:);
%
plot(row_leave_shaft(2), row_leave_shaft(1), 'o', 'MarkerSize', 12);


if output_png_figure

    release_number_str = sprintf('%02d', release_number); % %02d 表示至少两位数，不足部分用0填充
    if(plot_shaft)
        tmp = {'shaft',filename_main};
    else
        tmp = {'vane',filename_main};
    end
    filename_main = strjoin(tmp, '_');

    output_filename = strjoin({filename_main,'png'},'.');
    exportgraphics(gca, output_filename, 'ContentType', 'vector', 'Resolution', 300);
end

%plot x-time and y-time
figure(2)
% plot(coordinates_shaft(:,3), coordinates_shaft(:,1), 'r.', 'MarkerSize', 12);

release_number_str = sprintf('%02d', release_number); % %02d 表示至少两位数，不足部分用0填充
if(coordinate_id == 1)
    tmp = {'yt',filename_main};
    title('y-t Plot'); % 添加标题
    ylabel('y'); % 添加y轴标签
else
    tmp = {'xt',filename_main};
    title('x-t Plot'); % 添加标题
    ylabel('x'); % 添加y轴标签
end
output_filename_x_t = strjoin(tmp, '_');

time = coordinates_shaft(starting_id:ending_id,3);
n =4 ;
% p = polyfit(time, x_coor, n);
% y_fit = polyval(p, time);
%
% %  get the coefficients of derivative of poly
% p_derv = polyder(p);
%
% vel = polyval(p_derv, time);

[y_fit, vel] = derivative_of_data(time, x_coor, n);
velocity = vel(row_id_leave_string_shaft-starting_id);


% disp(y_fit1 - y_fit)
% disp(vel - vel1)

%get the acceleration

t_acce = coordinates_shaft(20:ending_id,3);
data_acce = coordinates_shaft(20:ending_id,vel_id);
[~, vel_1] = derivative_of_data(t_acce, data_acce, n);
[~, acce]  = derivative_of_data(t_acce, vel_1, n);
force = mass * acce;

accelerations{release_number, vel_id} = acce;

figure(3)
if(coordinate_id == 1)
    tmp = {'v_t',filename_main};
    title('vy-t Plot'); % 添加标题
    ylabel('vy'); % 添加y轴标签
else
    tmp = {'vt',filename_main};
    title('vx-t Plot'); % 添加标题
    ylabel('vx'); % 添加y轴标签
end


figure(4)
if(coordinate_id == 1)
    tmp = {'accd_t',filename_main};
    title('ay-t Plot'); % 添加标题
    ylabel('ay'); % 添加y轴标签
else
    tmp = {'at',filename_main};
    title('ax-t Plot'); % 添加标题
    ylabel('ax'); % 添加y轴标签
end



velocities(release_number,vel_id) = velocity;
%
% % 绘制原始数据点和拟合曲线
% plot(x, y, 'o', x, y_fit, '*');
%
% % 使用polyval计算拟合多项式在x值上的预测值
% y_fit = polyval(p, x);

    hold on
    figure(2)
    plot(time, x_coor, 'r.', 'MarkerSize', 12);
    % plot(time, , 'r.', 'MarkerSize', 12);
    hold on

    figure(3)
    plot(t_acce, vel_1, 'r.',  'MarkerSize', 12);

    figure(4)
    plot(t_acce, acce, 'r.', 'MarkerSize', 12);




%
% plot(time(row_id_leave_string_shaft-starting_id), x_coor(row_id_leave_string_shaft-starting_id), '*', 'MarkerSize', 12);
% plot(coordinates_vanes_cleared(:,3), coordinates_vanes_cleared(:,1), 'b.', 'MarkerSize', 12);
% plot(coordinates_shaft(2:end,3), coordinates_shaft(2:end,1)-coordinates_shaft(1:end-1,1), 'r.', 'MarkerSize', 12);
% hold on
% plot(coordinates_vanes_cleared(2:end,3), coordinates_vanes_cleared(2:end,1)-coordinates_vanes_cleared(1:end-1,1), 'b.', 'MarkerSize', 12);


legend('Shaft');
xlabel('time'); % 添加x轴标签


if output_png_figure


    output_filename_x_t = strjoin({output_filename_x_t,'png'},'.');
    exportgraphics(gca, output_filename_x_t, 'ContentType', 'vector', 'Resolution', 300);
end





% end

hold off;
% end
% fitting:

coord_xy = readtable(fitting_filename,"EmptyValue",0);
vel_abs = sqrt(velocities(:,1).*velocities(:,1)+velocities(:,2).*velocities(:,2));
data_for_fitting = [vel_abs,average_angles, coord_xy.y(1:total_number_release)];

% [poly, gof] = data_fitting(data_for_fitting(2:end,:),fitting_filename , 3);

% poly,gof


std_vel_angel_y = [std(data_for_fitting(:,1)),std(data_for_fitting(:,2)),std(data_for_fitting(:,3))];
[data_for_fitting;std_vel_angel_y]

