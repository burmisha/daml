clear all;
ImagesIdx = [15, 20, 68, 179, 207, 295];
for i=1%:length(ImagesIdx)
    %Image = imread(sprintf('tiff/%03d.tif',ImagesIdx(i)));
    Image = imread(sprintf('tiff/2.png',ImagesIdx(i)));
    lr = 1; % low resolution
    LowRes = Image((1:size(Image,1)/lr)*lr,(1:size(Image,2)/lr)*lr,:);
    Y = LowRes(:,:,3);
    d = 9/lr;
    S = ordfilt2(Y,round(d*d*0.65),true(d)) - Y;
    BW = ordfilt2(S > 7, 6, true(3));
    imshow(BW), hold on
    %pause
    [acc_copy,T,R] = hough(BW);
    %imshow(H,[],'XData',T,'YData',R, 'InitialMagnification','fit');
    % Find lines and plot them
    P  = houghpeaks(acc_copy,10,'threshold',ceil(0.2*max(acc_copy(:))));
    lines = houghlines(BW,T,R,P,'FillGap',500,'MinLength',10);
    %imshow(LowRes), hold on
    for k = 1:length(lines)
       xy = [lines(k).point1; lines(k).point2];
       plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
       plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
       plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
    end
    
    BW = [
        0 0 0 0 0 0 0 0 0 0;
        0 0 0 0 0 0 0 0 0 0;
        0 0 0 0 0 0 0 0 0 0;
        0 0 1 1 0 0 0 0 0 0;
        0 1 0 0 1 0 0 0 0 0;
        0 1 0 0 1 0 0 0 0 0;
        0 0 1 1 0 0 0 0 0 0;
        0 0 0 0 0 0 0 0 0 0;
        0 0 0 0 0 0 0 0 0 0;
        0 0 0 0 0 0 0 0 0 0;
        ];
    
    r = 1;
    Nx = 1:1:size(BW, 1);
    Ny = 1:1:size(BW, 2);

    acc = zeros(length(r), length(Nx), length(Ny));
    for x=1:size(BW, 1)
        row = BW(x,:);
        for y=find(row==1)
            [xx, yy] = meshgrid(Nx, Ny);
            rr = sqrt((x-xx).^2 + (y-yy).^2);
            [idx_xy, idx_r] = ismember(round(rr), r);
            [xc,yc] = ind2sub(size(idx_xy), find(idx_r~=0));
            rc=idx_r(idx_r~=0);
            subCell = num2cell([rc,xc,yc],2);
            %idx_xy = ind2sub([length(Nx), length(Ny)], find(idx_r~=0));
            %idx_r = idx_r(idx_r~=0);
            acc(subCell{:}) = acc(subCell{:}) + 1./rc;
        end
        squeeze(acc)
        imshow(squeeze(acc))
        x/size(BW, 1)
    end

    acc_copy = acc;
    hold off;
    imshow(BW)
    hold on;

    for j=1:5
        [m, id] = max(acc_copy(:));
        [ridx, xidx, yidx]  = ind2sub(size(acc_copy), id);
        rm = r(ridx);
        xm = Nx(xidx);
        ym = Ny(yidx);
        acc_copy(ridx, xidx, yidx) = 0;
        rectangle('Position',[ym-rm,xm-rm,2*rm,2*rm],'Curvature',[1,1],'LineWidth',1.5,'EdgeColor','red')
    end
end
