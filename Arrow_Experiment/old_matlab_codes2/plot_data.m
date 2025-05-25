function plot_data(coordinates_shaft_cleared, coordinates_vanes_cleared, figure_num)

figure(figure_num)
    plot(coordinates_shaft_cleared(:,1), coordinates_shaft_cleared(:,2), 'r.', 'MarkerSize', 12);
    hold on
    plot(coordinates_vanes_cleared(:,1), coordinates_vanes_cleared(:,2), 'b.', 'MarkerSize', 12);
    %
    %
    % plot(coordinates_shaft_filtered(:,1), coordinates_shaft_filtered(:,2), 'r.', 'MarkerSize', 12); % 'r.' 表示红色圆点，'MarkerSize' 调整点的大小
    %
    %
    %
    % % 保持当前图形

    %
    % plot(coordinates_vanes_filtered(:,1), coordinates_vanes_filtered(:,2), 'b.', 'MarkerSize', 12);

    % row_leave_vanes = coordinates_vanes_cleared(row_id_leave_string_vanes,:);
    % plot(row_leave_vanes(1), row_leave_vanes(2), '*', 'MarkerSize', 12);
    % 
    % row_leave_shaft = coordinates_shaft_cleared(row_id_leave_string_shaft,:);
    % 
    % plot(row_leave_shaft(1), row_leave_shaft(2), '*', 'MarkerSize', 12);
    %
    title('Coordinates Plot'); % 添加标题
    xlabel('X-axis'); % 添加x轴标签
    ylabel('Y-axis'); % 添加y轴标签
    legend('Shaft', 'Vanes');
    %
    % % 释放图形
    hold off;