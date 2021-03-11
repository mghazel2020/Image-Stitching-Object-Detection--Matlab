function [status, panoramaImage] = stitchSceneImages(sceneImages,...
                                                     featureDetector)
%==========================================================================
% Project: Zebra Technologies - Homework Assignment
%==========================================================================
% File: stitchSceneImages.m
% Author: Mohsen Ghazel 
% Date: Nov 23, 2018
%==========================================================================
% Specifications: 
% -------------------------------------------------------------------------
% - This function stitches the scene images and constructs a panorama from
%   all of them.
% ------------------------------------------------------------------------- 
% - It implements feature-based techniques are used to automatically 
%   stitch together a set of images. 
% - The procedure for image stitching is an extension of feature based 
%   image registration. 
% - Instead of registering a single pair of images, multiple image pairs 
%   are successively registered relative to each other and then 
%   stitched together to form a panorama.
%--------------------------------------------------------------------------
% Intput:
%--------------------------------------------------------------------------
% - sceneImages:     Scene images in a MATLAB imageDataStore format
% - featureDetector  The feature detector to be applied to detect features
%--------------------------------------------------------------------------
% Output:
%--------------------------------------------------------------------------
%  - status = 1 for success and 0 for failure
%  - panoramaImage: The panorama image composed of all the scene images
%                   stitched together
%--------------------------------------------------------------------------
% Execution: 
%
% >> [status, panoramaImage] = stitchSceneImages(sceneImages,...
%                                                featureDetector);
%==========================================================================
% History
%==========================================================================
% Date                      Changes
%--------------------------------------------------------------------------
% 11/14/2018                Initial definition
% 11/23/2018                Final version
%==========================================================================
% Software requirements/dependencies
%==========================================================================
% Developed and tested on:
% --------------------------------------------------------------------------
% MATLAB Version: 9.5.0.944444 (R2018b)
% MATLAB License Number: 0
% Operating System: Microsoft Windows 10 Home Version 10.0 (Build 17134)
% Java Version: Java 1.8.0_152-b16 with Oracle Corporation Java HotSpot(TM) 
% 64-Bit Server VM mixed mode
% -------------------------------------------------------------------------
% MATLAB                                    Version 9.5         (R2018b)
% Computer Vision System Toolbox            Version 8.2         (R2018b)
% Image Processing Toolbox                  Version 10.3        (R2018b)
% Signal Processing Toolbox                 Version 8.1         (R2018b)
%==========================================================================
% Copyright
%==========================================================================
% (c) Zebra Technologies (2018)
%==========================================================================
% suppress warnings
warning('off');

% execution status
status = 1;

% close all figures
close('all');

% a display flag
displayFlag = 1;

% set figures visibility
if ( displayFlag == 0 )
    set(0,'DefaultFigureVisible','off');
else
    set(0,'DefaultFigureVisible','on');
end

%==========================================================================
% Step 1 - Register image pairs
%==========================================================================
fprintf(1, '---------------------------------------------------------------\n');
fprintf(1, 'Step 1: Register image pairs:\n');
fprintf(1, '---------------------------------------------------------------\n');
%--------------------------------------------------------------------------
% We start by registering successive image pairs using the following 
% procedure:
% 
% 1) Detect and match features between consecutive image pairs: I(n) and 
%    I(n-1).
% 2) Estimate the geometric transformation, T(n), that maps I(n) to I(n-1).
% 3) Compute the transformation that maps image I(n) into the panorama 
%    image as the product of all consecutive transformation: T(n)*T(n-1)*...T(1)
%--------------------------------------------------------------------------
% number of images in the scene
numImages = numel(sceneImages.Files);

% Read the first image from the image set.
I = readimage(sceneImages, 1);

% convert to grayscale if color
if ( size(I, 3) > 1 )
    grayImage = rgb2gray(I);
else
    grayImage = (I);
end

