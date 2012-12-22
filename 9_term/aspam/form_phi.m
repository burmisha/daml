
clear all
dim = 2
N = 1000
R = 5;
c = 0.05;

Dir = randn(N,dim);
Norm = sqrt(sum(Dir.^2,2));


E = exp(c*R^2)*erfc(R*sqrt(c))*sqrt(pi/c)/2
S = 1*R + E;

Rand = rand(N,1);
Rad = zeros(N,1);
FromUniIdx = find(Rand < R/S);
FromNormIdx = find(Rand >= R/S);
Rad(FromUniIdx) = Rand(FromUniIdx) * S;
Rad(FromNormIdx) = erfcinv((1 - Rand(FromNormIdx))*S*exp(-c*R^2)*2/sqrt(pi/c))/sqrt(c);
hold off
plot(Rad(FromUniIdx), ones(length(Rad(FromUniIdx)),1), 'r.'); hold on
plot(Rad(FromNormIdx), ones(length(Rad(FromNormIdx)),1), 'b.');

Data = Dir ./ (Norm./Rad * ones(1,dim));

hold off
plot(Data(:,1), Data(:,2), 'r.')
rectangle('Position',[-R, -R, 2*R, 2*R],'Curvature',[1,1],'EdgeColor','g')
axis equal