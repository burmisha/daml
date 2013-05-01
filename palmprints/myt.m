% Create a video input object.
obj = videoinput('winvideo');
figure('Name', 'My Custom Preview Window'); 
uicontrol('String', 'Close', 'Callback', 'close(gcf)');  

vidRes = get(obj, 'VideoResolution'); 
nBands = get(obj, 'NumberOfBands'); 
hImage = image( zeros(vidRes(2), vidRes(1), nBands) ); 
preview(obj, hImage);