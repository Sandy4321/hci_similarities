function [ imageFullPath ] = getImagePath( frameId, dataset_path, sequencesFilePathes, sequencesLookupTable )
%Returns full path to the image

    CROPS_PATHS = fullfile(dataset_path,...
                           DatasetStructure.CROPS_DIR);

    [fileIndex, newImageIndex] = getSequenceIndex(frameId, sequencesLookupTable);
    sequenceInfoFile = matfile(sequencesFilePathes{fileIndex});
    imageInfo = sequenceInfoFile.hog(1, newImageIndex);
    imageFullPath = fullfile(CROPS_PATHS, imageInfo.cname,... 
                                          imageInfo.vname,...
                                          imageInfo.fname);

end

