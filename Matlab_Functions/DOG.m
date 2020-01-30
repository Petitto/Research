[img1, img1_dname] = uigetfile('*.jpeg');
img = imread(fullfile(img1_dname, img1));
img = rgb2gray(img);
img = im2double(img(:,:,1));
%scale extrema and difference of gaussian
%blur1 = fspecial('gaussian', 21, 1);
blur = fspecial('gaussian', 21, 5);
disp("test");
disp(blur1);
disp("testover");
image1 = conv2(img, blur, 'same');
image2 = conv2(image1, blur, 'same');
image3 = conv2(image2, blur, 'same');
image4 = conv2(image3, blur, 'same');

dog = image1-image2;
dog1 = image2-image3;
dog2 = image3-image4;

%finding keypoints
localMax = Max.empty;
localMin = Max.empty;
max = false;
min = true;
[m,n]  = size(img);
for i=1:m
    for j=1:n
        locateMat = dog(i:i+2, j:j+2);
        locateMat1 = dog1(i:i+2, j:j+2);
        locateMat2 = dog3(i:i+2, j:j+2);
        potentialPoint = locateMat1(2,2);
        for r=1:3
            for c=1:3
                if(r == 1 && c ==1)
                    if(locateMat(r,c) > potentialPoint && locateMat2(r,c) > potentialPoint)
                        max = true;
                    elseif(locateMat(r,c) > potentialPoint && locateMat2(r,c) > potentialPoint)
                        min = true;
                    else
                        max = false;
                        min = false; 
                        break;
                    end
                    
                elseif(locateMat(r,c) > potentialPoint && locateMat1(r,c) > potentialPoint && locateMat2(r,c) > potentialPoint)
                     max = true;
                elseif(locateMat(r,c) < potentialPoint && locateMat1(r,c) < potentialPoint && locateMat2(r,c) < potentialPoint)
                    min = true;
                else
                    min = false;
                    max = false;
                    break;
                end
            end
        end
        
        if(min)
            append(localMin,potentialPoint);
        elseif(max)
            append(localMax,potentialPoint);
        end
    end
end


figure(1)
subplot(2,2,1),imshow(img),title('original image');

subplot(2,2,2),imshow(dog), title('DOG');

subplot(2,2,3),imshow(dog1),title('DOG 1');

subplot(2,2,4),imshow(dog2), title('DOG 2');

figure(2);
subplot(2,2,1),imshow(image1),title('Blur 1');

subplot(2,2,2),imshow(image2), title('Blur 2');

subplot(2,2,3),imshow(image3),title('Blur 3');

subplot(2,2,4),imshow(image4), title('Blur 4');


