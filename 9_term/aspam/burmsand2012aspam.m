clear all
X = [
%     0, 0;
%     1, 0;
%     0.9, 0;
%     3, 0;
%     2, 2;
%     1, 1;
%     1.5, 1.5;
%     1.2, 1.3;
%     1.2, 1.4;
    1.3, 1.1;
    3, 3.5; 
    ];

X = [5*X ;randn(200,2)]

C = 0.1;

N = size(X,1);
prod = @(u,v) (u*v');
%prod = @(u,v) (exp(norm(u-v,2)/5));
prod(X(1,:), X(2,:));
% http://www.mathworks.com/help/optim/ug/quadprog.html
H = zeros(N);
for i=1:N
    for j=1:N
        H(i,j) = -prod(X(i,:), X(j,:));
    end
end
f = zeros(N,1);
for i=1:N
    f(i) = prod(X(i,:), X(i,:));
end
f
Aeq = ones(1,N);
beq = 1;
lowerBound = zeros(N,1);
upperBound = C*ones(N,1);

opts = optimset('Algorithm','active-set','Display','off');
[alpha, fmin] = quadprog(-2*H,-f,[],[],Aeq,beq,lowerBound,upperBound,[],opts);
alpha
fmin
% sum(abs(alpha)) - 1
a = X'*alpha;

eps = 10^-10;
inSphereIdx = find(abs(alpha) < eps);
onSphereIdx = find((alpha > eps) & (alpha < C - eps));
selectedOnSphere = X(onSphereIdx(1),:);
% sum((X(onSphereIdx,:) - repmat(a', length(onSphereIdx),1)).^2,2)
R = norm(a - selectedOnSphere',2) + eps

hold off
plot(X(:,1),X(:,2), 'r.', 'LineWidth',3)
hold on
plot(X(onSphereIdx,1),X(onSphereIdx,2), 'g.','LineWidth',3)
plot(X(inSphereIdx,1),X(inSphereIdx,2), 'm.','LineWidth',3)
axis equal

plot(a(1), a(2), 'b.')
rectangle('Position',[a(1) - R,a(2)-R,2*R,2*R],'Curvature',[1,1],...
    'EdgeColor','g')

