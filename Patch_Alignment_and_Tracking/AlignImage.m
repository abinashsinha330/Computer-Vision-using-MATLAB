%{
function to use inverse compositional image alignment for next image using
learnt affine tranformation matrix from above
%}
function [A_refined] = AlignImage(template, target, A)
    [Ix, Iy] = imgradientxy(template);
    H = zeros(6,6);
    delta_p_val = intmax;
    error = [];
    for i = 1 : size(template, 1)
        for j = 1 : size(template, 2)
            temp_ij = [Ix(i,j) Iy(i,j)] * [j i 1 0 0 0;...
                                           0 0 0 j i 1];
            H = H + (transpose(temp_ij)*temp_ij);
        end
    end
    while delta_p_val > 0.005
        I_tar_warped = WarpImage(target, A, size(template));
        I_err = I_tar_warped - template;
        error = [error; norm(double(I_err),'fro')];
        F = zeros(6,1);
        for i = 1 : size(template, 1)
            for j = 1 : size(template, 2)
                temp_ij = [Ix(i,j) Iy(i,j)] * [j i 1 0 0 0;...
                                           0 0 0 j i 1];
                F = F + (double(transpose(temp_ij)) * double([I_err(i,j)]));
            end
        end
        delta_p = H\F;
        A_delta_p = [delta_p(1)+1 delta_p(2) delta_p(3);...
             delta_p(4) delta_p(5)+1 delta_p(6);...
             0 0 1];
        A = A/A_delta_p;
        delta_p_val = norm(delta_p);
    end
    figure
    plot(error);
    title('Error curve')
    xlabel('Iteration')
    ylabel('Error (||I_tar_warped - template||)')
    A_refined = A;
end