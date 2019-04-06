function ori_histo_normalized = GetBlockDescriptor(ori_histo, block_size)

M_new = size(ori_histo,1) - block_size + 1;
N_new = size(ori_histo,2) - block_size + 1;

ori_histo_normalized = zeros([M_new N_new 6*block_size*block_size]);
for m = 1 : M_new
    for n = 1 : N_new
        
        block_feature=[];
        y = m : m+block_size-1;
        x = n : n+block_size-1;
        ori_histo_block = ori_histo(y,x,:);
        for i = 1 : block_size
            for j = 1 : block_size
                for k = 1 : 6
                    block_feature = cat(2, block_feature, ori_histo_block(i,j,k));
                end
            end
        end
        block_feature=block_feature/sqrt(norm(block_feature)^2+0.001^2);
        ori_histo_normalized(m, n, :) = block_feature;
    end
end
% disp(size(ori_histo_normalized))