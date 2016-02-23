for i = 1:length(anchor_global_ids)
    frame_id = anchor_global_ids(i);
    fprintf('----Anchor %d\n', frame_id);
    model_name = sprintf('%06d', frame_id);
    if anchor_flipvals(i)
        model_name = [model_name '_flipped'];
    end
    
    output_dir = fullfile(ESVM_MODELS_DIR, model_name);
    
    if (~isempty(getFilesInDir(output_dir, '.*svm-removed_top_hrd\.mat')) || ...
         any(find(ismember(previously_trained.trained_model_names, model_name))))
        continue;
    elseif exist(output_dir, 'dir') && isempty(getFilesInDir(output_dir, '.*svm-removed_top_hrd\.mat'))
        rmdir(output_dir, 's');
    end
    
    sim_esvm_train(frame_id, anchor_flipvals(i), dataset, data_info, output_dir, esvm_train_params);
end