%--------------------------------------------------------------------------
% Step 1.1: Detect the feature points in the image
%--------------------------------------------------------------------------
% initialize the feature points
points = [];
%--------------------------------------------------------------------------
% Detect the features depending on the specified featureDetector approach:
%  - if featureDetector = 'SURF', use MATLAB detectSURFFeatures()
%  - if featureDetector = 'BRISK', use MATLAB detectBRISKFeatures()
%  - if featureDetector = 'HARRIS', use MATLAB detectHarrisFeatures()
%  - if featureDetector = 'FAST', use MATLAB detectHarrisFeatures()
%--------------------------------------------------------------------------
% if featureDetector = 'SURF', use MATLAB detectSURFFeatures()
if ( strcmp(featureDetector, 'SURF' ) == 1 )
    points = detectSURFFeatures(grayImage);
% if featureDetector = 'BRISK', use MATLAB detectBRISKFeatures()
elseif ( strcmp(featureDetector, 'BRISK' ) == 1 )
    points = detectBRISKFeatures(grayImage);
% if featureDetector = 'HARRIS', use MATLAB detectHarrisFeatures()
elseif ( strcmp(featureDetector, 'HARRIS' ) == 1 )
    points = detectHarrisFeatures(grayImage);
% if featureDetector = 'FAST', use MATLAB detectFASTFeatures()
elseif ( strcmp(featureDetector, 'FAST' ) == 1 )
    points = detectFASTFeatures(grayImage);
else
    % display a message
    fprintf(1, 'Invalid FeatureDetector = %s\n', featureDetector);
    fprintf(1, 'Only: SURF, BRISK, FATS and Harris feature detectors are supported!\n');
    
    % set status to success
    status = -1;

    % return
    return;
end

%--------------------------------------------------------------------------
% Step 1.2: Extract the detected feature points in the image
%--------------------------------------------------------------------------
[features, points] = extractFeatures(grayImage, points);

%--------------------------------------------------------------------------
% Step 1.3: Estimate the geometric transformation between the first image
%           and every other image
%--------------------------------------------------------------------------
% Initialize all the transforms to the identity matrix. 
%--------------------------------------------------------------------------
geometricTransforms(numImages) = projective2d(eye(3));

% Initialize variable to hold image sizes.
imageSize = zeros(numImages,2);

