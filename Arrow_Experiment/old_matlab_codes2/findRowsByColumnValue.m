function [rows, index] = findRowsByColumnValue(A, column, value)
    % 检查输入的列是否存在于矩阵中
    if column > size(A, 2) || column < 1
        error('Column index is out of range.');
    end
    
    % 使用逻辑索引查找指定列中等于给定值的元素
    index = abs(A(:, column) - value)<1/8000*0.5;
    
    % 使用逻辑索引选择相应的行
    rows = A(index, :);
    index = find(index);
end