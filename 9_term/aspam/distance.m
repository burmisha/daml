function [ Dist ] = distance( Data, center )
%DISTANCE count L2-distances to center for Data
%   Detailed explanation goes here
    Dist = sqrt(sum((Data - ones(size(Data,1),1)*center').^2,2));
end

