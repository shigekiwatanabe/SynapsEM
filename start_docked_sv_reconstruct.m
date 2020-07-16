%updated 3/11/17; Written by Morven Chin for Watanabe Lab use
%Automatically runs through all reconstructions from SAME SAMPLE in workspace
%or through 2d synapse data
%Must load a .mat file containing raw data of reconstructed synapses from
%same sample. To be used with pits_reconstruct and compile_3d_reconstruct
%Do not mix/match 3d/2d synapse data in the same .mat file, but same file
%can contain 2d data across all samples
%Use compile_3d_reconstruct on the output files to compile the data

clear 

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
        
        for p = 1:length(sample_in.(ordered_fields{i}).raw_data)
            
            q(1,p)= isfield (sample_in.(ordered_fields{i}).raw_data(p).distance_data, 'pits');
        end
        
%         if sum (q)>0 % == 0 means no pits in this active zone. switch this to >0 if only counting synapses with pits. or disable this to count every synapses
            
            sample_out.(name_list{i}) = docked_vesicle_reconstruct(sample_in.(ordered_fields{i}), reconstruct_tf, pix_size, sect_thick, height_cut);
%         end
    end
    
    if isfield (sample_out,(name_list{i}))
    if isempty (sample_out.(name_list{i}).DockedSVData) ==0
        
    [row, col] = size(sample_out.(name_list{i}).DockedSVData);
    sv_in_row = col/5;
    
    ind = 1;
    for m = 1:sv_in_row
        
        for j= 1:row
            
            if sample_out.(name_list{i}).DockedSVData(j,(5*(m-1)+1)) >0
                
                b(ind)=(5*(m-1))+2;% row that docked sv in
                a(ind)=j;% column that docked sv in
                
                ind=ind+1;
            end
        end
    end
    clear ind
    for k=1:length(a)
        
        c=1;
        
        for m=1:sv_in_row
            
            for j = 1:row
                
                if sample_out.(name_list{i}).DockedSVData(j,(5*(m-1)+1)) >0
                    
                    if sample_out.(name_list{i}).DockedSVData(a(k),b(k)+3)== sample_out.(name_list{i}).DockedSVData(j,(5*m))
                        
                        x_dist = abs(sample_out.(name_list{i}).DockedSVData(a(k),b(k))...
                            -     sample_out.(name_list{i}).DockedSVData(j,(5*(m-1)+2)));
                        
                    elseif sample_out.(name_list{i}).DockedSVData(a(k),b(k)+3)~= sample_out.(name_list{i}).DockedSVData(j,(5*m))
                        
                        x_dist = abs(sample_out.(name_list{i}).DockedSVData(a(k),b(k))...
                            +     sample_out.(name_list{i}).DockedSVData(j,(5*(m-1)+2)));
                        
                    end
                    
                    z_dist=(j-a(k))*50;
                    
                    dist_data(k,c)=sqrt(x_dist^2+z_dist^2);
                    
                    c=c+1;
                end
            end
        end
    end
    
    clear x_dist z_dist c a b
    
    sample_out.(name_list{i}).distance_matrix = dist_data;
    
    clear dist_data
    end
    end
    
end

clear directory filename all_fields i name_list height_cut pix_size sect_thick reconstruct_tf index_order ordered_fields col j k m row sv_in_row p q