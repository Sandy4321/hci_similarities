function [] = compute_hog_pedro( dataset_path, crops_dir_name, output_path )
%COMPUTE_HOG_PEDRO
% This function uses HOG features implementation by Pedro Felzenszwalb, Deva Ramanan and presumably others.
% crops_dir_name = 'crops_227x227'

[output_dir_path, name, ext] = fileparts(output_path);
if ~exist(output_dir_path, 'dir')
    mkdir(output_dir_path);
end

HOG_CELL_SIZE = 8;

fprintf('Opening crops global info file...\n');
CROPS_INFO_FILEPATH = ...
    fullfile(DatasetStructure.getDataDirPath(dataset_path), ...
    'crops_global_info.mat');
crops_info = load(CROPS_INFO_FILEPATH);

num_samples = length(crops_info.crops);

hog = [];
hog_flipped = [];%cell(1, num_samples);

fprintf('Running Pedro-HOG computation on %s\n', fullfile(dataset_path, crops_dir_name));

progress_struct = init_progress_string('Frame:', num_samples, 50);
for frame_id = 1:num_samples
    update_progress_string(progress_struct, frame_id);
    image_path = fullfile(dataset_path, ...
                          crops_dir_name, ...
                          crops_info.crops(frame_id).img_relative_path);
                      
    im = im2double(imread(image_path));
    im_flipped = utils.fliplr(im);
    
    if isempty(hog)
        tmp_feature = features_pedro(im, HOG_CELL_SIZE);
        hog = zeros(size(tmp_feature, 1), size(tmp_feature, 2), size(tmp_feature, 3), num_samples,  'single');
        hog_flipped = zeros(size(tmp_feature, 1), size(tmp_feature, 2), size(tmp_feature, 3), num_samples, 'single');
    end
    
    hog(:, :, :, frame_id) = features_pedro(im, HOG_CELL_SIZE);
    hog_flipped(:, :, :, frame_id) = features_pedro(im_flipped, HOG_CELL_SIZE);
end

fprintf('hog vector size: %s\n', mat2str(size(hog(:, :, :, 1))));
whos hog
fprintf('Saving on disk...\n');
save(output_path, '-v7.3', 'hog', 'hog_flipped');

end

