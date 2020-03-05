[img1, img1_dname] = uigetfile('*.jpeg');
img = imread(fullfile(img1_dname, img1));
img = rgb2gray(img);
img = im2double(img(:,:,1));

%scale extrema and difference of gaussian
%blur1 = fspecial('gaussian', 21, 1);
blur = fspecial('gaussian', 21, 8);
blurImgArr = {};
octave = cell(5,5);
for r=1:5
    for c=1:5
        if(r==1 && c==1)
            octave{r,c} = img;
        elseif(c==1)
            octave{r,c} = octave{r-1,4};
        else
            octave{r,c} = conv2(octave{r,c-1}, blur, 'same');
        end     
    end
end

numBlurImg = size(blurImgArr);
diffOfGau = cell(4,4);

for r=1:4
    for c=1:4
        diffOfGau{r,c} = padarray(octave{r,c} - octave{r,c+1}, [1,1], 'both');
    end
end

for r=1:5
    figure(r);
    for c=1:5    
        subplot(1,5,c),imshow(octave{r,c});
    end
end

%finding keypointsx
xpos = {};
ypos = {};
keypoints = {};
[m,n]  = size(diffOfGau{1,1});

for row=1:4
    for col=1:4-2
        for r=1:m-2
            for j=1:n-2
                max = true;
                min = true;

                locateMat = diffOfGau{row,col}(r:r+2, j:j+2);
                locateMat1 = diffOfGau{row,col+1}(r:r+2, j:j+2);
                locateMat2 = diffOfGau{row,col+2}(r:r+2, j:j+2);
                potentialPoint = locateMat1(2,2);

                for r=1:3
                    for c=1:3
                        if(r == 2 && c ==2)
                            if(locateMat(r,c) >= potentialPoint || locateMat2(r,c) >= potentialPoint)
                                max = false;
                            end
                            if(locateMat(r,c) <= potentialPoint || locateMat2(r,c) <= potentialPoint)
                                min = false;
                            end
                        % sum number of values greater and less than   
                        else
                            if(locateMat(r,c) >= potentialPoint || locateMat1(r,c) >= potentialPoint || locateMat2(r,c) >= potentialPoint)
                                 max = false;
                            end
                            if(locateMat(r,c) <= potentialPoint || locateMat1(r,c) <= potentialPoint || locateMat2(r,c) <= potentialPoint)
                                min = false;
                            end
                        end
                    end
                end

                if(min)
                    xpos{row, end+1} = j;
                    ypos{row, end+1} = r;
                    keypoints{row, end+1} = potentialPoint;

                end

                if(max)
                   xpos{row, end+1} = j;
                   ypos{row, end+1} = r;
                   keypoints{row, end+1} = potentialPoint;
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
        fprintf('X-Pos: %d Y-Pos: %d Keypoint: %f\n',xpos{r,c}, ypos{r,c}, keypoints{r,c});
        plot(xpos{r,c}, ypos{r,c}, 'o');
    end
    
end





