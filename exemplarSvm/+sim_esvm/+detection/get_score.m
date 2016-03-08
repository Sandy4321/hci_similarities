function [score] = get_score( I, model, detect_params )
% Apply ESVM to the image and get score

assert(length(model) == 1);

if (~exist('detect_params', 'var'))
    detect_params = sim_esvm.get_default_params;
end
%Maximum #windows per exemplar (per image) to keep
detect_params.detect_max_windows_per_exemplar = 1;
%Turn on image flips for detection/training. If enabled, processing
%happes on each image as well as its left-right flipped version.
detect_params.detect_add_flip = 0; % No flipping
detect_params.detect_pyramid_padding = 0; % size of the window shifting
detect_params.detect_keep_threshold = -1e9; % keep all detections

if strcmp(detect_params.features_type, 'HOG-like')
    fprintf('Detection padding: %d\n', detect_params.detect_pyramid_padding);
else
    fprintf('Plain features.\n');
end

if strcmp(detect_params.features_type, 'HOG-like') && detect_params.should_load_features_from_disk == 0
    assert(isnumeric(I), 'I is not an image!');
    assert(size(I, 3) == 3, 'I is not a 3-channel Image!');
    
    I = im2double(I); % because ESVM lib deals with double images
else
    I = convert_to_image_struct(I, detect_params);
end

[resstruct, ~] = esvm_detect(I, model, detect_params);
score = max(resstruct.bbs{1}(:, 12));

end

