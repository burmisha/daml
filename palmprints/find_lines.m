clear all;
ImagesIdx = [15, 20, 68, 179, 207, 295];
for i=1:length(ImagesIdx)
    Image = imread(sprintf('tiff/%03d.tif',ImagesIdx(i)));
    lr = 2; % low resolution
    LowRes = Image((1:size(Image,1)/lr)*lr,(1:size(Image,2)/lr)*lr,:);
    Y = LowRes(:,:,3);
    d = 9/lr;
    S = ordfilt2(Y,round(d*d*0.65),true(d)) - Y;
    out = ordfilt2(S > 7, 6, true(3));
    imshow(LowRes);
    display 'Press Enter to show detected lines'
    pause
    imshow(1 - out);
    display 'Press Enter to go to next image'
    pause
end
