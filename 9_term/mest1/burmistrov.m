clear all;

X = dlmread('4.txt', ' ', 0, 0);
X=[X(:,1), X(:,3)];
% 2 -> 16, -150
% 3 -> 27, -150; 13, -178
% 4 -> 13, -150; 13, -178
% 5 -> 19, -178;
r = 19;
MinAngle = -178;

AngleIdxInit = @() ndgrid(1000, 0);
ImprooveAngleIdx = @(BA, BI, A, I) ndgrid(min(A, BA), [I BI] * ([A; BA] == min(A, BA)) );
clangle = @(u,v) (1.25-4*(heaviside((u(1)*v(2)-u(2)*v(1)))-0.75)^2)* acos(dot(u,v)/(norm(u)*norm(v)))*180/pi;

%18*(find([17; 16] == min(17, 16), 1 , 'first'))
[I BI] * ([A; BA] == min(A, BA))
[b e ] = ImprooveAngleIdx(7, 10, 7, 5);
[b e]
plot(X(:,1), X(:,2), 'r.','LineWidth',1);
axis normal; hold on;

[~, idx] = max(X(:,1)==max(X(:,1)));
plot(X(idx,1), X(idx,2), 'b.','LineWidth',3);

[BestAngle, BestIdx] = AngleIdxInit();
for i=1:size(X,1)
    Dist = norm(X(i,:) - X(idx,:));
    if (Dist < r) && (i ~= idx)
        Angle = clangle([0 -1], X(i,:)- X(idx,:));
        [BestAngle, BestIdx] = ImprooveAngleIdx(BestAngle, BestIdx, Angle, i);
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
            NPPrev = norm(X(i,:) - PrePrevious);
            if (BestAngle > Angle) && (NPrev <= NPPrev)
                BestIdx = i;
                BestAngle = Angle;
            end
            if (TestAngle > Angle) && (NPrev >  NPPrev)
                TestIdx = i;
                TestAngle = Angle;
            end
        end
    end
    if (BestIdx == 0)
        BestIdx = TestIdx;
    end
    idx = [idx BestIdx];
    plot(X(BestIdx,1), X(BestIdx,2), 'g.','LineWidth',3);
    length(idx)
end

plot(X(idx,1), X(idx,2), 'g-','LineWidth',2);
hold off