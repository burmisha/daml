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
R = 10;
F_p = [];
F_a = [];
for number=fish_fileidx
    X = read_cloud('fish', number);
    [idx, P, A]  = get_contour(norm_to_square(X),R);
    F_p = [F_p P];
    F_a = [F_a A];
    % plot_contour(X, idx);
    number
end


B_a = [];
B_p = [];
for number=bird_fileidx
    X = read_cloud('bird', number);
    [idx, P, A]  = get_contour(norm_to_square(X),R);
    B_p = [B_p P];
    B_a = [B_a A];
    % plot_contour(X, idx);
    number
end
hold off
plot(F_p.^2, F_a, 'r.'); hold on
plot(B_p.^2, B_a, 'b.'); hold on
