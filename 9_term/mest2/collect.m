function [ Per, Area,IdSize,ConvSize ] = collect( fileidx, filename_prefix )
%COLLECT Summary of this function goes here
%   Detailed explanation goes here
    R = 10;
    R_bin = 4;
    Per=zeros(length(fileidx), 1);
    Area=zeros(length(fileidx), 1);
    IdSize=zeros(length(fileidx), 1);
    ConvSize=zeros(length(fileidx), 1);
    for number=fileidx
        X = read_cloud(filename_prefix, number);
        [Y, Side] = norm_to_square(X);
        [idx, Per(number), Area(number)]  = get_contour(Y, R);
        IdSize(number) = length(idx);
        ConvSize(number) = length(get_contour(Y, Side));
        % imshow(binarise_cloud(X, R_bin)');
        plot_contour(X, idx);
        ConvSize(number) = length(get_contour(Y, Side));
        number
    end
end

