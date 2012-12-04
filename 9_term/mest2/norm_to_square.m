function [ Y ] = norm_to_square( X )
%RNORM_TO_SQUARE Summary of this function goes here
%   Detailed explanation goes here
    Y=[ (X(:,1) - min( X(:,1))) / (max(X(:,1)) - min( X(:,1))) * 100, ...
        (X(:,2) - min( X(:,2))) / (max(X(:,2)) - min( X(:,2))) * 100];

end

