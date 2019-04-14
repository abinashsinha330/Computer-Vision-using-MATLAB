%{
function to calculate cross-entropy softmax loss which is used when
dealing with multi-class classficiation problem

Input: x is input to softmax function and y is the ground truth label
Output: L is softmax loss evaluated and dLdy is derivate of loss wrt x
%}
function [L, dLdy] = Loss_cross_entropy_softmax(x, y)

    softmax_y = exp(x)/sum(exp(x));
    L = sum(y.*log(softmax_y));
    num_units = size(x, 1);
    dLdy = zeros(num_units, num_units);
    for i = 1 : num_units
        for j = 1 : num_units
            if i == j
                dLdy(i, j) = softmax_y(i) * (1 - softmax_y(i));
            else
                dLdy(i, j) = -softmax_y(i) * softmax_y(j);
            end
        end
    end