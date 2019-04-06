%{
function to track 4 frames of images or peform multi-frame tracking using
continuous inverse compositional image alignment
%}
function [A_cell] = TrackMultiFrames(template, image_cell)

A_cell = cell(4,1);
num_frames = size(image_cell,1);
[x1, x2] = FindMatch(template, image_cell{1});
% image3 = cat(2,template,image_cell{1});
% figure('Name','FindMatch')
% imshow(image3);
% hold on;
% for i = 1 : size(x1,1)
%     plot([x1(i,1),x2(i,1)+size(template,2)],[x1(i,2),x2(i,2)],'Color','r',...
%         'LineWidth',2);
% end
% hold off;



ransac_iter = 10000;
ransac_thres = 2;
ransac_A = AlignImageUsingFeature(x1, x2, ransac_thres, ransac_iter);



output_size = size(template);
A_refined = ransac_A;
for frame = 1 : num_frames
    
%     trans_u1 = A_refined*[1; 1; 1];
%     trans_u2 = A_refined*[size(template,2); 1; 1];
%     trans_u3 = A_refined*[size(template,2); size(template,1); 1];
%     trans_u4 = A_refined*[1; size(template,1); 1];
%     image3 = cat(2,template,image_cell{frame});
%     figure('Name',strcat('AlignBeforeInverseCompAlignFrame', num2str(frame)))
%     imshow(image3);
%     hold on;
%     plot([trans_u1(1)+size(template,2),trans_u2(1)+size(template,2)],...
%         [trans_u1(2),trans_u2(2)],'Color','y',...
%         'LineWidth',2);
%     plot([trans_u2(1)+size(template,2),trans_u3(1)+size(template,2)],...
%         [trans_u2(2),trans_u3(2)],'Color','y',...
%         'LineWidth',2);
%     plot([trans_u3(1)+size(template,2),trans_u4(1)+size(template,2)],...
%         [trans_u3(2),trans_u4(2)],'Color','y',...
%         'LineWidth',2);
%     plot([trans_u4(1)+size(template,2),trans_u1(1)+size(template,2)],...
%         [trans_u4(2),trans_u1(2)],'Color','y',...
%         'LineWidth',2);
%     if frame == 1
%         for i = 1 : size(x1,1)
%             if x2(i,1)+size(template,2) > trans_u1(1)+size(template,2) &&...
%                     x2(i,1)+size(template,2) < trans_u2(1)+size(template,2) &&...
%                     x2(i,2) < trans_u3(2) && x2(i,2) > trans_u1(2)
%                 plot([x1(i,1),x2(i,1)+size(template,2)],[x1(i,2),x2(i,2)],...
%                     'Color','g','LineWidth',2);
%             else
%                 plot([x1(i,1),x2(i,1)+size(template,2)],[x1(i,2),x2(i,2)],...
%                     'Color','r','LineWidth',2);
%             end
%         end
%     end
%     hold off;
    
    I_warped = WarpImage(image_cell{frame}, A_refined, output_size);
%     figure('Name',strcat('WarpBeforeInverseFrame', num2str(frame)))
%     imshow(uint8(I_warped));
%     figure('Name',strcat('ErrorMapBeforeInverseFrame', num2str(frame)))
%     imagesc(abs(double(template) - double(I_warped)));
%     overlay = double(template)+double(I_warped);
%     figure('Name',strcat('OverlayBeforeInverseFrame', num2str(frame)))
%     imshow(uint8(overlay));
    if frame == 1
        template = I_warped;
    end
    I_warped = template;
    A_refined = AlignImage(template, image_cell{frame}, A_refined);
    
    template = WarpImage(image_cell{frame}, A_refined, output_size);
%     figure('Name',strcat('WarpAfterInverseFrame', num2str(frame)))
%     imshow(uint8(template));
%     figure('Name',strcat('ErrorMapAfterInverseFrame', num2str(frame)))
%     imagesc(abs(double(I_warped) - double(template)));
%     overlay = double(I_warped)+double(template);
%     figure('Name',strcat('OverlayAfterInverseFrame', num2str(frame)))
%     imshow(uint8(overlay));
%     
%     trans_u1 = A_refined*[1; 1; 1];
%     trans_u2 = A_refined*[size(template,2); 1; 1];
%     trans_u3 = A_refined*[size(template,2); size(template,1); 1];
%     trans_u4 = A_refined*[1; size(template,1); 1];
%     figure('Name',strcat('AlignAfterInverseCompAlignFrame', num2str(frame)))
%     imshow(image_cell{frame});
%     hold on;
%     plot([trans_u1(1),trans_u2(1)],...
%         [trans_u1(2),trans_u2(2)],'Color','y',...
%         'LineWidth',2);
%     plot([trans_u2(1),trans_u3(1)],...
%         [trans_u2(2),trans_u3(2)],'Color','y',...
%         'LineWidth',2);
%     plot([trans_u3(1),trans_u4(1)],...
%         [trans_u3(2),trans_u4(2)],'Color','y',...
%         'LineWidth',2);
%     plot([trans_u4(1),trans_u1(1)],...
%         [trans_u4(2),trans_u1(2)],'Color','y',...
%         'LineWidth',2);
%     hold off;
    
end