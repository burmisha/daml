%% Example of building SVDD
clear all

N = 150;    % Number of points in 1 cluster
dim = 2;    % dimensions for this test only (don't change)
R = 1.5;    % Radius of original distribution
c = 0.6;    % parameter of distribution
a = [1;6];  % initial center

C = 0.015;    % regularization

X = [get_data(N, dim, a, R, c); get_data(N/2, dim, a+[5;0], R, c); get_data(N/3, dim, a+[3;4], R, c)];
display 'Data formed'
%% Build model
model = svdd(X, C, 'poly', 3);
display 'Model built'
%% Plot objects on 2D-plane
hold off
Plot = plot(X(:,1),X(:,2), 'b.', 'MarkerSize',10); axis equal; hold on
hold on
axis tight
plot(model.on(:,1), model.on(:,2),  '.','Color',[0.0 1 0.0],'MarkerSize',10)
plot(model.out(:,1),model.out(:,2), '.','Color',[0.1 0 0.9],'MarkerSize',10)
plot(model.in(:,1), model.in(:,2),  '.','Color',[0.9 0 0.1],'MarkerSize',10)
rectangle('Position',[a(1)-R, a(2)-R, 2*R, 2*R],'Curvature',[1,1],'EdgeColor','g','LineWidth',2);
rectangle('Position',[a(1)-R+5, a(2)-R, 2*R, 2*R],'Curvature',[1,1],'EdgeColor','g','LineWidth',2);
rectangle('Position',[a(1)-R+3, a(2)-R+4, 2*R, 2*R],'Curvature',[1,1],'EdgeColor','g','LineWidth',2);

%% Plot separating surface
plot_func = @(x,y) (model.count_sq_dist([x,y]) - model.radius^2);
h = ezplot(plot_func, [min(X(:,1)), max(X(:,1)),min(X(:,2)), max(X(:,2))]);
set(h,'LineWidth',2,'EdgeColor', 'b')
display 'Plot: completed'
%%
set(gcf,'Units','normal')
set(gca,'Position',[0.15 0.1 0.84 0.89])
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperPosition', [0 0 5 5]);
axis tight

%% Save everything

LaTeXifyTicks(20, 30, 100, '$x_1$', '$x_2$'); % Set axis to LaTeX style
saveas(Plot, strcat('example','.eps'), 'eps2c');
saveas(Plot, strcat('example','.png'), 'png');
% saveas(Plot, strcat('example','.pdf'), 'pdf');
% save_everything('Example.txt', '_Example',[2,2], X);
