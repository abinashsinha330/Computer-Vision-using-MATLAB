%{
function to emulate chain rule for getting derivates of loss with all
training variables involved and the input too
%}
function [dLdx, dLdw, dLdb] = FC_backward(dLdy, x, w, b, y)
    % matrix of size 1 x m
    dLdx = dLdy * w;
    % matrx of size n x m
    dLdw = x * dLdy;
    % matrix of size 1 x n
    dLdb = dLdy;