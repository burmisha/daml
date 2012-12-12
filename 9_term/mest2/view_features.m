fish_fileidx_all = 1:55; % - 0
bird_fileidx_all = 1:52;
for i=1:52
    i
    X = norm_to_square(read_cloud('fish', i));
     [GC,P ]= get_contour(X,30);
%     [D,A] = get_profile(X(GC,:));
%     plot_contour(X ,GC);
%     plot(D,A,'r.')
%     
%     B = binarise_cloud(X(GC,:), 1);
%     imshow(B)
%     
%     Z = bwmorph(B,'dilate',1);
%     Z = bwmorph(B,'skel',Inf);
     BC = binarise_contour(X(GC,:));
     BW2 = imfill(BC,'holes');
     BW3 = bwmorph(BW2,'skel',Inf);
     imshow(BW3);
end