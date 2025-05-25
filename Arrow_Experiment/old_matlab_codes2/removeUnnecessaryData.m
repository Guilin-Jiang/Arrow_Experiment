function coordinates_shaft_removed = removeUnnecessaryData(coordinates_shaft_filtered, plot_slope)
% remove uncessary data points by checking slopes
slopes_values = computeSlopes(coordinates_shaft_filtered);



[~,id]=max(abs(slopes_values));
coordinates_shaft_removed = coordinates_shaft_filtered(1:id-1,:);

if plot_slope
    figure(1)
    plot(coordinates_shaft_filtered(1:end-1,3), slopes_values);
end