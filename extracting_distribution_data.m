%11/13/19; Written by Shigeki Watanabe for Watanabe Lab use
%extracting the distribution data from the DockedSVData table. Before
%running this program, you have to run either "start_pit_reconstruct" or
%"start_fsv_reconstruct (or docked_sv)", and save the sample_out in the
%workspace. If you have multiple samples, make sure to rename the
%sample_out. by default, this program will extract the normalized distance
%from the table. If you need to extract the distance to the center or
%distance to the edge in the absolute number, change the code in line 42.  


tf = ismember(char('y'),char(input('is this for pits? (yes/no) ', 's')));

disp('Select folder containing matlab file');
directory = uigetdir('/Users/watanabe_lab/Dropbox (Watanabe_lab)/Watanabe_lab Team Folder/'); %CHANGE HERE!
filename = uigetfile(('*.mat'), 'Select matlab file', directory);
directory = [directory '/' filename];    
sample_in = load(directory);
sample_out = struct;
[fields] = fieldnames(sample_in);



c=1;
temp = zeros(1,1);
temp_2 = zeros(1,1);

if tf == 0 
    
    for m=1:length(fields)
        
        
         all_fields = fieldnames(sample_in.(fields{m})); % all_fields generates an array of strings w/ weird ordering eg. synapse1, synapse10... synapse2
    
        
        [ordered_fields, index_order] = sort_nat(all_fields); %ordered_fields is an array w/ string names w/ correct order eg. synapse1, synapse2...synapse10
        
        
        for k = 1:length(ordered_fields)
            
            [a,b] = size(sample_in.(fields{m}).(ordered_fields{k}).DockedSVData);
            
            total = b/5;
            
            d = 0;
            
            for i = 1:a
                
                for j = 1:total
                    
                    if sample_in.(fields{m}).(ordered_fields{k}).DockedSVData (i, (5*j)-4) >0
                        
                        temp(c,1) = sample_in.(fields{m}).(ordered_fields{k}).DockedSVData (i, (5*j)-2);
                        %change here to (5*j)-4 for distance to edge and (5*j)-3 for distance to center
                        
                        c=c+1;
                        d=d+1;
                        
                    end
                end
            end
            
            temp_2(k,1) = d;
            
        end
        
        sample_out.(fields{m}).distribution_table = temp;
        sample_out.(fields{m}).number_table = temp_2;
        
    end

else 
    
    for m=1:length(fields)
        
        
        all_fields = fieldnames(sample_in.(fields{m})); % all_fields generates an array of strings w/ weird ordering eg. synapse1, synapse10... synapse2

        
        [ordered_fields, index_order] = sort_nat(all_fields); %ordered_fields is an array w/ string names w/ correct order eg. synapse1, synapse2...synapse10
        
        
        for k = 1:length(ordered_fields)
            
            [a,b] = size(sample_in.(fields{m}).(ordered_fields{k}).PitData);
            
            total = b/5;
            
            d = 0;
            
            for i = 1:a
                
                for j = 1:total
                    
                    if sample_in.(fields{m}).(ordered_fields{k}).PitData (i, (5*j)-4) >0
                        
                        temp(c,1) = sample_in.(fields{m}).(ordered_fields{k}).PitData (i, (5*j)-2);
                        %change here to (5*j)-4 for distance to edge and (5*j)-3 for distance to center
                        
                        c=c+1;
                        d=d+1;
                        
                    end
                end
            end
            
            temp_2(k,1) = d;
            
        end
        
        sample_out.(fields{m}).distribution_table = temp;
        sample_out.(fields{m}).number_table = temp_2;
        
    end
    
end
    
    

clear total c i j b a temp k ordered_fields sample_in directory filename index_order all_fields fields m tf temp_2 d tf_3d