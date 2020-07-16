% This function is written by Shigeki Watanabe to convert the serial-section
% analysis data into text files, which can be used to generate 3D volume
% rendering in Maya. The serial-section must be aligned prior to image
% analysis. To use this function, run "start_analysis" for all text files
% in synapses, and save the resulting variables in the workspace as .mat.
% Select the .mat file after calling this function in the command window.
% The output of this function is to generate a bunch of text files that are
% named after what structures they represent. for pm, az, and dp, x,y,z are
% shown. for vesicles, x,y,z, and radius of vesicles. 

section_thick = input('What is the thickness of each section (nm)? ');
disp('Select folder containing matlab file');
directory = uigetdir('/Users/watanabe_lab/Dropbox (Watanabe_lab)/Watanabe_lab Team Folder/'); %CHANGE HERE!
filename = uigetfile(('*.mat'), 'Select matlab file', directory);

if (isequal (filename, 0)) % if cancelled, finish the program. 
    
    disp ('canceled')
    return
else
    directory_2 = [directory '/' filename];
    sample_in = load(directory_2);
    sample_out = struct;
    all_fields = fieldnames(sample_in); % all_fields generates an array of strings w/ weird ordering eg. synapse1, synapse10... synapse2
    [ordered_fields, index_order] = sort_nat(all_fields); %ordered_fields is an array w/ string names w/ correct order eg. synapse1, synapse2...synapse10

    % generating a text files for plasma membrane containing x,y,z coordinates 
    for i = 1:length(ordered_fields)
        %making new directories with the name of varialbles originally in the workspace.
        dir_name = char(ordered_fields{i});
        mkdir (directory, dir_name);
        new_dir = [directory '/' dir_name];
        
        %the text file will be named "pm".
        pm_text = sprintf('%s/%s', new_dir, 'pm');
        fid = fopen(pm_text, 'w');
        for j = 1:length(sample_in.(ordered_fields{i}).raw_data)
            
            for k = 1:length(sample_in.(ordered_fields{i}).raw_data(j).analysis_data.pm.x)
                
                a = sample_in.(ordered_fields{i}).raw_data(j).analysis_data.pm.x(k);
                b = sample_in.(ordered_fields{i}).raw_data(j).analysis_data.pm.y(k);
                c = j*section_thick;
                
                fprintf(fid, '%d %d %d \n', a, b, c);
                
            end
        end
        fclose(fid);
        
        %counting the number of active zone in case there are multiple active zones.
        az_num =1;% assuming only one active zone in each profile
        for j = 1:length(sample_in.(ordered_fields{i}).raw_data)
            
            if length(sample_in.(ordered_fields{i}).raw_data(j).analysis_data.az)>1
                
                az_num = length(sample_in.(ordered_fields{i}).raw_data(j).analysis_data.az);
                
            end
        end
        %the directory is named as az_xxx where xxx is the number of the
        %active zone. 
        az_name = sprintf('%s_%d', 'az', az_num);
        az_text = sprintf('%s/%s', new_dir, az_name);
        
        fid = fopen(az_text, 'w');
        for j = 1:length(sample_in.(ordered_fields{i}).raw_data)
            for m = 1:length(sample_in.(ordered_fields{i}).raw_data(j).analysis_data.az)
                
                for k = 1:length(sample_in.(ordered_fields{i}).raw_data(j).analysis_data.az(m).x)
                    
                    a = sample_in.(ordered_fields{i}).raw_data(j).analysis_data.az(m).x(k);
                    b = sample_in.(ordered_fields{i}).raw_data(j).analysis_data.az(m).y(k);
                    c = j*section_thick;
                    
                    fprintf(fid, '%d %d %d \n', a, b, c);
                    
                end
            end
        end
        fclose(fid);
        
        % if dp is straced, there will be a text file, named dp in the same
        % folder. 
        dp_text = sprintf('%s/%s', new_dir, 'dp');
        fid = fopen(dp_text, 'w');
        for j = 1:length(sample_in.(ordered_fields{i}).raw_data)
            
            if isfield (sample_in.(ordered_fields{i}).raw_data(j).analysis_data, 'dp')
                
                for k = 1:length(sample_in.(ordered_fields{i}).raw_data(j).analysis_data.dp.x)
                    
                    a = sample_in.(ordered_fields{i}).raw_data(j).analysis_data.dp.x(k);
                    b = sample_in.(ordered_fields{i}).raw_data(j).analysis_data.dp.y(k);
                    c = j*section_thick;
                    
                    fprintf(fid, '%d %d %d \n', a, b, c);
                    
                end
            end
        end
        fclose(fid);
        
        %for vesicles, the names of text files are based on the structures.
        %i.e. SV, tethered_SV, LV...
        idx =1;
        vesicle_name= {};%need to figure out which names are used in the analysis
        for j = 1:length(sample_in.(ordered_fields{i}).raw_data)
            
            if isfield (sample_in.(ordered_fields{i}).raw_data(j).analysis_data, 'vesicle')
                
                for m = 1:length(sample_in.(ordered_fields{i}).raw_data(j).analysis_data.vesicle)
                    
                    temp_name = sample_in.(ordered_fields{i}).raw_data(j).analysis_data.vesicle(m).name;
                    %going through all the data and checking what
                    %structures were traced. 
                    if ~any(strcmp(vesicle_name,temp_name))
                        
                        vesicle_name{idx} = temp_name;
                        idx=idx+1;
                        
                    end
                end
            end
        end
        % for paritcular vesicle type, generate a single text file with
        % x,y,z cooridnates. also add radius so the program can generate
        % vesicles of that size. 
        for n = 1:length(vesicle_name)
            
            vesicle_text = sprintf('%s/%s', new_dir, vesicle_name{n});
            
            fid = fopen(vesicle_text, 'w');
            
            for j = 1:length(sample_in.(ordered_fields{i}).raw_data)
                
                if isfield (sample_in.(ordered_fields{i}).raw_data(j).analysis_data, 'vesicle')
                    
                    for m = 1:length(sample_in.(ordered_fields{i}).raw_data(j).analysis_data.vesicle)
                        
                        if strcmp(sample_in.(ordered_fields{i}).raw_data(j).analysis_data.vesicle(m).name, vesicle_name{n})
                            
                            a = sample_in.(ordered_fields{i}).raw_data(j).analysis_data.vesicle(m).x;
                            b = sample_in.(ordered_fields{i}).raw_data(j).analysis_data.vesicle(m).y;
                            c = j*section_thick;
                            d = sample_in.(ordered_fields{i}).raw_data(j).analysis_data.vesicle(m).r;
                            
                            fprintf(fid, '%d %d %d %d \n', a, b, c, d);
                            
                        end
                    end
                end
            end
            fclose(fid);
        end%iterate through all vesicle names used in the study.
    end%iterate through all samples (i.e. syn1, syn2,...)
end%finish the program

clear all %leave no trace in the workspace. 

        

      
    
    
   