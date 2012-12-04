clear all;
fish_fileidx = 1:55;
bird_fileidx = 1:52;

% 15 - good, 10 - too
collect(fish_fileidx, 'fish')
collect(bird_fileidx, 'bird')
hold off
%plot(F_PerAr(:,1).^2, F_PerAr(:,2), 'r.'); hold on
%plot(B_PerAr(:,1).^2, B_PerAr(:,2), 'b.'); hold on
%%
X = read_cloud('bird', 27);
B = binarise_cloud(X, 10);
imshow(B)
Z = bwmorph(B,'dilate',1);
Z = bwmorph(B,'skel',Inf)
imshow(Z)