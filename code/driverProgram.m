function [status] = driverProgram()
%==========================================================================
% Project: Zebra Technologies - Homework Assignment
%==========================================================================
% File: driverProgram.m
% Author: Mohsen Ghazel 
% Date: Nov 23, 2018
%==========================================================================
% Specifications: 
%==========================================================================
% - This is the driver program, which performs the following operations, 
%   in sequence:
% 
%   1) Read the input configFileName configuration file to parse the user's
%      preferences, such as:
%      - Folder name of the scene images
%      - Folder name of the reference images
%      - The applied feature descriptor
%      - Flags to display and save the intermediate results
%      - Please the configuration file for a complete list of selected 
%        user preferences: configueation.txt
%   2) Applies feature-based methodology to stitch the sceneImages
%      together and constructs a panorama of all the scene images
%      sttiched together.
%   3) Applies a feature-based methodology to detect the  reference 
%      images within each one of the scene images as well as the
%      constructed panorama image.
%==========================================================================
% Intput:
%==========================================================================
% - Please see ./configuration/configuration.txt to changes the input and 
%   user preferences.
%==========================================================================
% Output:
%==========================================================================
%  - status = 1 for success and -1 for failure
%--------------------------------------------------------------------------
% Execution: 
%
% >> [status] = driverProgram()
%
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
% clear the screen
clc;

% close all open figures
close('all');

% suppress any warnings
warning('off');

% initialize the execution status
status = 1;

% display a message indicating the start of the execution
fprintf(1, '===============================================================\n');
fprintf(1, 'Feature Based Panoramic Image Stitching & Object Detection\n');
fprintf(1, '===============================================================\n');
fprintf(1, 'Author: Mohsen Ghazel\n');
fprintf(1, '===============================================================\n');
fprintf(1, 'Execution date and time: %s\n', datestr(now,'mmmm dd, yyyy HH:MM:SS.FFF AM'));
fprintf(1, '===============================================================\n');

%--------------------------------------------------------------------------
% start of exeution
%--------------------------------------------------------------------------
% - Keep track of start of execution in order to compute the total
%   execution time of the program
%--------------------------------------------------------------------------
tic;

%==========================================================================
% Step 1: Parse the configuration file
%==========================================================================
% configuration file: 
%--------------------------------------------------------------------------
% - User may edit this file to change preferences.
%--------------------------------------------------------------------------
configFileName = '.\configuration\configuration.txt';
%==========================================================================
fprintf(1, '\n\n');
% display message
fprintf(1, '---------------------------------------------------------------\n');
fprintf(1, 'Step 1: Parsing the configuration file: %s\n', configFileName);
fprintf(1, '---------------------------------------------------------------\n');
% call the readConfigFile function to parse the configuration file
[status, configParams] = readConfigFile(configFileName);
% check the status
if ( status ~= 1 )
    % display error message
    fprintf(1, 'Failure in reading the configuration file: %s\n', configFileName );
    % set execution status to failure
    status = -1;
    % return
    return;
end
% set the configuration parameters
% set the sceneImagesFolder
sceneImagesFolder = configParams.sceneImagesFolder;
% set the referenceImagesFolder
referenceImagesFolder = configParams.referenceImagesFolder;
% set the outputFolder
outputFolder = configParams.outputFolder;
% set the displayIntermediateResultsFlag
displayIntermediateResultsFlag = configParams.displayIntermediateResultsFlag;
% set the saveIntermediateResultsFlag
saveIntermediateResultsFlag = configParams.saveIntermediateResultsFlag;
% set the featureDetector
featureDetector = configParams.featureDetector;

% display the read configuration file settings
fprintf(1, 'Configuration file read and parsed successfully\n');
fprintf(1, '---------------------------------------------------------------\n')
fprintf(1, 'sceneImagesFolder = %s\n', sceneImagesFolder);
fprintf(1, 'referenceImagesFolder = %s\n', referenceImagesFolder );
fprintf(1, 'outputFolder = %s\n', outputFolder );
fprintf(1, 'displayIntermediateResultsFlag = %d\n', displayIntermediateResultsFlag );
fprintf(1, 'saveIntermediateResultsFlag = %d\n', saveIntermediateResultsFlag );
fprintf(1, 'featureDetector = %s\n', featureDetector );
fprintf(1, '---------------------------------------------------------------\n');

% set figures visibility
if ( displayIntermediateResultsFlag  == 0 )
    set(0,'DefaultFigureVisible','off');
else
    set(0,'DefaultFigureVisible','on');
end
fprintf(1, '\n\n');
%==========================================================================
% Step 2: Create the output folder, if it does not exist
%==========================================================================
fprintf(1, '---------------------------------------------------------------\n');
fprintf(1, 'Step 2: Creating the output folder\n');
fprintf(1, '---------------------------------------------------------------\n');
%--------------------------------------------------------------------------
% Check the output folder:
%   - If the output folder exists, if does not exist, then try to create it
%--------------------------------------------------------------------------
% create the outpout sub-folder if it does not exist
if (exist(outputFolder,'dir') ~= 7 )
    % create the output folder
    status = mkdir(outputFolder);
    if ( status ~= 1 )
        fprintf(1, 'Failure: Unable to create the outputFolder = %s\n', outputFolder );
        % set execution status to failure
        status = 0;
        % return
        return;
    end
