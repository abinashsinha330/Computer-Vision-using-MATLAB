%{
function to unflatten the derivatives calculated with respect output of
flattening layer
%}
function [dLdx] = Flattening_backward(dLdy, x, y)
    assert(size(y) == size(dLdy));
    
    dLdx = reshape(dLdy, size(x));