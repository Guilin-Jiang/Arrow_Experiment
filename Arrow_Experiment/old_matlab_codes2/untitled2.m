%orange22
xy_coord=[-8.367317743	24.14986839
-8.733071155	24.38068993
-8.796068597	17.53546149
-8.81274514	22.39868971
-8.009295477	24.32857439
-8.697790257	23.98160341
-8.4713589	25.06093992
-9.402932857	29.81401667
-9.648102076	29.96412662
-10.72810744	19.39247332
];
xy_coord = xy_coord * 1e-2;
target1_center_height = 0.65;
xy_coord(:,2) = xy_coord(:,2)+target1_center_height;
y_coord = xy_coord(:,2);

z0 = 1.5;
m = 21.472e-3;
dist = 68.36;
diff_targets = 0.58;
dist1 = dist - diff_targets;
v0 = 54;
g = 9.81;
initial_angle = 3.5; %degree
theta0 = deg2rad(90-initial_angle);
vz0 = v0 * sin(theta0);
t = 1.3166;
falpha = @(alpha) z0 + m./alpha.*(v0 + m.*g./alpha) .* (1 - exp(-alpha./m.* t)) -m*g*t./alpha;
dfalpha_dalpha_func = @(alpha) -m*(v0 + m*g/alpha)*exp(-alpha*t/m)/alpha + m*(v0 + m*g/alpha)*t/m - m*g*t/alpha^2;

dfalpha_dalpha_func1 = @(alpha, yi)(( - m * v0 ./ alpha.^2 - 2*m^2*g./alpha.^3) * (1 - exp(-alpha .* t/m))...
                     + ( m*v0 ./ alpha + m^2 .* g ./ alpha.^2) .* (t/m .* exp(-alpha .* t/m))...
                     + m*g*t/alpha.^2) .* (yi - falpha(alpha));


n=length(xy_coord(:,1));

for i = 1:n
    theta0 = deg2rad(angles(i));
    t = dist1/velocities(i)*cos(theta0);
    v0z = velocities(i)*sin(theta0);
    z(i) = z0 + v0z * t - 0.5 * g * t^2;

   

end


