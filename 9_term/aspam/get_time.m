function [ T ] = get_time(  )
%GET_TIME Summary of this function goes here
%   Detailed explanation goes here
    t = clock;
    T = sprintf('%02d:%02d:%02d.%03d', t(4), t(5), floor(t(6)), round(rem(t(6),1)*1000));
end

