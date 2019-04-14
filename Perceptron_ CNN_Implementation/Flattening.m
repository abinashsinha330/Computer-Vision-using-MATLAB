%{
function to perform flattening of the tensor to get a column vector using
column major traversal
%}
function [y] = Flattening(x)
    y = x(:);