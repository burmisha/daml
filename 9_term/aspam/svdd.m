function [ m ] = svdd(Data, C, varargin)
%SVDD builds Support Vector Data Description model
%   Mikhail Burmistrov, Liubov Sanduleanu
%   2012, Moscow, MIPT

    m.Data = Data;
    m.C = C;
    
    NVarargs = length(varargin);
    if NVarargs > 0
        if strcmp(varargin{1},'rbf')
            if NVarargs ~= 2
                error('Error: "rbf" option requires more.')
            else
                m.kernel = @(u,v) ( exp( - sum((repmat(u, size(v,1), 1) - v).^2,2)/varargin{2})' );
            end
        elseif strcmp(varargin{1},'ell2')
            if NVarargs ~= 1
                error('Error: "ell2" option requires nothing else.')
            else
                m.kernel = @(u,v) (u*v'); 
            end
        elseif strcmp(varargin{1},'poly')
            if NVarargs ~= 2
                error('Error: "poly"  option requires more: deg.')
            else
                m.kernel = @(u,v) ((1+u*v').^varargin{2}); 
            end        
        else
            error('Error: no such option.')
        end
    else
        m.kernel = @(u,v) (u*v'); 
    end
    % u - 1 object, row; v - matrix (1 row is 1 object)
    % kernel returns a row of results
    
    Number = size(m.Data, 1);
    if Number * m.C < 1
        error( 'ERROR: Too small C. Radius is 0.')
    end
    
    epsilon = 10^-4; % TODO: be careful

    m.PairWise = zeros(Number); % count matrix || x_i\cdot x_j ||
    for i=1:Number
        for j=1:Number
            m.PairWise(i,j) = m.kernel(Data(i,:), Data(j,:));
        end
    end

    m.SelfWise = zeros(Number,1); % count vector || x_i\cdot x_i ||
    for i=1:Number
        m.SelfWise(i) = m.kernel(Data(i,:), Data(i,:));
    end
    
    CoeffEq = ones(1,Number);
    ValEq = 1;
    lowerBound =       zeros(Number,1);   % \alpha_i >= 0
    upperBound = m.C * ones(Number,1);    % \alpha_i <= C
    opts = optimset('Algorithm','interior-point-convex','Display','off','TolX',1e-14,'TolFun',1e-14,'UseParallel','always');
    m.alpha = quadprog(2*m.PairWise,-m.SelfWise,[],[],CoeffEq,ValEq,lowerBound,upperBound,[],opts);
    
    m.in_idx = find(abs(m.alpha) < epsilon);
    m.on_idx = find((m.alpha >= epsilon) & (m.alpha <= m.C - epsilon));
    m.out_idx = find(m.alpha > m.C - epsilon);
    m.in = m.Data(m.in_idx,:);
    m.on = m.Data(m.on_idx,:);
    m.out = m.Data(m.out_idx,:); 
    
    m.count_sq_dist_t = @(x) (m.kernel(x,x) - 2*m.kernel(x, m.Data)*m.alpha + m.alpha'*m.PairWise*m.alpha);
    m.count_sq_dist = @(X) (cellfun(m.count_sq_dist_t, num2cell(X,2)));
    
    if ~isempty(m.on)
        m.radius = mean(sqrt(m.count_sq_dist(m.on)));
    else
        display('Error: No points on sphere. Try debugging! Good luck!')
        m.radius = (max(sqrt(m.count_sq_dist(m.in))) + min(sqrt(m.count_sq_dist(m.out))))/2;
    end
    
    m.classify = @(X) (m.count_sq_dist(X) <= m.radius^2); 
end

