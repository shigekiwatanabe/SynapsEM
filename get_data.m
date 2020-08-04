function data = get_data (pixel_size)

% Opening txt files and execute distance calculations.

% Choosing a directory using a dialog box
disp ('choose the directory where the text files are located');
directory_name = uigetdir('/Users/watanabe_lab/Dropbox (Watanabe_lab)/Watanabe_lab Team Folder/');
%change the path inside the () to set the initial directory. 

% Choosing the data files using a dialog box
fprintf ('select all data files');
[filename] = uigetfile(('*.txt'), 'MultiSelect', 'on',...
                        'Select all data files\n', directory_name);

                    
                    
% when users cancel the execution, stop the program and display
%'canceled'
if (isequal (filename, 0))
    
    disp ('canceled')
    return
    
elseif (ischar (filename)) % this means only one file is opened
    
    section_number = 1;
    
    file_name = sprintf('%s/%s', directory_name, filename);
    
    data.analysis_data = import_analysis_data(file_name, pixel_size);
                                          
                                          
else %if multiple files are selected
    
    for h = 1:length (filename)

        % converting a cell array to a character array
        file_name = char(filename(h));
        
        % directroy name needs to be added to file_name, so the program can
        % locate the file that you are opening
        file_name = sprintf('%s/%s', directory_name, file_name);
        
        data(h).analysis_data = import_analysis_data(file_name, pixel_size);

    end
end

for h = 1:length(data) 
    
    if isfield (data(h).analysis_data, 'vesicle')|...
            isfield (data(h).analysis_data, 'pits')|...
            isfield (data(h).analysis_data, 'fpits')|...
            isfield (data(h).analysis_data, 'endosomes')|...
            isfield (data(h).analysis_data, 'fendosomes')|...
            isfield (data(h).analysis_data, 'mvb')|...
            isfield (data(h).analysis_data, 'fmvb')|...
            isfield (data(h).analysis_data, 'coated_pits')
        
    
        data(h).distance_data = min_2D_dist (data(h).analysis_data,...
                                         pixel_size);
    end
        
        
end

end
   
    
    
