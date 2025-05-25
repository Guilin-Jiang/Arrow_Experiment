clear;
plot_vanes = false;

for release_number = 10:10
   
    output_png_figure = true;

    date = '0812';
    arrow = 'blue04';
    % release_number = 10;
    frames_per_second = '8000';

    %use slope to clear data otherwise use residuals
    use_slope = false;

    plot_all_data = false;
    plot_cleared_data = false;

    [data_filename, time_filename, output_filename] = setupFileNames(release_number, date, arrow, frames_per_second, 0);

    data_time_leave = readtable(time_filename);
    time_leave = [data_time_leave.s];
    time_leave_string = data_time_leave.s(release_number);

    data = readtable(data_filename,"EmptyValue",0);


    data_filename
    coordinates_shaft = [data.x___0_X_, data.x___0_Y_, data.time];
    threshold = 0.1;

    [coordinates_shaft_cleared, row_id_leave_string_shaft] = clearData(coordinates_shaft, time_leave_string, use_slope, threshold,plot_all_data, plot_cleared_data);

    coordinates_vanes = [data.x___1_X_, data.x___1_Y_, data.time];
    threshold = 0.9;
    % hold on
    [coordinates_vanes_cleared, row_id_leave_string_vanes] = clearData(coordinates_vanes, time_leave_string, use_slope, threshold,plot_all_data, plot_cleared_data);

    %两个追踪点的斜率
    two_point_slopes = (coordinates_vanes(:, 2) - coordinates_shaft(:,2))./(coordinates_vanes(:, 1) - coordinates_shaft(:,1));
    %两个追踪点同时有坐标
    two_point_slopes_lower_bound = find(coordinates_vanes(:,3) == coordinates_vanes_cleared(1,3));
    two_point_slopes_upper_bound = find(coordinates_shaft(:,3) == coordinates_shaft_cleared(end,3));



    figure(10)
    hold on
    plot(coordinates_vanes(two_point_slopes_lower_bound:two_point_slopes_upper_bound,3), ...
        abs(atan(two_point_slopes(two_point_slopes_lower_bound:two_point_slopes_upper_bound))/pi*360),'b.', 'MarkerSize', 12);
    
    stepSizes = [2:10];
    [angles_vanes, correlationCoefficients_vanes] = linearFitWithStepSizes(row_id_leave_string_vanes, coordinates_vanes_cleared, stepSizes);
    [angles_shaft, correlationCoefficients_shaft] = linearFitWithStepSizes(row_id_leave_string_shaft, coordinates_shaft_cleared, stepSizes);

    

    % correlationCoefficients = zeros(1, length(stepSizes));
    % slopes = zeros(1, length(stepSizes));
    % angles = zeros(1, length(stepSizes));
    %   for i = 1:length(stepSizes)
    %     stepSize = stepSizes(i);
    %     fprintf('正在进行步长为 %f 的线性拟合...\n', stepSize);
    % 
    %     % 根据步长选择数据点
    %     max_id = length(coordinates_vanes_cleared(:,1));
    %     lower_bound = row_id_leave_string_vanes-stepSize;
    %     upper_bound = min(row_id_leave_string_vanes+stepSize, max_id);
    %     selectedX = coordinates_vanes_cleared(lower_bound:upper_bound, 1);
    %     selectedY = coordinates_vanes_cleared(lower_bound:upper_bound, 2);
    % 
    %     % 进行线性拟合
    %     p = polyfit(selectedX, selectedY, 1);
    % 
    %     slopes(i) = p(1);
    %     angles(i) = abs(arc2degree(atan(slopes(i))));
    % 
    %     % 计算相关系数矩阵，并取第一个元素作为Pearson相关系数
    %     [r, CI] = corrcoef(selectedX, selectedY);
    %     correlationCoefficients(i) = r(1, 2); % 存储相关系数
    % 
    %     % 计算拟合线
    %     % yFit = polyval(p, x);
    % 
    %     % 绘制拟合线
    %     % plot(x, yFit, 'DisplayName', strcat('Step Size ', num2str(stepSize)));
    % end

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
    figure(1)
hold on;
    if plot_vanes
        hold on
        plot(coordinates_vanes_cleared(:,1), coordinates_vanes_cleared(:,2), 'b.', 'MarkerSize', 12);
    else
        hold on
        plot(coordinates_shaft_cleared(:,1), coordinates_shaft_cleared(:,2), 'r.', 'MarkerSize', 12);
    end
    hold on
    
    %
    %
    % plot(coordinates_shaft_filtered(:,1), coordinates_shaft_filtered(:,2), 'r.', 'MarkerSize', 12); % 'r.' 表示红色圆点，'MarkerSize' 调整点的大小
    %
    %
    %
    % % 保持当前图形

    %
    % plot(coordinates_vanes_filtered(:,1), coordinates_vanes_filtered(:,2), 'b.', 'MarkerSize', 12);
    if plot_vanes
        row_leave_vanes = coordinates_vanes_cleared(row_id_leave_string_vanes,:);
        plot(row_leave_vanes(1), row_leave_vanes(2), '*', 'MarkerSize', 12);
    else
        row_leave_shaft = coordinates_shaft_cleared(row_id_leave_string_shaft,:);

        plot(row_leave_shaft(1), row_leave_shaft(2), '*', 'MarkerSize', 12);
        %
    end
    
    %
    % % 释放图形
   

end
%
 hold off;
    %
  title('Coordinates Plot'); % 添加标题
    xlabel('X-axis'); % 添加x轴标签
    ylabel('Y-axis'); % 添加y轴标签
    % legend('Shaft', 'Vanes');
    xlim([-0.6, 0.1]); % 设置x轴的范围从0到10
    ylim([0.08, 0.135]);  % 设置y轴的范围从-2到2
    if output_png_figure

        % output_filename = strjoin({filename_main,'png'},'.');
        if plot_vanes
            output_filename = 'conbined-vanes.png';
        else
            output_filename = 'conbined-shaft.png';
        end
        exportgraphics(gca, output_filename, 'ContentType', 'vector', 'Resolution', 300);
    end

