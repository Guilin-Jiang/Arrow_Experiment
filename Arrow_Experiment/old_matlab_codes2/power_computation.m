mass = 0.2;                 %[kg]
velocity = 70;              %[m/s]
acceleration_time = 0.0143; %[s]
kinetic_energy = 0.5*mass*velocity^2; %[J]
P = kinetic_energy/acceleration_time; %[W]
disp(['所需功率为: ', num2str(P), ' 瓦特']);