% Iterate over remaining image pairs
for n = 2:numImages

    % Store points and features for I(n-1).
    pointsPrevious = points;
    featuresPrevious = features;

    % Read the next scene image: I(n).
    I = readimage(sceneImages, n);

    % Convert the image to grayscale.
    grayImage = rgb2gray(I);

    % Save image size.
    imageSize(n,:) = size(grayImage);

    % Detect and extract the features for I(n), depending on the
    % specified featureDetector 
    % initialize the feature points
    points = [];
    
    %----------------------------------------------------------------------
    % Detect the features depending on the specified featureDetector 
    % approach:
    %  - if featureDetector = 'SURF', use MATLAB detectSURFFeatures()
    %  - if featureDetector = 'BRISK', use MATLAB detectBRISKFeatures()
    %  - if featureDetector = 'HARRIS', use MATLAB detectHarrisFeatures()
    %  - if featureDetector = 'FAST', use MATLAB detectHarrisFeatures()
    %----------------------------------------------------------------------
    % if featureDetector = 'SURF', use MATLAB detectSURFFeatures()
    if ( strcmp(featureDetector, 'SURF' ) == 1 )
        points = detectSURFFeatures(grayImage);
    % if featureDetector = 'BRISK', use MATLAB detectBRISKFeatures()
    elseif ( strcmp(featureDetector, 'BRISK' ) == 1 )
        points = detectBRISKFeatures(grayImage);
    % if featureDetector = 'HARRIS', use MATLAB detectHarrisFeatures()
    elseif ( strcmp(featureDetector, 'HARRIS' ) == 1 )
        points = detectHarrisFeatures(grayImage);
    % if featureDetector = 'FAST', use MATLAB detectFASTFeatures()
    elseif ( strcmp(featureDetector, 'FAST' ) == 1 )
        points = detectFASTFeatures(grayImage);
    else
        % display a message
        fprintf(1, 'Invalid FeatureDetector = %s\n', featureDetector);
        fprintf(1, 'Only: SURF, BRISK, FATS and Harris feature detectors are supported!\n');

        % set status to success
        status = -1;

        % return
        return;
    end

    % extract the features
    [features, points] = extractFeatures(grayImage, points);

    %----------------------------------------------------------------------
    % Find correspondences between the extracted features of I(n) and I(n-1)
    % using MATLAB feature matching function:
    %----------------------------------------------------------------------
    % MATLAB documentation:
    %----------------------------------------------------------------------
    % >>help matchFeatures
    % matchFeatures Find matching features
    % indexPairs = matchFeatures(features1, features2) returns a P-by-2
    % matrix, indexPairs, containing indices to the features most likely to
    % correspond between the two input feature matrices. The function takes
    % two inputs, features1, an M1-by-N matrix, and features2, an M2-by-N
    % matrix. features1 and features2 can also be binaryFeatures objects in 
    % the case of binary descriptors produced by the FREAK descriptor.
    % 
    % [indexPairs, matchMetric] = matchFeatures(features1, features2, ...)
    % also returns the metric values that correspond to the associated
    % features indexed by indexPairs in a P-by-1 matrix matchMetric.
    % 
    % [indexPairs, matchMetric] = matchFeatures(...,Name, Value) specifies
    % additional name-value pairs described below:
    % 
    % 'Method'           A string used to specify how nearest neighbors
    %                    between features1 and features2 are found.
    % 
    %                    'Exhaustive': Matches features1 to the nearest
    %                                  neighbors in features2 by computing
    %                                  the pair-wise distance between
    %                                  feature vectors in features1 and
    %                                  features2.
    % 
    %                    'Approximate': Matches features1 to the nearest
    %                                   neighbors in features2 using an
    %                                   efficient approximate nearest
    %                                   neighbor search. Use this method for
    %                                   large feature sets
    % 
    %                    Default: 'Exhaustive'
    % 
    % 'MatchThreshold'   A scalar T, 0 < T <= 100, that specifies the
    %                    distance threshold required for a match. A pair of
    %                    features are not matched if the distance between
    %                    them is more than T percent from a perfect match.
    %                    Increase T to return more matches.
    % 
    %                    Default: 10.0 for binary feature vectors 
    %                              1.0 otherwise
    % 
    % 'MaxRatio'         A scalar R, 0 < R <= 1, specifying a ratio threshold
    %                    for rejecting ambiguous matches. Increase R to
    %                    return more matches.
    % 
    %                    Default: 0.6
    % 
    % 'Metric'           A string used to specify the distance metric. This
    %                    parameter is not applicable when features1 and
    %                    features2 are binaryFeatures objects.
    % 
    %                    Possible values are:
    %                      'SAD'         : Sum of absolute differences
    %                      'SSD'         : Sum of squared differences 
    % 
    %                    Default: 'SSD'
    % 
    %                    Note: When features1 and features2 are
    %                          binaryFeatures objects, Hamming distance is
    %                          used to compute the similarity metric.
    % 
    % 'Unique'           A logical scalar. Set this to true to return only
    %                    unique matches between features1 and features2.
    % 
    %                    Default: false
    % 
    % Notes
    % ----- 
    % The range of values of matchMetric varies as a function of the feature
    % matching metric being used. Prior to computation of SAD and SSD
    % metrics, the feature vectors are normalized to unit vectors using the
    % L2 norm. The table below summarizes the metric ranges and perfect match
    % values:
    % 
    %    Metric      Range                            Perfect Match Value
    %    ----------  -------------------------------  ------------------- 
    %    SAD         [0, 2*sqrt(size(features1, 2))]          0
    %    SSD         [0, 4]                                   0
    %    Hamming     [0, features1.NumBits]                   0
    % 
    % Class Support
    % -------------
    % features1 and features2 can be logical, int8, uint8, int16, uint16,
    % int32, uint32, single, double, or binaryFeatures object.
    % 
    % The output class of indexPairs is uint32. matchMetric is double when
    % features1 and features2 are double. Otherwise, it is single.
    %----------------------------------------------------------------------
    indexPairs = matchFeatures(features, featuresPrevious, 'Unique', true);

    % save the matched points
    matchedPoints = points(indexPairs(:,1), :);
    matchedPointsPrev = pointsPrevious(indexPairs(:,2), :);

    %----------------------------------------------------------------------
    % Estimate the transformation between I(n) and I(n-1) using the
    % estimateGeometricTransform() MATLAB function:
    %----------------------------------------------------------------------
    % MATLAB documentation
    %----------------------------------------------------------------------
    % >> help estimateGeometricTransform
    %----------------------------------------------------------------------
    % estimateGeometricTransform Estimate geometric transformation from 
    % matching point pairs.
    %
    % tform = estimateGeometricTransform(matchedPoints1,matchedPoints2,
    % transformType) returns a 2-D geometric transform which maps the inliers
    % in matchedPoints1 to the inliers in matchedPoints2. matchedPoints1 and 
    % matchedPoints2 can be M-by-2 matrices of [x,y] coordinates or objects of
    % any of the point feature types. transformType can be 'similarity', 'affine', 
    % or 'projective'. Outliers in matchedPoints1 and matchedPoints2 are 
    % excluded by using the M-estimator SAmple Consensus (MSAC) algorithm. 
    % The MSAC algorithm is a variant of the Random Sample Consensus (RANSAC)
    % algorithm. The returned tform is an affine2d object if transformType is
    % set to 'similarity' or 'affine', and is a projective2d object otherwise.
    % 
    % [tform,inlierPoints1,inlierPoints2] = estimateGeometricTransform(...)
    % additionally returns the corresponding inlier points in inlierPoints1
    % and inlierPoints2.
    % 
    % [tform,inlierPoints1,inlierPoints2,status] =
    % estimateGeometricTransform(...) additionally returns a status code with
    % the following possible values:
    % 
    %   0: No error. 
    %   1: matchedPoints1 and matchedPoints2 do not contain enough points.
    %   2: Not enough inliers have been found.
    % 
    % When the STATUS output is not given, the function will throw an error
    % if matchedPoints1 and matchedPoints2 do not contain enough points or
    % if not enough inliers have been found.
    % 
    % [...] = estimateGeometricTransform(matchedPoints1,matchedPoints2, 
    % transformType,Name,Value) specifies additional
    % name-value pair arguments described below:
    % 
    % 'MaxNumTrials'        A positive integer scalar specifying the maximum
    %                       number of random trials for finding the inliers.
    %                       Increasing this value will improve the robustness
    %                       of the output at the expense of additional
    %                       computation.
    % 
    %                       Default value: 1000
    % 
    % 'Confidence'          A numeric scalar, C, 0 < C < 100, specifying the
    %                       desired confidence (in percentage) for finding
    %                       the maximum number of inliers. Increasing this
    %                       value will improve the robustness of the output
    %                       at the expense of additional computation.
    % 
    %                       Default value: 99
    % 
    % 'MaxDistance'         A positive numeric scalar specifying the maximum
    %                       distance in pixels that a point can differ from
    %                       the projection location of its associated point.
    % 
    %                       Default value: 1.5
    % 
    % Class Support
    % -------------
    % matchedPoints1 and matchedPoints2 can be double, single, or any of the
    % point feature types.
    %----------------------------------------------------------------------
    [geometricTransforms(n), inlierpts1, inlierpts2, estimateGeometricTransformStatus] =...
        estimateGeometricTransform(matchedPoints, matchedPointsPrev,...
        'projective', 'Confidence', 99.9, 'MaxNumTrials', 2000);
    
    %----------------------------------------------------------------------
    % - We need at least 3 good inliers to construct the transformation relating the
    %   matched points
    % - If less than 3 matches, then we canntot construct the transformation
    %----------------------------------------------------------------------
    % check the exeusion status of: estimateGeometricTransform(...)
    %----------------------------------------------------------------------
    % status	Description
    %----------------------------------------------------------------------
    % 0	No error.
    % 1	matchedPoints1 and matchedPoints2 inputs do not contain enough points.
    % 2	Not enough inliers found.
    %----------------------------------------------------------------------
    if ( estimateGeometricTransformStatus > 0 )
        % display a message
        fprintf(1, 'Not enough inliers found.\n');
        
        % return
        continue;
    end

    % Compute the composition transformation defined by: 
    % T = T(n) * T(n-1) * ... * T(1)
    geometricTransforms(n).T = geometricTransforms(n).T * geometricTransforms(n-1).T;
