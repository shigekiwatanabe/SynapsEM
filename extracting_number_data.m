%11/13/19; Written by Shigeki Watanabe for Watanabe Lab use
%extracting the number data from the vesicle_number table from all the
%samples processed for the experiments. the matlab file should contain all
%the data in order. after running the "start_analysis", all samples need to
%be renamed in the workspace such that they appear in the order you want to
%have in the final graph (in the prism). Then, save the workspace. Type in
%extacting_number_data in the command window. It will prompt two questions.
%the first question will ask whether you need the typical values. If you
%answer yes to this, it will give you the following data in a table so you
%can directly copy the values into the prism: docked SV, SV within 30 nm of
%active zone membrane, total number of vesicles in terminals, large
%vesicles near the active zone (presumably recently endocytosed), large
%vesicles in the terminal, clathrin-coated vesicles in the terminal,
%exocytic ptis, endocytic pits, and endosomes. the second question will ask
%if ferritin was used in the experiments. If yes, it will also produces
%tables with the values for the following categories: ferritin+ docked sv,
%ferritin+ sv within 30 nm of AZ membrane, ferritin+ SV in the terminal,
%ferritin+ LV near the AZ membrnae, ferritin+ LV in the terminal, ferritin+
%CCV, ferritin+ endocytic pits, and ferritin+ endosomes (when annnotated as
%fbuds in imageJ). If you answer no to both questions, you can select your
%own row to extract the values. For example, if you want to get the values
%for clathrin-coated pits, type in "46" when prompted. the first row in
%each table is the total number sections you analyzed for each sample. 

%If the number of sections analyzed for each specimen is not the same, 0s
%will be added at the end of each column to match the largest number in the
%series. After coping the data to the prism, you will need to get rid of
%the 0s. 





disp('Select folder containing matlab file');
directory = uigetdir('/Users/watanabe_lab/Dropbox (Watanabe_lab)/Watanabe_lab Team Folder/'); %CHANGE HERE!
filename = uigetfile(('*.mat'), 'Select matlab file', directory);
directory = [directory '/' filename];    
sample_in = load(directory);
sample_out = struct;
all_fields = fieldnames(sample_in); % all_fields generates an array of strings w/ weird ordering eg. synapse1, synapse10... synapse2
[ordered_fields, index_order] = sort_nat(all_fields); %ordered_fields is an array w/ string names w/ correct order eg. synapse1, synapse2...synapse10

tf = ismember(char('y'),char(input('do you want to extract the typical values? (yes/no) ', 's')));
ferritin_tf = ismember(char('y'),char(input('did you use ferritin in the experiments? (yes/no) ', 's')));

if tf == 0

    row_number =  input('which row?');
    
    for i = 1:length(ordered_fields)
        
        [c,d] = size(sample_in.(ordered_fields{i}).vesicle_number);
            
            table (1, i) = d-5;
            
        for j = 6:d
            
            table (j-4, i) = sample_in.(ordered_fields{i}).vesicle_number(row_number, j);
            
        end
        
    end

else
    
    index = [2, 5, 31, 8, 34, 35, 41, 42, 55];
    
    name_list = {'docked_sv', 'sv_30nm', 'sv_total', 'LV_near_az', 'lv_terminal', 'ccv', 'exo_pits', 'endo_pits', 'endosomes'};
    
    for h = 1:9
        
        for i = 1:length(ordered_fields)
            
            [c,d] = size(sample_in.(ordered_fields{i}).vesicle_number);
            
            table (1, i) = d-5;
            
            for j = 6:d
                
                table (j-4, i) = sample_in.(ordered_fields{i}).vesicle_number(index(h), j);
                
            end
            
        end
        
        sample_out.(name_list{h}) = table;
    end

    
end

if tf >0 & ferritin_tf >0
    
    index = [10, 12, 38, 13, 39, 40, 48, 56];
    
    name_list = {'docked_fsv', 'fsv_30nm', 'fsv_total', 'fLV_near_az', 'flv_terminal', 'fccv', 'fendo_pits', 'fendosomes'};
    
    for h = 1:8
        
        for i = 1:length(ordered_fields)
            
            [c,d] = size(sample_in.(ordered_fields{i}).vesicle_number);
            
            table (1, i) = d-5;
            
            for j = 6:d
                
                table (j-4, i) = sample_in.(ordered_fields{i}).vesicle_number(index(h), j);
                
            end
            
        end
        
        sample_out.(name_list{h}) = table;
    end
end
    
    
    
clear all_fields directory filename i index_order j name_list ordered_fields row_number sample_in h index tf ferritin_tf c d
    
