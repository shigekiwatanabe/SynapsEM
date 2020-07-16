function table = ferritin_vesicle_count (data)


table = zeros (31,length(data)+5);

% row 1 = total length of active zone
% row 2-9 = vesicles within active zone and within 30 nm of membrane
% row 10-17 = vesicles outside active zone but within 30 nm of membrane
% row 18-25 = total number of vesicles in the terminal
% row 26-28 = pits
% row 29-31 = coated pits

% row 2,10,18 = docked sv
% row 3,11,19 = tethered sv
% row 4,12,20 = sv within 30 nm of membrane
% row 5,13,21 = sum of the previous 3 rows (2-4 or 9-11 or 16-18)
% row 6,14,22 = DCV
% row 7,15,23 = docked DCV
% row 8,16,24 = LV
% row 9,17,25 = clathrin-coated vesicles
% row 26 = pits in active zone
% row 27 = pits outside the active zone
% row 28 = pits in terminal (total)
% row 29 = coated pits in active zone
% row 30 = coated pits outside the active zone
% row 31 = coated pits in terminal (total)

% the first 5 columns is summary of the data 
% column 1 = mean
% column 2 = median
% column 3 = std 
% column 4 = sem 
% column 5 = skewness

for i = 1:length(data) 
    
    table (1,i+5) = data(i).analysis_data.az.length;
    
    for j = 1:length(data(i).distance_data.vesicle)
            
        vesicle_type = data(i).distance_data.vesicle(j).type;
        
        if data(i).distance_data.vesicle(j).dist2pm <= 30
        
            switch (vesicle_type)
                
                case 'docked_fSV'
                    
                    a=2;
                    
                case 'tethered_fSV'
                    
                    a=3;
                    
                case 'fSV'
                    
                    a=4;
                    
                case 'fDCV'
                     
                     a=6;
                     
                case 'docked_fDCV'
                    
                     a=7;
                    
                case 'fLV'
                    
                    a=8;
                    
                case 'fCCV'
                    
                    a=9;
                    
            end
            
            b=0;
            
            if data(i).distance_data.vesicle(j).dist2az >30
                
                b=8;
                
            end
            
            table(a+b,i+5) =  table(a+b,i+5) + 1;
            
        end
    end
    
    table(18,i+5)=data(i).analysis_data.vesicle_number.docked_fsv_count;
    table(19,i+5)=data(i).analysis_data.vesicle_number.tethered_fsv_count;
    table(20,i+5)=data(i).analysis_data.vesicle_number.cytosolic_fsv_count;
    table(21,i+5)=table(18,i+5) + table(19,i+5) + table(20,i+5);
%     table(22,i+5)=data(i).analysis_data.vesicle_number.dcv_count;
%     table(23,i+5)=data(i).analysis_data.vesicle_number.docked_dcv_count;
    table(24,i+5)=data(i).analysis_data.vesicle_number.flv_count;
    table(25,i+5)=data(i).analysis_data.vesicle_number.fccv_count;
    
    table(5,i+5)=table(2,i+5) + table(3,i+5) + table(4,i+5);
    table(13,i+5)=table(10,i+5) + table(11,i+5) + table(12,i+5);
    
end

for i = 1:length(data)
    
    if isfield(data(i).distance_data, 'fpits')
        
        for j = 1:length(data(i).distance_data.fpits)
            
            if data(i).distance_data.fpits(j).in_az == 1
                
                table(26,i+5) = table(26,i+5) + 1;
                
            elseif data(i).distance_data.fpits(j).in_az == 0
                
                table(27,i+5) = table(27,i+5) + 1;
                
            end
        end
        
        table(28,i+5) = table(26,i+5) + table(27,i+5);
        
    end
end

for i = 1:length(data)
        
    if isfield(data(i).distance_data, 'coated_fpits')
        
        for j = 1:length(data(i).distance_data.coated_fpits)
            
            if data(i).distance_data.coated_fpits(j).in_az == 1
                
                table(29,i+5) = table(29,i+5) + 1;
                
            elseif data(i).distance_data.coated_fpits(j).in_az == 0
                
                table(30,i+5) = table(30,i+5) + 1;
                
            end
        end
        
        table(31,i+5) = table(29,i+5) + table(28,i+5);
        
    end
end
    

for i = 1:31
    
    table(i,1) = mean(table(i,6:length(data)+5));
    table(i,2) = median(table(i,6:length(data)+5));
    table(i,3) = std(table(i,6:length(data)+5));
    table(i,4) = table(i,3)/sqrt(length(data));
    table(i,5) = (table(i,1)-table(i,2))/table(i,3);
    
end



end

                
                
              
                    
            