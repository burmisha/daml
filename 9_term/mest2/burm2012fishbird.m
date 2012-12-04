clear all;
fish_fileidx = 1:55;
bird_fileidx = 1:52;

% 15 - good, 10 - too
R = 10;
R_bin = 4;
F_PerAr=zeros(length(fish_fileidx), 2);
for number=fish_fileidx
    X = read_cloud('fish', number);
    [idx, F_PerAr(number,1 ), F_PerAr(number, 2)]  = get_contour(norm_to_square(X),R);
    % imshow(binarise_cloud(X, R_bin)');
    plot_contour(X, idx);
end
B_PerAr=zeros(length(bird_fileidx), 2);
for number=bird_fileidx
    X = read_cloud('bird', number);
    [idx, B_PerAr(number,1 ), B_PerAr(number, 2)]  = get_contour(norm_to_square(X),R);
    imshow(binarise_cloud(X, R_bin)')
    % plot_contour(X, idx);
end
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