function [] = merge_features_from_all_categories()
%MERGE_FEATURES_FROM_ALL_CATEGORIES Concat features for all categories into
% one big matrix and save on disk.

addpath(genpath(Config.SELF_ROOT));
dataset_path = '~/workspace/OlympicSports';
features_input_path = '/net/hciserver03/storage/mbautist/Desktop/projects/cnn_similarities/data/writeDB/';
output_filepath = '~/workspace/OlympicSports/alexnet/features/raw_features_all_alexnet_conv5_after_RELU_.mat';

data_info = load(DatasetStructure.getDataInfoPath(dataset_path), 'categoryNames');

features = [];
features_flip = [];
for i = 1:length(data_info.categoryNames)
    fprintf('Reading and concatenating features for %s...\n', data_info.categoryNames{i});
    
    filename = sprintf('features_%s_imagenet-alexnet_iter_0_conv5.mat', data_info.categoryNames{i});
    file = load(fullfile(features_input_path, filename));
    
    features      = cat(1, features, file.features);
    features_flip = cat(1, features_flip, file.features_flip);
    
    assert(all(size(file.features) == size(file.features_flip)), ...
        'size %s != %s', mat2str(size(file.features)), size(file.features_flip));
end

clear file;

whos features
fprintf('features size: %s\n', mat2str(size(features)));
fprintf('features_flip size: %s\n', mat2str(size(features_flip)));
fprintf('Saving on disk...\n');
save(output_filepath, '-v7.3', 'features', 'features_flip');

end

