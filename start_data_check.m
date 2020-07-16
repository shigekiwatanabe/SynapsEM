% Choosing a directory using a dialog box
ribbon_tf = ismember(char('y'),char(input('do these contain synaptic ribbons? (yes/no) ', 's')));
dp_tf = ismember(char('y'),char(input('do these contain dense projections? (yes/no) ', 's')));

disp ('Choose the directory where analysis data is loated');
directory_name = uigetdir('/Volumes/Emania_6/');

% Choosing analysis data files using a dialog box
[filename] = uigetfile(('*.txt'), 'MultiSelect', 'on',...
                        'Select all data files', directory_name);
                    
pixel_size = 0.498;
                    
% when user canceled the execution, stop the program and display
%'canceled'
if (isequal (filename, 0))
    
    disp ('canceled')
    return
          
elseif (ischar (filename)) % this means only one file is opened
    
    section_number = 1;
    % directroy name needs to be added to filename, so the program can
    % locate the proper file 
    file_name = sprintf('%s/%s', directory_name, filename);
    
    data.analysis_data = check_data(file_name,...
                                    pixel_size);
    
    
else
    for h = 1:length (filename)

        % section number will be required for assigning z-coordinates
        % note that section numbers cannot be skipped therefore, the data
        % needs to be in serial.
        section_num(h) = h;
        
        % file_name 
        file_name = char(filename(h));
        
        % directroy name needs to be added to file_name, so the program can
        % locate the file that you are opening
        file_name = sprintf('%s/%s', directory_name, file_name);
        
        data(h).analysis_data = check_data(file_name,...
                                           pixel_size, ribbon_tf, dp_tf);

    end
end

disp ('done')

clear data directory_name file_name filename h pixel_size section_num dp_tf ribbon_tf