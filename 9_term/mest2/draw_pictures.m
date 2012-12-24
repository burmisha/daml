clear all
fileidx = 23;
filename_prefix = 'bird'

R = 10; % 15 - good, 10 - too

Zeros = zeros(length(fileidx), 1);
Per=Zeros;
Area=Zeros;
Id=Zeros;
ConvPer=Zeros;
ConvArea=Zeros;
ConvId=Zeros;
BranchPoints=Zeros;
i = 0;
for number=fileidx
    i = i + 1;
    i / length(fileidx)
    X = read_cloud(filename_prefix, number);
    [Y, Side] = norm_to_square(X);
    [idx, Per(i), Area(i)]  = get_contour(Y, R);
    Id(i) = length(idx);
    [idxConv, ConvPer(i), ConvArea(i)]  = get_contour(Y, 2*Side);
    ConvId(i) = length(idxConv);
    
    hold off;
    p = plot(Y(:,1), 100-Y(:,2),'r.'); axis equal;
    saveas(p, 'cloud.eps', 'eps2c')
    saveas(p, 'cloud.png', 'png')
    p = plot_contour(Y, idx); axis equal;
    saveas(p, 'contour.eps', 'eps2c')
    saveas(p, 'contour.png', 'png')
    p = plot_contour(Y, idxConv); axis equal;
    saveas(p, 'convex.eps', 'eps2c')   
    saveas(p, 'convex.png', 'png')
    
    imwrite(imfill(binarise_contour(X(idx,:)),'holes')', 'binarised.png', 'png');
    BB = bwmorph(imfill(binarise_contour(X(idx,:)),'holes'),'skel',Inf);
    imwrite(BB', 'skel.png', 'png');
    for k = 1:40
        BB = BB - bwmorph(BB, 'endpoints');
    end
    imwrite(BB', 'prunned.png', 'png');
    BranchPoints(i) = sum(sum(bwmorph(BB, 'branchpoints')));
end