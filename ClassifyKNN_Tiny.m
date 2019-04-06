%{
function to classify image by running KNN on tiny image representations of
images
%}
function [confusion, accuracy] = ClassifyKNN_Tiny
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
    feature_train = [];
    % create the feature_train
    for i = 1 : num_train_data
        img_path = strrep(path_train(i),'\','/');
        I = imread(string(img_path));
        feature = GetTinyImage(I, [16 16]);
        feature_train = cat(1, feature_train, transpose(feature));
    end
    feature_test = [];
    % create the feature_test
    for i = 1 : num_test_data
        img_path = strrep(path_test(i),'\','/');
        I = imread(string(img_path));
        feature = GetTinyImage(I, [16 16]);
        feature_test = cat(1, feature_test, transpose(feature));
    end
    label_test_pred = PredictKNN(feature_train, label_train,...
        feature_test, 1);
    confusion = confusionmat(categorical(label_test),...
        categorical(label_test_pred));
    confusion = transpose(confusion);
    accuracy = trace(confusion) / sum(confusion, 'all');
    disp(accuracy);
    figure, confusionchart(transpose(confusion));
    figure, imagesc(transpose(confusion));
    figure, plotconfusion(categorical(label_test), categorical(label_test_pred));