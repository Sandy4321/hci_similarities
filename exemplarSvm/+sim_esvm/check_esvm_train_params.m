function [] = check_esvm_train_params(params)
% Check esvm train params to be valid.

params_required_fields = {'create_data_params', ...
                          'dataset_path', ...
                          'neg_mining_data_fraction', ...
                          'should_run_test', ...
                          'use_cnn_features', ...
                          'use_image_pathes'
                          };
                      
create_data_params_required_fields = {'data_info', ...
                          'crops_global_info', ...
                          'neg_mining_data_fraction', ...
                          'use_cnn_features', ...
                          'create_negatives_policy', ...
                          'dataset_path'
                          };

assert(isstruct(params));
for fieldname = params_required_fields
    assert(isfield(params, fieldname{:}), 'Field %s not found in params!', fieldname{:});
end

assert(params.use_cnn_features == 0 || isfield(params, 'features_path'));

assert(isstruct(params.create_data_params));
for fieldname = create_data_params_required_fields
    assert(isfield(params.create_data_params, fieldname{:}), 'Field %s not found in create_data_params!', fieldname{:});
end

assert(isfield(params.create_data_params, 'use_cnn_features') && ...
    params.create_data_params.use_cnn_features == params.use_cnn_features);

assert(strcmp(params.create_data_params.create_negatives_policy, 'negative_cliques') || ...
       strcmp(params.create_data_params.create_negatives_policy, 'random_from_other_categories'));

if strcmp(params.create_data_params.create_negatives_policy, 'negative_cliques')
    assert(isfield(params.create_data_params, 'cliques_data'));
end
   

if params.use_cnn_features
    assert(isfield(params.create_data_params, 'features_data'));
    assert(isfield(params.create_data_params.features_data, 'features'));
    assert(isfield(params.create_data_params.features_data, 'features_flip'));
end



end