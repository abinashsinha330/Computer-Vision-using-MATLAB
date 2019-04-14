%{
function to calculate derivate of 
%}
function [dLdx] = ReLu_backward(dLdy, x, y)
    dLdx = dLdy.*(y >= 0);