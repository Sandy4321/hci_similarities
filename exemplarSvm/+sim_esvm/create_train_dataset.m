function [ pos_objects, neg_objects ] = create_train_dataset( anchor_ids, anchor_flipvals, params)
%Create train dataset (positives + pool of negatives of other categories)
% Positive objects = achors, defined by anchor_ids
assert(isfield(params, 'positive_category_name'));
assert(isfield(params, 'positive_category_offset'));


pos_objects = sim_esvm.create_dataset(anchor_ids, params, anchor_flipvals);
for i = 1:length(pos_objects)
    if ~strcmp(params.positive_category_name, pos_objects{i}.recs.cname)
        error('Error.\nAll anchors must be from the same category - "%s".\nBut we found - %s!', ...
            params.positive_category_name,  pos_objects{i}.recs.cname);
    end
end

fprintf('Creating negative dataset...\n');
if strcmp(params.create_negatives_policy, 'negative_cliques')
    if length(anchor_ids) > 1
        error('Negative_cliques creating policy cannot be used for batch of anchors. Only one acnhor is allowed.')
    end
    negative_ids = negatives_negative_cliques(anchor_ids(1), params);
else
    negative_ids = negatives_random_from_other_categories(params);
end

neg_objects = sim_esvm.create_dataset(negative_ids, params, false(size(negative_ids)));
fprintf('Done.\n');

end


function [negative_ids] = negatives_negative_cliques(anchor_id, params)
% Take all samples from negative (distant) cliques and use them as negatives.
% Arguments:
%           anchor_id - global id of the positive frame.
%           params - create dataset params
% NOTE: params.cliques_data contains local inter-categorial ids.

    search_index = find(arrayfun(@(x) ...
        x.anchor_id + params.positive_category_offset == anchor_id, ...
        params.cliques_data.cliques, 'UniformOutput', true));
    assety(length(search_index) == 1);
    
    negative_ids = cell2mat(params.cliques_data.cliques(search_index).neg);
    negative_ids = negative_ids(:) + params.positive_category_offset; % convert from local to global ids.
end


function [negative_ids] = negatives_random_from_other_categories(params)
% Random choose N * params.neg_mining_data_fraction samples from other categories as negatives.
    positive_category_id = find(ismember(params.data_info.categoryNames, params.positive_category_name));
    negative_ids = [];
    for i = 1:length(params.data_info.categoryNames)
        if i == positive_category_id
            continue;
        end
        cat_ids = find(params.data_info.categoryLookupTable == i);
        cat_length = length(cat_ids);
        cat_subset_idx = randperm(cat_length, ceil(cat_length * params.neg_mining_data_fraction));
        negative_ids = [negative_ids cat_ids(cat_subset_idx)];
    end
end