clc;clear
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

data =[   54.3954    3.5001   25.4185
   54.2566    3.5160   29.2126
   54.2572    3.5246   25.8273
   54.1194    3.4878   33.9292
   54.3040    3.4872   32.2851
   54.1595    3.5152   28.9519
   54.6008    3.6111   20.9230
   54.6149    3.5444   34.8623
   54.6572    3.5857   13.8815
   54.5403    3.6058   33.6402];



angles = data(:, 2);
velocities = data(:,1);
xy_coord = xy_coord * 1e-2;
target1_center_height = 0.65;
xy_coord(:,2) = xy_coord(:,2)+target1_center_height;

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
t = 1.2231;
falpha = @(alpha) z0 + m/alpha*(v0 + m*g/alpha) * (1 - exp(-alpha/m * t)) -m*g*t/alpha;
dfalpha_dalpha_func = @(alpha) -m*(v0 + m*g/alpha)*exp(-alpha*t/m)/alpha + m*(v0 + m*g/alpha)*t/m - m*g*t/alpha^2;

dfalpha_dalpha_func1 = @(alpha)( - m * v0 / alpha^2 - 2*m^2*g/alpha^3) * (1 - exp(-alpha * t/m))...
                     + ( m*v0 / alpha + m^2 * g / alpha^2) * (t/m * exp(-alpha * t/m))...
                     + m*g*t/alpha^2;

n = length(angles);
time = zeros(n,1);
for i = 1:n
    theta0 = deg2rad(angles(i));
    t = dist1/velocities(i)*cos(theta0);
    v0z = velocities(i)*sin(theta0);
    z(i) = z0 + v0z * t - 0.5 * g * t^2;
    time(i) = t;
end

[z',xy_coord(:,2) ,time]

