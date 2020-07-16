
% written by shigeki for the use in the Watanabe lab. 6/23/2020
% this program is used in conjuction with "randomize". after analyzing the
% randomized images, generated from the "randomize" code, run this program
% by simply typing "unblind_me" in the command line". This program will
% prompt users to select the directory where the analysis text files are
% and also where the key for randomization is. if you rename the key.mat,
% you will need to select the matalab file that contains the key. this
% program will copy the text files into a new folder called "unblinded" and
% rename the text files based on the original names of the tif files. 

clear all

%prompting users to select the folder that contain text files. 
disp('Select a folder containing text files');
text_directory = uigetdir('/Users/watanabe_lab/Dropbox (Watanabe_lab)/Watanabe_lab Team Folder/'); %CHANGE HERE!
[filename] = uigetfile(('*.txt'), 'MultiSelect', 'on','Select all .txt files', text_directory);

% asking users whether the key is in the same folder as the text files.
tf = ismember(char('y'),char(input('is the key.mat file in the same folder as text files you want to unblind? (yes/no) ', 's')));
% if not, users must define where the key is. 
if tf == 0 
    
    disp('Select a folder containing the key');
    key_directory = uigetdir('/Users/watanabe_lab/Dropbox (Watanabe_lab)/Watanabe_lab Team Folder/');
    
else 
    key_directory = text_directory;
end
% asking whether the users changed the name of the file containing the key.
tf = ismember(char('y'),char(input('did you chage the file name of the key? (yes/no) ', 's')));
% if so, they will need to select the matlab file that cotains the key. 
if tf == 1
    
    key_name = uigetfile(('*.mat'), 'Select the key file', key_directory);
else
    
    key_name = 'key.mat';
   
end

% loading the key into the workspace
key_file = sprintf('%s/%s', key_directory, key_name);
load (key_file);

% clear to_save
% making a new folder called "unblind"
mkdir (text_directory, 'unblinded');
new_directory = sprintf('%s/%s', text_directory, 'unblinded');

[total_num,~] = size (key);
num = length(filename);

for i = 1:num % for all the text files selected
    [~, current, ~]= fileparts(char(filename(i))); %get the name of the files
    current_name = string(current);
    
    for j = 1:total_num

        random_name = string(key(j,2));
        % extracting the original name of the file. 
        if strcmp (current_name, random_name)
            
            original_name = string(key(j,3));
            
            break
        end
    end
    
    % coping the file and renaming based on the original name
    unblind_file = sprintf ('%s/%s', new_directory, original_name);
    random_file = sprintf('%s/%s', text_directory, char(filename(i)));
    copyfile(random_file, unblind_file);
    
end

clear all












