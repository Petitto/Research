
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
disp('Kernel before division');
disp(kernel);
kernel = kernel/w;
disp('Final kernel');
disp(kernel);
%now apply the filter to the image
[m,n] = size(I);
output = zeros(m,n);
Im = padarray(I,[2,2]);

for i=1:m
    for j=1:n
        temp = Im(i:i+4, j:j+4);
        temp = double(temp);
        conv = temp.*kernel;
        output(i,j) = sum(conv(:));
    end
end
output = uint8(output);

%show original and filtered image
%figure(1);
%set(gcf, 'Position', get(0,'Screensize'));
f1 = figure;
f2 = figure;

figure(f1);
imshow(I),title('original image');

figure(f2);
imshow(output), title('output of gaussian filter');


% Log_filter = fspecial('log', [5,5], 4.0); % fspecial creat predefined filter.Return a filter.
%                                         % 25X25 Gaussian filter with SD =25 is created.
% img_LOG = imfilter(img, Log_filter, 'symmetric', 'conv');
% imshow(img_LOG, []);