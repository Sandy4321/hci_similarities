addpath(genpath('~/workspace/similarities'));
dataset_path = '~/workspace/OlympicSports';

ESVM_MODELS_DIR = '~/workspace/OlympicSports/esvm_models_untrained_data';
if exist(ESVM_MODELS_DIR, 'dir')
    prompt = sprintf('Do you want to delete existing folder %s? yes/N [N]: ', ESVM_MODELS_DIR);
    str = input(prompt,'s');
    if strcmp(str, 'yes')
        rmdir(ESVM_MODELS_DIR, 's');
        fprintf('Deleted %s.\n', ESVM_MODELS_DIR);
    end
end

if ~exist('dataset', 'var')
    tic;
    fprintf('Reading dataset file...\n');
%     CROPS_ARRAY_FILEPATH = fullfile(DatasetStructure.getDataDirPath(dataset_path), 'crops_227x227.mat');
    CROPS_ARRAY_FILEPATH = fullfile(DatasetStructure.getDataDirPath(dataset_path), 'crops_global_info.mat');
    dataset = load(CROPS_ARRAY_FILEPATH);
    toc
end

if ~exist('data_info', 'var')
    data_info = load(DatasetStructure.getDataInfoPath(dataset_path));
end

RUN_TEST = 0;

fprintf('Starting parpool...\n');
c = parcluster('local');
c.NumWorkers = 12;
if (~strcmp(version('-release'), '2014b'))
    matlabpool(c, c.NumWorkers);
else
    parpool(c, c.NumWorkers);
end

labels_dir_path = '~/workspace/dataset_labeling/untrained_data';
anchor_global_ids = get_all_labeled_global_anchor_ids(labels_dir_path);

parfor i = 1:length(anchor_global_ids)
    frame_id = anchor_global_ids(i);
    output_dir = fullfile(ESVM_MODELS_DIR, sprintf('%06d', frame_id));
    if (exist(output_dir, 'dir'))
        continue;
    end

    sim_esvm_train(frame_id, dataset, data_info, output_dir, RUN_TEST);
end
