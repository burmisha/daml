clear all;

X = dlmread('2.txt', ' ', 0, 0);
X = [X(:,1), X(:,3)];
% 2 -> 12
% 3 -> 13
% 4 -> 13
% 5 -> 19
r = 12;
MinAngle = -178;

AngleIdxInit = @() ndgrid(1000, 0);
clangle = @(u,v) (1.25-4*(heaviside((u(1)*v(2)-u(2)*v(1)))-0.75)^2)* acos(dot(u,v)/(norm(u)*norm(v)))*180/pi;

plot(X(:,1), X(:,2), 'r.','LineWidth',1);
axis normal; hold on;

[~, idx] = max(X(:,1)==max(X(:,1)));
plot(X(idx,1), X(idx,2), 'b.','LineWidth',3);

[BestAngle, BestIdx] = AngleIdxInit();
for i=1:size(X,1)
    Dist = norm(X(i,:) - X(idx,:));
    if (Dist < r) && (i ~= idx)
        Angle = clangle([0 -1], X(i,:)- X(idx,:));
        if (Angle > MinAngle) && (BestAngle > Angle)
            BestIdx = i;
            BestAngle = Angle;
        end
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
            if NPrev <= NPPrev
                if (BestAngle > Angle)
                    BestIdx = i;
                    BestAngle = Angle;
                end
                if (TestAngle > Angle)
                    TestIdx = i;
                    TestAngle = Angle;
                end
            end
        end
    end
    if (BestIdx == 0)
        BestIdx = TestIdx;
    end
    idx = [idx BestIdx];
    %plot(X(BestIdx,1), X(BestIdx,2), 'g.','LineWidth',3);
    length(idx)
end

plot(X(idx,1), X(idx,2), 'g-','LineWidth',2);
hold off