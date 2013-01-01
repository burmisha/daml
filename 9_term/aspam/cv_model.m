clear all

T = 20;
Q = 3;
C = 0.015:0.0005:0.045;

N = 400;
dim = 2;
a = [1;2];
R = 3;
c = 0.2;

name = sprintf('Model_N%d_%0.4f-%0.4f-%0.4f_T%d_Q%d',N,C(1),C(2)-C(1),C(end),T,Q);
filename = strcat(name,'.mat');

F_one = zeros(length(C),1);
%%
X = get_data(N, dim, a, R, c);
for i=1:length(C)
    c = C(i);
    Precision = zeros(Q,T);
    Recall = zeros(Q,T);
    for t=1:T
        Pre = randperm(N);
        X_perm = X(Pre,:);
        for q=1:Q
            (i - 1)/length(C) + (t-1)/T/length(C) + (q-1)/Q/T/length(C)
            idx_for_train = [1:round((q-1)/Q*N), round(q/Q*N + 1):N];
            idx_for_test = round((q-1)/Q*N+1):round(q/Q*N);
            X_train = X_perm(idx_for_train,:);
            X_test = X_perm(idx_for_test,:);
            model = svdd(X_train, c);
            True_Positive  = sum(distance( X_test(distance(X_test, a) <= R,:), model.center) <= model.radius);
            True_Negative  = sum(distance( X_test(distance(X_test, a) >  R,:), model.center) >  model.radius);
            False_Negative = sum(distance( X_test(distance(X_test, a) <= R,:), model.center) >  model.radius);
            False_Positive = sum(distance( X_test(distance(X_test, a) >  R,:), model.center) <= model.radius);
            
            Pre = True_Positive/(True_Positive + False_Positive);
            if isnan(Pre)
                Pre=0;
            end
            Rec = True_Positive/(True_Positive + False_Negative);
            if isnan(Rec)
                Rec = 0;
            end
            
            Precision(q,t) = Pre;
            Recall(q,t) = Rec;
        end
    end
    Quality = mean(mean(2*Precision.*Recall./(Precision + Recall)));
    if isnan(Quality)
        Quality = 0;
    end
    F_one(i) = Quality;  
end
save(filename, 'F_one');
%%

load(filename);
hold off
p = plot(C, F_one, 'r-', 'LineWidth', 2);
xlabel('$C$',   'FontSize', 20, 'FontName', 'Times', 'Interpreter','latex');
ylabel('$F_1$', 'FontSize', 20, 'FontName', 'Times', 'Interpreter','latex');
set(gca, 'FontSize', 20, 'FontName', 'Times')
axis tight
saveas(p, strcat(name,'.png'), 'png');
saveas(p, strcat(name,'.eps'), 'eps2c');

save_everything('CVModel.txt', strcat('_CV_', name),[4,4], [C', F_one]);
