function [ Y ] = binarise_contour(X)
%BINARISE_CLOUD Summary of this function goes here
%   Detailed explanation goes here
    Size = 150;
    d = 5;
    Y = zeros(Size+2*d, Size+2*d);
    [XX, Side] = norm_to_square(X);
    XX = round(XX*(Size-1)/Side) + 1;
    for k=1:size(X,1)-1;
        v = XX(k+1,:) - XX(k,:);
        len = round(norm(v,2) + 1/2);
        dv = v/len;
        for i = 1:len
            Y(XX(k,1)+round(i*dv(1)) +d, XX(k,2)+round(i*dv(2))+d) = 1;
        end
    end
end

