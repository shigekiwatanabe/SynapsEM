
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


pm_length = zeros(1,1);


for i = 1:length(ordered_fields)

    for j = 1:length(sample_in.(ordered_fields{i}).raw_data)
       
        pm_length (j+2, i) = sample_in.(ordered_fields{i}).raw_data(j).analysis_data.pm.length;
        
    end
    pm_length (1, i)= j;
    pm_length (2, i)= sum(pm_length(3:j+2,1))/j;%average per sample in the first row
    
end

norm_factor= zeros(1,1);

[a,b]=size(pm_length);

for i = 1:b
    c=1;
    for j = 3:a
        
        norm_factor(c,i) = abs(pm_length(j,i)/pm_length(2,1));
        c=c+1;
    end
end

for i = 1:length(ordered_fields)

    for j = 1:length(sample_in.(ordered_fields{i}).raw_data)        
        temp_num_docked = 0;
        temp_num_tethered =0;
        if isfield (sample_in.(ordered_fields{i}).raw_data(j).analysis_data, 'vesicle')
            
            sample_out.(ordered_fields{i}).all_sv (j,1) = length(sample_in.(ordered_fields{i}).raw_data(j).analysis_data.vesicle) *norm_factor(j,i);
                                      
            for k = 1:length(sample_in.(ordered_fields{i}).raw_data(j).analysis_data.vesicle)
                
                if strcmp (sample_in.(ordered_fields{i}).raw_data(j).analysis_data.vesicle(k).name, 'docked_SV')
                    
                    temp_num_docked = temp_num_docked +1;
                    
                end
                
                if strcmp (sample_in.(ordered_fields{i}).raw_data(j).analysis_data.vesicle(k).name, 'tethered_SV')
                    
                    temp_num_tethered = temp_num_tethered +1;
                    
                end
                
            end
            
            sample_out.(ordered_fields{i}).docked_sv (j,1) = temp_num_docked*norm_factor(j,i);
                        
            sample_out.(ordered_fields{i}).tethered_sv (j,1) = temp_num_tethered*norm_factor(j,i);
    
        end
    end
end
   

clear a b c all_fields directory filename i index_order j k mean_profile ordered_fields temp_num_docked temp_num_tethered norm_factor sample_in
    
    
    
    