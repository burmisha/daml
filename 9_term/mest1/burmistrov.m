%close
X = dlmread('input.txt', ' ', 1, 0);
X=[X(:,1), X(:,2)]
r = 1.2;
%%
X = dlmread('2.txt', ' ', 0, 0);
X=[X(:,1), X(:,3)];
% 2 - 16-ok
r = 15;

%%
%max_coords = max(X,[],1);
%max_x = max_coords(1);
[~, first_idx] = max(X(:,1)==max(X(:,1)));
%h = figure;
plot(X(:,1), X(:,2), 'r.','LineWidth',2);
axis normal
hold on

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
    tmp = [];
    for i=1:size(X,1)
        Dist = norm(X(i,:) - Previous);
        Angle = clangle(LastLine, X(i,:)- Previous);
        %if (dist < r) && (i ~= idx(end)) && (ang > -120)
        if (Dist < r) && (i ~= idx(end)) && (Angle > -150) ...
            && (norm(X(i,:) - Previous) <= norm(X(i,:) - PrePrevious)) 
            tmp = [tmp; i Angle Dist];
        end        
    end
    %[X(tmp(:,1),:), tmp(:, 2:3)]
    if (isempty(tmp))
        error='ERROR! no points'
        break;
    end
    [~, ia] = min(tmp(:,2)+400);
    ba = tmp(ia,:);
    [~, id] = max(ba(:, 3));
    BestIdx = ba(id, 1);
    plot(X(BestIdx,1), X(BestIdx,2), 'g.','LineWidth',3);
    idx = [idx BestIdx];
    % X(best_idx,:);
    %pause(0.1)
    length(idx)
end

plot(X(idx,1), X(idx,2), 'g-','LineWidth',1);

hold off
X(idx,:);
%sortrows([5 2; 3 4], 2);
