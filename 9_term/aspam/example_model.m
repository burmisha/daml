clear all
% X = [(randn(10,2)+ones(10,2)*(-10)); randn(200,2)];

N = 240;
dim = 2;
R = 3;
c = 0.2;
a = [1;6];

C = 0.008;

X = get_data(N, dim, a, R, c);

model = svdd(X, C);
%%
hold off
Plot = plot(X(:,1),X(:,2), 'b.', 'MarkerSize',10); axis equal; hold on
axis equal
plot(model.on(:,1), model.on(:,2),  '.','Color',[0.0 1 0.0],'LineWidth',2)
plot(model.out(:,1),model.out(:,2), '.','Color',[0.1 0 0.9],'LineWidth',2)
plot(model.in(:,1), model.in(:,2),  '.','Color',[0.9 0 0.1],'LineWidth',2)

mean(sqrt(sum((model.on - repmat(model.center', size(model.on, 1),1)).^2,2)));

a_predicted = model.center
R_predicted = model.radius+10^-9

%plot(a_predicted(1), a_predicted(2), '.', 'Color',[220 150 90]/255, 'LineWidth',2)
rectangle('Position',[a_predicted(1)-R_predicted, a_predicted(2)-R_predicted,...
    2*R_predicted, 2*R_predicted],'Curvature',[1,1],'EdgeColor','r','LineWidth',2); hold on
rectangle('Position',[a(1)-R, a(2)-R, 2*R, 2*R],'Curvature',[1,1],'EdgeColor','g','LineWidth',2)

saveas(Plot, strcat('example','.eps'), 'eps2c');

save_everything('Example.txt', '_Example',[2,2], X);

model.classify([1, 1])

%%

First = a(1)-2:.03:a(1)+2;
Second = a(2)-2:.03:a(2)+2;
[X1, X2] = meshgrid(First,Second);
coords = cell(length(First), length(Second));
for i=1:length(First)
    for j=1:length(Second)
        coords{i,j} = [First(i), Second(j)];
    end
end
classes = double(cellfun(model.classify, coords')); % TODO: check transpose
[C,h] = contour(X1,X2,classes,1, 'EdgeColor', 'b');
set(h,'LineWidth',2)
axis equal