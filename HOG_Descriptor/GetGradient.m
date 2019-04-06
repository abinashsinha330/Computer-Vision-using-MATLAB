function [grad_mag, grad_angle] = GetGradient(im_dx, im_dy)

grad_mag = sqrt(im_dx.^2 + im_dy.^2);
grad_angle = atan2d(im_dy, im_dx);
grad_angle(grad_angle < 0) = grad_angle(grad_angle < 0) + 180;
grad_angle(grad_angle == 180) = 0;
end