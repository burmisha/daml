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
% PP = F_one;
% RR = F_one;
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
%             
%             misses(q,t) = sum(sqrt(sum((X_test - ones(size(X_test,1),1)*model.center').^2,2)) > model.radius) / size(X_test,1);
        end
    end
%     PP(i) = mean(mean(Precision));
%     RR(i) = mean(mean(Recall));
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


fileID = fopen('CVModel.txt','w');

fprintf(fileID,strcat('%%','_CV_',name,'\n', ...
        '\\addplot[red, mark=none, thick] coordinates {\n'));
fprintf(fileID,'(%.4f, %.4f)',[C; F_one']);
fprintf(fileID,'\n};');

fprintf(fileID,'\n\n\n %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% \n\n\n');

fprintf(fileID,strcat('%%','_CV_',name,'\n', ...
        '\\addplot[red, mark=none, thick] coordinates {\n'));
fprintf(fileID,'\t(%.4f,\t%.4f)\n',[C; F_one']);
fprintf(fileID,'};');
fclose(fileID);