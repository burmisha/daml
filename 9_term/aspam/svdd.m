function [ model ] = svdd(Data, C)
%SVDD builds Support Vector Data Description model
%   Mikhail Burmistrov, Liubov Sanduleanu
%   2012, Moscow, MIPT
    
    prod = @(u,v) (u*v');
    %prod = @(u,v) (exp(norm(u-v,2)/5));
    
    Number = size(Data, 1);
    epsilon = 10^-14;
    
    alpha_Zero = ones(Number,1)/Number;
    center_Zero = Data'*alpha_Zero;
    radius_Zero = 0;
    
    if Number * C < 1
        alpha = alpha_Zero;
        center = center_Zero;
        radius = radius_Zero;
    else
        PairWiseProd = zeros(Number); % count matrix || x_i\cdot x_j ||
        for i=1:Number
            for j=1:Number
                PairWiseProd(i,j) = -prod(Data(i,:), Data(j,:));  
            end
        end
       
        SingleWiseProd = zeros(Number,1); % count vector || x_i\cdot x_i ||
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
        L_NotZ = -L_NotZ;
        center_NotZ = Data'*alpha_NotZ;
        DistSq_NotZ = sum((Data - ones(Number, 1)*center_Zero').^2,2);
        OnIdx_NotZ  = find((alpha_NotZ >= epsilon) & (alpha_NotZ <= C - epsilon));
        if isempty(OnIdx_NotZ)
            cand = find(alpha_NotZ < epsilon);
            [~, OnIdx_NotZ] = min(DistSq_NotZ(cand));
            OnIdx_NotZ = cand(OnIdx_NotZ);
        end
        radius_NotZ = mean(sqrt(sum((Data(OnIdx_NotZ,:) - repmat(center_NotZ', size(Data(OnIdx_NotZ,:), 1),1)).^2,2)));
        
        L_Zero = C*sum(sum((Data - ones(Number, 1)*center_Zero').^2))/Number;
        
        if L_Zero > L_NotZ
            alpha = alpha_Zero;
            center = center_Zero;
            radius = radius_Zero;
        else
            alpha = alpha_NotZ;
            center = center_NotZ;
            radius = radius_NotZ;
        end
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

