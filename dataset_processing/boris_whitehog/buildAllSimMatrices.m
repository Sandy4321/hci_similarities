function [] = buildAllSimMatrices( dataset_path )
%Build similatity matrices for each category.
% crops, whitehog must be computed before running this procedure

PAIRWISE_SIM_DIR = 'pairwise_sim_normalized';
SIM_DIR = 'sim_normalized';

fprintf('Building pairwise sim matrices inside each category\n');
pairwise_similarities( DatasetStructure.getWhitehogDirPath(dataset_path),...
                      fullfile(dataset_path, PAIRWISE_SIM_DIR));

categories = getNonEmptySubdirs(fullfile(dataset_path, CROPS_DIR));
for i = 1:length(categories)
    fprintf('Building sim matrix for category %d/%d ...\n', i, length(categories));
    buildSimMatrixFromPairwise(categories{i}, ... 
                                  fullfile(dataset_path, PAIRWISE_SIM_DIR)), ...
                                  fullfile(dataset_path, DatasetStructure.CROPS_DIR),...
                                  fullfile(dataset_path, SIM_DIR);
end

end

