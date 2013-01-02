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
F_one = zeros(size(C,2),T);

name = sprintf('Real_N%d_%0.4f-%0.4f-%0.4f_T%d',N,C(1),C(2)-C(1),C(end),T);
filename = strcat(name,'.mat');

%%
for t=1:T
    Permutation = randperm(SpamSize,N);
    for i=1:length(C)
        c = C(i);
        [t, c, i/length(C)]
        model = svdd(SpamTrain(Permutation,:), c);
        True_Positive  = sum(model.classify(SpamTrain) == 1);
        True_Negative  = sum(model.classify(HamTest)   == 0);
        False_Negative = sum(model.classify(SpamTrain) == 0);
        False_Positive = sum(model.classify(HamTest)   == 1);      
        Precision = zeronan(True_Positive/(True_Positive + False_Positive));
        Recall    = zeronan(True_Positive/(True_Positive + False_Negative));
        F_one(i,t) = zeronan(2*Precision*Recall/(Precision + Recall));
    end
end

save(filename, 'F_one');
%%
load(filename);
ToPlot = mean(F_one,2);
hold off
p = plot(C, ToPlot, 'r-', 'LineWidth', 2);
saveas(p, strcat(name,'.png'), 'png');
saveas(p, strcat(name,'.eps'), 'eps2c');

save_everything('CVReal.txt', strcat('_CV_', name),[3,4], [C', ToPlot]);
