clear all
X = [
    5, 7;
    3.3, 2.5; 
    ];
X = [(randn(10,2)+ones(10,2)*5) ;randn(200,2)];
C = 0.025;
model = svdd(X, C);
%%
hold off
Plot = plot(X(:,1),X(:,2), 'r.', 'LineWidth',3); axis equal; hold on

plot(model.on(:,1), model.on(:,2),  '.','Color',[0.0 1 0.0],'LineWidth',4)
plot(model.out(:,1),model.out(:,2), '.','Color',[0.1 0 0.9],'LineWidth',2)
plot(model.in(:,1), model.in(:,2),  '.','Color',[0.9 0 0.1],'LineWidth',2)

mean(sqrt(sum((model.on - repmat(model.center', size(model.on, 1),1)).^2,2)));

a = model.center;
R = model.radius;
plot(a(1), a(2), '.', 'Color',[220 150 90]/255, 'LineWidth',3)
rectangle('Position',[a(1)-R, a(2)-R, 2*R, 2*R],'Curvature',[1,1],'EdgeColor','g')

saveas(Plot, strcat('modelData','.eps'), 'eps2c');
