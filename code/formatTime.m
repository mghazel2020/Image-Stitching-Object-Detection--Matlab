function [timeString] = formatTime(timeInSecs)
%==========================================================================
% Project: Zebra Technologies - Homework Assignment
%==========================================================================
% File: formatTime.m
% Author: Mohsen Ghazel 
% Date: Nov 23, 2018
%==========================================================================
% Specifications: 
%==========================================================================
% - This function converts and formats the input time from seconds to 
%   hours, minutes, seconds
% - This utility function used to compute the execution time of the program
%==========================================================================
% Intput:
%==========================================================================
% - timeInSecs:     Time in seconds
%==========================================================================
% Output:
%==========================================================================
%  - timeString: Time formatted in hours, minutes, seconds
%--------------------------------------------------------------------------
% Execution: 
%
% >> [timeString] = formatTime(timeInSecs)
%
%==========================================================================
% History
%==========================================================================
% Date                      Changes
%--------------------------------------------------------------------------
% 11/15/2018                Initial definition
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
% initialize the output time string
timeString = '';

% number of hours
numHours = 0;

% number of minutes
numMins = 0;

% check if input time is longer than 3600 seconds (1 hours)
if ( timeInSecs >= 3600 )
    % compute the number of hours (integer division)
    numHours = floor(timeInSecs/3600);
    % if more then 1 hour, then plural (hours)
    if ( numHours > 1 )
        hourString = ' hours, ';
    else % otherwise, then singular (hour)
        hourString = ' hour, ';
    end
    % the time string
    timeString = [num2str(numHours ) hourString];
end
% check if input time is longer than 60 seconds (1 minute)
if ( timeInSecs >= 60 )
    % number of minutes
    numMins = floor((timeInSecs - 3600*numHours)/60);
    if numMins > 1
        minuteString = ' mins, ';
    else
        minuteString = ' min, ';
    end
    timeString = [timeString num2str(numMins) minuteString];
end

% number of seconds
numSecs = timeInSecs - 3600*numHours - 60*numMins;

%--------------------------------------------------------------------------
% the formatted time string
%--------------------------------------------------------------------------
timeString = [timeString sprintf('%2.1f', numSecs) ' secs'];

% return
return;

end