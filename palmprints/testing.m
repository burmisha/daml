% Add the callback function directory to the MATLAB® path.
utilpath = fullfile(matlabroot, 'toolbox', 'imaq', 'imaqdemos', 'helper');
addpath(utilpath)

vidobj = videoinput('winvideo'); % Access an image acquisition device.
set(vidobj, 'ReturnedColorSpace', 'grayscale') % Convert the input images to grayscale.
vidRes = get(vidobj, 'VideoResolution'); % Retrieve the video resolution.
f = figure('Visible', 'off'); % Create a figure and an image object.
imageRes = fliplr(vidRes);
subplot(1,2,1);
hImage = imshow(zeros(imageRes));
axis image; % fix aspect ratio of the

setappdata(hImage,'UpdatePreviewWindowFcn',@update_livehistogram_display);

% The PREVIEW function starts the camera and display. The image on which to
% display the video feed is also specified.
preview(vidobj, hImage);

% View the histogram for 30 seconds.
pause
stoppreview(vidobj);   delete(f);

delete(vidobj)
clear vidobj