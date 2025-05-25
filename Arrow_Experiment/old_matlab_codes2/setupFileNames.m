function [filename,  time_filename, output_filename, filename_main]= setupFileNames(release_number, date, arrow_name, frames_per_second, copy_num)

% date = '0812';
% arrow_name = 'blue04';
% release_number = 10;
file_type = 'csv';

% frames_per_second = '8000';
release_number_str = sprintf('%02d', release_number); % %02d 表示至少两位数，不足部分用0填充

if(copy_num >0)
    copy_num_str = sprintf('copy%d', copy_num);
    filename_str = {copy_num_str,arrow_name,release_number_str,frames_per_second,date};
else
    filename_str = {arrow_name,release_number_str,frames_per_second,date,'S0001'};
end
filename_main = strjoin(filename_str, '_');
filename_type = {filename_main,file_type};
filename = strjoin(filename_type,'.');


time_filename = strjoin({arrow_name,frames_per_second,date,'leave_string_time'},'_');
time_filename = strjoin({time_filename, 'xlsx'}, '.');


output_filename = strjoin({filename_main,'png'},'.');