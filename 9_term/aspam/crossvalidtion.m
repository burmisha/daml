%clear all

T = 50;
Q = 3;
C = 0.005:0.001:0.03;

N = 400;
dim = 2;
a = [1;2];
R = 3;
c = 0.2;

%X = get_data(N, dim, a, R, c);
Quality = zeros(size(C,2),1);
PP = Quality;
RR = Quality;

for i=1:length(C)
    c = C(i);
    Precision = zeros(Q,T);
    Recall = zeros(Q,T);
    for t=1:T
        Pre = randperm(N);
        X_perm = X(Pre,:);
        for q=1:Q
            (i - 1)/length(C) + (t-1)/T/length(C) + (q-1)/T/Q/length(C)
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
            if isnan(R)
                Rec = 0;
            end
            
            Precision(q,t) = Pre;
            Recall(q,t) = Rec;
            
%             hold off
%             plot(model.on(:,1), model.on(:,2),  '.','Color',[0.0 1 0.0],'LineWidth',4)
%             hold on
%             plot(model.out(:,1),model.out(:,2), '.','Color',[0.1 0 0.9],'LineWidth',2)
%             plot(model.in(:,1), model.in(:,2),  '.','Color',[0.9 0 0.1],'LineWidth',2)
% 
%             a_predicted = model.center;
%             R_predicted = model.radius+10^-9;
%             plot(a_predicted(1), a_predicted(2), '.', 'Color',[220 150 90]/255, 'LineWidth',3)
%             rectangle('Position',[a_predicted(1)-R_predicted, a_predicted(2)-R_predicted,...
%                 2*R_predicted, 2*R_predicted],'Curvature',[1,1],'EdgeColor','r'); hold on
%             rectangle('Position',[a(1)-R, a(2)-R, 2*R, 2*R],'Curvature',[1,1],'EdgeColor','g')
            
            % misses(q,t) = sum(sqrt(sum((X_test - ones(size(X_test,1),1)*model.center').^2,2)) > model.radius) / size(X_test,1);
        end
    end
    PP(i) = mean(mean(Precision));
    RR(i) = mean(mean(Recall));
    Qual = mean(mean(2*Precision.*Recall./(Recall + Recall)));
    if isnan(Qual)
        Qual = 0;
    end
    Quality(i) = Qual;
    
end

%%
hold off
Quality;
p = plot(C, Quality, 'r-');
name = sprintf('CV_%0.3f-%0.3f-%0.3f_T%d_Q%d',C(1),C(2)-C(1),C(end),T,Q);
saveas(p, strcat(name,'.jpg'), 'jpg');
saveas(p, strcat(name,'.eps'), 'eps');
