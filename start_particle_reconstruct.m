%updated 3/11/17; Written by Shigeki Watanabe for Watanabe Lab use
%Automatically runs through all reconstructions from SAME SAMPLE in workspace
%or through 2d synapse data
%Must load a .mat file containing raw data of reconstructed synapses from
%same sample. To be used with pits_reconstruct and compile_3d_reconstruct
%Do not mix/match 3d/2d synapse data in the same .mat file, but same file
%can contain 2d data across all samples
%Use compile_3d_reconstruct on the output files to compile the data

%clear 

disp('Select folder containing matlab file');
directory = uigetdir('/Users/watanabe_lab/Dropbox (Watanabe_lab)/Watanabe_lab Team Folder/Data/Morven/'); %CHANGE HERE!
filename = uigetfile(('*.mat'), 'Select matlab file', directory);
directory = [directory '/' filename];    
sample_in = load(directory);
sample_out = struct;
all_fields = fieldnames(sample_in); % all_fields generates an array of strings w/ weird ordering eg. synapse1, synapse10... synapse2
[ordered_fields, index_order] = sort_nat(all_fields); %ordered_fields is an array w/ string names w/ correct order eg. synapse1, synapse2...synapse10
name_list = {};


reconstruct_tf = ismember(char('y'),char(input('Is this for 3D reconstruction? (yes/no) ', 's')));
pix_size = input('Pixel Size? ');
sect_thick = input('Section Thickness (nm)? ');
height_cut = input('Pit Cutoff Height (nm)? ');

%iterate through all the files in loaded .mat file to automatically analyze
%the raw data
for i = 1:length(ordered_fields) 
    
    %checks if file is an raw data file, not output file
    if length(strfind(ordered_fields{i}, 'output')) == 0 
        disp([char(10) ordered_fields{i}]);
        name_list(1,i) = {strcat(ordered_fields{i}, '_output')}; %generates name list
        sample_out.(name_list{i}) = particle_reconstruct(sample_in.(ordered_fields{i}), reconstruct_tf, pix_size, sect_thick, height_cut);
    end
end

clear directory filename all_fields i name_list height_cut pix_size sect_thick reconstruct_tf index_order ordered_fields