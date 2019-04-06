%{
function to classify image by running KNN on bag of word (BoW) representations of
images
%}
function [confusion, accuracy] = ClassifyKNN_BoW
    clc;
    clear;
    close all;
    train_fileID = fopen('train.txt','r');
    train_data = textscan(train_fileID, '%s %s');
    % get labels of training data
    label_train = string(train_data{1});
    path_train = train_data{2};
    num_train_data = size(label_train, 1);
    test_fileID = fopen('test.txt','r');
    test_data = textscan(test_fileID, '%s %s');
    % get labels of test data
    label_test = string(test_data{1});
    path_test = test_data{2};
    num_test_data = size(label_test, 1);
    
    % make a set of training images
    img_data = './checkpoints/imageData.mat';
    if isfile(img_data)
        load(img_data, 'training_image_cell');
        load(img_data, 'test_image_cell');
    else
        % make a set of training images
        training_image_cell = cell(num_train_data, 1);
        for i = 1 : num_train_data
            img_path = strrep(path_train(i),'\','/');
            I = imread(string(img_path));
            training_image_cell{i} = I;
        end
        % make a set of test images
        test_image_cell = cell(num_test_data, 1);
        for i = 1 : num_train_data
            img_path = strrep(path_test(i),'\','/');
            I = imread(string(img_path));
            test_image_cell{i} = I;
        end
        
        save(img_data, 'training_image_cell', 'test_image_cell');
    end
    
    %get dense SIFT features from training images
    dSIFTFeatures = './checkpoints/denseSIFTFeatures.mat';
    if isfile(dSIFTFeatures)
        load(dSIFTFeatures, 'features_train');
        load(dSIFTFeatures, 'features_test');
    else
        features_train = cell(num_train_data);
        for i = 1 : num_train_data
            I = training_image_cell{i};
            I = single(I);
            [~, d] = vl_dsift(I, 'size', 20, 'step', 10, 'fast');
            features_train{i} = transpose(double(d));
        end
        
        features_test = cell(num_test_data);
        for i = 1 : num_test_data
            I = test_image_cell{i};
            I = single(I);
            [~, d] = vl_dsift(I, 'size', 20, 'step', 10, 'fast');
            features_test{i} = transpose(double(d));
        end
        
        save(dSIFTFeatures, 'features_train', 'features_test');
    end
    
    % build the dictionary / vocabulary of means of dic_size number of
    % clusters of images
    vocab_file = './checkpoints/vocab.mat';
    if isfile(vocab_file)
        load(vocab_file, 'vocab');
    else
        dic_size = 50; % size of dictionary / vocabulary
        vocab = BuildVisualDictionary(training_image_cell, dic_size);
        save(vocab_file, 'vocab');
    end
    
    % derive the Bag of Word vector representing each training image
    boWFeatures = './checkpoints/boWFeatures.mat';
    if isfile(boWFeatures)
        load(boWFeatures, 'bow_features_train');
        load(boWFeatures, 'bow_features_test');
    else
        bow_features_train = zeros(num_train_data, dic_size);
        for i = 1 : num_train_data
            bow_features_train(i, :) = transpose(...
                ComputeBoW(features_train{i}, vocab));
        end
        
        bow_features_test = zeros(num_test_data, dic_size);
        for i = 1 : num_test_data
            bow_features_test(i, :) = transpose(...
                ComputeBoW(features_test{i}, vocab));
        end
        
        save(boWFeatures, 'bow_features_train', 'bow_features_test');
    end
   
    label_test_pred = PredictKNN(bow_features_train, label_train,...
        bow_features_test, 12);
    confusion = confusionmat(categorical(label_test),...
        categorical(label_test_pred));
    confusion = transpose(confusion);
    accuracy = trace(confusion) / sum(confusion, 'all');
    disp(accuracy);
    figure, confusionchart(transpose(confusion));
    figure, imagesc(transpose(confusion));
    figure, plotconfusion(categorical(label_test), categorical(label_test_pred));