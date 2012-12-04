function [ idx, Perimeter, Area ] = get_contour( X, r )
%GET_CONTOUR [idx, Perimeter, Area]
%   form contour of cloud
MinAngle = -179;
clangle = @(x) (1.25-4*(heaviside(x(:,1).*x(:,4)-x(:,2).*x(:,3))-0.75).^2) .*abs(acos((x(:,1).*x(:,3)+x(:,2).*x(:,4))./sqrt((x(:,1).^2+ x(:,2).^2) .*(x(:,3).^2+ x(:,4).^2))))*180/pi;

MaxedX=find(X(:,1)==max(X(:,1)));
[~, idx] = max(X(MaxedX, 2));
idx = MaxedX(idx);

Previous = X(idx,:);
nearest = find(((X(:,1) - Previous(1)).^2 + (X(:,2) - Previous(2)).^2) < r^2);
nearest(nearest == idx) = [];
XX = X(nearest,:);
Angle = clangle([ones(length(nearest),1) * [0 -1] (XX - ones(length(nearest),1) * Previous)]);
[~, NewIdx] = min(Angle(Angle > MinAngle));
idx = [idx nearest(NewIdx)];
%plot(X(:,1), X(:,2), 'r.','LineWidth',2);
%plot(X(idx,1), X(idx,2), 'b.','LineWidth',2);
%hold on
while idx(end) ~= idx(1)
    Previous = X(idx(end),:);
    PrePrevious = X(idx(end-1),:);
    LastLine = Previous - PrePrevious;
    nearest = find(((X(:,1) - Previous(1)).^2 + (X(:,2) - Previous(2)).^2) < r^2);
    nearest(nearest == idx(end)) = [];
    XX = X(nearest,:);
    NPrev = (XX(:,1) - Previous(1)).^2 + (XX(:,2) - Previous(2)).^2;
    NPPrev = (XX(:,1) - PrePrevious(1)).^2 + (XX(:,2) - PrePrevious(2)).^2;
    Angle = clangle([ones(length(nearest),1) * LastLine (XX-ones(length(nearest),1)*Previous) ] );
    Positive = find((Angle > MinAngle) & (NPrev <= NPPrev));
    if ~isempty(Positive)
        [min_angle, BestPos] = min(Angle(Positive));
        if min_angle == 0
            idx = idx(1:end-1);
        end
        NewIdx = nearest(Positive(BestPos));
    else
        PPPrevious = X(idx(end-2),:);
        NPPPrev = (XX(:,1) - PPPrevious(1)).^2 + (XX(:,2) - PPPrevious(2)).^2;
        Level_1 = find((Angle > 0) & (NPrev > NPPrev) & (NPrev < NPPPrev));
        if ~isempty(Level_1)
            error_level ='ERROR LEVEL: 1';
            [~, BestNeg] = min(Angle(Level_1));
            NewIdx = nearest(Level_1(BestNeg));
        else
            error_level ='ERROR LEVEL: 2';
            Level_2 = find((Angle > MinAngle) & (NPrev > NPPrev) & (NPrev >= NPPPrev));
            [~, BestOst] = min(Angle(Level_2));
            NewIdx = nearest(Level_2(BestOst));
        end
    end
    %plot(XX(Positive,1), XX(Positive,2), 'y.','LineWidth',3);
    idx = [idx NewIdx];
    %plot(X(idx(end),1), X(idx(end),2), 'g.','LineWidth',4);
    %plot(XX(Positive,1), XX(Positive,2), 'r.','LineWidth',3);
    %plot(X(idx,1), X(idx,2), 'b.','LineWidth',2);
end

Perimeter = sum(sqrt((X(idx(1:end-1),1)-X(idx(2:end),1)).^2 + (X(idx(1:end-1),2)-X(idx(2:end),2)).^2) );
Area = 1/2 * sum(X(idx(1:end-1),1).*X(idx(2:end),2) - X(idx(1:end-1),2).*X(idx(2:end),1));

end

