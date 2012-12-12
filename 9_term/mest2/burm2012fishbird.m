clear all;
fish_fileidx = 1:30; % - 0
fish_fileidx = 35
bird_fileidx = []%:30; % - 1
Matrix = [collect(fish_fileidx, 'fish'); collect(bird_fileidx, 'bird')];
%Answers = [zeros(length(fish_fileidx), 1); ones(length(bird_fileidx), 1)];
%SVMStruct = svmtrain(Matrix,Answers,'Kernel_Function','rbf','boxconstraint',Inf)

%%
fish_fileidx = 31:55; % - 0
bird_fileidx = 31:52; % - 1
Matrix = [collect(fish_fileidx, 'fish'); collect(bird_fileidx, 'bird')];
Group = svmclassify(SVMStruct, Matrix)
Answers = [zeros(length(fish_fileidx), 1); ones(length(bird_fileidx), 1)];

sum(abs(Group - Answers))/length(Answers)

%%
fish_fileidx_all = 1:55; % - 0
bird_fileidx_all = 1:52; % - 1
Matrix = [collect(fish_fileidx_all, 'fish'); collect(bird_fileidx_all, 'bird')];
Matrix = Matrix(:,[2 7 4 6]);
Answers = [zeros(length(fish_fileidx_all), 1); ones(length(bird_fileidx_all), 1)];
GotAnswers = zeros(length(fish_fileidx_all) + length(bird_fileidx_all),1);
for i=1:(length(fish_fileidx_all) + length(bird_fileidx_all))
    i/(length(fish_fileidx_all) + length(bird_fileidx_all))
    ii = 1:(length(fish_fileidx_all) + length(bird_fileidx_all));
    ii(ii==i)=[];
    SVMStruct = svmtrain(Matrix(ii,:),Answers(ii),'Kernel_Function','rbf','boxconstraint',Inf);
    GotAnswers(i) = svmclassify(SVMStruct, Matrix(i,:));
end
ErrorIdx = find(GotAnswers ~= Answers);
ErrorFishIdx = ErrorIdx(ErrorIdx <= 55)'
ErrorBirdIdx = (ErrorIdx(ErrorIdx >= 56) - 55)'
ErrorRate = sum(abs(GotAnswers - Answers))/length(GotAnswers)

%%
[b,se,pval,inmodel,stats,nextstep,history] = stepwisefit(Matrix, Answers, 'display','off', 'scale', 'on');
B = sortrows([pval (1:7)'], 1);
BestfFeatures=B

