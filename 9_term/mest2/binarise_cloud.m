function [ Y ] = binarise_cloud( X, R )
%BINARISE_CLOUD Summary of this function goes here
%   Detailed explanation goes here
    Size = 100;
    Y = zeros(Size+2*R, Size+2*R);
    [XX, Side] = norm_to_square(X);
    XX = round(XX*(Size-1)/Side) + 1;
    T = ones(2*R+1);
    for i=1:size(X,1);
        Y(XX(i,1):XX(i,1)+2*R, XX(i,2):XX(i,2)+2*R) = T;
    end
    Y = Y(R+1:Size+R, R+1:Size+R)';
end

