function A_filtered = removeZeroRows(A)
    % 检查每一行是否所有元素都是0
    rowsWithAllZeros = all(A(:,1:2) == 0, 2);
    
    % 选择不全为0的行
    A_filtered = A(~rowsWithAllZeros, :);
end