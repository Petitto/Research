
[img1, img1_dname] = uigetfile('*.jpeg');
img = imread(fullfile(img1_dname, img1));
I = rgb2gray(img);
I = im2double(I(:,:,1));

%making gaussian kernel
sigma = 30;              %standard deviation of the distribution

                
kernel = zeros(5,5);
w = 0;                  %sum of elements of kernel
for i = 1:5
    for j = 1:5
        sq_dist = (i-3)^2 + (j-3)^2;
        kernel(i,j) = exp(-1*(sq_dist)/(2*sigma*sigma));
        w = w + kernel(i,j);
    end
end
disp("kern1");
disp(kernel);
%kernel = kernel*100;
kernel = kernel/w;
disp('Gaussian Kernel');
disp(kernel);
%now apply the filter to the image
[m,n] = size(I);
output = zeros(m,n);
output2 = zeros(m,n);
Im = padarray(I,[2,2]);
for i=1:m
    for j=1:n
        temp = Im(i:i+4, j:j+4);
        temp = double(temp);
        conv = temp.*kernel;
        output(i,j) = sum(conv(:)); %sum of convolution
    end
end

Im2 = padarray(output,[2,2]);
for i=1:m
    for j=1:n
        temp = Im2(i:i+4, j:j+4);
        temp = double(temp);
        conv = temp.*kernel;
        output2(i,j) = sum(conv(:));
    end
end

diffOfGaus = output - output2;

subplot(2,2,1),imshow(I),title('original image');

subplot(2,2,2),imshow(output), title('First Blur');

subplot(2,2,3),imshow(output2),title('Second Blur');

subplot(2,2,4),imshow(diffOfGaus),title('Difference of Gaussian');

