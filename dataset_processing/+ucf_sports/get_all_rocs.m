function [ result ] = get_all_rocs()
%GET_ALL_ROCS Summary of this function goes here
%   Detailed explanation goes here
dataset_path = '~/workspace/ucf_sports';
data_info = load(DatasetStructure.getDataInfoPath(dataset_path));



for i = 1:length(data_info.categoryNames)
    fprintf('->Category %s...\n', data_info.categoryNames{i});
    cat_result = ucf_sports.get_roc(dataset_path, data_info.categoryNames{i});
    result(i).category_name = data_info.categoryNames{i};
    result(i).models = cat_result;
end



end

