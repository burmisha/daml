clear all;

X = dlmread('2.txt', ' ', 0, 0);
X = [X(:,1), X(:,3)];
% 2 -> 12 .. 10
% 3 -> 13 .. 12
% 4 -> 13 .. 11
% 5 -> 19 only
r = 12;
MinAngle = -179;

AngleIdxInit = @() ndgrid(1000, 0);
clangle = @(x) (1.25-4*(heaviside(x(:,1).*x(:,4)-x(:,2).*x(:,3))-0.75).^2) .*acos((x(:,1).*x(:,3)+x(:,2).*x(:,4))./sqrt((x(:,1).^2+ x(:,2).^2) .*(x(:,3).^2+ x(:,4).^2)))*180/pi;

plot(X(:,1), X(:,2), 'r.','LineWidth',1);
axis normal; hold on;

[~, idx] = max(X(:,1)==max(X(:,1)));
plot(X(idx,1), X(idx,2), 'b.','LineWidth',3);

[BestAngle, BestIdx] = AngleIdxInit();
for i=1:size(X,1)
    Dist = norm(X(i,:) - X(idx,:));
    if (Dist < r) && (i ~= idx)
        Angle = clangle([0 -1 (X(i,:)-X(idx,:))]);
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
    XX = X(nearest,:);
    NPrev = (XX(:,1) - Previous(1)).^2 + (XX(:,2) - Previous(2)).^2;
    NPPrev = (XX(:,1) - PrePrevious(1)).^2 + (XX(:,2) - PrePrevious(2)).^2;
    Angle = clangle([ones(length(nearest),1) * LastLine (XX-ones(length(nearest),1)*Previous) ] );
    for i=find(Angle > MinAngle)'
        if NPrev(i) <= NPPrev(i)
            if (BestAngle > Angle(i))
                BestIdx = nearest(i);
                BestAngle = Angle(i);
            end
        else
            if (TestAngle > Angle(i))
                TestIdx = nearest(i);
                TestAngle = Angle(i);
            end
        end
    end
    if (BestIdx == 0)
        BestIdx = TestIdx;
    end
    idx = [idx BestIdx];
    %plot(X(BestIdx,1), X(BestIdx,2), 'g.','LineWidth',3);
    %length(idx)
end

plot(X(idx,1), X(idx,2), 'g-','LineWidth',2);
hold off