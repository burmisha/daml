clear all;
fish_fileidx = 1:30; % - 0
bird_fileidx = 1:30; % - 1
Matrix = [collect(fish_fileidx, 'fish'); collect(bird_fileidx, 'bird')];
Answers = [zeros(length(fish_fileidx), 1); ones(length(bird_fileidx), 1)];
SVMStruct = svmtrain(Matrix,Answers,'Kernel_Function','rbf','boxconstraint',Inf)

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
Answers = [zeros(length(fish_fileidx_all), 1); ones(length(bird_fileidx_all), 1)];
errors = 0;
for i=1:(length(fish_fileidx_all) + length(bird_fileidx_all))
    ii = 1:(length(fish_fileidx_all) + length(bird_fileidx_all));
    ii(ii==i)=[];
    SVMStruct = svmtrain(Matrix(ii,:),Answers(ii),'Kernel_Function','rbf','boxconstraint',Inf)
    answer = svmclassify(SVMStruct, Matrix(i,:));
    errors = errors + (answer ~= Answers(i));
end
errors/(length(fish_fileidx_all) + length(bird_fileidx_all))

%%
fish_fileidx = 1:55; % - 0
bird_fileidx = 1:52; % - 1
[~, FP, FA, FI, FPc, FAc, FIc] = collect(fish_fileidx, 'fish');
[~, BP, BA, BI, BPc, BAc, BIc] = collect(bird_fileidx, 'bird');

%%

hold off
plot(FP.^2, FA, 'r.'); hold on
plot(BP.^2, BA, 'b.'); hold on

hold off
plot(FI, FIc, 'r.'); hold on
plot(BI, BIc, 'b.'); hold on

hold off
plot(FAc, FA, 'r.'); hold on
plot(BAc, BA, 'b.'); hold on

%%
X = read_cloud('bird', 27);
B = binarise_cloud(X, 10);
imshow(B)
Z = bwmorph(B,'dilate',1);
Z = bwmorph(B,'skel',Inf)
imshow(Z)