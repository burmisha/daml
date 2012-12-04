clear all;
folder_name = 'data';
fish_prefix = 'fish (';
bird_prefix = 'bird (';
suffix = ').txt';
fish_fileidx = 1:55;
bird_fileidx = 1:52;
number = 1;

% R for fish 15
% R for bird 15
% only 15
% 15 - good, 10 - too
R = 10
for number=fish_fileidx
    X = read_cloud('fish', number);
    idx = get_contour(norm_to_square(X),R);
    plot_contour(X, idx);
    number
end

for number=bird_fileidx
    X = read_cloud('bird', number);
    idx = get_contour(norm_to_square(X),R);
    plot_contour(X, idx);
    number
end
