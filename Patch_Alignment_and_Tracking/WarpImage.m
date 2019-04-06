%{
function to warp image using affin transformation matrix learnt using
RANSAC algorithm above
%}
function [I_warped] = WarpImage(I, A, output_size)

    [m,n]=size(A);
    if ((m ~= 3) || (n ~= 3))
        error('Invalid input transformation');
    end
    I_warped = zeros(output_size);
    for i=1 : output_size(1)
        for j=1 : output_size(2)
            template_coordinates = [j; i; 1];
            target_coordinates = A*double(template_coordinates);
                I_warped(i, j) =...
                    I(floor(target_coordinates(2)),...
                    floor(target_coordinates(1)));
        end  
    end
end