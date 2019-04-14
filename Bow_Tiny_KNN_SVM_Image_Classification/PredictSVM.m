%{
function to predict label of an observation using SVM algorithm
%}
function [label_test_pred] = PredictSVM(feature_train, label_train, feature_test)

    weights = [];
    bias = [];
    classes = unique(label_train);
    num_classes = size(classes, 1);
    lambda = 0.00001;
    max_iter = 100/lambda;
    for i=1:num_classes
        label_class = ones(size(label_train,1),1)*-1;
        label_class(label_train==classes(i, 1)) = 1;
        [w, b] = vl_svmtrain(feature_train', label_class, lambda,...
            'MaxNumIterations', max_iter, 'Loss', 'HINGE2');
        weights = cat(1, weights, w');
        bias = cat(1, bias, b);
    end
    num_test_examples = size(feature_test,1);
    score = weights*feature_test' + repmat(bias,1,num_test_examples);
    [~, index] = max(score, [], 1);
    index = classes(index);
    label_test_pred = index;
end