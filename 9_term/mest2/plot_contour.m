function [ h ] = plot_contour( X, idx )
%PLOT_CONTOUR Summary of this function goes here
%   Detailed explanation goes here
    hold off
    %h = plot(X(:,1), X(:,2), 'r.','LineWidth',1); hold on
    plot(X(idx,1), X(idx,2), 'g-','LineWidth',1); hold on
    plot(X(idx,1), X(idx,2), 'b.','LineWidth',2); hold off
    axis ij;
end

