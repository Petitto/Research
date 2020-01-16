%choose a picture
[img1, img1_dname] = uigetfile('*.jpeg');
[img2, img2_dname] = uigetfile('*.jpeg');

I1 = rgb2gray(imread(fullfile(img1_dname, img1)));
I2 = rgb2gray(imread(fullfile(img2_dname, img2)));
%find SURF points
points1 = detectSURFFeatures(I1);
points2 = detectSURFFeatures(I2);

[features1, valid_points1] = extractFeatures(I1, points1);
[features2, valid_points2] = extractFeatures(I2, points2);

indexPairs = matchFeatures(features1,features2);

matchedPoints1 = valid_points1(indexPairs(:,1));
matchedPoints2 = valid_points2(indexPairs(:,2));

figure; 
showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2);



[F, epipolarInliers, status] = estimateFundamentalMatrix(matchedPoints1, matchedPoints2,...
    'Method', 'RANSAC', 'NumTrials', 2000, 'DistanceThreshold', 1e-4);
disp(F);
%need to decompose r matrix, find dimensions, understand results
[r,t]=relativeCameraPose(F,cameraParams,matchedPoints1, matchedPoints2);
%theta in radia -pi to pi
theta_X = atan2(r(3,2), r(3,3));
theta_Y = atan2(-r(3,1), sqrt((r(3,2)^2 + r(3,3)^2)));
theta_Z = atan2(r(2,1), r(1,1));

%decompose r matrix to x, y, z
r_X = [1 0 0; 0 cos(theta_X) -sin(theta_X); 0 sin(theta_X) cos(theta_X)];
r_Y = [cos(theta_Y) 0 sin(theta_Y); 0 1 0; -sin(theta_Y) 0 cos(theta_Y)];
r_Z = [cos(theta_Z) -sin(theta_Z) 0; sin(theta_Z) cos(theta_Z) 0; 0 0 1];

%want to compute estimated R to actual R
compare_R = r_Z*r_Y*r_X;

disp("Transition");
disp(t);

disp(r);

disp("Theta_X");
disp(theta_X);
disp("Theta_Y");
disp(theta_Y);
disp("theta_Z");
disp(theta_Z);


disp(compare_R);

% if(status ~= 0 || isEpipoleInImage(F, size(I1)) || isEpipoleInImage(F, I2))
%     error(['Either not enough matching points were found or '...
%          'the epipoles are inside the images. You may need to '...
%          'inspect and improve the quality of detected features ',...
%          'and/or improve the quality of your images.']);
% end

inlierPoints1 = matchedPoints1(epipolarInliers, :);
inlierPoints2 = matchedPoints2(epipolarInliers,:);

[t1, t2]= estimateUncalibratedRectification(F, ...
  inlierPoints1.Location, inlierPoints2.Location, size(I2));
tform1 = projective2d(t1);
tform2 = projective2d(t2);

[I1Rect, I2Rect] = rectifyStereoImages(I1, I2, tform1, tform2);
figure;
rectifyImage = stereoAnaglyph(I1Rect, I2Rect);
imshow(rectifyImage);
title('Rectified Stereo Images (Red - Left Image, Cyan - Right Image)');

rectifyImage = rgb2gray(rectifyImage);
pointRectify = detectSURFFeatures(rectifyImage);
[featuresRectify, valid_pointsRectify] = extractFeatures(rectifyImage, pointRectify);

indexPairs2 = matchFeatures(features1,featuresRectify);
matchedPoints1 = valid_points1(indexPairs2(:,1));
matchedPointsRectify = valid_pointsRectify(indexPairs2(:,2));

figure;
showMatchedFeatures(I1, rectifyImage, matchedPoints1, matchedPointsRectify, 'montage');

