function [] = sim_esvm_train_all_categories()

dataset_path = '~/workspace/OlympicSports';
data_info = load(DatasetStructure.getDataInfoPath(dataset_path));
ESVM_NUMBER_OF_WORKERS = 1;

scores = {};
file_to_save = fullfile(dataset_path, 'esvm/results/standard_esvm_all_categories_scores.mat');

for i = 1:length(data_info.categoryNames)
    category_name = data_info.categoryNames{i};
    
    fprintf('=====Training ESVM for %s=====\n', category_name);
    models_path = sim_esvm.scripts.run(dataset_path, category_name, ESVM_NUMBER_OF_WORKERS);
    
    result = ucf_sports.get_roc(dataset_path, category_name);
%     roc_params = get_roc_params(category_name, models_path);
%     [results] = sim_esvm_get_roc(category_name, roc_params);
%     scores{i}.esvm_auc = results(1).auc;
%     scores{i}.category_name = category_name;
%     scores{i}.models_path = models_path;
%     
%     save(file_to_save, '-v7.3', 'scores');  
end

    


end