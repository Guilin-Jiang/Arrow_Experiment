clear;

output_png_figure = true;

date = '0812';
arrow = 'blue04';
release_number = 10;
frames_per_second = '8000';

%use slope to clear data otherwise use residuals
use_slope = false;

plot_all_data = false;
plot_cleared_data = true;

[data_filename, time_filename, output_filename] = setupFileNames(release_number, date, arrow, frames_per_second);

data_time_leave = readtable(time_filename);
time_leave = [data_time_leave.s];
time_leave_string = data_time_leave.s(release_number);

data = readtable(data_filename,"EmptyValue",0);



coordinates_shaft = [data.x___0_X_, data.x___0_Y_, data.time];
threshold = 0.2;
figure(3)
clearData(coordinates_shaft, time_leave_string, use_slope, threshold,plot_all_data, plot_cleared_data);

coordinates_vanes = [data.x___1_X_, data.x___1_Y_, data.time];
threshold = 0.9;
figure(4)
clearData(coordinates_vanes, time_leave_string, use_slope, threshold,plot_all_data, plot_cleared_data);



coordinates_shaft_filtered = removeZeroRows(coordinates_shaft);
coordinates_vanes_filtered = removeZeroRows(coordinates_vanes);

%离弦时间
time = data_time_leave.s(release_number);
[row_leave_shaft, id_shaft] = findRowsByColumnValue(coordinates_shaft_filtered, 3, time);
[row_leave_vanes, id_vanes] = findRowsByColumnValue(coordinates_vanes_filtered, 3, time);


coordinates_shaft_removed = removeUnnecessaryData(coordinates_shaft_filtered, true);
rows_vanes_removed = findNonLinearPoints(coordinates_vanes_filtered, id_vanes, 0.9);  %removeUnnecessaryData(coordinates_vanes_filtered, false);
coordinates_vanes_removed = coordinates_vanes_filtered(rows_vanes_removed, :);

figure(2)
plot(coordinates_shaft_removed(:,1), coordinates_shaft_removed(:,2), 'go', 'MarkerSize', 15); 
hold on
plot(coordinates_vanes_removed(:,1), coordinates_vanes_removed(:,2), 'go', 'MarkerSize', 15); 


plot(coordinates_shaft_filtered(:,1), coordinates_shaft_filtered(:,2), 'r.', 'MarkerSize', 12); % 'r.' 表示红色圆点，'MarkerSize' 调整点的大小



% 保持当前图形
hold on;

plot(coordinates_vanes_filtered(:,1), coordinates_vanes_filtered(:,2), 'b.', 'MarkerSize', 12);

plot(row_leave_vanes(1), row_leave_vanes(2), '*', 'MarkerSize', 12);
plot(row_leave_shaft(1), row_leave_shaft(2), '*', 'MarkerSize', 12);

title('Coordinates Plot'); % 添加标题
xlabel('X-axis'); % 添加x轴标签
ylabel('Y-axis'); % 添加y轴标签
legend('Shaft-removed','Vanes-removed','Shaft', 'Vanes');

% 释放图形
hold off;

if output_png_figure

    % output_filename = strjoin({filename_main,'png'},'.');
    exportgraphics(gca, output_filename, 'ContentType', 'vector', 'Resolution', 300);
end



