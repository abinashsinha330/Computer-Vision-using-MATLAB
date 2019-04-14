%{
function to perform backpropagation across max-pooling layer
%}
function [dLdx] = Pool2x2_backward(dLdy, x, y)
    [H, W, C] = size(dLdy);
    assert(size(dLdy) == size(y));
    dLdx = zeros([H, W, C]);
    for h = 1 : H
        for w = 1 : W
            for c = 1 : C
                % corners of current "slice" from input
                vert_start = (h-1)*stride + 1;
                vert_end = vert_start + f - 1;
                horiz_start = (w-1)*stride + 1;
                horiz_end = horiz_start + f - 1;
                    
                % using corners to define the (3D) slice of x
                x_slice = x(vert_start:vert_end, horiz_start:horiz_end, c);
                x_slice_iden = (x_slice == max(x_slice, [], 'all'));
                % convolve (3D) slice with correct filter w_conv and bias b_conv
                % to get output of corresponding pixel in output
                dLdx(vert_start:vert_end, horiz_start:horiz_end, c) = ...
                    dLdx(vert_start:vert_end, horiz_start:horiz_end, c) + ...
                        (x_slice_iden * dLdy(h, w, c));
            end
        end
    end
    
end    