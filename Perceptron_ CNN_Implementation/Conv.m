%{
function to implement convolution on an image using C2 number of filters;
size of image is H x W x C1 where C1 is number of channels of image;
size of filter is f x f x C1 for each of C1 channels and there are C2
filters in total; usually a filter is odd sized and are square shaped;
by default the stride is 1 when performing convolution and stride = 2 for
max-pooling layer;

This is a multi-channel input and the output after performing convolution
is multi-channel output
%}
function [y] = Conv(x, w_conv, b_conv)
    
    stride = 1;
    [H, W, C1]= size(x);
    [~, f, f_C1, C2] = size(w_conv);
    % one side padding value, p in order to produce output of same size
    p = (f - 1)/2;
    % padded input image to CNN
    padded_x = zeros(H + 2*p, W + 2*p, C1);
    % output is of size H x W x C2
    y = zeros(H, W, C2);

    for h = 1 : H
        for w = 1 : W
            for c = 1 : C2
                % corners of current "slice" from input
                vert_start = (h-1)*stride + 1;
                vert_end = vert_start + f - 1;
                horiz_start = (w-1)*stride + 1;
                horiz_end = horiz_start + f - 1;
                    
                % using corners to define the (3D) slice of x
                x_slice = padded_x(vert_start:vert_end, horiz_start:horiz_end, :);
                    
                % convolve (3D) slice with correct filter w_conv and bias b_conv
                % to get output of corresponding pixel in output
                y(h, w, c) = sum(sum(x_slice.*w_conv(:, :, :, c), 3), 'all') + b_conv(c);
            end
        end
    end
    
    assert(f_C1 == C1); % number of channels in image should be equal # of channels in each filter
    
end