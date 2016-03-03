function [ roc_params ] = get_roc_params(category_name)
%GET_ROC_PARAMS Get deafult params for ROC plotting.
addpath(genpath('~/workspace/similarities'))

roc_params.dataset_path = '~/workspace/OlympicSports';
roc_params.plots_dir = 'plots';

roc_params.use_cnn_features = 1;% ESVM Uses CNN features or HOG.
roc_params.features_path = ... % used only if use_cnn_features = 1
    '~/workspace/OlympicSports/alexnet/features/features_all_alexnet_fc7_zscores.mat';
roc_params.esvm_crops_dir_name = 'crops_227x227';

roc_params.use_models_with_top_hardest_negatives_removed = 1;

% Load features into memory
if roc_params.use_cnn_features
    tic;
    fprintf('Reading CNN features file... %s\n', roc_params.features_path);
    assert(exist(roc_params.features_path, 'file') ~= 0, ...
                'File %s is not found', roc_params.features_path);
    roc_params.features_data = load(roc_params.features_path, 'features', 'features_flip');
    toc
end

roc_params.detect_params = sim_esvm.get_default_params;
if roc_params.use_cnn_features
    roc_params.detect_params.features_type = 'FeatureVector';
    roc_params.esvm_models_dir = 'esvm/alexnet_zscores_esvm_at_once_models_long_jump_negative_cliques';
    roc_params.esvm_name = 'ESVM-alexnet-fc7-zscores';
else
    roc_params.detect_params.features_type = 'HOG-like';
    ESVM_DATA_FRACTION_STR = '0.1';
    ROUND_STR = '1';
    roc_params.esvm_models_dir = ['esvm/esvm_models_all_' ESVM_DATA_FRACTION_STR '_round' ROUND_STR];
%     roc_params.esvm_models_dir = 'esvm/esvm_long_jump_test';
    roc_params.esvm_name = 'ESVM-HOG';
end


roc_params.data_info = load(DatasetStructure.getDataInfoPath(roc_params.dataset_path));
if ~isfield(roc_params.data_info, 'dataset_path')
    roc_params.data_info.dataset_path = roc_params.dataset_path;
end

roc_params.should_use_crops_info = 1; % Use crops_info file to get fetch image patches.
if roc_params.should_use_crops_info == 1
    CROPS_INFO_FILEPATH = fullfile(DatasetStructure.getDataDirPath(roc_params.dataset_path), 'crops_global_info.mat');
    roc_params.crops_info = load(CROPS_INFO_FILEPATH);
end

roc_params.labels_filepath = sprintf(['~/workspace/dataset_labeling'...
                                       '/merged_data_19.02.16/labels_%s.mat'], category_name);

roc_params.path_simMatrix = ['~/workspace/OlympicSports/sim/simMatrix_', category_name, '.mat'];

end
