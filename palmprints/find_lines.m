clear;
X = imread('tiff/207.tif');
Y = rgb2gray(X);
Y = X(:,:,3);

d = 9;
% Y = imfilter(Y, fspecial('gaussian',2, 2));
% R = medfilt2(Y, [3 3]);
S = ordfilt2(Y,round(d*d*0.65),true(d)) - Y;
%T = fspecial('gaussian', 2, 7); 
%RR = R - imfilter(R, T);
% imshow(edge(RR,'prewitt'))
imshow(ordfilt2(S > 7, 6, true(3)))
% imshow(X)
%%
% Y = histeq(Y, 0:2:255);
 Y(Y < 50) = 0;
% Y(Y > 70) = 255;
d = 7; B = medfilt2(Y, [d d]);
T = fspecial('gaussian',4, 6); BB = imfilter(Y, T);
% R = abs(int32(B - Y).*int32(BB-Y)/255);
%R = R/max(max(R))*255;
R = (B - Y) .* (BB - Y);
%R = B - Y;
%R = medfilt2(R,[3 3]);
R = wiener2(R,[8 8]);
%RR = imfilter(R, fspecial('gaussian',2, 2));
%R = medfilt2(R,[3 3]);
gamma = 0.3;
J = imadjust(double(R)/255, [0; 1], [0; 1], gamma);
J = J > 0;
imshow(R)
%imhist(R)

%imhist(Y)

% ScreenCapture('task_1.jpg')
% close
%%

% task 2
I = histeq(Y, 0:2:200);
imhist(I)
ScreenCapture('task_2a.jpg')
close
imwrite(I, 'task_2b.jpg', 'Quality', 90);
imwrite(Y, 'task_2c.jpg', 'Quality', 90);

% task 3
gamma = 0.7;
J = imadjust(Y, [0; 1], [0; 1], gamma);
imwrite(J, 'task_3_07.jpg', 'Quality', 90);
gamma = 1.5;
J = imadjust(Y, [0; 1], [0; 1], gamma);
imwrite(J, 'task_3_15.jpg', 'Quality', 90);


% task 5
%T1 = ones(3,3)/9;
%T2 = [0, 1, 0; 1, 2, 1;  0, 1, 0]/8;
T = fspecial('gaussian',5, 20);
B = imfilter(Ca, T);
imwrite(B, 'task_5.jpg', 'Quality', 90);

% task 6
B = imfilter(Cb, T);
imshow(B)

B = medfilt2(Cb, [3 3]);
imshow(B)
imwrite(B, 'task_6.jpg', 'Quality', 90);

% task 7
p = plot(conv(Ca(100,:), [-1 1]))
hold on
plot(conv(Y(100,:), [-1 1]));
set(p,'Color','red')
saveas(p, 'task_7.jpg', 'jpg')
hold off
close

% task 8
imwrite(edge(Y,'sobel'), 'task_8a_sobel.jpg', 'Quality', 90);
imwrite(edge(Y,'prewitt'), 'task_8b_prewitt.jpg', 'Quality', 90);
imwrite(edge(Y,'canny'), 'task_8c_canny_best.jpg', 'Quality', 90);