end
fprintf(1, 'Output folder created successfully!\n');

%--------------------------------------------------------------------------
% For each run, the results are saved in a different subfolder with a time
% stamp in its name, in order to avoid over-writing previous results
%--------------------------------------------------------------------------
% create a time-stamp sub-folder name
% get the current time as a string
timeStamp = datestr(now,'mmmm dd, yyyy HH:MM:SS.FFF AM');
% delimters
delimiters = [' ', '  ', '\s', ',\s', ':\s', '.\s'];
% iterate over the delimiters and replace them with underscore
for counter = 1: length(delimiters)
    % replace delimiter with underscore to connect substrings
    timeStamp = strrep(timeStamp, strtrim(delimiters(counter)),'_');
end
% create the subfolder using the timeStamp
outputFolder = [outputFolder timeStamp '\'];
% create the output sub-folder if it does not exist
if (exist(outputFolder,'dir') ~= 7 )
    % create the subfolder
    mkdir(outputFolder);
end
fprintf(1, 'Time-stamp output sub-folder created successfully: %s\n', timeStamp);
fprintf(1, '---------------------------------------------------------------\n');
fprintf(1, '\n\n');
%==========================================================================
% Step 3: Read input image data
%==========================================================================
fprintf(1, '---------------------------------------------------------------\n');
fprintf(1, 'Step 3: Reading the input images data\n');
fprintf(1, '---------------------------------------------------------------\n');
%--------------------------------------------------------------------------
% Step 3.1: Read input scene images and store them in a MATLAB 
%           imageDataStore for efficiency
%--------------------------------------------------------------------------
[status, sceneImagesData] = getInputImages(sceneImagesFolder);
% check the execution status
if ( status ~= 1 )
    fprintf(1, 'Failure in reading the sceneimages from: %s\n', sceneImagesFolder );
    % set execution status to failure
    status = 0;
    % return
    return;
end
fprintf(1, 'Scene images data is read successfully!\n');
fprintf(1, '- Found %d scene images\n', numel(sceneImagesData.Files));
fprintf(1, '- Constructing and saving a montage of the scene images\n');
% Display images to be stitched
h10 = figure(10);
montage(sceneImagesData.Files)
% montage-folder label
montageFolderLabel = 'sceneImagesMontage';
% create a subfolder
montageFolder = [outputFolder montageFolderLabel '\'];
% create the outpout sub-folder if it does not exist
if (exist(montageFolder,'dir') ~= 7 )
    % create the subfolder
    mkdir(montageFolder);
end
% save the input images if saveIntermediateResults = 1
if ( saveIntermediateResultsFlag == 1 )
    saveas(h10, [montageFolder montageFolderLabel '.jpg']);
end
fprintf(1, '---------------------------------------------------------------\n');
%--------------------------------------------------------------------------
% Step 3.2: Read input reference images and store them in a MATLAB 
%           imageDataStore for efficiency
%--------------------------------------------------------------------------
[status, referenceImagesData] = getInputImages(referenceImagesFolder);
% check the execution status
if ( status ~= 1 )
    fprintf(1, 'Failure in reading the sceneimages from: %s\n', referenceImagesFolder );
    % set execution status to failure
    status = 0;
    % return
    return;
end

fprintf(1, 'Reference images data is read successfully!\n');
fprintf(1, '- Found %d scene images\n', numel(referenceImagesData.Files));
fprintf(1, '- Constructing and saving a montage of the reference images\n');
% Display images to be stitched
h15 = figure(15);
montage(referenceImagesData.Files)
% montage-folder label
montageFolderLabel = 'referenceImagesMontage';
% create a subfolder
montageFolder = [outputFolder montageFolderLabel '\'];
% create the outpout sub-folder if it does not exist
if (exist(montageFolder,'dir') ~= 7 )
    % create the subfolder
    mkdir(montageFolder);
end
% save the input images if saveIntermediateResults = 1
if ( saveIntermediateResultsFlag == 1 )
    saveas(h15, [montageFolder montageFolderLabel '.jpg']);
end
fprintf(1, '---------------------------------------------------------------\n');
fprintf(1, '\n\n');
%==========================================================================
% Step 4: Stitch the scene images together
%==========================================================================
fprintf(1, '---------------------------------------------------------------\n');
fprintf(1, 'Step 4: Stitching the scene images together to form a panorama...please wait!\n');
fprintf(1, '---------------------------------------------------------------\n');
%--------------------------------------------------------------------------
% Step 4.1: Call the stitchSceneImages() function to stitch the scene images
%           and construct a panorama of all the images stitched together
%--------------------------------------------------------------------------
[status, panoramaImage] = stitchSceneImages(sceneImagesData, featureDetector);
% check the execution status
if ( status ~= 1 )
    fprintf(1, 'Failure in stitchSceneImages(...)\n' );
    % set execution status to failure
    status = -1;
    % return
    return;
end
% display a message
fprintf(1, 'Scene images are stitched together successfully!\n');
%--------------------------------------------------------------------------
% Step 2.2: Display and save the constructed panorama
%--------------------------------------------------------------------------
% panorama-folder label
panoramaFolderLabel = 'sceneImagesPanorama';
% create a subfolder
panoramaFolder = [outputFolder panoramaFolderLabel '\'];
% create the outpout sub-folder if it does not exist
if (exist(panoramaFolder,'dir') ~= 7 )
    % create the subfolder
    mkdir(panoramaFolder);
end
% create a new display figure
h20 = figure(20);
% display the panorama image
imshow(panoramaImage);
% save the input images
% save the input images if saveIntermediateResults = 1
if ( saveIntermediateResultsFlag == 1 )
    saveas(h20, [panoramaFolder panoramaFolderLabel '.jpg']);
end
fprintf(1, '\n\n');
fprintf(1, '---------------------------------------------------------------\n');
fprintf(1, 'Step 5: Detecting reference images and panorama image...please wait!!\n');
fprintf(1, '---------------------------------------------------------------\n');
%--------------------------------------------------------------------------
% Scene images:
%--------------------------------------------------------------------------
% The number of scene images
numSceneImages = numel(sceneImagesData.Files);

%--------------------------------------------------------------------------
% Reference images:
%--------------------------------------------------------------------------
% The number of reference images
numReferenceImages = numel(referenceImagesData.Files);

%--------------------------------------------------------------------------
% variable initialization
%--------------------------------------------------------------------------
% initialize the original scene image
originalSceneImage =  [];
% Initialize the label o fthe original scene image
sceneImageLabel = 'panoramaImage';
    
%--------------------------------------------------------------------------
% Iterate over the scene-images plus the panorama image
%--------------------------------------------------------------------------
% scene images: sceneImageCounter = 1 : numSceneImages
% panorama image: sceneImageCounter = numSceneImages + 1
%--------------------------------------------------------------------------
for sceneImageCounter = 1 : numSceneImages + 1 
     
    %----------------------------------------------------------------------
    % For the original scene images
    % scene images: sceneImageCounter = 1 : numSceneImages
    %----------------------------------------------------------------------
    if ( sceneImageCounter <= numSceneImages )
        
        % Dislay a message
        fprintf(1, '-------------------------------------------------------\n' );
        fprintf(1, 'Pocessing scene image # %d of %d\n', sceneImageCounter, numSceneImages );
        fprintf(1, '-------------------------------------------------------\n' );
    
        % Read the next scene image
        originalSceneImage = readimage(sceneImagesData, sceneImageCounter);
        
        % sceneImageLabel
        sceneImageLabel = ['sceneImage' num2str(sceneImageCounter)];
    %----------------------------------------------------------------------
    % For the original scene images
    % % panorama image: sceneImageCounter = numSceneImages + 1
    %----------------------------------------------------------------------
    else 
        % Dislay a message
        fprintf(1, '-------------------------------------------------------\n' );
        fprintf(1, 'Pocessing the panorama scene image\n' );
        fprintf(1, '-------------------------------------------------------\n' );
        %----------------------------------------------------------------------
        % For panorama image
        %----------------------------------------------------------------------
        % set the originalSceneImage to the panoramaImage
        originalSceneImage =  panoramaImage;
        % sceneImageLabel for the panorama image
        sceneImageLabel = 'panoramaImage';
    end
    %----------------------------------------------------------------------
    % Iterate over the reference-images
    %----------------------------------------------------------------------
    for referenceImageCounter = 1: numReferenceImages
        
        fprintf(1, '-------------------------------------------------------\n' );
        fprintf(1, 'Pocessing reference image # %d of %d\n', referenceImageCounter, numReferenceImages );
        fprintf(1, '-------------------------------------------------------\n' );
        % Read the next reference-image
        originalReferenceImage = readimage(referenceImagesData, referenceImageCounter);

        % referenceImageLabel
        referenceImageLabel = ['referenceImage' num2str(referenceImageCounter)]; 
    
        % call the object detection functionality
        [status, referenceImagePolygon] = detectObject(originalSceneImage,...
                                                       sceneImageLabel,...
                                                       originalReferenceImage,...
                                                       referenceImageLabel,...
                                                       featureDetector,...
                                                       displayIntermediateResultsFlag,...
                                                       saveIntermediateResultsFlag,...
                                                       outputFolder);
        % display a message indicating whether the detection was successful
        % or not
        if ( status == 1 )
            fprintf(1, 'Reference image # %d was successfully detected in scene image # %d\n', sceneImageCounter, referenceImageCounter );
        else
            fprintf(1, 'Reference image # %d was not detected in scene image # %d\n', sceneImageCounter, referenceImageCounter );
        end

    end
end

% display a final message dusplaying the execution time of the program.
fprintf(1, '===============================================================\n');
fprintf(1, 'Program execution completed successfully in %s\n', formatTime(toc));
fprintf(1, 'Good bye!\n');
fprintf(1, '===============================================================\n');

% status to success
status = 1;

% return
return;

end