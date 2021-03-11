function [status, referenceImagePolygon] = detectObject(originalSceneImage,...
                                                        sceneImageLabel,...
                                                        originalReferenceImage,...
                                                        referenceImageLabel,...
                                                        featureDetector,...
                                                        displayIntermediateResultsFlag,...
                                                        saveIntermediateResultsFlag,...
                                                        outputFolder)
%==========================================================================
% Project: Zebra Technologies - Homework Assignment
%==========================================================================
% File: detectObject.m
% Author: Mohsen Ghazel 
% Date: Nov 14, 2018
%==========================================================================
% Specifications: 
% -------------------------------------------------------------------------
% - This function implements feature-based approach a reference object image in a cluttered scene image:
%
%   - The algorithm for detecting a specific object based on finding point 
%     correspondences between the reference and the target image. 
%   - It can detect objects despite a scale change or in-plane
%     rotation. 
%   - It is also robust to small amount of out-of-plane rotation and 
%     occlusion.
% 
% This method of object detection works best for objects that exhibit
% non-repeating texture patterns, which give rise to unique feature
% matches. This technique is not likely to work well for uniformly-colored
% objects, or for objects containing repeating patterns. Note that this
% algorithm is designed for detecting a specific object, for example, the
% elephant in the reference image, rather than any elephant. For detecting
% objects of a particular category, such as people or faces, see
% vision.PeopleDetector and vision.CascadeObjectDetector.
% %--------------------------------------------------------------------------
% Intput:
%--------------------------------------------------------------------------
% - sceneImage: Scene image
% - sceneImageLabel: Scene image label
% - referenceImage: Reference image
% - sceneImageLabel: Reference image label
% - featureDetector: The feature detector to be applied to detect features
% - displayIntermediateResultsFlag: A flag for displaying all intermediate 
%                                   results
% - saveIntermediateResultsFlag: A flag for saving all intermediate 
%                                   results
% - outputFolder:Ouput folder, where output will be saved
%--------------------------------------------------------------------------
% Output:
%--------------------------------------------------------------------------
%  - status = 1 for success and 0 for failure
%  - polygone: Polygine with vertices specifying the locations of the 
%              detected reference image in the scene image
%--------------------------------------------------------------------------
% Execution: 
%
% >> [status, referenceImagePolygon] = detectObject(originalSceneImage,...
%                                                         sceneImageLabel,...
%                                                         originalReferenceImage,...
%                                                         referenceImageLabel,...
%                                                         featureDetector,...
%                                                         displayIntermediateResultsFlag,...
%                                                         saveIntermediateResultsFlag,...
%                                                         outputFolder);
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

% initialize the referenceImagePolygon
referenceImagePolygon = [];

% close all figures
close('all');

% set figures visibility
if ( displayIntermediateResultsFlag == 0 )
    set(0,'DefaultFigureVisible','off');
else
    set(0,'DefaultFigureVisible','on');
end

