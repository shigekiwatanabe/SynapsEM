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

structures = {'SV', 'DCV', 'LV', 'CCV'};
pooled_raw_num = zeros(1,1);
mean_profile = zeros(1,1);

for i = 1:length(ordered_fields)

    for k = 1:4

        for j = 6:length(sample_in.(ordered_fields{i}).vesicle_diameter.(structures{k}).average_total)
            sample_out.(structures{k}).pooled_raw_num (1,i) =length(sample_in.(ordered_fields{i}).vesicle_diameter.(structures{k}).average_total)-5;
            sample_out.(structures{k}).pooled_raw_num (j-4,i) = sample_in.(ordered_fields{i}).vesicle_diameter.(structures{k}).average_total(j);
            
        end
        for j = 6:length(sample_in.(ordered_fields{i}).vesicle_diameter.(structures{k}).average_profile)
            
            sample_out.(structures{k}).mean_profile (1,i) =length(sample_in.(ordered_fields{i}).vesicle_diameter.(structures{k}).average_profile)-5;
            sample_out.(structures{k}).mean_profile (j-4,i) = sample_in.(ordered_fields{i}).vesicle_diameter.(structures{k}).average_profile(j);
            
        end
    end
    
    sample_out.cumulative(:,i) = sample_in.(ordered_fields{i}).vesicle_diameter.cumulative(:,4);
    
    
end

clear all_fields directory filename i index_order j k mean_profile ordered_fields poopled_raw_num sample_in structures pooled_raw_num
    
    
    
    