function [ Per, Area,Id,ConvPer,ConvArea,ConvId ] = collect( fileidx, filename_prefix )
%COLLECT Summary of this function goes here
%   Detailed explanation goes here
    R = 10; % 15 - good, 10 - too
    R_bin = 4;
    Per=zeros(length(fileidx), 1);
    Area=zeros(length(fileidx), 1);
    Id=zeros(length(fileidx), 1);
    ConvPer=zeros(length(fileidx), 1);
    ConvArea=zeros(length(fileidx), 1);
    ConvId=zeros(length(fileidx), 1);
    i = 0;
    for number=fileidx
        i = i +1
        X = read_cloud(filename_prefix, number);
        [Y, Side] = norm_to_square(X);
        [idx, Per(i), Area(i)]  = get_contour(Y, R);
        Id(i) = length(idx);
        [idxConv, ConvPer(i), ConvArea(i)]  = get_contour(Y, 2*Side);
        ConvId(i) = length(idxConv);
        % plot_contour(X, idx);
        % imshow(binarise_cloud(X, R_bin)');
        number
    end
end

