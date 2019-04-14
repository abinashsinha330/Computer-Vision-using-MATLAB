%{
function to extract the bag of words feature for each of the training
images
%}
function [bow_feature] = ComputeBoW(feature, vocab)

    bow_feature = zeros(size(vocab, 1), 1);
    for i=1:size(feature,1)
        idx = knnsearch(vocab, feature(i,:),'K',1);
        %increment count of word representing the cluster
        bow_feature(idx) = bow_feature(idx) + 1;
    end
    bow_feature = bow_feature / norm(double(bow_feature));