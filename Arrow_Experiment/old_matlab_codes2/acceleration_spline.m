starting_id = 1;
x = coordinates_shaft(starting_id:end,2);
y = coordinates_shaft(starting_id:end,1);
t = coordinates_shaft(starting_id:end,3);
xx = (x(2:end) + x(1:end-1))/2;
t_mid = (t(2:end) + t(1:end-1))/2;

yy = spline(t,x);
% plot(x,y,'o',xx,yy)
dyy = fnder(yy);  
ddyy = fnder(dyy);  

spline_val_y = fnval(yy, t);  % 在xx点处求二次导数值
spline_val_ddy = fnval(ddyy, t);  % 在xx点处求二次导数值
figure(11);
plot(t, y, 'o');
figure(12)
plot(t, spline_val_y, '*-');
figure(13)
plot(t, spline_val_ddy, '*-');



