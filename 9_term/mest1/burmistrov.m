clear all;

FileNumber = 5;
FileNamePrefix = sprintf('%d',FileNumber);
RadiusOptimal = [500, 12, 13, 13, 19];
X = dlmread(strcat(FileNamePrefix,'.txt'));
%X = [X(:,1), X(:,3)];  % 2 -> 12 .. 10     % 3 -> 13 .. 12     % 4 -> 13 .. 11     % 5 -> 19 only
r = RadiusOptimal(FileNumber);
r = 13;
MinAngle = -179;

AngleIdxInit = @() ndgrid(1000, 0);
clangle = @(x) (1.25-4*(heaviside(x(:,1).*x(:,4)-x(:,2).*x(:,3))-0.75).^2) .*acos((x(:,1).*x(:,3)+x(:,2).*x(:,4))./sqrt((x(:,1).^2+ x(:,2).^2) .*(x(:,3).^2+ x(:,4).^2)))*180/pi;

h = plot(X(:,1), X(:,2), 'r.','LineWidth',1);
axis normal; hold on;

max(X)
%[~, idx] = max(X(:,1)==max(X(:,1)));
MaxedX=find(X(:,1)==max(X(:,1)));
[~, idx] = max(X(MaxedX, 2));
idx = MaxedX(idx);
plot(X(idx,1), X(idx,2), 'b.','LineWidth',3);

Previous = X(idx,:);
nearest = find(((X(:,1) - Previous(1)).^2 + (X(:,2) - Previous(2)).^2) < r^2);
nearest(nearest == idx) = [];
XX = X(nearest,:);
NPrev = (XX(:,1) - Previous(1)).^2 + (XX(:,2) - Previous(2)).^2;
Angle = clangle([ones(length(nearest),1) * [0 -1] (XX - ones(length(nearest),1) * Previous)]);
[~, NewIdx] = min(Angle(Angle > MinAngle));
idx = [idx nearest(NewIdx)];
plot(X(idx(end),1), X(idx(end),2), 'b.','LineWidth',3);
X(idx,:)
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
    if ~isempty(Angle(Positive))
        [~, BestPos] = min(Angle(Positive));
        NewIdx = nearest(Positive(BestPos));
    else
        Negative = find((Angle > MinAngle) & (NPrev > NPPrev));
        [~, BestNeg] = min(Angle(Negative));
        NewIdx = nearest(Negative(BestNeg))
    end
    plot(XX(Positive,1), XX(Positive,2), 'y.','LineWidth',3);
    idx = [idx NewIdx];
    plot(XX(Positive,1), XX(Positive,2), 'r.','LineWidth',3);
    plot(X(idx(end),1), X(idx(end),2), 'g.','LineWidth',3);
    %length(idx)
end

Perimeter = sum(sqrt((X(idx(1:end-1),1)-X(idx(2:end),1)).^2 + (X(idx(1:end-1),2)-X(idx(2:end),2)).^2) )
Area = 1/2 * sum(X(idx(1:end-1),1).*X(idx(2:end),2) - X(idx(1:end-1),2).*X(idx(2:end),1))

plot(X(idx,1), X(idx,2), 'g-','LineWidth',2);
%axis('tight')
axis('square');
axis('xy');
text(   0.5*min(X(:,1)) + 0.5* max(X(:,1)), min(X(:,2)), ...
    strcat('$$P = ', num2str(Perimeter),', S = ',num2str(Area),'$$'), ...
    'Interpreter','latex', 'FontSize',12);
saveas(h, strcat(FileNamePrefix, sprintf('_r%d.eps',r)),        'eps2c');
hold off
