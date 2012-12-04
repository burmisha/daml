clear all;
%close
X = dlmread('input.txt', ' ', 1, 0);
X=[X(:,1), X(:,2)]
r = 1.2;
%%
X = dlmread('3.txt', ' ', 0, 0);
X=[X(:,1), X(:,3)];
% 2 -> 16, -150
% 3 -> 27, -150
% 4 -> 13, -150
r = 13;
MinAngle = -150;

%%
plot(X(:,1), X(:,2), 'r.','LineWidth',1); 
axis normal; hold on;

[~, first_idx] = max(X(:,1)==max(X(:,1)));
idx = first_idx;
plot(X(first_idx,1), X(first_idx,2), 'b.','LineWidth',3);

tmp=[]
for i=1:size(X,1)
    Dist = norm(X(i,:) - X(first_idx,:));
    if (Dist < r) && (i ~= idx(end))
        tmp = [tmp; i clangle([0 -1], X(i,:)- X(first_idx,:)) Dist];
    end
end
[~, ia] = min(tmp(:,2)+400); %WTF
ba = tmp(ia,:);
[~, id] = max(ba(:, 3));
BestIdx = ba(id, 1);
idx = [idx BestIdx]
plot(X(BestIdx,1), X(BestIdx,2), 'b.','LineWidth',3);

while idx(end) ~= first_idx
    Previous = X(idx(end),:);
    PrePrevious = X(idx(end-1),:);
    LastLine = Previous - PrePrevious;
    BestAngle = 1000;
    BestDist = 2*r;
    BestIdx = 0;
    TestIdx = BestAngle;
    TestAngle = BestAngle;
    for i=1:size(X,1)
        Dist = norm(X(i,:) - Previous);
        if (Dist < r) && (i ~= idx(end)) 
            Angle = clangle(LastLine, X(i,:)- Previous);
            %if ((Angle > MinAngle) && (norm(X(i,:) - Previous) <= norm(X(i,:) - PrePrevious))) ...
            if (Angle > MinAngle) && (norm(X(i,:) - Previous) <= norm(X(i,:) - PrePrevious)) ...
                    && ((BestAngle > Angle) || (BestAngle == Angle) && (Dist > BestDist))
                BestIdx = i;
                BestAngle = Angle;
                BestDist = Dist;
            end
            if (Angle > MinAngle) && (norm(X(i,:) - Previous) > norm(X(i,:) - PrePrevious)) ...
                    && (TestAngle > Angle)
                TestIdx = i;
                TestAngle = Angle;
            end
        end        
    end
    if (BestIdx == 0)
        error='ERROR! no points'
        % break;
        BestIdx = TestIdx;
    end
    idx = [idx BestIdx];
    plot(X(BestIdx,1), X(BestIdx,2), 'g.','LineWidth',3);
    length(idx)
end

plot(X(idx,1), X(idx,2), 'g-','LineWidth',1);
hold off