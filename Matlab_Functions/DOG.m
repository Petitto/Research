[img1, img1_dname] = uigetfile('*.jpeg');
img = imread(fullfile(img1_dname, img1));
img = im2double(img(:,:,1));

blur1 = fspecial('gaussian', 21, 15);
blur2 = fspecial('gaussian', 21, 20);

diffOfGaus = blur1 - blur2;
dogimage = conv2(img, diffOfGaus, 'same');
figure, imshow(dogimage, []);