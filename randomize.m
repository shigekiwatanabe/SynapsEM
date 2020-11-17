
% written by shigeki for the use in the Watanabe lab. 6/23/2020
% this program will randomize the images that are in the same folder and
% move the randomized images into a new folder ("randomized"). The key will
% be automatically saved in the randomized folder. 

% to run this program, simply type in randomize in the command window. 


clear all
%prompting users to select the directory where the files are and which
%files they want to shuffle. 
disp('Select a folder containing tif files');
directory = uigetdir('/Users/watanabe_lab/Dropbox (Watanabe_lab)/Watanabe_lab Team Folder/'); %CHANGE HERE!
[filename] = uigetfile(('*'), 'MultiSelect', 'on','Select all image files', directory);

%asking users whether they want to keep to the original files
tf = ismember(char('y'),char(input('do you want to duplicate the images? (yes/no) ', 's')));

key = {};%initializing variables
total_num = length(filename);% the total number of files

%the first column of the key is the original file names in order (xxx.tif)
for i = 1:total_num
    
    key(i,1) = filename(i);
    
end
%making a new directory called randomized
mkdir (directory, 'randomized');

new_directory = sprintf('%s/%s', directory, 'randomized');
%generating random numbers
random_num = randperm(total_num);

for i = 1:total_num
    
    temp_name = num2str(random_num(i));
    
    
    original_name = sprintf('%s/%s', directory, char(filename(i)));
    [~, name, ext]= fileparts(char(filename(i)));
    tail = ext;
    
    if random_num(i) < 10
        
        head = '0000';
        
    elseif (random_num(i) > 9) & (random_num(i) < 100)

        head = '000';
        
    elseif (random_num(i) > 99) & (random_num(i) < 1000)

        head = '00';

    else

        head = '0';

    end
    
    new_name = sprintf ('%s%s', head, temp_name);%the new name is assigned to the file being processed
    new_file = sprintf ('%s/%s%s', new_directory, new_name, tail);
    
    if tf ==1 %if the originals images are to be kept, images will be copied and randomized.
        copyfile(original_name, new_file);
    else %otherwise the original images will be moved to a new folder and renamed.  
        movefile(original_name, new_file);
    end
    
    key(i,2) = cellstr(new_name);%the 2nd column of the key lists the randomized names of the files without an extension.
    
    % the third column of the key lists the decoded names for the text files.  
    key(i,3) = cellstr(sprintf ('%s%s', name, '.txt'));
    
end
% automatically save the key
cd (new_directory);
clear directory ext filename head i name new_directory new_file new_name original_name random_num tail temp_name total_num tf
save (sprintf ('%s', 'key.mat'));



