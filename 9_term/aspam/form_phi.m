clear all

N = 10;
dim = 2;
R = 5;
c = 0.05;
a=[1;2]

Data = get_data(N, dim, a, R, c);
hold off
plot(Data(:,1), Data(:,2), 'r.')
rectangle('Position',[a(1)-R, a(2)-R, 2*R, 2*R],'Curvature',[1,1],'EdgeColor','g')
axis equal