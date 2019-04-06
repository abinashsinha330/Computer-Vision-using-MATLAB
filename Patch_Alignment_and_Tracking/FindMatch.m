%{
function to get coordinates of points in images, I1 and I2 which match
each other
%}
function [x1, x2] = FindMatch(I1, I2)
[f1, d1] = vl_sift(single(I1));
[f2, d2] = vl_sift(single(I2));
f1 = transpose(f1);
f2 = transpose(f2);
d1 = transpose(d1);
d2 = transpose(d2);
[IDX, D] = knnsearch(d2, d1, 'Distance', 'euclidean', 'K', 2);
num_keypoints = size(IDX,1);
matched_descriptors_indices = zeros(num_keypoints,1);
count = 1;
for i = 1 : num_keypoints
        if D(i,1) < 0.7*D(i,2) %Lowe's ratio test
            matched_descriptors_indices(i,1) = IDX(i,1);
            count = count + 1;
        end
end

x1 = zeros(count,2);
x2 = zeros(count,2);
j = 1;
for i = 1 : num_keypoints
    if(matched_descriptors_indices(i,1) ~= 0)
        matched_desc_idx = matched_descriptors_indices(i,1);
        p2 = [f2(matched_desc_idx,1), f2(matched_desc_idx,2)];
        p1 = [f1(i,1), f1(i,2)];
        x1(j,1:2) = p1;
        x2(j,1:2) = p2;
        j = j + 1;
    end
end