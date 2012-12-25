clear all

C = 0.015:0.01:0.045;

AllData = dlmread('spambase/spambase.data.txt', ',', 0, 0);
% 58 --> 1, 0.    | spam, non-spam classes
AllSpam = AllData(AllData(:,58) == 1,:);
AllHam = AllData(AllData(:,58) == 0,:);
Spam = AllSpam(:,1:57);
Ham = AllHam(:,1:57);
SpamSize = size(Spam, 1);
HamSize = size(Ham,  1);
name = sprintf('Real_%0.4f-%0.4f-%0.4f',C(1),C(2)-C(1),C(end));
SpamTrain = (Spam - ones(SpamSize,1)*min(Spam))./(ones(SpamSize,1)*max(Spam)-ones(SpamSize,1)*min(Spam));
HamTest = (Ham - ones(HamSize,1)*min(Spam))./(ones(HamSize,1)*max(Spam)-ones(HamSize,1)*min(Spam));
%%
Quality = zeros(size(C,2),1);
PP = Quality;
RR = Quality;

for i=1:length(C)
    c = C(i)
    model = svdd(SpamTrain, c);
    True_Positive  = sum(distance(SpamTrain, model.center) <= model.radius);
    True_Negative  = sum(distance(HamTest,   model.center) >  model.radius);
    False_Negative = sum(distance(SpamTrain, model.center) >  model.radius);
    False_Positive = sum(distance(HamTest,   model.center) <= model.radius);

    Precision = True_Positive/(True_Positive + False_Positive);
    if isnan(Precision)
        Precision=0;
    end
    Recall = True_Positive/(True_Positive + False_Negative);
    if isnan(Recall)
        Recall = 0;
    end

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
    
    Qual = 2*Precision*Recall/(Precision + Recall);
    if isnan(Qual)
        Qual = 0;
    end
    Quality(i) = Qual;
    
end
dlmwrite(strcat(name,'.matr'), Quality);
%%
ReadData = dlmread(strcat(name,'.matr'), ',');
hold off
p = plot(C, ReadData, 'r-', 'LineWidth', 2);
saveas(p, strcat(name,'.png'), 'png');
saveas(p, strcat(name,'.eps'), 'eps');


