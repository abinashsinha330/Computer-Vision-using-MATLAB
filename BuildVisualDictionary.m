%{
function to build dictionary of means of configured number of clusters
%}
function [vocab] = BuildVisualDictionary(training_image_cell, dic_size)

    features = [];
    for i=1:size(training_image_cell, 1)
        img = training_image_cell{i};
        img = single(img);
        [~, d] = vl_dsift(img, 'fast', 'size', 20, 'step', 10);
        features = cat(2, features, d);
    end
    features = double(features');
    [~, vocab] = kmeans(features, dic_size, 'MaxIter', 400);
end