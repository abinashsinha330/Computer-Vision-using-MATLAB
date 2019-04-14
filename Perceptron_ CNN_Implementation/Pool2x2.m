%{
function to do 2 x 2 max-pooling with a stride of 2 on the input given
%}
function [y] = Pool2x2(x)
    stride = 2;
    f = 2;
    [H, W, C] = size(x);
    y = zeros(floor(((H-f)/stride) + 1), floor(((W-f)/stride) + 1), C);
    
    [y_H, y_W, y_C] = size(y);
    
    for h = 1 : y_H
        for w = 1 : y_W
            for c = 1 : y_C
                % corners of current "slice" from input
                vert_start = (h-1)*stride + 1;
                vert_end = vert_start + f - 1;
                horiz_start = (w-1)*stride + 1;
                horiz_end = horiz_start + f - 1;
                    
                % using corners to define the (3D) slice of x
                x_slice = x(vert_start:vert_end, horiz_start:horiz_end, c);
                    
                % convolve (3D) slice with correct filter w_conv and bias b_conv
                % to get output of corresponding pixel in output
                y(h, w, c) = max(x_slice, [], 'all');
            end
        end
    end
    
end