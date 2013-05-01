clear all

% C = 0.03:0.01:0.2;
C = 0.04:0.004:0.12;

AllData = dlmread('spambase/spambase.data.txt', ',', 0, 0);
% 58 --> 1, 0.    | spam (1), non-spam (0) classes
AllSpam = AllData(AllData(:,58) == 1,:);
AllHam = AllData(AllData(:,58) == 0,:);
Spam = AllSpam(:,1:57);
Ham = AllHam(:,1:57);
SpamSize = size(Spam, 1);
HamSize = size(Ham,  1);

SpamTrain = (Spam - ones(SpamSize,1)*min(Spam))./(ones(SpamSize,1)*max(Spam)-ones(SpamSize,1)*min(Spam));
HamTest = (Ham - ones(HamSize,1)*min(Spam))./(ones(HamSize,1)*max(Spam)-ones(HamSize,1)*min(Spam));

N = 300;
T = 20;
rbf = 0.7;
name = sprintf('Real_N%d_%0.4f-%0.4f-%0.4f_T%d_rbf%0.3f',N,C(1),C(2)-C(1),C(end),T,rbf);
filename = strcat(name,'.mat');

%%
startTime = get_time()
clear F_one;
matlabpool local 4

parfor i=1:length(C)
    Spam_copy = SpamTrain;
    c = C(i); 
    Precision = zeros(T,1);
    Recall = zeros(T,1);
    for t=1:T
        Permutation = randperm(SpamSize,N);
        % [t, c, i/length(C)]
        model = svdd(Spam_copy(Permutation,:), c, 'rbf', rbf);
        True_Positive  = sum(model.classify(SpamTrain) == 1);
        True_Negative  = sum(model.classify(HamTest)   == 0);
        False_Negative = sum(model.classify(SpamTrain) == 0);
        False_Positive = sum(model.classify(HamTest)   == 1);
        Precision(t) = zeronan(True_Positive/(True_Positive + False_Positive));
        Recall(t)    = zeronan(True_Positive/(True_Positive + False_Negative));
    end
    F_one(i) = zeronan(mean(2*Precision.*Recall./(Precision + Recall)));
end
matlabpool close
finishTime = get_time()
save(filename, 'F_one');
%%
load(filename);
hold off
p = plot(C, F_one, 'r-', 'LineWidth', 2);
axis tight
LaTeXifyTicks(20, 110000, 8000, '$C$', '$F_1$'); % Set axis to LaTeX style
saveas(p, strcat(name,'.pdf'), 'pdf');
saveas(p, strcat(name,'.eps'), 'eps2c');
save_everything('CVReal.txt', strcat('_CV_', name),[3,4], [C', F_one']);
