clear all

N = 1000;
dim = 2;
R = 3;
c = 0.2;
a=[1;2]

Data = get_data(N, dim, a, R, c);
hold off
plot(Data(:,1), Data(:,2), 'r.')
rectangle('Position',[a(1)-R, a(2)-R, 2*R, 2*R],'Curvature',[1,1],'EdgeColor','g')
axis equal