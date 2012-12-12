function [ D,A ] = get_profile( X )
%GET_PROFILE Summary of this function goes here
%   Detailed explanation goes here
    N = size(X,1)-1;
    clangle = @(x) ((x(:,1).*x(:,4)-x(:,2).*x(:,3) >= 0 ) * 2 -1 ) .*abs(acos((x(:,1).*x(:,3)+x(:,2).*x(:,4))./sqrt((x(:,1).^2+ x(:,2).^2) .*(x(:,3).^2+ x(:,4).^2))))*180/pi;
    A = clangle([X(1:N,1) X(1:N,2) X(2:N+1,1) X(2:N+1,2)]);
    D = sqrt((X(1:N,1)-X(2:N+1,1)).^2 + (X(1:N,2)-X(2:N+1,2)).^2);
    A = cumsum(A);
    D = cumsum(D);
end

