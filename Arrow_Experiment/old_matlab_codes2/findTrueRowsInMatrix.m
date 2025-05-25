function trueRowIndexs = findTrueRowsInMatrix(matrix, condition)
    % 应用条件到矩阵的每一行，返回一个逻辑向量
    logicalVector = condition(matrix);
    
    % 找到逻辑向量中为true的位置
    trueRowIndexs = find(logicalVector);
end
