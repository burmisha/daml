clear all
X = [
    1.3, 1.1;
    3, 3.5; 
    ];
X = [5*X ;randn(200,2)]
C = 0.05;
model = svdd(X, C);
%%
hold off
plot(X(:,1),X(:,2), 'r.', 'LineWidth',3); axis equal; hold on

plot(model.on(:,1), model.on(:,2),  '.','Color',[0 1 0],'LineWidth',3)
plot(model.out(:,1),model.out(:,2), '.','Color',[0.1 0 0.9],'LineWidth',3)
plot(model.in(:,1), model.in(:,2),  '.','Color',[0.9 0 0.1],'LineWidth',3)

a = model.center;
R = model.radius;
plot(a(1), a(2), 'b.')
rectangle('Position',[a(1)-R, a(2)-R, 2*R, 2*R],'Curvature',[1,1],'EdgeColor','g')

