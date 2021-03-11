function [status, imageData] = getInputImages(dataFolder)
%==========================================================================
% Project: Zebra Technologies - Homework Assignment
%==========================================================================
% File: getInputImages.m
% Author: Mohsen Ghazel 
% Date: Nov 23, 2018
%==========================================================================
% Specifications: 
% -------------------------------------------------------------------------
% - This function gets all images in an image subfolder
%==========================================================================
% Intput:
%==========================================================================
% - dataFolder: path name of the data folder containing the images
%               - only image files in standard image format (jpg, png, ppm, 
%                 etc.) are expected in this folder.
%==========================================================================
% Output:
%==========================================================================
%  - status = 1 for success and 0 for failure
%  - imageData: MATLAB imageDatastore of images
%--------------------------------------------------------------------------
% Execution: 
%
% >> [status, imageData] = getInputImages(dataFolder)
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
% suppress warnings
warning('off');

% execution status
status = 1;

% set image data to empty
imageData = [];
    
% allowed image format extensions
validExtensions = ['.jpeg' '.jpg ' '.png ' '.tif ' '.tiff' '.gif '];

% check the content of the images
list = dir(dataFolder);
% skip over the frist 2 elements, which are typically (.) and (..)
list = list(3:end);

% check if the images in the data-folder are valid
% iterate over the images
for counter1 = 1 : length(list)
    % get the image file
    fname = list(counter1).name;
    % set a flag for valid file
    isValidImgFile = 0;
    % iterate over the file format
    for counter2 = 1 : length(validExtensions)
        % get the extension
        ext = strtrim(validExtensions(counter2));
        % check if fname contains ext
        if ( contains(fname, ext) )
            % this file name is valid
            isValidImgFile = 1;
            % break out of the loop
            break;
        end
    end
    
    % check if the file name is valid
    if ( isValidImgFile == 0 )
        % display error message 
        fprintf(1, 'Invalid image file: %s\n', fname );
        % set execution status to failure
        status = -1;
        % return
        return;
    end
end

% Since all files within the dataFolder are valid then storore them in a
% MATLAB imageDataStore
imageData = imageDatastore(dataFolder);

% set execution status to success
status = 1;

% return
return;

end