function [ Per, Area,Id,ConvPer,ConvArea,ConvId ] = collect( fileidx, filename_prefix )
%COLLECT Summary of this function goes here
%   Detailed explanation goes here
    R = 10;
    R_bin = 4;
    Per=zeros(length(fileidx), 1);
    Area=zeros(length(fileidx), 1);
    Id=zeros(length(fileidx), 1);
    ConvPer=zeros(length(fileidx), 1);
    ConvArea=zeros(length(fileidx), 1);
    ConvId=zeros(length(fileidx), 1); 
    for number=fileidx
        X = read_cloud(filename_prefix, number);
        [Y, Side] = norm_to_square(X);
        [idx, Per(number), Area(number)]  = get_contour(Y, R);
        Id(number) = length(idx);
        [idxConv, ConvPer(number), ConvArea(number)]  = get_contour(Y, 2*Side);
        ConvId(number) = length(idxConv);
        % plot_contour(X, idx);
        % imshow(binarise_cloud(X, R_bin)');
        number
    end
end

