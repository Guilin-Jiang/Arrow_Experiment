import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy import stats
from numpy.polynomial.polynomial import Polynomial

# Configuration parameters
plot_shaft = True
step_sizes = np.arange(2, 11)
num_forward_points = 2
num_backward_points = 8
scaling_factor = 1
plot_coordinates = True  # False: plot displacement
output_png_figure = True
fitting_filename = '/Users/jiangguilin/Desktop/VSCODE/Arrow_Experiment/old_matlab_codes/purple12_8000_1130_leave_string_time.xlsx'
date = '1130'
arrow = 'purple12'
frames_per_second = '8000'

use_slope = False
plot_all_data = False
plot_cleared_data = False

total_number_release = 10
velocities = np.zeros((total_number_release, 2))
angles = np.zeros((total_number_release, 9))
average_angles = np.zeros(total_number_release)

# Create the figure for plotting
fig1, ax1 = plt.subplots()
fig2, ax2 = plt.subplots()

# Function to remove rows with zero values
def remove_zero_rows(data):
    return data[np.all(data != 0, axis=1)]

# Linear fit function with step sizes
def linear_fit_with_step_sizes(start_idx, coordinates, step_sizes):
    angles = []
    correlation_coefficients = []
    for step_size in step_sizes:
        # Perform a linear regression on the specified step size
        x = coordinates[start_idx:start_idx + step_size, 0]
        y = coordinates[start_idx:start_idx + step_size, 1]
        slope, intercept, r_value, p_value, std_err = stats.linregress(x, y)
        angles.append(np.arctan(slope) * 180 / np.pi)  # Convert to degrees
        correlation_coefficients.append(r_value)
    return np.array(angles), np.array(correlation_coefficients)

def setup_file_names(release_number, date, arrow_name, frames_per_second, copy_num):
    # Convert release number to two digits
    release_number_str = f"{release_number:02d}"

    if copy_num > 0:
        # If copy_num is greater than 0, add 'copyX' to the filename
        copy_num_str = f"copy{copy_num}"
        filename_parts = [copy_num_str, arrow_name, release_number_str, frames_per_second, date]
    else:
        # Otherwise, standard naming convention
        filename_parts = [arrow_name, release_number_str, frames_per_second, date, 'S0001']
    
    # Create the main filename by joining parts with underscores
    filename_main = "_".join(filename_parts)
    
    # Create the full filename with extension
    filename = f"{filename_main}.csv"
    
    # Create the time filename
    time_filename = f"{arrow_name}_{frames_per_second}_{date}_leave_string_time.xlsx"
    
    # Create the output filename with .png extension
    output_filename = f"{filename_main}.png"

    return filename, time_filename, output_filename, filename_main

# Reading and processing the data
for vel_id in range(2):  # Iterate for both y and x coordinates
    coordinate_id = vel_id + 1
    for release_number in range(total_number_release):
        # Setup file paths (you'll need to replace this with actual function calls for setupFileNames)
        data_filename, time_filename, output_filename, filename_main = setup_file_names(release_number, date, arrow, frames_per_second, copy_num=-1)
        
        data_time_leave = pd.read_csv(time_filename)
        time_leave = data_time_leave['s'].values
        time_leave_string = data_time_leave['s'][release_number]
        
        data = pd.read_csv(data_filename, header=None, skip_blank_lines=True)
        
        if plot_shaft:
            coordinates_shaft = data[['x___0_X_', 'x___0_Y_', 'time']].values
        else:
            coordinates_shaft = data[['x___1_X_', 'x___1_Y_', 'time']].values
        
        coordinates_shaft = remove_zero_rows(coordinates_shaft)
        
        # Flip y coordinates for correct trend representation
        coordinates_shaft[:, 0] = -coordinates_shaft[:, 0]
        coordinates_shaft[:, :2] *= scaling_factor

        # Perform linear fitting and angle calculations
        angles_shaft, correlation_coefficients_shaft = linear_fit_with_step_sizes(0, coordinates_shaft, step_sizes)
        angles[release_number, :] = 90 - angles_shaft

        # Compute the average of the angles
        average_angles[release_number] = np.mean(90 - angles_shaft)

        # Plot coordinates if needed
        if plot_coordinates:
            if vel_id == 0:
                ax1.plot(coordinates_shaft[:, 1], coordinates_shaft[:, 0], 'r.', markersize=12)
            else:
                ax1.plot(coordinates_shaft[:, 1], coordinates_shaft[:, 0], 'g*', markersize=6)

        if plot_shaft:
            ax1.set_title('Shaft Coordinates')
        else:
            ax1.set_title('Vane Coordinates')
        ax1.set_xlabel('X-axis')
        ax1.set_ylabel('Y-axis')
        
        # Plot the point at release number
        ax1.plot(coordinates_shaft[release_number, 1], coordinates_shaft[release_number, 0], 'o', markersize=12)

        # Save the figure as PNG if specified
        if output_png_figure:
            output_filename = f'{filename_main}_shaft.png' if plot_shaft else f'{filename_main}_vane.png'
            plt.savefig(output_filename, dpi=300, format='png')

        # Plot x-time and y-time
        ax2.plot(coordinates_shaft[:, 2], coordinates_shaft[:, 0], 'r.', markersize=12)
        starting_id = max(release_number - num_backward_points, 0)
        ending_id = min(release_number + num_forward_points, len(coordinates_shaft))
        
        x_coor = coordinates_shaft[starting_id:ending_id, coordinate_id]
        time = coordinates_shaft[starting_id:ending_id, 2]
        
        # Polynomial fitting
        p = np.polyfit(time, x_coor, 3)
        y_fit = np.polyval(p, time)
        p_derv = np.polyder(p)
        velocity = np.polyval(p_derv, time)[release_number - starting_id]

        velocities[release_number, vel_id] = velocity
        
        ax2.plot(time, x_coor, 'r.', time, y_fit, 'r-', markersize=12)
        
        # Plot the current velocity data
        ax2.plot(time[release_number - starting_id], x_coor[release_number - starting_id], '*', markersize=12)

        # Save the figure for time plots
        if output_png_figure:
            output_filename_x_t = f'{filename_main}_xt.png' if vel_id == 1 else f'{filename_main}_yt.png'
            plt.savefig(output_filename_x_t, dpi=300, format='png')

# Fitting and final output for velocities and angles
coord_xy = pd.read_excel(fitting_filename, header=None)
vel_abs = np.sqrt(np.sum(velocities**2, axis=1))
data_for_fitting = np.column_stack((vel_abs, average_angles, coord_xy['y'].values))

# Polynomial fitting (similar to MATLAB code for fitting)
p, stats = np.polyfit(data_for_fitting[:, 1], data_for_fitting[:, 2], 3, full=True)

# Output final data and stats
std_vel_angel_y = np.std(data_for_fitting, axis=0)
final_data = np.vstack((data_for_fitting, std_vel_angel_y))

print(final_data)
