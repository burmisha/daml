function [ Data ] = get_data( N, dim, a, R, c )
%GET_DATA Summary of this function goes here
%   Detailed explanation goes here
    Dir = randn(N,dim);
    Norm = sqrt(sum(Dir.^2,2));

    E = exp(c*R^2)*erfc(R*sqrt(c))*sqrt(pi/c)/2;
    S = 1*R + E;

    Rand = rand(N,1);
    Rad = zeros(N,1);
    FromUniIdx = find(Rand < R/S);
    FromNormIdx = find(Rand >= R/S);
    Rad(FromUniIdx) = Rand(FromUniIdx) * S;
    Rad(FromNormIdx) = erfcinv((1 - Rand(FromNormIdx))*S*exp(-c*R^2)*2/sqrt(pi/c))/sqrt(c);

    Data = Dir ./ (Norm./Rad * ones(1,dim)) + ones(N,1)*a';
end

