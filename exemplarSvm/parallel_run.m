sim_esvm_init;


previously_trained = load(fullfile(dataset_path, 'esvm/esvm_models_all_0.1_round1.mat'));

% labels_dir_path = '~/workspace/dataset_labeling/labels_to_train';
% [anchor_global_ids, flipvals] = get_all_labeled_global_anchor_ids(labels_dir_path);

CLIQUES_FILE_PATH = fullfile(dataset_path, 'exemplar_cnn/multiclass_svm_test/data/100_30_cliques_long_jump.mat');
CATEGORY_NAME = 'long_jump';
[anchor_global_ids, anchor_flipvals] = get_global_anchors_from_cliques_file(data_info, CATEGORY_NAME, CLIQUES_FILE_PATH);
anchor_global_ids = anchor_global_ids(1:end);
anchor_flipvals = anchor_flipvals(1:end);

sim_esvm_run_parfor_training;

