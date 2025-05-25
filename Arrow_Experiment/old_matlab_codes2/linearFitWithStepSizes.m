function [angles,correlationCoefficients ]= linearFitWithStepSizes(row_id_leave_string_vanes,  coordinates_vanes_cleared, stepSizes)
correlationCoefficients = zeros(1, length(stepSizes));
slopes = zeros(1, length(stepSizes));
angles = zeros(1, length(stepSizes));
for i = 1:length(stepSizes)
    stepSize = stepSizes(i);
    % fprintf('正在进行步长为 %f 的线性拟合...\n', stepSize);

    % 根据步长选择数据点
    max_id = length(coordinates_vanes_cleared(:,1));
    lower_bound = max(row_id_leave_string_vanes-stepSize, 1);
    upper_bound = min(row_id_leave_string_vanes+stepSize, max_id);
    selectedX = coordinates_vanes_cleared(lower_bound:upper_bound, 1);
    selectedY = coordinates_vanes_cleared(lower_bound:upper_bound, 2);

    % 进行线性拟合
    p = polyfit(selectedX, selectedY, 1);

    slopes(i) = p(1);
    angles(i) = abs(arc2degree(atan(slopes(i))));

    % 计算相关系数矩阵，并取第一个元素作为Pearson相关系数
    [r, CI] = corrcoef(selectedX, selectedY);
    correlationCoefficients(i) = r(1, 2); % 存储相关系数

    % 计算拟合线
    % yFit = polyval(p, x);

    % 绘制拟合线
    % plot(x, yFit, 'DisplayName', strcat('Step Size ', num2str(stepSize)));
end
end