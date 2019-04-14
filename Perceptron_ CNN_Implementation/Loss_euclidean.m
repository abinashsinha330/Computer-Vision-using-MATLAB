%{
function to calculate Euclidean loss or squared error
%}
function [L, dLdy] = Loss_euclidean(y_tilde, y)
    L = norm(y - y_tilde)^2;
    dLdy = -2*transpose(y - y_tilde);