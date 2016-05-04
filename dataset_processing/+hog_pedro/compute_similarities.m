function [] = compute_similarities( category_name, dataset_path,  ...
                                              hog_pedro_path, hog_pedro_flipped_path, output_path )
% Calculate intra-category pairwise correlations between
% pedro-HOG representations of the samples from specified category. 
narginchk(2, 5);

if nargin == 2
    hog_pedro_path = fullfile(dataset_path, 'features/hog_pedro_227x227.mat');
    hog_pedro_flipped_path = fullfile(dataset_path, 'features/hog_pedro_227x227.mat');
    output_path = fullfile(dataset_path, sprintf('sim/sim_hog_pedro_%s.mat', category_name));
else
    narginchk(5, 5);
end

fprintf('hod_pedro.compute_similarities for %s\n', category_name);

[output_dir_path, name, ext] = fileparts(output_path);
if ~exist(output_dir_path, 'dir')
    mkdir(output_dir_path);
end

if exist(output_path, 'file')
    fprintf('Skip. File %s already exists!\n', output_path);
    return
end

fprintf('Loading data info... ');
data_info = load(DatasetStructure.getDataInfoPath(dataset_path));
fprintf('[OK]\n');

if strcmp(category_name, 'ALL') == 1
    category_offset = 0;
    category_size = data_info.totalNumberOfVectors;
    fprintf('Computing SIM FOR ALL CATEGORIES (%d vectors)...\n', category_size);
else
    fprintf('Computing category offset...\n');
    category_offset = get_category_offset(category_name, data_info);
    fprintf('Computing category size...\n');
    category_size = get_category_size(category_name, data_info);
end

fprintf('Opening hog files... ');
hog_file = matfile(hog_pedro_path);
hog_flipped_file = matfile(hog_pedro_flipped_path);
fprintf('[OK]\n');

hog_matrix = get_hog_matrix_for_category(hog_file, 'hog', category_offset, category_size);
hog_matrix_flipped = get_hog_matrix_for_category(hog_flipped_file, 'hog_flipped', category_offset, category_size);

fprintf('hog_matrix size: %s\n', mat2str(size(hog_matrix)));
assert(size(hog_matrix, 1) == category_size);

fprintf('Computing correlation unflipped - unflipped ...\n');
simMatrix = single(squareform(2 - pdist(hog_matrix, 'correlation')));

fprintf('Computing correlation unflipped - flipped ...\n');
simMatrix_flipped = single(2 - pdist2(hog_matrix, hog_matrix_flipped, 'correlation'));

clear hog_matrix
clear hog_matrix_flipped

whos simMatrix
fprintf('simMatrix size: %s\n', mat2str(size(simMatrix)));
fprintf('simMatrix_flipped size: %s\n', mat2str(size(simMatrix_flipped)));
fprintf('Saving on disk...\n');
save(output_path, '-v7.3', 'simMatrix', 'simMatrix_flipped');

end

function hog_matrix = get_hog_matrix_for_category(hog_file, fieldname, category_offset, category_size)
% Return M x N matrix, containing hog representations in rows.
% Each row is reshaped into plain vector HOG feature. 
% M is number of samples, N is number of dimensions in HOG vector.
fprintf('getting hog_matrix for category. [%s]\n', fieldname);

hog_for_category = hog_file.(fieldname)(:, :, :, category_offset + 1: category_offset + category_size);
fprintf('Num of hog vectors: %d\n', length(hog_for_category));

hog_matrix = zeros(length(hog_for_category), 26*26*31, 'single');
for i = 1:length(hog_for_category)
    hog_matrix(i, :) = single(reshape(hog_for_category(:, :, :, i), 1, []));
end

clear hog_for_category
end
