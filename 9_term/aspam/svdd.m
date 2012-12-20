function [ model ] = svdd(Data, C)
%SVDD builds Support Vector Data Description model
%   Mikhail Burmistrov, Liubov Sanduleanu
%   2012, Moscow, MIPT
    
    prod = @(u,v) (u*v');
    %prod = @(u,v) (exp(norm(u-v,2)/5));
    
    Number = size(Data, 1);
    % count matrix || x_i\cdot x_j ||
    PairWiseProd = zeros(Number);
    for i=1:Number
        for j=1:Number
            PairWiseProd(i,j) = -prod(Data(i,:), Data(j,:));
        end
    end

    % count vector || x_i\cdot x_i ||
    SingleWiseProd = zeros(Number,1);
    for i=1:Number
        SingleWiseProd(i) = prod(Data(i,:), Data(i,:));
    end
    
    CoeffEq = ones(1,Number);
    ValEq = 1;
    lowerBound = zeros(Number,1);   % \alpha_i >= 0
    upperBound = C*ones(Number,1);  % \alpha_i <= C 
    opts = optimset('Algorithm','active-set','Display','off');
    H = 2 * PairWiseProd;     % cause it minimises 1/2*x'*H*x
    alpha = quadprog(-H,-SingleWiseProd,[],[],CoeffEq,ValEq,lowerBound,upperBound,[],opts);
    % look http://www.mathworks.com/help/optim/ug/quadprog.html for full decription
    
    eps = 10^-9;
    
    if abs(sum(abs(alpha)) - 1) >= eps
        display('ERROR: while maximizing quadratic form')
        alpha
        abs(sum(abs(alpha)) - 1)
    end
    
    model.alpha = alpha;
    
    % form point ON, IN and OUT of sphere
    model.in_idx = find(abs(alpha) < eps);
    model.on_idx = find((alpha > eps) & (alpha < C - eps));
    model.out_idx = find(alpha > C - eps);
    
    model.in = Data(model.in_idx,:);
    model.on = Data(model.on_idx,:);
    model.out = Data(model.out_idx,:);
    
    % form sphere parameters
    model.center = Data'*alpha + eps;
    model.radius = mean(sqrt(sum((model.on - repmat(model.center', size(model.on, 1),1)).^2,2)));
end

