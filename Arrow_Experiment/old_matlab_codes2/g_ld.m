function y = g_ld(data_x, data_y, ld, x0,v0x, y0, v0y)
n = length(data_x);
y = 0;

for i=1:n
    % (data_y(i) - y_traj(data_x(i), ld, x0, v0x, y0, v0y))
    % partial_y_traj(data_x(i), ld, x0,v0x)
    y = y + (data_y(i) - y_traj(data_x(i), ld, x0, v0x, y0, v0y)) * partial_y_traj(data_x(i), ld, x0,v0x);
end