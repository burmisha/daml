fish_fileidx_all = 1:55; % - 0
bird_fileidx_all = 1:52;
plot(D,A,'r.-'); hold off
plot(D,A,'r.-'); hold off

for i=bird_fileidx_all
    i
    X = norm_to_square(read_cloud('bird', i));
    [GC,P]= get_contour(X,10);
    [D,A] = get_profile(X(GC,:));
    A = (A - min(A)) / (max(A) - min(A))
    D = (D - min(D)) / (max(D) - min(D));
     % plot_contour(X ,GC);
    plot(D,A,'r.-'); %hold on

%     
%     B = binarise_cloud(X(GC,:), 1);
%     imshow(B)
%     
%     Z = bwmorph(B,'dilate',1);
%     Z = bwmorph(B,'skel',Inf);
%      BC = binarise_contour(X(GC,:));
%      BW2 = imfill(BC,'holes');
%      BW3 = bwmorph(BW2,'skel',Inf);
%      BB = BW3;
%      imshow(BB);
%      for k = 1:40
%          BB = BB - bwmorph(BB, 'endpoints');
%      end
%      BW4 = bwmorph(BB, 'branchpoints');
%      imshow(BB);
%      a = [a sum(sum(BW4))];
end
% sqrt(mean((a - mean(a)).^2))
% mean(a)