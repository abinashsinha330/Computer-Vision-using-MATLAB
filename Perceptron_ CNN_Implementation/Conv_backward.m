%{
function to implement chaining rule in order to derive derivates of loss
with respect to weight and bias
%}
function [dLdw, dLdb] = Conv_backward(dLdy, x, w_conv, b_conv, y)
    
    stride = 1;
    [~, ~, C1]= size(x);
    [~, f, ~, ~] = size(w_conv);
    [H, W, C2] = size(dLdy);                   
    dLdw = zeros(size(w_conv));
    dLdb = zeros(size(b_conv));
    
    % one side padding value, p in order to produce output of same size
    p = (f - 1)/2;
    % padded input image to CNN
    padded_x = zeros(H + 2*p, W + 2*p, C1);
    
    for h = 1 : H % loop along height of output
        for w = 1 : W % loop along width of output
            for c = 1 : C2 % loop along channels of output
                % corners of current "slice" from input
                vert_start = (h-1)*stride + 1;
                vert_end = vert_start + f - 1;
                horiz_start = (w-1)*stride + 1;
                horiz_end = horiz_start + f - 1;
                    
                % using corners to define the (3D) slice of x
                x_slice = padded_x(vert_start:vert_end, horiz_start:horiz_end, :);

                % Update gradients for the window and the filter's parameters using the code formulas given above
                dLdw(:,:,:,c) = dLdw(:,:,:,c) + (x_slice * dLdy(h, w, c));
                dLdb(c) = dLdb(c) + dLdy(h, w, c);
            end
        end
    end
    
end