function [ parameters ] = runFlann_all()
%TESTFLANN Summary of this function goes here
%   Detailed explanation goes here

fprintf('loading hog in memory...\n');
load('~/workspace/similarities/hogForFlann/hogForFlann_all.mat', 'hogVectors');

parameters = runFlann(hogVectors, 'all');

end

