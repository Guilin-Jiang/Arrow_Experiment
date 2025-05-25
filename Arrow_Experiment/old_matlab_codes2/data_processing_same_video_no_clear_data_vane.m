clear;close all;
plot_coordinates = true; % false:plot displacement

output_png_figure = true;

date = '1031';
arrow = 'blue03';
release_number = 1;
frames_per_second = '8000';

%use slope to clear data otherwise use residuals
use_slope = false;

plot_all_data = false;
plot_cleared_data = false;

figure(1)
hold on;
figure(2)
hold on;
for copy_num = 1:3

    %如果是副本
    % copy_num = 2;


    [data_filename, time_filename, output_filename,filename_main] = setupFileNames(release_number, date, arrow, frames_per_second, copy_num);


    data_time_leave = readtable(time_filename);
    time_leave = [data_time_leave.s];
    time_leave_string = data_time_leave.s(release_number);

    data = readtable(data_filename,"EmptyValue",0);


    data_filename
    coordinates_shaft = [data.x___1_X_, data.x___1_Y_, data.time];
            coordinates_shaft =  removeZeroRows(coordinates_shaft);
        %flip y coordinates so that it represents the right trends
         coordinates_shaft(:,2) = -1*coordinates_shaft(:,2);

    [~, row_id_leave_string_shaft] = findRowsByColumnValue(coordinates_shaft, 3, time_leave_string);

    % vane:1  shaft: 0
    x = data.x___1_X_;
    y = data.x___1_Y_;

    ux = [0;coordinates_shaft(2:end,1)-coordinates_shaft(1:end-1,1)];

    uy = [0;coordinates_shaft(2:end,2)-coordinates_shaft(1:end-1,2)];

    stepSizes = [2:10];
    [angles_shaft, correlationCoefficients_shaft] = linearFitWithStepSizes(row_id_leave_string_shaft, coordinates_shaft, stepSizes);
    angles_shaft
    average = mean(90 - angles_shaft)
    correlationCoefficients_shaft
    % n = 3;

    % 使用polyfit进行拟合
    % p = polyfit(x, y, n);
    %
    % % 使用polyval计算拟合多项式在x值上的预测值
    % y_fit = polyval(p, x);
    %
    % % 绘制原始数据点和拟合曲线
    % plot(x, y, 'o', x, y_fit, '*');
    % legend('原始数据', '拟合曲线');
    % xlabel('x');
    % ylabel('y');
    % title('多项式拟合');
    % coordinates_vanes = [data.x___1_X_, data.x___1_Y_, data.time];

    % if copy_num == 2
    %     threshold = 0.3;
    % else
    %     threshold = 0.9;
    % end
    % hold on
    % [coordinates_vanes_cleared, row_id_leave_string_vanes] = clearData(coordinates_vanes, time_leave_string, use_slope, threshold,plot_all_data, plot_cleared_data);

    % u_shaft = coordinates_shaft_cleared(2:end,:) - coordinates_shaft_cleared(1:end-1, :);
    % u_vanes = coordinates_vanes_cleared(2:end, :) - coordinates_vanes_cleared(1:end-1, :);
    % plot_data(coordinates_shaft, coordinates_vanes,102);
    % [row_leave_vanes, row_id_leave_string_vanes] = findRowsByColumnValue(coordinates_vanes_cleared, 3, time_leave_string);
    %
    %
    %
    % coordinates_shaft_filtered = removeZeroRows(coordinates_shaft);
    % coordinates_vanes_filtered = removeZeroRows(coordinates_vanes);
    %
    % %离弦时间
    % time = data_time_leave.s(release_number);
    % [row_leave_shaft, id_shaft] = findRowsByColumnValue(coordinates_shaft_filtered, 3, time);
    % [row_leave_vanes, id_vanes] = findRowsByColumnValue(coordinates_vanes_filtered, 3, time);
    %
    %
    % coordinates_shaft_removed = removeUnnecessaryData(coordinates_shaft_filtered, true);
    % rows_vanes_removed = findNonLinearPoints(coordinates_vanes_filtered, id_vanes, 0.9);  %removeUnnecessaryData(coordinates_vanes_filtered, false);
    % coordinates_vanes_removed = coordinates_vanes_filtered(rows_vanes_removed, :);
    %
    if plot_coordinates
        if copy_num == 0
            hold on
            figure(1)
            plot(coordinates_shaft(:,1), coordinates_shaft(:,2), 'r.', 'MarkerSize', 12);
            hold on
            figure(2)
            plot(ux, uy, 'r.', 'MarkerSize', 12);
            hold on

            % plot(coordinates_vanes_cleared(:,1), coordinates_vanes_cleared(:,2), 'b.', 'MarkerSize', 12);
        elseif copy_num == 1
            hold on
            figure(1)
            plot(coordinates_shaft(:,1), coordinates_shaft(:,2), 'g*', 'MarkerSize', 6);
            hold on
            % plot(coordinates_vanes_cleared(:,1), coordinates_vanes_cleared(:,2), 'k*', 'MarkerSize', 6);
        elseif copy_num == 2
            hold on
            figure(1)
            plot(coordinates_shaft(:,1), coordinates_shaft(:,2), 's', 'MarkerSize', 6);
            hold on
            %             figure(2)
            % plot(ux, uy, 's', 'MarkerSize', 6);
            % hold on
            % plot(coordinates_vanes_cleared(:,1), coordinates_vanes_cleared(:,2), 's', 'MarkerSize', 6);
        elseif copy_num == 3
            hold on
            figure(1)
            plot(coordinates_shaft(:,1), coordinates_shaft(:,2), 'r*', 'MarkerSize', 6);
            hold on
            % plot(coordinates_vanes_cleared(:,1), coordinates_vanes_cleared(:,2), 's', 'MarkerSize', 6);
        else
        end
    else
        if copy_num == 0
            hold on
            plot(u_shaft(:,1), u_shaft(:,2), 'r.', 'MarkerSize', 12);
            hold on
            plot(u_vanes(:,1), u_vanes(:,2), 'b.', 'MarkerSize', 12);
        elseif copy_num == 1
            hold on
            plot(u_shaft(:,1), u_shaft(:,2), 'g*', 'MarkerSize', 6);
            hold on
            plot(u_vanes(:,1), u_vanes(:,2), 'k*', 'MarkerSize', 6);
        elseif copy_num == 2
            hold on
            plot(u_shaft(:,1), u_shaft(:,2), 's', 'MarkerSize', 12);
            hold on
            plot(u_vanes(:,1), u_vanes(:,2), 's', 'MarkerSize', 12);
        else
        end
    end
    %
    %
    % plot(coordinates_shaft_filtered(:,1), coordinates_shaft_filtered(:,2), 'r.', 'MarkerSize', 12); % 'r.' 表示红色圆点，'MarkerSize' 调整点的大小
    %
    %
    %
    % % 保持当前图形

    %
    % plot(coordinates_vanes_filtered(:,1), coordinates_vanes_filtered(:,2), 'b.', 'MarkerSize', 12);
    %
    % row_leave_vanes = coordinates_vanes_cleared(row_id_leave_string_vanes,:);
    % plot(row_leave_vanes(1), row_leave_vanes(2), '*', 'MarkerSize', 12);

    row_leave_shaft = coordinates_shaft(row_id_leave_string_shaft,:);
    %
    plot(row_leave_shaft(1), row_leave_shaft(2), '*', 'MarkerSize', 12);
    %

    %
    % % 释放图形
    % hold off;
    %
    if output_png_figure

        % output_filename = strjoin({filename_main,'png'},'.');
        release_number_str = sprintf('%02d', release_number); % %02d 表示至少两位数，不足部分用0填充

        tmp = {filename_main,'vane',release_number_str};
        output_filename_x_t = strjoin(tmp, '_');

        output_filename_x_t = strjoin({output_filename_x_t,'png'},'.');
        exportgraphics(gca, output_filename_x_t, 'ContentType', 'vector', 'Resolution', 300);
        % exportgraphics(gca, output_filename, 'ContentType', 'vector', 'Resolution', 300);
    end

end

hold off;
%
title('Coordinates Plot'); % 添加标题
xlabel('X-axis'); % 添加x轴标签
ylabel('Y-axis'); % 添加y轴标签
% legend('ouput0-shaft', 'ouput0-vanes', 'ouput1-shaft', 'ouput1-vanes','ouput2-shaft', 'ouput2-vanes');

