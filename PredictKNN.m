%{
function to run predict label of an observation using KNN algorithm
%}
function [label_test_pred] = PredictKNN(feature_train, label_train, feature_test, k)

    label_test_pred = [];
    for i=1:size(feature_test,1)
        idx = knnsearch(feature_train, feature_test(i,:),'K',k);
        label = string(mode(categorical(label_train(idx))));
        label_test_pred = cat(1, label_test_pred, label);  %[label_test_pred; label]; 
    end
end