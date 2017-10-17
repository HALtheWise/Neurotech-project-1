% This script can be helpful is sorting out how to load the data. Right now
% you only have 1 subject, but the general form allows you load any subject
% number (or to do this in a loop in the future, with minor modifications).

% I am only including notes on loading the behavioral and analyzed data
% here. If you want to load the raw strutural, resting state, or diffusion
% data, you will need a matlab library to load .nii files (imaging data).
% Ask Sam if you want to do this, but we strongly sugget that you start
% with the analyzed imaging data (loaded below).

% See the slides and variable description document for more details on
% these files.

% You can choose to read the data in a different format, if preferred.
% If you're using linux or a mac, you might have to switch slashes \/

% You will need to change this to your own directory
DIRDATA = '\home\eric\git\Neurotech-project-1\DemoData\';

subj = 1;


%% Load change detection training data 
fname = dir(strcat(DIRDATA,num2str(subj),'\','ChangeDetectionTask*.csv'));
changedetection = readtable(strcat(fname.folder,'\',fname.name));

% There are 3 versions per each session and a variable number of games
% played per each version within each session.

%% Load the visuospatial training data
fname = dir(strcat(DIRDATA,num2str(subj),'\','VisuoSpatialTask*.csv'));
visuospatial = readtable(strcat(fname.folder,'\',fname.name));

%% Load the Testing Data
fname = dir(strcat(DIRDATA,'\',num2str(subj),'\','TestingData*.csv'));
testingdata = readtable(strcat(fname.folder,'\',fname.name));

%% Load MITRE - item by item questions
fname = dir(strcat(DIRDATA,'\',num2str(subj),'\','MITRE*.csv'));
mitre = readtable(strcat(fname.folder,'\',fname.name));


%% Resting state, pre and post, Analyzed
fname = dir(strcat(DIRDATA,'\',num2str(subj),'\','Pre_RestingState_Functional*.csv'));
RSpre = csvread(strcat(fname.folder,'\',fname.name));

fname = dir(strcat(DIRDATA,'\',num2str(subj),'\','Post_RestingState_Functional*.csv'));
RSpost = csvread(strcat(fname.folder,'\',fname.name));

% The labels are not provided in this data file (but will be provided in
% the next version of the data files). 

%% Structural connectivity DTI
% probabilistic tensor components describing anisotropic diffusion

% In the region of interest (ROI) labels, the names are often abbreviated.
% lh refers to left hemisphere and rh to right hemisphere

% Matlab won't like some of the variable names, so it will adjust them
% (details in the Warning message).

% pre
fname = dir(strcat(DIRDATA,'\',num2str(subj),'\','Pre_Structconn68_VolumeWeighted_headers*.csv'));
tabledti = readtable(strcat(fname.folder,'\',fname.name));
dtiregions = tabledti.Properties.VariableNames;
dtipre = tabledti{:,:};
clear tabledti fname

% post
fname = dir(strcat(DIRDATA,'\',num2str(subj),'\','Post_Structconn68_VolumeWeighted_headers*.csv'));
tabledti = readtable(strcat(fname.folder,'\',fname.name));
dtipost = tabledti{:,:};
clear tabledti

