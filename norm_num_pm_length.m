
% written by Shigeki Watanabe for the Watanabe lab use. 

% this script will extract the vesicle size data from the samples already
% processed using start_analysis. 

disp('Select folder containing matlab file');
directory = uigetdir('/Users/watanabe_lab/Dropbox (Watanabe_lab)/Watanabe_lab Team Folder/'); %CHANGE HERE!
filename = uigetfile(('*.mat'), 'Select matlab file', directory);
directory = [directory '/' filename];
sample_in = load(directory);
sample_out = struct;
all_fields = fieldnames(sample_in); % all_fields generates an array of strings w/ weird ordering eg. synapse1, synapse10... synapse2
[ordered_fields, index_order] = sort_nat(all_fields); %ordered_fields is an array w/ string names w/ correct order eg. synapse1, synapse2...synapse10




for i = 1:length(ordered_fields)

    for j = 1:length(sample_in.(ordered_fields{i}).raw_data)
       
        temp_num_docked = 0;
        temp_num_tethered =0;
        
        if isfield (sample_in.(ordered_fields{i}).raw_data(j).analysis_data, 'vesicle')
            
            sample_out.(ordered_fields{i}).all_sv (j,1) = length(sample_in.(ordered_fields{i}).raw_data(j).analysis_data.vesicle)...
                                                / sample_in.(ordered_fields{i}).raw_data(j).analysis_data.pm.length;
                                      
            for k = 1:length(sample_in.(ordered_fields{i}).raw_data(j).analysis_data.vesicle)
                
                if strcmp (sample_in.(ordered_fields{i}).raw_data(j).analysis_data.vesicle(k).name, 'docked_SV')
                    
                    temp_num_docked = temp_num_docked +1;
                    
                end
                
                if strcmp (sample_in.(ordered_fields{i}).raw_data(j).analysis_data.vesicle(k).name, 'tethered_SV')
                    
                    temp_num_tethered = temp_num_tethered +1;
                    
                end
                
            end
            
            sample_out.(ordered_fields{i}).docked_sv (j,1) = temp_num_docked/sample_in.(ordered_fields{i}).raw_data(j).analysis_data.pm.length;
                        
            sample_out.(ordered_fields{i}).tethered_sv (j,1) = temp_num_tethered/sample_in.(ordered_fields{i}).raw_data(j).analysis_data.pm.length;
    
        end
    end
end
   

clear a b all_fields directory filename i index_order j k mean_profile ordered_fields temp_num_docked temp_num_tethered
    
    
    
    