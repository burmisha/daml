% http://www.matlabtips.com/realtime-processing/
vid = videoinput('winvideo', 1, 'YUY2_640x480');
preview(vid);
vid
data = getsnapshot(vid);