end

%--------------------------------------------------------------------------
% At this point, all the transformations in geometricTransforms are 
% relative to the first image:
%
% - This was a convenient way to code the image registration
%    procedure because it allowed sequential processing of all the images.
% 
% - However, using the first image as the start of the panorama does not
%   produce the most aesthetically pleasing panorama because it tends to
%   distort most of the images that form the panorama. 
%
% - A nicer panorama can be created by modifying the transformations such 
%   that the center of the scene is the least distorted. 
%
% - This is accomplished by inverting the transform for the center image 
%   and applying that transform to all the others.
% 
% - Start by using the projective2d outputLimits method to find the output
%   limits for each transform. 
%
% - The output limits are then used to automatically find the image that 
%   is roughly in the center of the scene.
%--------------------------------------------------------------------------
% Compute the output limits for each transform
for i = 1:numel(geometricTransforms)
    [xlim(i,:), ylim(i,:)] = outputLimits(geometricTransforms(i), [1 imageSize(i,2)], [1 imageSize(i,1)]);
end
%--------------------------------------------------------------------------
% - Next, compute the average X limits for each transforms and find the 
%   image that is in the center. 
% - Only the X limits are used here because the scene is known to be 
%   horizontal. 
% - If another set of images are used, both the X and Y 
%   limits may need to be used to find the center image.
%--------------------------------------------------------------------------
avgXLim = mean(xlim, 2);
[~, idx] = sort(avgXLim);
centerIdx = floor((numel(geometricTransforms)+1)/2);
centerImageIdx = idx(centerIdx);

