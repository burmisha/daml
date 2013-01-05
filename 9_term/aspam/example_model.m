%% Example of building SVDD
clear all

N = 150;    % Number of points in 1 cluster
dim = 2;    % dimensions for this test only (don't change)
R = 1.5;    % Radius of original distribution
c = 0.6;    % parameter of distribution
a = [1;6];  % initial center

C = 0.2;    % regularization

X = [get_data(N, dim, a, R, c); get_data(N/2, dim, a+[5;0], R, c); get_data(N/3, dim, a+[3;4], R, c)];

%% Build model and plot objects on 2D-plane
model = svdd(X, C, 'rbf', 4);

hold off
Plot = plot(X(:,1),X(:,2), 'b.', 'MarkerSize',10); axis equal; hold on
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

%% Set axis to LaTeX style
fontSize = 20;
title('');
set(get(gca,'XLabel'),'String',[])
set(get(gca,'YLabel'),'String',[])
set(gca,'yticklabel',[], 'xticklabel', [])
yTicks = get(gca,'ytick');
xTicks = get(gca,'xtick');
ax = axis;

verticalOffset = fontSize / 60;
for i = 1:length(xTicks)
    text(xTicks(i), ax(3) - verticalOffset, ['$' num2str( xTicks(i)) '$'],'HorizontalAlignment','Center','interpreter', 'latex','FontSize', fontSize); 
end
text((ax(1)+ax(2))/2, ax(3) - verticalOffset*2.5,   '$x_1$','HorizontalAlignment','Center','interpreter', 'latex','FontSize', fontSize); 

horizontalOffset = fontSize / 100;
for i = 1:length(yTicks) 
    text(ax(1) - horizontalOffset,yTicks(i),['$' num2str(yTicks(i)) '$'],'HorizontalAlignment','Right','interpreter', 'latex','FontSize', fontSize); 
end
text(ax(1) - horizontalOffset*3.5, (ax(3)+ax(4))/2, '$x_2$','HorizontalAlignment','Right', 'interpreter', 'latex','FontSize', fontSize); 

%% Save everything

% saveas(Plot, strcat('example','.eps'), 'eps2c');
% saveas(Plot, strcat('example','.png'), 'png');
saveas(Plot, strcat('example','.pdf'), 'pdf');
% save_everything('Example.txt', '_Example',[2,2], X);
