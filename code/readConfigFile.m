function [status, configParams] = readConfigFile(config_file)
%==========================================================================
% Project: Zebra Technologies - Homework Assignment
%==========================================================================
% File: readConfigFile.m
% Author: Mohsen Ghazel 
% Date: Nov 15, 2018
%==========================================================================
% Specifications: 
%==========================================================================
% - This function read the configuration file
% 
%==========================================================================
% Intput:
%==========================================================================
% - config_file: Full-path name of the configuration file
%==========================================================================
% Output:
%==========================================================================
%  - status = 1 for success and 0 for failure
%  - configParams: The configuration file as a structure
%--------------------------------------------------------------------------
% Execution: 
%
% >> [status, configParams] = readConfigFile(config_file)
%==========================================================================
% History
%==========================================================================
% Date                      Changes
%--------------------------------------------------------------------------
% 11/15/2018                Initial definition
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
% initialze the ouput variables
% execution status
status = 1;

% define a structure to store the configuration parameters
configParams = struct('sceneImagesFolder','',...
                       'referenceImagesFolder','',...
                       'outputFolder','',...
                       'displayIntermediateResultsFlag','0',...
                       'saveIntermediateResultsFlag','0',...
                       'featureDetector', 'SURF');
                   
                   
% open the configuration file
fid = fopen(config_file);
% check if the file was opended properly
if ( fid == - 1)
    fprintf(1, 'Failure: Unable to open the input file: %s\n', config_file );
    % set status to failure
    status = -1;
    % return failure
    return;
end
                       
% input scene images folder: sceneImagesFolder
str1 = 'sceneImagesFolder =';
% input reference images folder: referenceImagesFolder
str2 = 'referenceImagesFolder =';
% output folder: outputFolder
str3 = 'outputFolder =';
% display intermediate results flag: displayIntermediateResultsFlag
str4 = 'displayIntermediateResultsFlag =';
% save intermediate results flag: saveIntermediateResultsFlag
str5 = 'saveIntermediateResultsFlag =';
% featureDetector: featureDetector
str6 = 'featureDetector =';

% read line from file
tline = fgetl(fid);
% keep reading until end of file
while ischar(tline)
    % skip if line strats with #
    if ( contains(tline, '#') )
        % read the next line;
    elseif ( contains(tline, str1) ) % sceneImagesFolder
        configParams.sceneImagesFolder = strtrim(char(tline(length(str1) + 1:length(tline))));
    elseif ( contains(tline, str2) ) % referenceImagesFolder
        configParams.referenceImagesFolder= strtrim(char(tline(length(str2) + 1:length(tline))));
    elseif ( contains(tline, str3) ) % outputFolder
        configParams.outputFolder = strtrim(char(tline(length(str3) + 1:length(tline))));
    elseif ( contains(tline, str4) ) % displayIntermediateResults
        configParams.displayIntermediateResultsFlag = str2num(strtrim(char(tline(length(str4) + 1:length(tline)))));
    elseif ( contains(tline, str5) ) % saveIntermediateResults
        configParams.saveIntermediateResultsFlag = str2num(strtrim(char(tline(length(str5) + 1:length(tline)))));
    elseif ( contains(tline, str6) ) % featureDetector
        configParams.featureDetector = strtrim(char(tline(length(str6) + 1:length(tline))));
    end
     % read the next line 
    tline = fgetl(fid);
end

% close file fid
fclose(fid);

% set ststaus to success
status = 1;

% return
return;

end









