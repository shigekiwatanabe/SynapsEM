function name = extracting_original_filename (filename)
% created by Shigeki Watanabe on 9/13/2019 to extract the orignal name of
% the tiff files from blinded datase. This is used when the R code somehow
% did not work to generate the correct key. 


fid = fopen(filename);

while (true)
    
    tline = fgetl(fid);
    
    [type] = strtok(tline);
    
    if strcmp (type, 'Original')
        
%         disp (tline);
        [text1, text2, text3, text4, original_name] = strread(tline, '%s %s %s %s %s');
        
        str1 = string(original_name);
        str2 = '.txt';
        
        name = append(str1, str2);
        
        break,
        
    end
end
fclose (fid);
clear fid tline thype text1 text2 text3 orginal_name str1 str2 
end
        
        