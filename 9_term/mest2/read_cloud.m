function [ X ] = read_cloud( prefix, number )
%READ_CLOUD Summary of this function goes here
%   Detailed explanation goes here
    file_name = strcat('data/', prefix, ' (', num2str(number), ').txt');
    X = dlmread(file_name, ' ', 1, 0);
    X = X(:,[1 3]);
end

