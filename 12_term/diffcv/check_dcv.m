Mu = 47:0.05:50;
Beta = (10:0.1:18)/100;

[S_diff_CV, S_LOO_I, S_honest_CV] = deal(zeros(length(Mu), length(Beta)));

%\beta = \lambda(1-\alpha)N
%\mu = 2N\alpha
N = 100;

rng(3,'twister') % for reproducibility
X = zeros(N,5);
for ii = 1:5
    X(:,ii) = exprnd(ii,N,1);
end

r = [0;2;0;-3;0];
Y = X*r + randn(N,1)*.1;

for mu_idx = 1:length(Mu) 
    for beta_idx = 1:length(Beta) 
            mu = Mu(mu_idx);
            beta = Beta(beta_idx);
            alpha = mu / 2 / N;
            lambda = beta / N / (1 - alpha);

            a = lasso(X,Y, 'Alpha', alpha, 'Lambda', lambda);
            I = a ~= 0;
            tilde_X = X(:, I);
            hat_n = sum(I);
            small = diag(tilde_X * ((tilde_X' * tilde_X + beta * eye(hat_n)) \ tilde_X'));
            hat_delta = Y - X * a ;
            S_diff_CV(mu_idx, beta_idx) = 1/N * sum(hat_delta'.^2 * (ones(N,1) + 2 * small));
            S_LOO_I(mu_idx, beta_idx) = 1/N * sum(hat_delta.^2 ./ (ones(N,1) - 2 * small).^2);

            S = 0;
            for i=1:N
                no_i = [1:(i-1) (i+1):N];
                X_this = X(no_i, :);
                Y_this = Y(no_i);
                b_this = lasso(X_this, Y_this, 'Alpha', alpha, 'Lambda', lambda);
                S = S + (Y(i) - X(i,:) * b_this)^2;
            end
            S_honest_CV(mu_idx, beta_idx) = S/N;
            ((mu_idx - 1)  / length(Mu) + beta_idx / length(Mu) / length(Beta)) * 100
    end
end


%% Save results to files
exit
dlmwrite('diff_CV.matr', S_diff_CV);
dlmwrite('LOO_I.matr', S_LOO_I);
dlmwrite('honest_CV.matr',   S_honest_CV);

%% PNG
files = {'diff_CV', 'LOO_I', 'honest_CV'}
report=''
for f = 1:size(files,2)
    file = cell2mat(files(f));
    S = dlmread([file '.matr'],',');
    [best_beta_idx, best_mu_idx] = find(S == min(min(S)),1);
    report = [report file ...
        ', \hat S &=' num2str(min(min(S))) ... 
        ', \\ \hat \beta &=' num2str(Beta(best_beta_idx)) ...
        ', \\ \hat \mu &=' num2str(Mu(best_mu_idx)) ...
        char(10)];
    displayProb(Beta, Mu, S);
    print(['-r' num2str(500)], [file '.png'], ['-d' 'png']);
    crop([file '.png']);
end
report
%% old EPS
% saveas(displayProb(Beta, Mu,dlmread('diff_CV.matr',   ',')), 'diff_CV.eps',   'eps2c');
% saveas(displayProb(Beta, Mu,dlmread('LOO_I.matr', ',')), 'LOO_I.eps',     'eps2c');
% saveas(displayProb(Beta, Mu,dlmread('honest_CV.matr',     ',')), 'honest_CV.eps', 'eps2c');

%% old PNG
% saveas(displayProb(Beta, Mu,dlmread('diff_CV.matr',   ',')), 'diff_CV.png',   'png', '-r300');
% saveas(displayProb(Beta, Mu,dlmread('LOO_I.matr', ',')), 'LOO_I.png',     'png');
% saveas(displayProb(Beta, Mu,dlmread('honest_CV.matr',     ',')), 'honest_CV.png', 'png');


