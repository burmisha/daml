clear all

T = 20;
Q = 3;
C = 0.015:0.005:0.045;

N = 400;
dim = 2;
a = [1;2];
R = 3;
c = 0.2;

name = sprintf('Model_N%d_%0.4f-%0.4f-%0.4f_T%d_Q%d',N,C(1),C(2)-C(1),C(end),T,Q);
filename = strcat(name,'.mat');

%%
startTime = get_time()
clear F_one;
matlabpool local 4
X = get_data(N, dim, a, R, c);
parfor i = 1:length(C)
    X_copy = X;
    c = C(i);
    Precision = zeros(Q,T);
    Recall = zeros(Q,T);
    for t = 1:T
        Pre = randperm(N);
        X_perm = X_copy(Pre,:);
        for q = 1:Q
            % (i - 1)/length(C) + (t-1)/T/length(C) + (q-1)/Q/T/length(C);
            idx_for_train = [1:round((q-1)/Q*N), round(q/Q*N + 1):N];
            idx_for_test = round((q-1)/Q*N+1):round(q/Q*N);
            X_train = X_perm(idx_for_train,:);
            X_test = X_perm(idx_for_test,:);
            model = svdd(X_train, c);
            real = (distance(X_test, a) <= R);
            pred = model.classify(X_test);
            True_Positive  = sum((real == 1) & (pred == 1));
            True_Negative  = sum((real == 0) & (pred == 0));
            False_Negative = sum((real == 1) & (pred == 0)); 
            False_Positive = sum((real == 0) & (pred == 1));          
            Precision(q,t) = zeronan(True_Positive/(True_Positive + False_Positive));
            Recall(q,t)    = zeronan(True_Positive/(True_Positive + False_Negative));
        end
    end
    F_one(i) = zeronan(mean(mean(2*Precision.*Recall./(Precision + Recall))));
end
matlabpool close
finishTime = get_time()
save(filename, 'F_one');

%%
load(filename);
hold off
p = plot(C, F_one, 'r-', 'LineWidth', 2);
axis tight
LaTeXifyTicks(20, 8500, 40000, '$C$', '$F_1$'); % Set axis to LaTeX style

saveas(p, strcat(name,'.pdf'), 'pdf');
saveas(p, strcat(name,'.eps'), 'eps2c');
save_everything('CVModel.txt', strcat('_CV_', name),[4,4], [C', F_one']);
