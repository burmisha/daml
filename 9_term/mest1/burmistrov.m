clear all;

X = dlmread('5.txt', ' ', 0, 0);
X=[X(:,1), X(:,3)];
% 2 -> 16, -150
% 3 -> 27, -150; 13, -178
% 4 -> 13, -150; 13, -178
% 5 -> 19, -178;
r = 19;
MinAngle = -178;
AngleIdxInit=@() ndgrid(1000, 0);
ImprooveAngleIdx=@(BA, BI, A, I) ndgrid(min(A, BA), [I BI] * ([A; BA] == min(A, BA)) );
plot(X(:,1), X(:,2), 'r.','LineWidth',1);
axis normal; hold on;
%ImprooveAngleIdx(17, 10, 53, 17)
%[a, b] = ndgrid(min(17, 53), [10; 17] * ([17, 53] == min(17, 53)) );
% ndgrid([10 17] * find([17; 17] == min(17, 53)) )
[~, idx] = max(X(:,1)==max(X(:,1)));
plot(X(idx,1), X(idx,2), 'b.','LineWidth',3);

[BestAngle, BestIdx] = AngleIdxInit();
for i=1:size(X,1)
    Dist = norm(X(i,:) - X(idx,:));
    if (Dist < r) && (i ~= idx)
        Angle = clangle([0 -1], X(i,:)- X(idx,:));
        [BestAngle, BestIdx] = ImprooveAngleIdx(BestAngle, BestIdx, Angle, i);
        %if (Angle > MinAngle) && (BestAngle > Angle)
        %    BestIdx = i;
        %    BestAngle = Angle;
        %end
    end
end
plot(X(BestIdx,1), X(BestIdx,2), 'b.','LineWidth',3);
idx = [idx BestIdx];

while idx(end) ~= idx(1)
    Previous = X(idx(end),:);
    PrePrevious = X(idx(end-1),:);
    LastLine = Previous - PrePrevious;
    [BestAngle, BestIdx] = AngleIdxInit();
    [TestAngle, TestIdx] = AngleIdxInit();
    nearest = find(((X(:,1) - Previous(1)).^2 + (X(:,2) - Previous(2)).^2) < r^2);
    nearest(nearest == idx(end)) = [];
    for i=nearest'
        Angle = clangle(LastLine, X(i,:)- Previous);
        if (Angle > MinAngle)
            NPrev = norm(X(i,:) - Previous);
            if (BestAngle > Angle) && (NPrev <= norm(X(i,:) - PrePrevious))
                BestIdx = i;
                BestAngle = Angle;
            end
            if (TestAngle > Angle) && (NPrev > norm(X(i,:) - PrePrevious))
                TestIdx = i;
                TestAngle = Angle;
            end
        end
        %end
    end
    if (BestIdx == 0)
        BestIdx = TestIdx;
    end
    idx = [idx BestIdx];
    %plot(X(BestIdx,1), X(BestIdx,2), 'g.','LineWidth',3);
    %length(idx)
end

plot(X(idx,1), X(idx,2), 'g-','LineWidth',1);
hold off