[img1, img1_dname] = uigetfile('*.jpeg');
img = imread(fullfile(img1_dname, img1));
img = rgb2gray(img);
img = im2double(img(:,:,1));

%scale extrema and difference of gaussian
%blur1 = fspecial('gaussian', 21, 1);
blur = fspecial('gaussian', 21, 8);
blurImgArr = {};
for i=1:19
    if(i == 1)
        blurImgArr{end+1} = conv2(img, blur, 'same');
    else
        blurImgArr{end+1} = conv2(blurImgArr{i-1}, blur, 'same');
    end
end
% image1 = conv2(img, blur, 'same');
% image2 = conv2(image1, blur, 'same');
% image3 = conv2(image2, blur, 'same');
% image4 = conv2(image3, blur, 'same');
numBlurImg = size(blurImgArr);
diffOfGau = {};
for i=1:numBlurImg-1
    if(i == 1)
        diffOfGau{end+1} = img - blurImgArr{i};
    else
        diffOfGau{end+1} = blurImgArr{i} - blurImgArr{i-1};
    end
end
% dog = image1-image2;
% dog1 = image2-image3;
% dog2 = image3-image4;

%padding dog for easier computation
% padDog = padarray(dog, [1,1], 'both');
% padDog1 = padarray(dog1, [1,1], 'both');
% padDog2 = padarray(dog2, [1,1], 'both');
figure(1);
for i=1:numBlurImg
    subplot(2,10,i),imshow(blurImgArr{i});
end
% figure(1);
% subplot(2,2,1),imshow(img),title('original image');
% subplot(2,2,2),imshow(dog), title('DOG');
% subplot(2,2,3),imshow(dog1),title('DOG 1');
% subplot(2,2,4),imshow(dog2), title('DOG 2');
% 
% figure(2);
% subplot(2,2,1),imshow(image1),title('Blur 1');
% subplot(2,2,2),imshow(image2), title('Blur 2');
% subplot(2,2,3),imshow(image3),title('Blur 3');
% subplot(2,2,4),imshow(image4), title('Blur 4');

%finding keypoints
localMax = zeros(1,2);
localMin = zeros(1,2);
xpos = [];
ypos = [];
keypoints = [];
[m,n]  = size(padDog);
for i=1:m-2
    for j=1:n-2
        max = true;
        min = true;
        
        locateMat = padDog(i:i+2, j:j+2);
        locateMat1 = padDog1(i:i+2, j:j+2);
        locateMat2 = padDog2(i:i+2, j:j+2);
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
            xpos = [xpos i];
            ypos = [ypos j];
            keypoints = [keypoints potentialPoint];
            
        end
        
        if(max)
            xpos = [xpos i];
            ypos = [ypos j];
            keypoints = [keypoints potentialPoint];
        end
    end
end

len = size(xpos);
for i=1:len(2)
    fprintf('X-Pos: %d Y-Pos: %d Keypoint: %f\n',xpos(i), ypos(i), keypoints(i));
    img(xpos(i), ypos(i), 1) = 255;
    img(xpos(i), ypos(i), 2) = 0;
    img(xpos(i), ypos(i), 3) = 0;
end

figure(3);
imshow(img);




