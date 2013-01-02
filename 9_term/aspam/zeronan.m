function [ zn ] = zeronan( n )
%ZERONAN Summary of this function goes here
%   Detailed explanation goes here
        if isnan(n)
            zn = 0;
        else
            zn = n;
        end

end

