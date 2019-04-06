%{
function returning filtered image using input filter
%}
function [im_f] = FilterImage(im, filter)

% % filtered image initialization
% im_f = zeros(size(im));
% center_k = floor(size(filter,1)/2)+1;
% center_l = floor(size(filter,2)/2)+1;
% for i = 1 : size(im,1)
%     for j = 1 : size(im,2)
%         v = 0;
%         for k = 1 : size(filter,1)
%             for l = 1 : size(filter,2)
%                 i1 = i + k - center_k;
%                 j1 = j + l - center_l;
%                 if i1 <= 0 || i1 > size(im_f,1) || j1 <= 0 || j1 > size(im_f,2)
%                     continue;
%                 end
%                 v = v + im(i1,j1)*filter(k,l);
%             end
%         end
%         im_f(i,j) = v;
%     end
% end
[m,n]=size(im);
paddedImage=zeros(m+2, n+2);
for i=1: m
    for j=1:n
        paddedImage(i+1,j+1)=im(i,j);
    end
end

[padded_m, padded_n]=size(paddedImage);
im_f=zeros(m,n);

for i=2:padded_m-1
    for j=2:padded_n-1
        im_f(i-1,j-1)=sum(sum(filter.*paddedImage(i-1:i+1,j-1:j+1)));
    end
end