===========================================================================
 Project: Homework Assignment - Computer Vision Position Application
          Zebra Technologies, Mississauga
===========================================================================
 Author: Mohsen Ghazel 
 Date: November 23, 2018
===========================================================================
 Please follow the following instructions to install and run the 
 MATLAB code.
===========================================================================
STEP 1: Copying the folder:
===========================================================================

- Copy the folder "Homework_Assignment_MGhazel_Submitted_23Nov2018" to your computer

- In your File Explorer, go to the destination folder:
        
	...\Homework_Assignment_MGhazel_Submitted_23Nov2018

- You should see the following sub-folders:

	Homework_Assignment_MGhazel_Submitted_23Nov2018\configuration    Contains a configuration file
	Homework_Assignment_MGhazel_Submitted_23Nov2018\data             Contains the acquire scenes and templates images
	Homework_Assignment_MGhazel_Submitted_23Nov2018\readme           Contains this readme file
	Homework_Assignment_MGhazel_Submitted_23Nov2018\report           Contains a PDF Homework Assignment report
	Homework_Assignment_MGhazel_Submitted_23Nov2018\results          Contains generated results
	Homework_Assignment_MGhazel_Submitted_23Nov2018\log              Contains log messages printed to the screen during program execution  

- You should also the following MATLAB files:

	driverProgram.m         		The driver MATLAB program, which should be executed from the MATLAB GUI or prompt
	stitchSceneImages.m     		A function for stitching the images together
	detectObject.m				A function for detecting an object template image in a scene image
	getInputImages.m        		A helper function the reads the input scene and reference images
	formatTime.m				A helper function that formats the elapsed time from secs to hours, mins, secs.

===========================================================================
STEP 2: Reviewing the configuration file: NO NEED TO CHNAGE THE FILE
===========================================================================
- Note: There is NO NEED to edit or change this file, only if desired.
===========================================================================
- The configuration file:

	...\Homework_Assignment_MGhazel_Submitted_23Nov2018\configuration\configuration.txt

  contains various editable user preferences, such as:
	 
	- Input data path
	- Output path
	- Display and saving preferences
	- The type of feature-descriptor to be applied, such as:

		- Harris corners
	       	- BRIEF
	       	- FAST
	       	- SURF

	- The file contains clear documentation of what each 
	  editable preference means?

===========================================================================
STEP 2: Execute the program:
===========================================================================
	- Change the MATLAB current folder to ...\Homework_Assignment_MGhazel_Submitted_23Nov2018

	   - Option 1: Open the driver file: driverProgram.m and press "Run"
           - Option 2: At the MATLAB prompt with the folder above:
                       
			>> status = driverProgram()

===========================================================================
STEP 3: Examine Output:
===========================================================================

- Results are saved to the results folder:

	...\Homework_Assignment_MGhazel_Submitted_23Nov2018\results

- For each run, the results are saved in a time-stamped sub-folder of the 
  above results folder, specifying the date and time of program execution:


- For example: 

  ...\Homework_Assignment_MGhazel_Submitted_23Nov2018\results\November 23_ 2018  6_57_36_195 PM

  contains the output for the execution dated on: November 23, 2018 at 6:57:36:195 PM

---------------------------------------------------------------------------
Output Format for My Collected Data:
---------------------------------------------------------------------------
The above output subfolder should contain the following subfolders:

1) Subfolders
 containing the montage of the scene and reference images:
sceneImagesMontage
referenceImagesMontage

2) Subfolder containing the constructed stitched montage of the scene images:

sceneImagesPanorama

3) Subfolder contains the results of detecting reference_i in sceneImage_j, for i = 1,2,...6 and j = 1, 2, ..., 9:

sceneImage1_referenceImage1
sceneImage1_referenceImage2
.
.
.
sceneImage9_referenceImage6

3) Subfolder contains the results of detecting reference_i in the panoramaImage, for i = 1,2,...6:

panoramaImage_referenceImage1
panoramaImage_referenceImage2
.
.
.
panoramaImage_referenceImage6

===========================================================================
SOFTWARE DEPENDENCIES
%==========================================================================
% Developed and Tested on:
%==========================================================================
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

        

