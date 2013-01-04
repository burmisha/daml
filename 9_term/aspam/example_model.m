clear all
% X = [(randn(10,2)+ones(10,2)*(-10)); randn(200,2)];

N = 150;
dim = 2;
R = 1.5;
c = 0.6;
a = [1;6];

C = 0.02;

X = [get_data(N, dim, a, R, c); ...
     get_data(N/2, dim, a+[5;0], R, c); get_data(N/3, dim, a+[3;4], R, c)];

model = svdd(X, C, 'rbf', 3);
%%
hold off
Plot = plot(X(:,1),X(:,2), 'b.', 'MarkerSize',10); axis equal; hold on
axis equal
plot(model.on(:,1), model.on(:,2),  '.','Color',[0.0 1 0.0],'LineWidth',2)
plot(model.out(:,1),model.out(:,2), '.','Color',[0.1 0 0.9],'LineWidth',2)
plot(model.in(:,1), model.in(:,2),  '.','Color',[0.9 0 0.1],'LineWidth',2)
rectangle('Position',[a(1)-R, a(2)-R, 2*R, 2*R],'Curvature',[1,1],'EdgeColor','g','LineWidth',2); hold on

%%
plot_func = @(x,y) (model.count_sq_dist([x,y]) - model.radius^2);
h = ezplot(plot_func, [min(X(:,1)), max(X(:,1)),min(X(:,2)), max(X(:,2))]);
set(h,'LineWidth',2,'EdgeColor', 'b')

%%
xlabel('$x_1$', 'FontSize', 24, 'FontName', 'Times', 'Interpreter','latex');
ylabel('$x_2$', 'FontSize', 24, 'FontName', 'Times', 'Interpreter','latex');
set(gca, 'FontSize', 24, 'FontName', 'Times')
title('');

% saveas(Plot, strcat('example','.eps'), 'eps2c');
saveas(Plot, strcat('example','.png'), 'png');
save_everything('Example.txt', '_Example',[2,2], X);