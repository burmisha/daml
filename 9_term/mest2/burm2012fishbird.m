clear all;
folder_name = 'data';
fish_prefix = 'fish (';
bird_prefix = 'bird (';
suffix = ').txt';
fish_fileidx = 1:55;
bird_fileidx = 1:52;
number = 1;

for number=5
    prefix = fish_prefix;
    file_name = strcat(folder_name, '/', prefix, num2str(number), suffix);
    X = dlmread(file_name, ' ', 1, 0);
    X = X(:,[1 3]);
    X(:,1) = (X(:,1) - min( X(:,1))) / (max(X(:,1)) - min( X(:,1))) * 100;
    X(:,2) = (X(:,2) - min( X(:,2))) / (max(X(:,2)) - min( X(:,2))) * 100;
    hold off
    h = plot(X(:,1), X(:,2), 'r.','LineWidth',1);
    %axis ij;
    hold on

    idx = get_contour(X, 18.986675);
    plot(X(idx,1), X(idx,2), 'g-','LineWidth',1);
    plot(X(idx,1), X(idx,2), 'b.','LineWidth',2);
    number
end
