function [ roc_params ] = get_roc_params(category_name, models_path)
%GET_ROC_PARAMS Get deafult params for ROC plotting.

roc_params.dataset_path = '~/workspace/OlympicSports';
roc_params.plots_dir = 'plots';

    '~/workspace/OlympicSports/data/features_hog_pedro_227x227.mat';
roc_params.use_plain_features = 1;% ESVM Uses CNN features or HOG.
roc_params.features_path = ... % used only if use_plain_features = 1
roc_params.esvm_crops_dir_name = 'crops_227x227';

roc_params.use_models_with_top_hardest_negatives_removed = 0;

% Load features into memory
if roc_params.use_plain_features
    tic;
    fprintf('Reading CNN features file... %s\n', roc_params.features_path);
    assert(exist(roc_params.features_path, 'file') ~= 0, ...
                'File %s is not found', roc_params.features_path);
    roc_params.features_data = load(roc_params.features_path, 'features', 'features_flip');
    toc
end

roc_params.detect_params = sim_esvm.get_default_params;
if roc_params.use_plain_features
    roc_params.detect_params.features_type = 'FeatureVector';
    if exist('models_path', 'var')
        roc_params.esvm_models_dir = models_path;
    else
        roc_params.esvm_models_dir = fullfile(roc_params.dataset_path, ...
            'esvm/hog_pedro_initialization_esvm_model');
    end
    roc_params.esvm_name = 'ESVM-HOG-pedro-init';
else
    roc_params.detect_params.features_type = 'HOG-like';
    if exist('models_path', 'var')
        roc_params.esvm_models_dir = models_path;
    else
        ESVM_DATA_FRACTION_STR = '0.1';
        ROUND_STR = '1';
        roc_params.esvm_models_dir = ['esvm/esvm_models_all_' ESVM_DATA_FRACTION_STR '_round' ROUND_STR];
    %     roc_params.esvm_models_dir = 'esvm/esvm_long_jump_test';
        roc_params.esvm_models_dir = fullfile(roc_params.dataset_path, roc_params.esvm_models_dir);
    end
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

% roc_params.path_simMatrix = ['~/workspace/OlympicSports/sim/simMatrix_', category_name, '.mat'];
roc_params.path_simMatrix = ['~/workspace/OlympicSports/sim_pedro_hog/sim_max_hog_pedro_', category_name, '.mat'];

end
