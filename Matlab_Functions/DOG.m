[img1, img1_dname] = uigetfile('*.jpeg');
img = imread(fullfile(img1_dname, img1));
img = rgb2gray(img);
img = im2double(img(:,:,1));

%scale extrema and difference of gaussian

%figure out kernel size

% figure(7)
% testimg = conv2(img,fspecial('gaussian', 100, 2),'same');
% imshow(testimg)

octave = cell(5,5);
%blur by exact values instead of previous image
blurStrength = 2^(1/3);
blur = fspecial('gaussian', 100, blurStrength);
cnt = 1;
for rTemp=1:5   
    for c=1:5
        if(rTemp==1 && c==1)
            octave{rTemp,c} = img;
            fprintf('row = %d, col = %d, blurStrength = %d\n', rTemp, c, blurStrength^cnt);
        elseif(c==1)
            octave{rTemp,c} = octave{rTemp-1,4};
            cnt = cnt - 1;
            fprintf('row = %d, col = %d, blurStrength = %d\n', rTemp, c, blurStrength^cnt);
        else
            octave{rTemp,c} = conv2(octave{rTemp,c-1}, blur, 'same');
            fprintf('row = %d, col = %d, blurStrength = %d\n', rTemp, c, blurStrength^cnt);
            blur = fspecial('gaussian', 100, blurStrength^cnt);
            cnt = cnt + 1;
        end     
    end
end

diffOfGau = cell(5,4);

for rTemp=1:5
    for c=1:4
        diffOfGau{rTemp,c} = padarray(octave{rTemp,c} - octave{rTemp,c+1}, [1,1], 'both');
    end
end

for rTemp=1:5
    figure(rTemp);
    for c=1:5    
        subplot(1,5,c),imshow(octave{rTemp,c});
    end
end

%finding keypoints fix memory allocation
xpos = {};
ypos = {};
keypoints = {};
[m,n]  = size(diffOfGau{1,1});

for row=1:5
    keyPointPerRow = 1;
    for col=1:4-2
        for r=1:m-2
            for j=1:n-2
                max = true;
                min = true;

                locateMat = diffOfGau{row,col}(r:r+2, j:j+2);
                locateMat1 = diffOfGau{row,col+1}(r:r+2, j:j+2);
                locateMat2 = diffOfGau{row,col+2}(r:r+2, j:j+2);
                potentialPoint = locateMat1(2,2);

                for rTemp=1:3
                    for c=1:3
                        if(rTemp == 2 && c ==2)
                            if(locateMat(rTemp,c) >= potentialPoint || locateMat2(rTemp,c) >= potentialPoint)
                                max = false;
                            end
                            if(locateMat(rTemp,c) <= potentialPoint || locateMat2(rTemp,c) <= potentialPoint)
                                min = false;
                            end
                        % sum number of values greater and less than
                        else
                            if(locateMat(rTemp,c) >= potentialPoint || locateMat1(rTemp,c) >= potentialPoint || locateMat2(rTemp,c) >= potentialPoint)
                                 max = false;
                            end
                            if(locateMat(rTemp,c) <= potentialPoint || locateMat1(rTemp,c) <= potentialPoint || locateMat2(rTemp,c) <= potentialPoint)
                                min = false;
                            end
                        end
                    end
                end

                if(min)
                    xpos{row, keyPointPerRow}= j;
                    ypos{row, keyPointPerRow} = r;
                    keypoints{row, keyPointPerRow} = potentialPoint;
                    keyPointPerRow = keyPointPerRow + 1;

                end

                if(max)
                   xpos{row, keyPointPerRow} = j;
                   ypos{row, keyPointPerRow} = r;
                   keypoints{row, keyPointPerRow} = potentialPoint;
                   keyPointPerRow = keyPointPerRow + 1;
                end
            end
        end
    end
end


[m,n] = size(xpos);
figure(6);
imshow(img); hold on;
for r=1:m
    for c=1:n
       % fprintf('X-Pos: %d Y-Pos: %d Keypoint: %f\n',xpos{r,c}, ypos{r,c}, keypoints{r,c});
       if(r==1)
            plot(xpos{r,c}, ypos{r,c}, '+r');
       elseif(r==2)
           plot(xpos{r,c}, ypos{r,c}, '+b');
       elseif(r==3)
           plot(xpos{r,c}, ypos{r,c}, '+g');
       elseif(r==4)
           plot(xpos{r,c}, ypos{r,c}, '+y');
       else
           plot(xpos{r,c}, ypos{r,c}, '+w');
       end
         
    end
    
end





