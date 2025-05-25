function [fitting_data, d_fitting_data] = derivative_of_data(time, data, n)

% time = coordinates_shaft(starting_id:ending_id,3);
        % n = 4;
        p = polyfit(time, data, n);
        fitting_data = polyval(p, time);

        %  get the coefficients of derivative of poly
        p_derv = polyder(p);
        
        d_fitting_data = polyval(p_derv, time);