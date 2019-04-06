function ori_histo = BuildHistogram(grad_mag, grad_angle, cell_size)

M = floor(size(grad_mag,1)/cell_size);
N = floor(size(grad_mag,2)/cell_size);
ori_histo = zeros([M N 6]);
for m = 0 : M-1
    for n = 0 : N-1
        mth_cell = cell_size*m;
        nth_cell = cell_size*n;
        y = mth_cell+1 : mth_cell+cell_size;
        x = nth_cell+1 : nth_cell+cell_size;
        grad_mag_cell_xy = grad_mag(y,x);
        grad_angle_cell_xy = grad_angle(y,x);
        for p=1:cell_size
            for q=1:cell_size
                angle= grad_angle_cell_xy(p,q);
                magnitude = grad_mag_cell_xy(p,q);
                if ((angle>=165 && angle<180) || (angle>=0 && angle<15))
                    ori_histo(m+1, n+1, 1)=ori_histo(m+1, n+1, 1)+ magnitude;
                elseif angle>=15 && angle<45
                    ori_histo(m+1, n+1, 2)=ori_histo(m+1, n+1, 2)+ magnitude;
                elseif angle>=45 && angle<75
                    ori_histo(m+1, n+1, 3)=ori_histo(m+1, n+1, 3)+ magnitude;
                elseif angle>=75 && angle<105
                    ori_histo(m+1, n+1, 4)=ori_histo(m+1, n+1, 4)+ magnitude;
                elseif angle>=105 && angle<135
                    ori_histo(m+1, n+1, 5)=ori_histo(m+1, n+1, 5)+ magnitude;
                elseif angle>=135 && angle<165
                    ori_histo(m+1, n+1, 6)=ori_histo(m+1, n+1, 6)+ magnitude;
                end
            end
        end
    end
end