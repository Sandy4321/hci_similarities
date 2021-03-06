function [] = run_parallel_training(anchor_global_ids, anchor_flipvals, ...
                                                  previously_trained, ...
                                                  esvm_train_params, ...
                                                  ESVM_MODELS_DIR, ESVM_NUMBER_OF_WORKERS )
%RUN_PARALLEL_TRAINING

if (strcmp(version('-release'), '2012a') || strcmp(version('-release'), '2013a'))
    fprintf('Probably matlab 2012a and 2013a is non supported\n');
end

p = gcp('nocreate'); % If no pool, then create a new one.
if isempty(p)
    fprintf('Starting parpool with %d workers...\n', ESVM_NUMBER_OF_WORKERS);
    c = parcluster('local');
    c.NumWorkers = ESVM_NUMBER_OF_WORKERS;
    
    if (~strcmp(version('-release'), '2014b'))
        matlabpool(c, c.NumWorkers);
    else
        parpool(c, c.NumWorkers);
    end 
end

parfor i = 1:length(anchor_global_ids)
    frame_id = anchor_global_ids(i);
    fprintf('----Anchor %d\n', frame_id);
    model_name = sprintf('%06d', frame_id);
    if anchor_flipvals(i)
        model_name = [model_name '_flipped'];
    end
    
    output_dir = fullfile(ESVM_MODELS_DIR, model_name);
    
    has_final_model_file = ~isempty(getFilesInDir([output_dir, '/models'], '.*-svm\.mat')) || ...
                           ~isempty(getFilesInDir(output_dir, '.*-svm\.mat'));
    
    if (has_final_model_file || ...
         any(find(ismember(previously_trained.trained_model_names, model_name))))
        continue;
    elseif exist(output_dir, 'dir') && ~has_final_model_file
        rmdir(output_dir, 's');
    end
    
%     model_file = load(fullfile(ESVM_MODELS_DIR_PREVIOUS_ROUND, ...
%         sprintf('%06d', frame_id), 'models', sprintf('%06d-svm.mat', frame_id)));
% 
%     sim_esvm.train(frame_id, dataset, data_info, output_dir, esvm_train_params, model_file.models);
    assert(anchor_flipvals(i) == 0);
    sim_esvm.train(frame_id, anchor_flipvals(i), output_dir, esvm_train_params);
end

end

