clear;
    max_x = -1e16;
    max_y = max_x;
    min_x = 1e16;
    min_y = min_x;
acceraleration_time=[];
for release_number = 1:10

    output_png_figure = true;

    date = '1031';
    arrow = 'blue03';
    % release_number = 10;
    frames_per_second = '8000';

    %use slope to clear data otherwise use residuals
    use_slope = false;

    plot_all_data = false;
    plot_cleared_data = false;

    [data_filename, time_filename, output_filename, filename_main] = setupFileNames(release_number, date, arrow, frames_per_second, 0);

    data_time_leave = readtable(time_filename);
    time_leave = [data_time_leave.s];
    time_leave_string = data_time_leave.s(release_number);

    data = readtable(data_filename,"EmptyValue",0);


    data_filename
    coordinates_shaft = [data.x___0_X_, data.x___0_Y_, data.time];
    coordinates_vanes = [data.x___1_X_, data.x___1_Y_, data.time];


    no_clear_data = true;
    %restore original data
    if(no_clear_data)
        coordinates_shaft_cleared =  removeZeroRows(coordinates_shaft);
        %flip y coordinates so that it represents the right trends
         coordinates_shaft_cleared(:,2) = -1*coordinates_shaft_cleared(:,2)

        [~, row_id_leave_string_shaft] = findRowsByColumnValue(coordinates_shaft_cleared, 3, time_leave_string);

        coordinates_vanes_cleared =removeZeroRows(coordinates_vanes);
coordinates_vanes_cleared(:,2) = -1* coordinates_vanes_cleared(:,2);

        [~, row_id_leave_string_vanes] = findRowsByColumnValue(coordinates_vanes_cleared, 3, time_leave_string);
    else
        threshold = 0.1;


        [coordinates_shaft_cleared, row_id_leave_string_shaft] = clearData(coordinates_shaft, time_leave_string, use_slope, threshold,plot_all_data, plot_cleared_data);

        threshold = 0.9;
        % hold on
        [coordinates_vanes_cleared, row_id_leave_string_vanes] = clearData(coordinates_vanes, time_leave_string, use_slope, threshold,plot_all_data, plot_cleared_data);
    end


    two_point_slopes = coordinates_vanes(:, 2) - coordinates_shaft(:,2)./coordinates_vanes(:, 1) - coordinates_shaft(:,1);


    stepSizes = [2:10];
    [angles_vanes, correlationCoefficients_vanes] = linearFitWithStepSizes(row_id_leave_string_vanes, coordinates_vanes_cleared, stepSizes);
    [angles_shaft, correlationCoefficients_shaft] = linearFitWithStepSizes(row_id_leave_string_shaft, coordinates_shaft_cleared, stepSizes);

    acceraleration_time = [acceraleration_time;time_leave(release_number) - coordinates_shaft_cleared(1,3)];

    

    plot(coordinates_shaft_cleared(:,1), coordinates_shaft_cleared(:,2), 'r.', 'MarkerSize', 12);
    hold on
    plot(coordinates_vanes_cleared(:,1), coordinates_vanes_cleared(:,2), 'b.', 'MarkerSize', 12);
    %

    %used to fix x and y lim
    max_x = max(max(coordinates_shaft_cleared(:,1)), max_x);
    max_y = max(max(coordinates_shaft_cleared(:,2)), max_y);
    min_x = min(min(coordinates_shaft_cleared(:,1)), min_x);
    min_y = min(min(coordinates_shaft_cleared(:,2)), min_y);

    %the moment when arrow leaves the string
    row_leave_vanes = coordinates_vanes_cleared(row_id_leave_string_vanes,:);
    plot(row_leave_vanes(1), row_leave_vanes(2), '*', 'MarkerSize', 12);
    row_leave_shaft = coordinates_shaft_cleared(row_id_leave_string_shaft,:);
    plot(row_leave_shaft(1), row_leave_shaft(2), '*', 'MarkerSize', 12);


    %
    title('Coordinates Plot'); % 添加标题
    xlabel('X-axis'); % 添加x轴标签
    ylabel('Y-axis'); % 添加y轴标签
    legend('Shaft', 'Vanes');
    xlim([-5.6e-3, -2e-3]); % 设置x轴的范围从0到10
    ylim([-0.023, 0.026]);  % 设置y轴的范围从-2到2
    %
    % % 释放图形
    hold off;
    %
    if output_png_figure

        % output_filename = strjoin({filename_main,'png'},'.');
        exportgraphics(gca, output_filename, 'ContentType', 'vector', 'Resolution', 300);
    end

    %plot x-time and y-time
    figure(2)
    plot(coordinates_shaft_cleared(:,3), coordinates_shaft_cleared(:,1), 'r.', 'MarkerSize', 12);
    hold on
    plot(coordinates_vanes_cleared(:,3), coordinates_vanes_cleared(:,1), 'b.', 'MarkerSize', 12);
    % plot(coordinates_shaft_cleared(2:end,3), coordinates_shaft_cleared(2:end,1)-coordinates_shaft_cleared(1:end-1,1), 'r.', 'MarkerSize', 12);
    % hold on
    % plot(coordinates_vanes_cleared(2:end,3), coordinates_vanes_cleared(2:end,1)-coordinates_vanes_cleared(1:end-1,1), 'b.', 'MarkerSize', 12);

    title('x-t Plot'); % 添加标题
    legend('Shaft', 'Vanes');
    xlabel('time'); % 添加x轴标签
    ylabel('x'); % 添加y轴标签    

    if output_png_figure
        release_number_str = sprintf('%02d', release_number); % %02d 表示至少两位数，不足部分用0填充
            
        tmp = {filename_main,'xt',release_number_str};
        output_filename_x_t = strjoin(tmp, '_');
        
        output_filename_x_t = strjoin({output_filename_x_t,'png'},'.');
        exportgraphics(gca, output_filename_x_t, 'ContentType', 'vector', 'Resolution', 300);
    end
    hold off



end
%

disp(" use min_x and y max_x and y to set xlim and ylim");
[min_x, max_x]
[min_y, max_y]

