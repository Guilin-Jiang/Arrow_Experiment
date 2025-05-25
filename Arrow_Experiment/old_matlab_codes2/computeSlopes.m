function slopes = computeSlopes(data)

slopes = (data(2:end,2) - data(1:end-1,2))./...
    (data(2:end,1) - data(1:end-1,1));