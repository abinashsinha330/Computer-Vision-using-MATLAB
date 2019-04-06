%{
function to get filters responsible for differentiating image along x and y
%}
function [filter_x, filter_y] = GetDifferentialFilter()

%filter_x and filter_y
filter_x = [1 0 -1; 1 0 -1; 1 0 -1];
filter_y = [1 1 1; 0 0 0; -1 -1 -1];