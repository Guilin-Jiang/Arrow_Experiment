function [coordinates_shaft_cleared, row_id_leave_string] = clearData(coordinates_shaft, time_leave_string, use_slope, threshold, plot_all_data, plot_cleared_data)


% coordinates_shaft = [data.x___0_X_, data.x___0_Y_, data.time];
% coordinates_vanes = [data.x___1_X_, data.x___1_Y_, data.time];

coordinates_shaft_filtered = removeZeroRows(coordinates_shaft);
% coordinates_vanes_filtered = removeZeroRows(coordinates_vanes);

%离弦时间
% time = data_time_leave.s(release_number);
[~, row_id_leave_string] = findRowsByColumnValue(coordinates_shaft_filtered, 3, time_leave_string);
% [row_leave_vanes, id_vanes] = findRowsByColumnValue(coordinates_vanes_filtered, 3, time);

if use_slope
    coordinates_shaft_cleared = removeUnnecessaryData(coordinates_shaft_filtered, true);
else
    %use residual
    rows_shaft_removed = findNonLinearPoints(coordinates_shaft_filtered, row_id_leave_string, threshold);  %removeUnnecessaryData(coordinates_vanes_filtered, false);
    coordinates_shaft_cleared = coordinates_shaft_filtered(rows_shaft_removed, :);
end

[~, row_id_leave_string] = findRowsByColumnValue(coordinates_shaft_cleared, 3, time_leave_string);

% figure(101)
if plot_cleared_data
    plot(coordinates_shaft_cleared(:,1), coordinates_shaft_cleared(:,2), 'g.', 'MarkerSize', 12);
end
hold on
% plot(coordinates_vanes_removed(:,1), coordinates_vanes_removed(:,2), 'go', 'MarkerSize', 15);

if plot_all_data
    plot(coordinates_shaft_filtered(:,1), coordinates_shaft_filtered(:,2), 'r.', 'MarkerSize', 12); % 'r.' 表示红色圆点，'MarkerSize' 调整点的大小
    % plot(coordinates_vanes_filtered(:,1), coordinates_vanes_filtered(:,2), 'b.', 'MarkerSize', 12);
end


% 保持当前图形
% hold on;

% plot(coordinates_vanes_filtered(:,1), coordinates_vanes_filtered(:,2), 'b.', 'MarkerSize', 12);

% plot(row_leave_vanes(1), row_leave_vanes(2), '*', 'MarkerSize', 12);
% plot(row_leave_shaft(1), row_leave_shaft(2), '*', 'MarkerSize', 12);

title('Coordinates Plot'); % 添加标题
xlabel('X-axis'); % 添加x轴标签
ylabel('Y-axis'); % 添加y轴标签


% 释放图形
hold off;