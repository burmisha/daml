clear all
X = [(randn(10,2)+ones(10,2)*(-10)); randn(200,2)];

N = size(X,1);
C = 0.01:0.01:2;
T = 5;
Q = 5;
Quality = C*0;
for i=1:length(C)
    c = C(i);
    misses = zeros(Q,T);
    for t=1:T    
        P = randperm(N);
        X_perm = X(P,:);
        for q=1:Q
            (i - 1)/length(C) + (t-1)/T/length(C) + (q-1)/T/Q/length(C)
            idx_for_train = [1:round((q-1)/Q*N), round(q/Q*N + 1):N];
            idx_for_test = round((q-1)/Q*N+1):round(q/Q*N);
            X_train = X_perm(idx_for_train,:);
            X_test = X_perm(idx_for_test,:);
            model = svdd(X_train, c);
            misses(q,t) = sum(sqrt(sum((X_test - ones(size(X_test,1),1)*model.center').^2,2)) > model.radius) / size(X_test,1); 
        end
    end
    Quality(i) = mean(mean(misses));
end
hold off
p = plot(C, Quality, 'r-');
saveas(p, strcat('modelData','.jpg'), 'jpg');
