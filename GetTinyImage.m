function [feature] = GetTinyImage(I, output_size)
    tiny_I = imresize(I, output_size);
    feature = double(tiny_I(:));
    feature = feature / norm(feature);