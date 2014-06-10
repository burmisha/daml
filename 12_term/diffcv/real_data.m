clear all

AllData = dlmread('../../spambase/spambase.data', ',', 0, 0);
% 58 --> 1, 0.    | spam (1), non-spam (0) classes
N_all = size(AllData, 1);
idx = randperm(N_all,200);
X_raw = AllData(idx, [1:3 5:57]);
Y_raw = AllData(idx, 58);
N = size(X_raw, 1);


X = 2 * ((X_raw - ones(N,1)*min(X_raw))./(ones(N,1)*max(X_raw)-ones(N,1)*min(X_raw)) - 1/2);
Y = 2 * ((Y_raw - min(Y_raw))/(max(Y_raw) - min(Y_raw)) - 1/2);

Mu = 10:10:50;
Beta = (1:3:25)/100;

[S_diff_CV, S_LOO_I, S_honest_CV] = deal(zeros(length(Mu), length(Beta)));

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
dlmwrite('real_diff_CV.matr', S_diff_CV);
dlmwrite('real_LOO_I.matr', S_LOO_I);
dlmwrite('real_honest_CV.matr',   S_honest_CV);

%%
files = {'real_diff_CV', 'real_LOO_I', 'real_honest_CV'};
report='';
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

