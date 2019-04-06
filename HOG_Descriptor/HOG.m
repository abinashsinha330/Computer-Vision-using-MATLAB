function [hog] = HOG(im)
figure(1), imshow(im);
cell_size = 8;
block_size = 2;
im_converted = im2double(im);
%{
function to get filters responsible for differentiating image along x and y
%}
[diff_filter_x, diff_filter_y] = GetDifferentialFilter();
%{
function returning differentiating image along x
%}
im_dx = FilterImage(im_converted, diff_filter_x);
figure(2);
imagesc(im_dx);
%{
function returning differentiating image along y
%}
im_dy = FilterImage(im_converted, diff_filter_y);
figure(3);
imagesc(im_dy);
%{
function returning gradient magnitudes and gradient anagles at each pixel
of image
%}
[grad_mag, grad_angle] = GetGradient(im_dx, im_dy);
figure(4), imagesc(grad_mag);
figure(5), imagesc(grad_angle);

[m,n,p]=size(im);
[x,y]=meshgrid(1:2:n,1:2:m);


figure; imshow(im_converted); hold on
q=quiver(x,y,im_dx(1:2:m,1:2:n),im_dy(1:2:m,1:2:n));
q.AutoScaleFactor = 3;
q.ShowArrowHead = 'off';
q.Color='r';
q.LineWidth=2;
%{
function returning histogram having 6 bins where non-overlapping 
cell_size x cell_size patches are considered and value of each bin is sum
of gradient magnitudes
%}
ori_histo = BuildHistogram(grad_mag, grad_angle, cell_size);
%{
function returning normalized histogram using overlapping 
block_size*block_size cells with stride of 1 (therefore 
block_size*block_size*6 histogram bins are used for normalization)
%}
ori_histo_normalized = GetBlockDescriptor(ori_histo, block_size);

%Visualize HOG in the form of dominant edges
[M,N,P]=size(ori_histo);
[x,y]=meshgrid(floor(cell_size/2):cell_size:N*cell_size,floor(cell_size/2):cell_size:M*cell_size);
var = ori_histo;
figure;
imshow(im);

hold on;

var = var*2;

phase = -90;
px = var(:,:,1)*cosd(phase+0);py = var(:,:,1)*sind(phase+0);
q=quiver(x,y,px,py);
q.Color='r';
q.LineWidth=2;
q.ShowArrowHead = 'off';
q=quiver(x,y,-px,-py);
q.Color='r';
q.LineWidth=2;
q.ShowArrowHead = 'off';


px = var(:,:,2)*cosd(phase+30);py = var(:,:,2)*sind(phase+30);
q=quiver(x,y,px,py);
q.Color='r';
q.LineWidth=2;
q.ShowArrowHead = 'off';
q=quiver(x,y,-px,-py);
q.Color='r';
q.LineWidth=2;
q.ShowArrowHead = 'off';

px = var(:,:,3)*cosd(phase+60);py = var(:,:,3)*sind(phase+60);
q=quiver(x,y,px,py);
q.Color='r';
q.LineWidth=2;
q.ShowArrowHead = 'off';
q=quiver(x,y,-px,-py);
q.Color='r';
q.LineWidth=2;
q.ShowArrowHead = 'off';

px = var(:,:,4)*cosd(phase+90);py = var(:,:,4)*sind(phase+90);
q=quiver(x,y,px,py);
q.Color='r';
q.LineWidth=2;
q.ShowArrowHead = 'off';
q=quiver(x,y,-px,-py);
q.Color='r';
q.LineWidth=2;
q.ShowArrowHead = 'off';

px = var(:,:,5)*cosd(phase+120);py = var(:,:,5)*sind(phase+120);
q=quiver(x,y,px,py);
q.Color='r';
q.LineWidth=2;
q.ShowArrowHead = 'off';
q=quiver(x,y,-px,-py);
q.Color='r';
q.LineWidth=2;
q.ShowArrowHead = 'off';

px = var(:,:,6)*cosd(phase+150);py = var(:,:,6)*sind(phase+150);
q=quiver(x,y,px,py);
q.Color='r';
q.LineWidth=2;
q.ShowArrowHead = 'off';
q=quiver(x,y,-px,-py);
q.Color='r';
q.LineWidth=2;
q.ShowArrowHead = 'off';


hog = [];
for i=1 : size(ori_histo_normalized, 1)
    for j=1 : size(ori_histo_normalized, 2)
        for k =1 : size(ori_histo_normalized, 3)
            hog = cat(1, hog, ori_histo_normalized(i,j,k));
        end
    end
end