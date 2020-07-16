%updated 3/11/17; Written by Morven Chin for Watanabe Lab use
%Intended to compile data from pits_reconstruct function in a readable
%format. Can also be used with 2D data for comparison across samples

clear

%creates an array of all the variable names (as string)
disp('Select folder containing matlab file');
directory = uigetdir('/Users/watanabe_lab/Dropbox (Watanabe_lab)/Watanabe_lab Team Folder/Data/Morven/'); %CHANGE HERE!
filename = uigetfile(('*.mat'), 'Select matlab file', directory);
directory = [directory '/' filename];    
load(directory);
all_fields = fieldnames(sample_out);

compiled_data = struct('PitData', [], 'MiscData', []);
pit_data = {}; %initialize empty array for pit data
misc_data = {}; %initialize empty cell array for misc data eg. Pr, Pvr...

a = 2; %array row index
b = 2;
%iterate through all the files in loaded .mat file to copy their data to a new
%data array
for i = 1:length(all_fields) 
    
    new_label = all_fields{i}(1:length(all_fields{i})-7); %removes the '_output' part for labeling purposes
    misc_data(b,1) = {new_label};
    misc_data(1,2:11) = {'Pits Total', '30 nm SV Total',...%creates data labels
        'Pvr(30nm) (%)', 'Norm. Pits', 'Norm. 30 nm SV', 'Pits Raw',...
        'Norm. 30 nm SV Raw', 'Total AZ', 'AZ w/ Pits', 'Pr (%)'};
    
    col = length(sample_out.(all_fields{i}).MiscData(1,:)); %get the dimensions of misc_data array to copy
    row = length(sample_out.(all_fields{i}).MiscData(:,1));
        
    %transfer all misc data
    for j = 1:row-1
        
        for k = 1:col
                misc_data(b, 1+k) = {sample_out.(all_fields{i}).MiscData{j+1,k}};
        end
                
            b = b+1;
    end
    
    %checks if file is an output file, not raw data, and if that synapse
    %has pits
    if length(strfind(all_fields{i}, 'output')) ~= 0
        
        if length(sample_out.(all_fields{i}).PitData) ~=0

            pit_data(a,1) = {new_label};
            pit_data(1,2:6) = {'Distance from Edge (xy or z)', 'Distance from Center', 'Normalized Distance from Edge',...
                'Pit Height', 'Height Cutoff'};


            col = length(sample_out.(all_fields{i}).PitData(1,:)); %get the dimensions of pit_data array to copy
            row = length(sample_out.(all_fields{i}).PitData(:,1));

            %transfer all pit data
            for j = 1:row

                for k = 1:col
                    pit_data(a, 1+k) = {sample_out.(all_fields{i}).PitData(j,k)};
                end

                a = a+1;
            end
        end
    end
end

%Shows basic statistics of all data, intended for a set of 3D reconstructions 
misc_data(b+1, 1) = {'Total'};
misc_data(b+2, 1) = {'Average'};
misc_data(b+3, 1) = {'StdDev'};


%generates the statistics
for col = 2:length(misc_data(1,:))
    
    real_num = 0; %keeps count of non-NaN values
    total = 0;
    stddev_tot = 0;
    
    for row = 2:b-1
        
        if ~isnan(misc_data{row,col}) %& misc_data{row,col} ~= 0 %only interested in synapses w/ pits
            real_num = real_num + 1;
            total = total + misc_data{row,col};
        end
    end
    
    if col ~= 4 && col ~= 11
        
        misc_data{b+1, col} = total;
    end
    
    avg = total/(real_num);
    misc_data{b+2, col} = avg;
    
    %calculate std dev
    for row = 2:b-1
        
        if ~isnan(misc_data{row,col}) %& misc_data{row,col} ~= 0
            stddev_tot = stddev_tot + (avg - misc_data{row,col}) ^ 2;
        end
    end
    
    misc_data{b+3, col} = (stddev_tot/(real_num))^.5;
end

compiled_data.PitData = pit_data;
compiled_data.MiscData = misc_data;

clear i b new_label a row col j k total avg real_num stddev_tot

clear directory filename all_fields pit_data misc_data S