
[img1, img1_dname] = uigetfile('*.jpeg');
img = imread(fullfile(img1_dname, img1));
I = rgb2gray(img);

%making gaussian kernel
sigma = 1;              %standard deviation of the distribution

                
kernel = zeros(5,5);
disp('Initial Kernel');
disp(kernel);
w = 0;                  %sum of elements of kernel
for i = 1:5
    for j = 1:5
        sq_dist = (i-3)^2 + (j-3)^2;
        kernel(i,j) = exp(-1*(sq_dist)/(2*sigma*sigma));
        w = w + kernel(i,j);
    end
end
kernel = kernel*100;
kernel = kernel/w;
disp('Final kernel');
disp(kernel);
%now apply the filter to the image
[m,n] = size(I);
output = zeros(m,n);
Im = padarray(I,[2,2]);
disp(Im);
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

edgeDetection = output - output2;

output = uint8(output);
output2 = uint8(output2);
edgeDetection = uint8(edgeDetection);

subplot(2,2,1),imshow(I),title('original image');

subplot(2,2,2),imshow(output), title('First Blur');

subplot(2,2,3),imshow(output2),title('Second Blur');

subplot(2,2,4),imshow(edgeDetection),title('Difference of Gaussian');

