clear;
plot_coordinates = true; % false:plot displacement

output_png_figure = true;

date = '0812';
arrow = 'blue04';
release_number = 10;
frames_per_second = '8000';

%use slope to clear data otherwise use residuals
use_slope = false;

plot_all_data = false;
plot_cleared_data = false;

figure
hold on;
for copy_num = 0:2
   
    %如果是副本
    % copy_num = 2;


    [data_filename, time_filename, output_filename] = setupFileNames(release_number, date, arrow, frames_per_second, copy_num);
    

    data_time_leave = readtable(time_filename);
    time_leave = [data_time_leave.s];
    time_leave_string = data_time_leave.s(release_number);

    data = readtable(data_filename,"EmptyValue",0);


    data_filename
    coordinates_shaft = [data.x___0_X_, data.x___0_Y_, data.time];
    threshold = 0.1;

    [coordinates_shaft_cleared, row_id_leave_string_shaft] = clearData(coordinates_shaft, time_leave_string, use_slope, threshold,plot_all_data, plot_cleared_data);

    coordinates_vanes = [data.x___1_X_, data.x___1_Y_, data.time];
    if copy_num == 2
        threshold = 0.3;
    else
        threshold = 0.9;
    end
    % hold on
    [coordinates_vanes_cleared, row_id_leave_string_vanes] = clearData(coordinates_vanes, time_leave_string, use_slope, threshold,plot_all_data, plot_cleared_data);

    u_shaft = coordinates_shaft_cleared(2:end,:) - coordinates_shaft_cleared(1:end-1, :);
    u_vanes = coordinates_vanes_cleared(2:end, :) - coordinates_vanes_cleared(1:end-1, :);



    stepSizes = [2:2:row_id_leave_string_shaft+5];
    [angles_vanes, correlationCoefficients_vanes] = linearFitWithStepSizes(row_id_leave_string_vanes, coordinates_vanes_cleared, stepSizes);
    [angles_shaft, correlationCoefficients_shaft] = linearFitWithStepSizes(row_id_leave_string_shaft, coordinates_shaft_cleared, stepSizes);


    plot(stepSizes,angles_shaft, 'r.', 'MarkerSize', 12);
    hold on
    plot(stepSizes, angles_vanes, 'b.', 'MarkerSize', 12);
    plot(stepSizes, angles_vanes - angles_shaft, 'g.', 'MarkerSize', 12);
  
    %


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
 

    %
    % % 释放图形
    % hold off;
    %
    if output_png_figure

        output_filename = strjoin({'./plots_angles/angle-same-video',output_filename},'_');
        exportgraphics(gca, output_filename, 'ContentType', 'vector', 'Resolution', 300);
    end

end

hold off;

    title('stepSize vs angles'); % 添加标题
    xlabel('step size'); % 添加x轴标签
    ylabel('angle'); % 添加y轴标签
    legend('Shaft', 'Vanes');
    xlim([0, 130]); % 设置x轴的范围从0到10
    ylim([0, 4.5]);  % 设置y轴的范围从-2到2
