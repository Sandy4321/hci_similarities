addpath(genpath('/net/hciserver03/storage/asanakoy/workspace/similarities'));
dataset_path = '/net/hciserver03/storage/asanakoy/workspace/OlympicSports';

ESVM_MODELS_DIR = '/net/hciserver03/storage/asanakoy/workspace/OlympicSports/esvm_models';
if exist(ESVM_MODELS_DIR, 'dir')
    rmdir(ESVM_MODELS_DIR, 's');
end

if ~exist('dataset', 'var')
    tic;
    fprintf('Reading dataset file...\n');
    CROPS_ARRAY_FILEPATH = fullfile(DatasetStructure.getDataDirPath(dataset_path), 'crops_227x227.mat');
    dataset = load(CROPS_ARRAY_FILEPATH);
    toc
end

if ~exist('data_info', 'var')
    data_info = load(DatasetStructure.getDataInfoPath(dataset_path));
end

RUN_TEST = 0;

if ~exist('labeled_data', 'var')
    labeled_data = load('/net/hciserver03/storage/asanakoy/workspace/dataset_labeling/merged_data/long_jump_21.10.mat');
end

for i = 1:length(labeled_data.labels)
    sim_esvm_train(labeled_data.category_offset + labeled_data.labels(i).anchor, dataset, data_info, ESVM_MODELS_DIR, RUN_TEST);
end
