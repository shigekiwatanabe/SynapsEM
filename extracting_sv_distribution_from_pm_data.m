%1/27/20; Written by Shigeki Watanabe for Watanabe Lab use

%extracting the data for the distribution of vesicles relative to active 
%zone membrane. This is to be used after running the "start_analysis" on
%all the samples you have in a set and save the workspace as "xxx.mat".
%This program will go through every field in the workspace and extract the
%distribution of all synaptic vesicles relative to the active zone
%membrane and spits out the data as tables. per_synapse means that all the
%number in each bin is summed. per_profile means that each image is treated
%as independent data point. If you are doing the 2D analysis, per_profile
%is the only thing that is relevant to the analysis. 


disp('Select folder containing matlab file');
directory = uigetdir('/Users/watanabe_lab/Dropbox (Watanabe_lab)/Watanabe_lab Team Folder/'); %CHANGE HERE!
filename = uigetfile(('*.mat'), 'Select matlab file', directory);
directory = [directory '/' filename];    
sample_in = load(directory);
sample_out = struct;
all_fields = fieldnames(sample_in); % all_fields generates an array of strings w/ weird ordering eg. synapse1, synapse10... synapse2
[ordered_fields, index_order] = sort_nat(all_fields); %ordered_fields is an array w/ string names w/ correct order eg. synapse1, synapse2...synapse10


temp_table_1 = zeros(1,1);
temp_table_2 = zeros(1,1);
synapse_table = zeros(1,1);
norm_abundance = zeros(1,1);
d=1;
for i = 1:length(ordered_fields)
    
    [a,b] = size (sample_in.(ordered_fields{i}).vesicle_distribution_pm.all_SV);
    c=1;
    
    
    for k = 7:b
        
        for j = 1:a
            
            %treating distribution from each synapse
            temp_table_1 (j, c) = sample_in.(ordered_fields{i}).vesicle_distribution_pm.all_SV (j,k);
            
            
            %treating distribution from each image as independent values
            temp_table_2 (j, d) = sample_in.(ordered_fields{i}).vesicle_distribution_pm.all_SV (j,k);
            
            
        end
        c=c+1;
        d=d+1;
    end
    sample_out.(ordered_fields{i}).raw_num_per_profile = temp_table_2;
    
    
    %summing each row to get the number per synapse
    for j = 1:a
        synapse_table (j,1) = sample_in.(ordered_fields{1}).vesicle_distribution.all_SV (j,1);
        norm_abundance  (j,1) = sample_in.(ordered_fields{1}).vesicle_distribution.all_SV (j,1);
        synapse_table (j,i+1) = sum(temp_table_1 (j,:));
        norm_abundance (j,i+1) = sample_in.(ordered_fields{i}).vesicle_distribution_pm.all_SV(j,6);
    end
    
end


sample_out.average = synapse_table;
sample_out.norm_abundance = norm_abundance; 


clear a b c d i j k temp_table_1 temp_table_2 synapse_table ordered_fields sample_in directory filename all_fields index_order norm_abundance
