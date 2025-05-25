function outliers = findNonLinearPoints(data, leave_time_id, threshold)
end_id = min(leave_time_id+5, length(data(:,1)));
x = data(leave_time_id-5:end_id,1);
y = data(leave_time_id-5:end_id,2);
% 对数据进行线性回归拟合
b = polyfit(x, y, 1);

% 计算拟合线
y_fit = polyval(b, data(:,1));

% 计算残差
residuals = data(:,2) - y_fit;

% 计算残差的标准差
stdResiduals = std(residuals);

% 根据阈值筛选出不符合线性的点
% 阈值可以是残差标准差的倍数，例如3倍标准差
outlierIndices = abs(residuals) > threshold * stdResiduals;
num = length(data(:,1));
outlierIndices(1:end_id) = false;
% 获取符合线性的点的索引
outliers = find(~outlierIndices);
end