%5/11/19; Written by Shigeki Watanabe for Watanabe Lab use
%Automatically runs through all data for calculating distances between
%receptors to either pits or docked vesicles. 
%Must load a .mat file containing raw data of normalized distance from each 
%feature to center. Must run "start_particle_reconstruct",
%"start_pit_reconstruct", and "start_docked_SV_reconstruct" before running
%this program. After those programs, sample_out must be renamed as
%"receptors" for gold particles, "pits" for pits, and "docked_sv" for docked
%sv. Then, the workspace should be saved. This program starts by selcting
%the .mat file containig, pits, receptors, and docked_sv. If either pits or
%docked_sv is missing, then it only calculates distance for whichever
%exists. The calculations are only done from those that contain both
%receptors and pits or docked sv. 


disp('Select folder containing matlab file');
directory = uigetdir('/Users/watanabe_lab/Dropbox (Watanabe_lab)/Watanabe_lab Team Folder/'); %CHANGE HERE!
filename = uigetfile(('*.mat'), 'Select matlab file', directory);
directory = [directory '/' filename];    
sample_in = load(directory);
sample_out = struct;
all_fields = fieldnames(sample_in); % all_fields generates an array of strings w/ weird ordering eg. synapse1, synapse10... synapse2
[ordered_fields, index_order] = sort_nat(all_fields); %ordered_fields is an array w/ string names w/ correct order eg. synapse1, synapse2...synapse10
field_names = fieldnames(sample_in.(ordered_fields{1}));

pits_tf = isfield (sample_in, 'pits');
docked_tf = isfield(sample_in, 'docked_sv');
%iterate through all the files in loaded .mat file to automatically analyze
%the raw data
for i = 1:length(field_names) 
    
    if pits_tf >0
        
        name_list(1,i) = {strcat(field_names{i}, '_pits')}; %generates name list
        sample_out.(name_list{i}) = pits_receptor_distance (sample_in.pits.(field_names{i}), sample_in.receptors.(field_names{i}) );
   
    end
    
    if docked_tf >0
        
        name_list(1,i) = {strcat(field_names{i}, '_docked_sv')}; %generates name list
        sample_out.(name_list{i}).docked2receptors = docked_sv_receptors_distance (sample_in.docked_sv.(field_names{i}), sample_in.receptors.(field_names{i}) );
    
    end
end

clear directory filename all_fields i  index_order ordered_fields pits_tf docked_tf name_list field_names