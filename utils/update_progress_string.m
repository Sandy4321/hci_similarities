function [] = update_progress_string(progress_struct, iteration_num)
%UPDATE_PROGRESS_STRING Summary of this function goes here
%   Detailed explanation goes here
    if mod(iteration_num, progress_struct.update_period) == 0
        fprintf(progress_struct.clean_symbols);
        fprintf(progress_struct.format, iteration_num);
    end

end

