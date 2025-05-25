clear;close all;

% true for shaft, false for vane
plot_shaft = false;

% 1 for y coordinate (vertical); 2 for x
coordinate_id = 1;

% used to fit angles 
stepSizes = [2:10];

scaling_factor = 11.5;

plot_coordinates = true; % false:plot displacement

output_png_figure = true;

date = '1104';
arrow = 'blue03';
% used to determine time leave string
release_number = 2;
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
    % file name pattern: 'copy3_blue03_01_8000_1031.csv'

    [data_filename, time_filename, output_filename, filename_main] = setupFileNames(release_number, date, arrow, frames_per_second, copy_num);


    data_time_leave = readtable(time_filename);
    time_leave = [data_time_leave.s];
    time_leave_string = data_time_leave.s(release_number);

    data = readtable(data_filename,"EmptyValue",0);


    data_filename

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
    average = mean(90 - angles_shaft)
    correlationCoefficients_shaft

  
    if plot_coordinates
        if copy_num == 0
            hold on
            figure(1)
            plot(coordinates_shaft(:,2), coordinates_shaft(:,1), 'r.', 'MarkerSize', 12);
            hold on
            % figure(2)
            % plot(ux, uy, 'r.', 'MarkerSize', 12);
            % hold on

            % plot(coordinates_vanes_cleared(:,1), coordinates_vanes_cleared(:,2), 'b.', 'MarkerSize', 12);
        elseif copy_num == 1
            hold on
            figure(1)
            plot(coordinates_shaft(:,2), coordinates_shaft(:,1), 'g*', 'MarkerSize', 6);
            hold on
            % plot(coordinates_vanes_cleared(:,1), coordinates_vanes_cleared(:,2), 'k*', 'MarkerSize', 6);
        elseif copy_num == 2
            hold on
            figure(1)
            plot(coordinates_shaft(:,2), coordinates_shaft(:,1), 's', 'MarkerSize', 6);
            hold on
            %             figure(2)
            % plot(ux, uy, 's', 'MarkerSize', 6);
            % hold on
            % plot(coordinates_vanes_cleared(:,1), coordinates_vanes_cleared(:,2), 's', 'MarkerSize', 6);
        elseif copy_num == 3
            hold on
            figure(1)
            plot(coordinates_shaft(:,2), coordinates_shaft(:,1), 'r*', 'MarkerSize', 6);
            hold on
            % plot(coordinates_vanes_cleared(:,1), coordinates_vanes_cleared(:,2), 's', 'MarkerSize', 6);
        else
        end
    else

    end

    if(plot_shaft)
        title('Shaft Coordinates'); % 添加标题
    else
        title('Vane Coordinates'); % 添加标题
    end
    xlabel('X-axis'); % 添加x轴标签
    ylabel('Y-axis'); % 添加y轴标签
    %

    row_leave_shaft = coordinates_shaft(row_id_leave_string_shaft,:);
    %
    plot(row_leave_shaft(2), row_leave_shaft(1), 'o', 'MarkerSize', 12);


    if output_png_figure

        
        release_number_str = sprintf('%02d', release_number); % %02d 表示至少两位数，不足部分用0填充
        if(plot_shaft)
            tmp = {filename_main,'shaft'};
        else
            tmp = {filename_main,'vane'};
        end
        filename_main = strjoin(tmp, '_');

        output_filename = strjoin({filename_main,'png'},'.');
        exportgraphics(gca, output_filename, 'ContentType', 'vector', 'Resolution', 300);
    end

    %plot x-time and y-time
    figure(2)
    % plot(coordinates_shaft(:,3), coordinates_shaft(:,1), 'r.', 'MarkerSize', 12);
    starting_id = 20;
    ending_id = min(row_id_leave_string_shaft+3, length(coordinates_shaft(:,1)));

    x_coor = coordinates_shaft(starting_id:ending_id,coordinate_id);
    release_number_str = sprintf('%02d', release_number); % %02d 表示至少两位数，不足部分用0填充
    if(coordinate_id == 1)
        tmp = {filename_main,'yt'};
        title('y-t Plot'); % 添加标题
        ylabel('y'); % 添加y轴标签
    else
        tmp = {filename_main,'xt'};
        title('x-t Plot'); % 添加标题
        ylabel('x'); % 添加y轴标签
    end
    output_filename_x_t = strjoin(tmp, '_');

    time = coordinates_shaft(starting_id:ending_id,3);
    n = 3;
    p = polyfit(time, x_coor, n);
    y_fit = polyval(p, time);

    %  get the coefficients of derivative of poly
    p_derv = polyder(p);
    vel = polyval(p_derv, time);
    velocity = vel(row_id_leave_string_shaft-starting_id)
    %
    % % 绘制原始数据点和拟合曲线
    % plot(x, y, 'o', x, y_fit, '*');
    %
    % % 使用polyval计算拟合多项式在x值上的预测值
    % y_fit = polyval(p, x);
    hold on

    if copy_num == 0

    elseif copy_num == 1
        hold on
        figure(2)
        plot(time, x_coor, 'g*', time, y_fit,'g-', 'MarkerSize', 6);
        hold on
        % plot(coordinates_vanes_cleared(:,1), coordinates_vanes_cleared(:,2), 'k*', 'MarkerSize', 6);
    elseif copy_num == 2
        hold on
        figure(2)
        plot(time, x_coor, 's',  time, y_fit,'-', 'MarkerSize', 6);
        hold on
        %             figure(2)
        % plot(ux, uy, 's', 'MarkerSize', 6);
        % hold on
        % plot(coordinates_vanes_cleared(:,1), coordinates_vanes_cleared(:,2), 's', 'MarkerSize', 6);
    elseif copy_num == 3
        hold on
        figure(2)
        plot(time, x_coor, 'r*', time, y_fit,'-','MarkerSize', 6);
        hold on
        % plot(coordinates_vanes_cleared(:,1), coordinates_vanes_cleared(:,2), 's', 'MarkerSize', 6);
    else
    end

    %
    plot(time(row_id_leave_string_shaft-starting_id), x_coor(row_id_leave_string_shaft-starting_id), '*', 'MarkerSize', 12);
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





end

hold off;
%

% legend('ouput0-shaft', 'ouput0-vanes', 'ouput1-shaft', 'ouput1-vanes','ouput2-shaft', 'ouput2-vanes');

