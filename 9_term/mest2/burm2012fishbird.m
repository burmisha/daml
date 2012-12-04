clear all;
fish_fileidx = 1:55; % - 0
bird_fileidx = 1:52; % - 1

% 15 - good, 10 - too
[FP, FA, FI, FPc, FAc, FIc] = collect(fish_fileidx, 'fish');
[BP, BA, BI, BPc, BAc, BIc] = collect(bird_fileidx, 'bird');
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
Matrix = [[FP, FA, FI, FPc, FAc, FIc]; [BP, BA, BI, BPc, BAc, BIc]];
Answers = [zeros(length(fish_fileidx), 1); ones(length(bird_fileidx), 1)];
y = regress(Answers, Matrix);
sum(abs(round(Matrix*y) - Answers))

%%
X = read_cloud('bird', 27);
B = binarise_cloud(X, 10);
imshow(B)
Z = bwmorph(B,'dilate',1);
Z = bwmorph(B,'skel',Inf)
imshow(Z)