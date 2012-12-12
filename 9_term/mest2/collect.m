function [AllFeatures, Per, Area,Id,ConvPer,ConvArea,ConvId ] = collect( fileidx, filename_prefix )
%COLLECT Summary of this function goes here
%   Detailed explanation goes here
    R = 10; % 15 - good, 10 - too
    R_bin = 4;
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
        i = i + 1
        X = read_cloud(filename_prefix, number);
        [Y, Side] = norm_to_square(X);
        [idx, Per(i), Area(i)]  = get_contour(Y, R);
        Id(i) = length(idx);
        [idxConv, ConvPer(i), ConvArea(i)]  = get_contour(Y, 2*Side);
        ConvId(i) = length(idxConv);
        plot_contour(X, idx);

        BB = bwmorph(imfill(binarise_contour(X(idx,:)),'holes'),'skel',Inf);
        for k = 1:40
            BB = BB - bwmorph(BB, 'endpoints');
        end
        BranchPoints(i) = sum(sum(bwmorph(BB, 'branchpoints')));

        %imshow(binarise_cloud(X, R_bin)');
    end
    AllFeatures = [Per, Area,Id,ConvPer,ConvArea, ConvId,BranchPoints];
end

