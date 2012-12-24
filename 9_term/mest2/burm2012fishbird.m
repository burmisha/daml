clear all;

fish_fileidx_all = 1:55; % - 0
bird_fileidx_all = 1:52; % - 1
Matrix = [collect(fish_fileidx_all, 'fish'); collect(bird_fileidx_all, 'bird')];
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

