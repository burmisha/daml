clear all
% X = [(randn(10,2)+ones(10,2)*(-10)); randn(200,2)];

N = 150;
dim = 2;
R = 1.5;
c = 0.6;
a = [1;6];

C = 0.008;

X = [get_data(N, dim, a, R, c); ...
     get_data(N, dim, a+[5;0], R, c)];

model = svdd(X, C, 'rbf', 8);
%%
hold off
Plot = plot(X(:,1),X(:,2), 'b.', 'MarkerSize',10); axis equal; hold on
axis equal
plot(model.on(:,1), model.on(:,2),  '.','Color',[0.0 1 0.0],'LineWidth',2)
plot(model.out(:,1),model.out(:,2), '.','Color',[0.1 0 0.9],'LineWidth',2)
plot(model.in(:,1), model.in(:,2),  '.','Color',[0.9 0 0.1],'LineWidth',2)

rectangle('Position',[a(1)-R, a(2)-R, 2*R, 2*R],'Curvature',[1,1],'EdgeColor','g','LineWidth',2); hold on

% saveas(Plot, strcat('example','.eps'), 'eps2c');
saveas(Plot, strcat('example','.png'), 'png');

save_everything('Example.txt', '_Example',[2,2], X);
%%

First = min(X(:,1)):0.12:max(X(:,1));
Second = min(X(:,2)):0.12:max(X(:,2));
[X2, X1] = meshgrid(Second, First);
coords = cell(length(First), length(Second));
for i=1:length(First)
    for j=1:length(Second)
        coords{i,j} = [First(i), Second(j)];
    end
end
classes = double(cellfun(model.classify, coords)); % TODO: check transpose
[C,h] = contour(X1,X2,classes,1, 'EdgeColor', 'b');
set(h,'LineWidth',2)
axis equal