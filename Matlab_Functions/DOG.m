[img1, img1_dname] = uigetfile('*.jpeg');
img = imread(fullfile(img1_dname, img1));
img = im2double(img(:,:,1));

blur1 = fspecial('gaussian', 21, 0.5);
blur2 = fspecial('gaussian', 21, 30);
disp("test");
disp(blur1);
disp("testover");
dogimage1 = conv2(img, blur1, 'same');
dogimage2 = conv2(img, blur2, 'same');
dogimage3 = dogimage1-dogimage2;
subplot(2,2,1),imshow(I),title('original image');

subplot(2,2,2),imshow(dogimage1), title('First Blur');

subplot(2,2,3),imshow(dogimage2),title('Second Blur');

subplot(2,2,4),imshow(dogimage3), title("Diff of Gaussian");