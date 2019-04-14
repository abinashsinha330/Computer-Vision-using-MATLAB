%{
function to apply ReLu activation on the input fed where:
Relu(x) = max(0, x)
It is a way to bring non-linearity in the neural network otherwise just
simple linear transformation would not be able to capture under non-linear
characteristics involved in the dataset
Optional: We can also use Leaky ReLu to avoid vanishing gradient problem
when the value is towards the nega
%}
function [y] = ReLu(x)
    y = max(0, x);