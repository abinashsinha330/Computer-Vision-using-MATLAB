%{
function to get mini batches of images to be used for training for mini-batch
gradient descent
1. first shuffle the images
2. then iterate in batches of batch_size to get the mini-batches of data
%}
function [mini_batch_x, mini_batch_y] = GetMiniBatch(im_train,...
    label_train, batch_size)
    
    num_train = size(im_train, 2);
    num_batches = ceil(num_train/batch_size);
    mini_batch_x = cell(num_batches, 1);
    mini_batch_y = cell(num_batches, 1);
    one_hot_label_train = bsxfun(@eq, label_train(:), 0:9)';
    % concatenate im_train and label_train by adding a row to im_train
    train_data = cat(1, im_train, one_hot_label_train);
    % randomly shuffle the training data
    shuffled_train_data = train_data(:, randperm(size(im_train, 2)));
    for i = 1 : num_batches-1
        batch_data = shuffled_train_data(:, (i-1)*batch_size+1:i*batch_size);
        mini_batch_x{i} = batch_data(1:196, :);
        mini_batch_y{i} = batch_data(197:207, :);
    end
    
    % get remaining data as the last batch
    batch_data = shuffled_train_data(:, (num_batches-1)*batch_size+1: num_train);
    mini_batch_x{num_batches} = batch_data(1:196, :);
    mini_batch_y{num_batches} = batch_data(197:207, :);