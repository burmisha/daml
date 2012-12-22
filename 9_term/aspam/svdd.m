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
    % see http://www.mathworks.com/help/optim/ug/quadprog.html for full decription
    [alpha_NotZ, L_NotZ] = quadprog(-H,-SingleWiseProd,[],[],CoeffEq,ValEq,lowerBound,upperBound,[],opts);
    [alpha_Zero, L_Zero] = quadprog(-H,-SingleWiseProd,[],[],[],[],lowerBound,upperBound,[],opts);
    
    epsilon = 10^-14;
    
    center_NotZ = Data'*alpha_NotZ;
    center_Zero = Data'*alpha_Zero/sum(alpha_Zero);
    OnIdx_NotZ = find((alpha_NotZ >= epsilon) & (alpha_NotZ <= C - epsilon));
    OnIdx_Zero = find((alpha_Zero >= epsilon) & (alpha_Zero <= C - epsilon));
    radius_NotZ = mean(sqrt(sum((Data(OnIdx_NotZ,:) - repmat(center_NotZ', size(Data(OnIdx_NotZ,:), 1),1)).^2,2)));
    radius_Zero = mean(sqrt(sum((Data(OnIdx_Zero,:) - repmat(center_Zero', size(Data(OnIdx_Zero,:), 1),1)).^2,2)));

    if (radius_Zero < epsilon) && ((L_Zero > L) || (abs(sum(abs(alpha_NotZ)) - 1) > epsilon)) ...
        || (Number * C < 1)
            alpha = alpha_Zero;
            center = center_Zero;
            radius = radius_Zero;
    else
            alpha = alpha_NotZ;
            center = center_NotZ;
            radius = radius_NotZ;
    end
    
    model.alpha = alpha;

    % form point ON, IN and OUT of sphere
    model.in_idx = find(abs(alpha) < epsilon);
    model.on_idx = find((alpha >= epsilon) & (alpha <= C - epsilon));
    model.out_idx = find(alpha > C - epsilon);

    model.in = Data(model.in_idx,:);
    model.on = Data(model.on_idx,:);
    model.out = Data(model.out_idx,:);

    % form sphere parameters
    model.center = center;
    model.radius = radius;

end

