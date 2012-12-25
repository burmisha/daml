clear all

C = 0.01:0.01:0.2;

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

% T = SpamTrain;
% SpamTrain = HamTest;
% HamTest = T;

%%
Quality = zeros(size(C,2),1);
PP = Quality;
RR = Quality;

Permutation = randperm(SpamSize,200);

for i=1:length(C)
    c = C(i)
    model = svdd(SpamTrain(Permutation,:), c);
    True_Positive  = sum(distance(SpamTrain, model.center) <= model.radius);
    True_Negative  = sum(distance(HamTest,   model.center) >  model.radius);
    False_Negative = sum(distance(SpamTrain, model.center) >  model.radius);
    False_Positive = sum(distance(HamTest,   model.center) <= model.radius);

    Precision = True_Positive/(True_Positive + False_Positive)
    if isnan(Precision)
        Precision=0;
    end
    Recall = True_Positive/(True_Positive + False_Negative)
    if isnan(Recall)
        Recall = 0;
    end
  
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


