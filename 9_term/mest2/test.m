NM = 1000000;
SM = 3;
Max = 100;
X = rand(NM,SM)*Max;
Sum = sum(X,2);
MaxSum = SM*Max;
X = 0:(MaxSum/100):MaxSum;
a = zeros(length(X)-1,1);
for i=1:length(X)-1
    a(i) = sum( (Sum > (i-1)*MaxSum/100) .* (Sum < (i*MaxSum/100) ));
end
plot(1:length(a),a,'r.-')
