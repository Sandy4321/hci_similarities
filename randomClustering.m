function [ cliques ] = randomClustering()
%create random clustering

load simMatrix_basketball_layup.mat;
PATH_TO_DATA = '/net/hciserver03/storage/mbautist/Desktop/mbautista/Exemplar_CNN/crops/basketball_layup/';
imagesSeqNames = image_names(:,3:25);
seqNames = unique (imagesSeqNames,'rows');
nSequences = size(seqNames, 1);
frameSeqId = zeros(size(imagesSeqNames,1), 1); % frameSeqId(i) - id of the sequence  frame {i} belongs to
for i = 1:size(imagesSeqNames,1)
    frameSeqId(i,1) = find(ismember(seqNames, imagesSeqNames(i,:), 'rows'));
end

framesBySequences = cell(nSequences, 1); % seqFrames{i} = set of indices of frames that belong to i-th sequence
for i = 1:nSequences
    framesBySequences{i} = find(ismember(imagesSeqNames, seqNames(i,:), 'rows'))';
end

nFrames = size(simMatrix, 1);
nClusters = 2;
nMaxPointsPerCluster = 10;
[clusters, weights] = generateRandomClusters(simMatrix, nFrames, nClusters, nSequences, framesBySequences, nMaxPointsPerCluster);

fprintf('generated %d clusters, max %d images each\n', size(clusters,1), nMaxPointsPerCluster);

for i = 1:size(clusters,1)
    fprintf('cluster %d:  size=%d, weight=%f\n', i, size(clusters{i}, 2), weights(i));
    visualize(PATH_TO_DATA, imagesSeqNames, image_names, clusters{i});
end


end

%==========================================================================
function [clusters, weights] = generateRandomClusters(simMatrix, nFrames, nClusters, nSequences, framesBySequences, nMaxPointsPerCluster)

    nPointsPerCluster = nMaxPointsPerCluster;
    if nFrames < nClusters * nPointsPerCluster
        nPointsPerCluster = nFrames / nClusters;
    end

    sequenceUsed = zeros(nSequences, 1);

    framesPermutation = randperm(nFrames);
    clusters = cell(nClusters, 1);

    weights = zeros(nClusters, 1);
    for i = 1:nClusters
        [clusters{i} framesBySequences]  = createRandomCluster(framesBySequences, nMaxPointsPerCluster);
        weights(i) = computeClusterWeight(simMatrix, clusters{i});
    end

end

%==========================================================================
function [cluster restFrames] = createRandomCluster(framesBySequences, nMaxPoints)
    MAX_POINTS_PER_SEQ = 3;
    MAX_POINTS_PER_SEED_SEQ = 2;

    nSequences = size(framesBySequences,1);
    restFrames = framesBySequences(randperm(nSequences));

    cluster = [];
    iSeq = 1;
    while size(cluster, 2) < nMaxPoints && iSeq <= nSequences 
        currentSequeneSize = size(restFrames{iSeq},2);
        restFrames{iSeq} = restFrames{iSeq}(1, randperm(currentSequeneSize));
        if iSeq > 1
            nPointsToGenerate = ceil(rand * MAX_POINTS_PER_SEQ);
        else
            nPointsToGenerate = ceil(rand * MAX_POINTS_PER_SEED_SEQ);
        end
        nPointsToGenerate = min([nPointsToGenerate currentSequeneSize (nMaxPoints - size(cluster, 2))]);
        cluster = [cluster restFrames{iSeq}(1:nPointsToGenerate)];
        restFrames{iSeq}(1:nPointsToGenerate) = []; % remove used points
        
        iSeq = iSeq + 1;
    end

end

%==========================================================================
function [weight] = computeClusterWeight(simMatrix, cluster)
    weight = 0.0;
    for i = 1:size(cluster, 2)
        for j = (i + 1):size(cluster, 2)
            weight = weight + simMatrix(cluster(1, i), cluster(1, j));
        end
    end
end

%==========================================================================
function visualize(pathsToImages, imagesSeqNames, imageNames, cluster)



    for i = 1:length(cluster)


        frameName = imageNames(cluster(i),3:end);
        fparts = strsplit(frameName,'/');
        frameName = [fparts{1},'/',sprintf('I%05d.png',str2num(fparts{2}(2:6))-1)];


        figure,imshow(fullfile(pathsToImages,frameName));
        title(imagesSeqNames(cluster(i),:),'Interpreter','none')
        pause

    end
end