%{
function to emulate fully-connected layer (or doing linear transorm of x)
%}
function [y] = FC(x, w, b)
    y = w*x + b;