% create a subfolder to save intermediate results in
subfolder_label = [sceneImageLabel '_' referenceImageLabel];
% craete the subfolder using the timeStamp
outputFolder = [outputFolder subfolder_label '\'];
% create the outpout sub-folder if it does not exist
if (exist(outputFolder,'dir') ~= 7 )
    % create the subfolder
    mkdir(outputFolder);
end

%--------------------------------------------------------------------------
% Step 1: convert images to grayscale if color
%--------------------------------------------------------------------------
% initialize the sceneImage 
sceneImage = originalSceneImage;
if ( size(originalSceneImage, 3) > 1 )
    sceneImage = rgb2gray(originalSceneImage);
end
% initialize the referenceImage 
referenceImage = originalReferenceImage;
if ( size(originalReferenceImage, 3) > 1 )
    referenceImage = rgb2gray(originalReferenceImage);
end
    
%==========================================================================
% Step 1: Detect Feature Points 
%==========================================================================
fprintf(1, 'Step 1: Compute feature points from both images\n');
%--------------------------------------------------------------------------
% Step 1.1: Detect the feature points in the sceneImage
%--------------------------------------------------------------------------
scenePoints = [];
%--------------------------------------------------------------------------
% Detect the features depending on the specified featureDetector approach:
%  - if featureDetector = 'SURF', use MATLAB detectSURFFeatures()
%  - if featureDetector = 'BRISK', use MATLAB detectBRISKFeatures()
%  - if featureDetector = 'HARRIS', use MATLAB detectHarrisFeatures()
%  - if featureDetector = 'FAST', use MATLAB detectHarrisFeatures()
%--------------------------------------------------------------------------
% if featureDetector = 'SURF', use MATLAB detectSURFFeatures()
if ( strcmp(featureDetector, 'SURF' ) == 1 )
    scenePoints = detectSURFFeatures(sceneImage);
% if featureDetector = 'BRISK', use MATLAB detectBRISKFeatures()
elseif ( strcmp(featureDetector, 'BRISK' ) == 1 )
    scenePoints = detectBRISKFeatures(sceneImage);
% if featureDetector = 'HARRIS', use MATLAB detectHarrisFeatures()
elseif ( strcmp(featureDetector, 'HARRIS' ) == 1 )
    scenePoints = detectHarrisFeatures(sceneImage);
% if featureDetector = 'FAST', use MATLAB detectFASTFeatures()
elseif ( strcmp(featureDetector, 'FAST' ) == 1 )
    scenePoints = detectFASTFeatures(sceneImage);
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
% Visualize the strongest feature points found in the target 
% image.
%--------------------------------------------------------------------------
% create a new figure
h30 = figure(30);
imshow(sceneImage);
title('The top 100 strongest feature points from scene image', 'FontSize', 10);
hold on;
plot(selectStrongest(scenePoints, 100));
% save the image if saveIntermediateResultsFlag = 1
if ( saveIntermediateResultsFlag == 1 )
    saveas(h30, [outputFolder sceneImageLabel '_top_100_features.jpg']);
end
% close all figures
close('all');

%--------------------------------------------------------------------------
% Step 1.2: Detect the feature points in the referenceImage
%--------------------------------------------------------------------------
% initialize referencePoints 
referencePoints = [];
%--------------------------------------------------------------------------
% Detect the features depending on the specified featureDetector approach:
%  - if featureDetector = 'SURF', use MATLAB detectSURFFeatures()
%  - if featureDetector = 'BRISK', use MATLAB detectBRISKFeatures()
%  - if featureDetector = 'HARRIS', use MATLAB detectHarrisFeatures()
%  - if featureDetector = 'FAST', use MATLAB detectHarrisFeatures()
%--------------------------------------------------------------------------
% if featureDetector = 'SURF', use MATLAB detectSURFFeatures()
if ( strcmp(featureDetector, 'SURF' ) == 1 )
    referencePoints = detectSURFFeatures(referenceImage);
% if featureDetector = 'BRISK', use MATLAB detectBRISKFeatures()
elseif ( strcmp(featureDetector, 'BRISK' ) == 1 )
    referencePoints = detectBRISKFeatures(referenceImage);
% if featureDetector = 'HARRIS', use MATLAB detectHarrisFeatures()
elseif ( strcmp(featureDetector, 'HARRIS' ) == 1 )
    referencePoints = detectHarrisFeatures(referenceImage);
% if featureDetector = 'FAST', use MATLAB detectFASTFeatures()
elseif ( strcmp(featureDetector, 'FAST' ) == 1 )
    referencePoints = detectFASTFeatures(referenceImage);
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
% Setp 1.4: Visualize the strongest feature points found in the 
%           reference image
%--------------------------------------------------------------------------
% create a new figure
h30 = figure(30);
imshow(referenceImage);
title('The top 100 strongest feature points from the reference image', 'FontSize', 8);
hold on;
plot(selectStrongest(referencePoints, 100));
% save the image if saveIntermediateResultsFlag = 1
if ( saveIntermediateResultsFlag == 1 )
    saveas(h30, [outputFolder referenceImageLabel '_top_100_features.jpg']);
end
% close all figures
close('all');

%==========================================================================
% Step 2: Extract Feature Descriptors
%==========================================================================
fprintf(1, 'Step 2: Extract Feature Descriptors for both images\n');
%--------------------------------------------------------------------------
% Step 2.1: Extract feature descriptors at the interest points in 
%           both images.
%--------------------------------------------------------------------------
% Extract Feature Descriptors from the reference image
[boxFeatures, referencePoints] = extractFeatures(referenceImage, referencePoints);
% Extract Feature Descriptors from the scene image
[sceneFeatures, scenePoints] = extractFeatures(sceneImage, scenePoints);

%==========================================================================
% Step 3: Find Putative Point Matches
%==========================================================================
fprintf(1, 'Step 3: Matched the features from both images\n');
%--------------------------------------------------------------------------
% Match the features using MATLAB matchFeatures() function:
%--------------------------------------------------------------------------
%----------------------------------------------------------------------
% MATLAB documentation:
%----------------------------------------------------------------------
% help matchFeatures
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
boxPairs = matchFeatures(boxFeatures, sceneFeatures);

%--------------------------------------------------------------------------
% Step 3.2: Display putatively matched features.
%--------------------------------------------------------------------------
% matched points on the reference image
matchedReferencePoints = referencePoints(boxPairs(:, 1), :);
% matched points on the scene image
matchedScenePoints = scenePoints(boxPairs(:, 2), :);
% create a new figure
h50 = figure(50);
showMatchedFeatures(referenceImage, sceneImage, matchedReferencePoints, ...
    matchedScenePoints, 'montage');
title('All matched points between scene and reference images (Including outliers)', 'FontSize', 10);
% save the image if saveIntermediateResultsFlag = 1
if ( saveIntermediateResultsFlag == 1 )
    saveas(h50, [outputFolder sceneImageLabel '_' referenceImageLabel '_matched_features.jpg']);
end
% close all figures
close('all');
%==========================================================================
% Step 4: Calculates the transformation relating the matched points
%==========================================================================
fprintf(1, 'Step 4: Calculates the transformation relating the matched points\n');

%--------------------------------------------------------------------------
% estimateGeometricTransform calculates the transformation relating the 
% matched points, while eliminating outliers. 
% This transformation allows us to localize the object in the scene.
%--------------------------------------------------------------------------
% construct the transformation using MATLAB estimateGeometricTransform()
% function
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
[tform, inlierreferencePoints, inlierScenePoints, estimateGeometricTransformStatus ] = ...
    estimateGeometricTransform(matchedReferencePoints, matchedScenePoints, 'affine'); 

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
if ( estimateGeometricTransformStatus > 1 )
    % display a message
    fprintf(1, 'Not enough inliers found.\n');
    fprintf(1, 'Therefore the reference image is not detected in the scene image!\n');
    
    % set status to success
    status = -1;

    % return
    return;
end   

%--------------------------------------------------------------------------
% Step 5.1: Display the matching point pairs with the outliers removed
%--------------------------------------------------------------------------
% create a new figure
h60 = figure(60);
% display the matched eatures
showMatchedFeatures(referenceImage, sceneImage, inlierreferencePoints, ...
    inlierScenePoints, 'montage');
title('Matched points between scene and reference images (Inliers only)', 'FontSize', 10);

% save the image if saveIntermediateResultsFlag = 1
if ( saveIntermediateResultsFlag == 1 )
    saveas(h60, [outputFolder sceneImageLabel '_' referenceImageLabel '_matched_inliers.jpg']);
end
% close all figures
close('all');

%==========================================================================
% Step 5: Get the bounding polygon of the reference image.
%==========================================================================
fprintf(1, 'Step 5: Get the bounding polygon of the reference image.\n');
%--------------------------------------------------------------------------
% Step 5.2: Get the bounding polygon of the reference image.
%--------------------------------------------------------------------------
boxPolygon = [1, 1;...                           % top-left
        size(referenceImage, 2), 1;...                 % top-right
        size(referenceImage, 2), size(referenceImage, 1);... % bottom-right
        1, size(referenceImage, 1);...                 % bottom-left
        1, 1];                   % top-left again to close the polygon

%==========================================================================
% Step 6: Transform the polygon into the coordinate system of the target 
%         image
%==========================================================================
fprintf(1, 'Step 6: Transform the polygon into the coordinate system of the target image\n');
%--------------------------------------------------------------------------
% Step 5.2: Transform the polygon into the coordinate system of the target 
%           image. 
%   - The transformed polygon indicates the location of the object in the 
%     scene.
%--------------------------------------------------------------------------
referenceImagePolygon = transformPointsForward(tform, boxPolygon);

%==========================================================================
% Step 7: Overlay the polygone on the target image
%==========================================================================
fprintf(1, 'Step 7: Overlay the polygone on the target image\n');
%--------------------------------------------------------------------------
% Step 5.3: Display the detected object.
%--------------------------------------------------------------------------
% create a new figure
h70 = figure(70);
% display the image
imshow(originalSceneImage);
hold on;
% overlay the polygone on the detected object
line(referenceImagePolygon(:, 1), referenceImagePolygon(:, 2), 'Color', 'g', 'LineWidth', 3);
title('Detected reference image polygone overlaid on the scene image', 'FontSize', 10);

% save the image if saveIntermediateResultsFlag = 1
if ( saveIntermediateResultsFlag == 1 )
    saveas(h70, [outputFolder sceneImageLabel '_' referenceImageLabel '_detected_results.jpg']);
end

% close all figures
close('all');

% set status to success
status = 1;

% return
return;

end