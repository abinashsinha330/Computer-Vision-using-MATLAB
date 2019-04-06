%{
function to align template image in target image using RANSAC algorithm by
learning the affine transformation matrix, ransac_A

It contains two nested functions
1. GetAffineTransformVector(P, Q) gives us the current affine
transformation vector
2. TransformToTarget(curr_A, x1) gives us the transformed points using
current affine transformation matrix
%}
function [A] = AlignImageUsingFeature(x1, x2, ransac_thr, ransac_iter)

    %function to get current affine transformation (vector version)
    function [A_vector] = GetAffineTransformVector(P, Q)
        trans_P = transpose(P);
        %to compute inverse and do subsequent multiplication fast using
        %backlash operator
        A_vector = (trans_P*P)\(trans_P*Q);
    end
    
    %{
    function to get corresponding points in 2nd image using current affine
    transformation matrix, curr_A
    %}
    function [transformedPoints] = TransformToTarget(curr_A, x1)
        transformedPoints = [x1, ones(size(x1,1),1)]*curr_A;
    end
    
    %code below is used to run the RANSAC algorithm
    max_num_inliers = 0;
    num_points = size(x1,1);
    ransac_A = 0;
    N_iter = ransac_iter;
    for i=1 : N_iter
        sampled_idxs = randi(num_points,4,1);
        disp(sampled_idxs);
        %P matrix
        P = [x1(sampled_idxs(1),1) x1(sampled_idxs(1),2) 1 0 0 0;
             0 0 0 x1(sampled_idxs(1),1) x1(sampled_idxs(1),2) 1;
             x1(sampled_idxs(2),1) x1(sampled_idxs(2),2) 1 0 0 0;
             0 0 0 x1(sampled_idxs(2),1) x1(sampled_idxs(2),2) 1;
             x1(sampled_idxs(3),1) x1(sampled_idxs(3),2) 1 0 0 0;
             0 0 0 x1(sampled_idxs(3),1) x1(sampled_idxs(3),2) 1];
        %Q matrix
        Q = [x2(sampled_idxs(1),1);
            x2(sampled_idxs(1),2);
            x2(sampled_idxs(2),1);
            x2(sampled_idxs(2),2);
            x2(sampled_idxs(3),1);
            x2(sampled_idxs(3),2);]
        A_vector = GetAffineTransformVector(P, Q);
        %transformed version of current transformation matrix
        curr_A = [A_vector(1) A_vector(4) 0;
                A_vector(2) A_vector(5) 0;
                A_vector(3) A_vector(6) 1]
        transformedPoints = TransformToTarget(curr_A, x1);
        error = sum((transformedPoints(:,1:2) - x2).^2, 2).^0.5;
        inlier_points = (error<ransac_thr).*x1;
        num_inlier_points = nnz(inlier_points(:,1)>0);
        if num_inlier_points > max_num_inliers
            max_num_inliers = num_inlier_points;
            e = (1-num_inlier_points/num_points);
            N_iter = round(log10(1-0.95)/log10(1-(1-e)^3));
            ransac_A = curr_A;
        end
    end
    A = transpose(ransac_A);
end