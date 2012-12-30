clear all

C = 0.03:0.005:0.15;

AllData = dlmread('spambase/spambase.data.txt', ',', 0, 0);
% 58 --> 1, 0.    | spam, non-spam classes
AllSpam = AllData(AllData(:,58) == 1,:);
AllHam = AllData(AllData(:,58) == 0,:);
Spam = AllSpam(:,1:57);
Ham = AllHam(:,1:57);
SpamSize = size(Spam, 1);
HamSize = size(Ham,  1);

SpamTrain = (Spam - ones(SpamSize,1)*min(Spam))./(ones(SpamSize,1)*max(Spam)-ones(SpamSize,1)*min(Spam));
HamTest = (Ham - ones(HamSize,1)*min(Spam))./(ones(HamSize,1)*max(Spam)-ones(HamSize,1)*min(Spam));

% Tmp = SpamTrain;
% SpamTrain = HamTest;
% HamTest = Tmp;

N = 200;
T = 20;
Quality = zeros(size(C,2),T);

name = sprintf('Real_N%d_%0.4f-%0.4f-%0.4f_T%d',N,C(1),C(2)-C(1),C(end),T);

%%
for t=1:T
    Permutation = randperm(SpamSize,N);
    for i=1:length(C)
        c = C(i);
        [t, c, i/length(C)]
        model = svdd(SpamTrain(Permutation,:), c);
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
        
        Qual = 2*Precision*Recall/(Precision + Recall);
        if isnan(Qual)
            Qual = 0;
        end
        Qual
        Quality(i,t) = Qual;
    end
end
dlmwrite(strcat(name,'.matr'), Quality);
%%
ReadData = dlmread(strcat(name,'.matr'), ',');
ToPlot = mean(ReadData,2);
hold off
p = plot(C, ToPlot, 'r-', 'LineWidth', 2);
saveas(p, strcat(name,'.png'), 'png');
saveas(p, strcat(name,'.eps'), 'eps2c');

fileID = fopen('CVReal.txt','w');

fprintf(fileID,strcat('%%','_CV_',name,'\n', ...
        '\\addplot[red, mark=none, thick] coordinates {\n'));
fprintf(fileID,'(%.4f, %.4f)',[C; ToPlot']);
fprintf(fileID,'\n};');

fprintf(fileID,'\n\n\n %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% \n\n\n');

fprintf(fileID,strcat('%%','_CV_',name,'\n', ...
        '\\addplot[red, mark=none, thick] coordinates {\n'));
fprintf(fileID,'\t(%.4f,\t%.4f)\n',[C; ToPlot']);
fprintf(fileID,'};');

fclose(fileID);