% Finally, apply the center image's inverse transform to all the others.
Tinv = invert(geometricTransforms(centerImageIdx));
for i = 1:numel(geometricTransforms)
    geometricTransforms(i).T = geometricTransforms(i).T * Tinv.T;
end

%--------------------------------------------------------------------------
% Step 3: Initialize the Panorama now, create an initial, empty, panorama
% into which all the images are mapped.
%-------------------------------------------------------------------------- 
% Use the outputLimits method to compute the minimum and maximum output
% limits over all transformations. These values are used to automatically
% compute the size of the panorama.
%--------------------------------------------------------------------------
for i = 1:numel(geometricTransforms)
    [xlim(i,:), ylim(i,:)] = outputLimits(geometricTransforms(i), [1 imageSize(i,2)], [1 imageSize(i,1)]);
end

% maximum image size
maxImageSize = max(imageSize);

% Find the minimum and maximum output limits
% x-coordinates
xMin = min([1; xlim(:)]);
xMax = max([maxImageSize(2); xlim(:)]);
% y-coordinates
yMin = min([1; ylim(:)]);
yMax = max([maxImageSize(1); ylim(:)]);

% Compute the width and height of panorama.
width  = round(xMax - xMin);
height = round(yMax - yMin);

% Initialize the empty panorama.
panoramaImage = zeros([height width 3], 'like', I);

%--------------------------------------------------------------------------
% Step 4 - Create the panoramaImage: 
%--------------------------------------------------------------------------
% Use imwarp to map images into the panoramaImage and use 
% vision.AlphaBlender to overlay the images together.
%--------------------------------------------------------------------------
blender = vision.AlphaBlender('Operation', 'Binary mask', ...
    'MaskSource', 'Input port');

%--------------------------------------------------------------------------
% Create a 2-D spatial reference object defining the size of the 
% panoramaImage.
%--------------------------------------------------------------------------
xLimits = [xMin xMax];
yLimits = [yMin yMax];
panoramaView = imref2d([height width], xLimits, yLimits);

% Create the panoramaImage.
for i = 1:numImages
    
    % read the next ime
    I = readimage(sceneImages, i);

    % Transform I into the panoramaImage.
    warpedImage = imwarp(I, geometricTransforms(i), 'OutputView', panoramaView);

    % Generate a binary mask.
    mask = imwarp(true(size(I,1),size(I,2)), geometricTransforms(i), 'OutputView', panoramaView);

    % Overlay the warpedImage onto the panoramaImage.
    panoramaImage = step(blender, panoramaImage, warpedImage, mask);
end

% successful execution
status = 1;

% return
return;

end