clc
clear
close all
I1=imread('3_I1.jpg');
I2=imread('3_I2.jpg');
I3=imread('6_I3.jpg');
I4=imread('7_I4.jpg');
I5=imread('7_I5.jpg');
inpIm1=rgb2gray(I1);
inpIm2=rgb2gray(I2);
inpIm3=rgb2gray(I3);
inpIm4=rgb2gray(I4);
inpIm5=rgb2gray(I5);
inpIm3 = imresize(inpIm3, size(inpIm2));
inpIm4 = imresize(inpIm4, size(inpIm2));
inpIm5 = imresize(inpIm5, size(inpIm2));

image_cell=cell(4,1);
image_cell{1}=inpIm2;
image_cell{2}=inpIm3;
image_cell{3}=inpIm4;
image_cell{4}=inpIm5;
% %{
% function to track 4 frames of images or peform multi-frame tracking using
% continuous inverse compositional image alignment
% %}
A_cell = TrackMultiFrames(inpIm1, image_cell);