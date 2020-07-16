function table = vesicle_count_dp (data)

% this function generates the summary table of the count data for all
% structures within 100 nm of dense projections. 

table = zeros (59,length(data)+5);

% row 1 = total length of active zone
% row 2-14 = vesicles within active zone and within 30 nm of membrane
% row 15-27 = vesicles outside active zone but within 30 nm of membrane
% row 28-40 = total number of vesicles in the terminal
% row 26-28 = pits
% row 29-31 = coated pits

% row 2,15,28 = docked sv
% row 3,16,29 = tethered sv
% row 4,17,30 = sv within 30 nm of membrane
% row 5,18,31 = sum of the previous 3 rows (2-4 or 9-11 or 16-18)
% row 6,19,32 = DCV
% row 7,20,33 = docked DCV
% row 8,21,34 = LV
% row 9,22,35 = clathrin-coated vesicles
% row 10,23,36= docked fsv
% row 11,24,37= tethered fsv
% row 12,25,38= fsv within 30 nm of membrane
% row 13,26,39= flv
% row 14,27,40= fccv
% row 41 = pits in active zone
% row 42 = pits outside the active zone
% row 43 = pits in terminal (total)
% row 44 = coated pits in active zone
% row 45 = coated pits outside the active zone
% row 46 = coated pits in terminal (total)
% row 47 = fpits in active zone
% row 48 = fpits outside the active zone
% row 49 = fpits in terminal (total)
% row 50 = coated fpits in active zone
% row 51 = coated fpits outside the active zone
% row 52 = coated fpits in terminal (total)
% row 53 = buds on endosome
% row 54 = fbuds on endosome
% row 55 = endosome (ferritin negative)
% row 56 = fendosome (ferritin positive)
% row 57 = particles
% row 58 = mvb (ferritin negative)
% row 59 = fmvb (ferritin positive)


% the first 5 columns is summary of the data 
% column 1 = mean
% column 2 = median
% column 3 = std 
% column 4 = sem 
% column 5 = skewness

for i = 1:length(data) 
    
    if isfield(data(i).analysis_data,'dp') && isfield(data(i).distance_data, 'vesicle')
    
    table (1,i+5) = data(i).analysis_data.dp.length;
    
    for j = 1:length(data(i).distance_data.vesicle)
            
        vesicle_type = data(i).distance_data.vesicle(j).type;
        
        if data(i).distance_data.vesicle(j).dist2dp <= 100
        
            switch (vesicle_type)
                
                case 'docked_SV'
                    
                    a=2;
                    
                case 'tethered_SV'
                    
                    a=3;
                    
                case 'SV'
                    
                    a=4;
                    
                case 'DCV'
                    
                    a=6;
                    
                case 'docked_DCV'
                    
                    a=7;
                    
                case 'LV'
                    
                    a=8;
                    
                case 'CCV'
                    
                    a=9;
                
                case 'docked_fSV'
                    
                    a=10;
                    
                case 'tethered_fSV'
                    
                    a=11;
                    
                case 'fSV'
                    
                    a=12;
                    
                case 'fLV'
                    
                    a=13; 
                    
                case 'fCCV'
                    
                    a=14;
                    
            end
            
            b=0;
            
            if data(i).distance_data.vesicle(j).dist2az >100
                
                b=13;
                
            end
            
            table(a+b,i+5) =  table(a+b,i+5) + 1;
            
        end
    end
    
    table(28,i+5)=data(i).analysis_data.vesicle_number.docked_sv_count;
    table(29,i+5)=data(i).analysis_data.vesicle_number.tethered_sv_count;
    table(30,i+5)=data(i).analysis_data.vesicle_number.cytosolic_sv_count;
    table(31,i+5)=table(28,i+5) + table(29,i+5) + table(30,i+5);
    table(32,i+5)=data(i).analysis_data.vesicle_number.dcv_count;
    table(33,i+5)=data(i).analysis_data.vesicle_number.docked_dcv_count;
    table(34,i+5)=data(i).analysis_data.vesicle_number.lv_count;
    table(35,i+5)=data(i).analysis_data.vesicle_number.ccv_count;
    table(36,i+5)=data(i).analysis_data.vesicle_number.docked_fsv_count;
    table(37,i+5)=data(i).analysis_data.vesicle_number.tethered_fsv_count;
    table(38,i+5)=data(i).analysis_data.vesicle_number.cytosolic_fsv_count;
    table(39,i+5)=data(i).analysis_data.vesicle_number.flv_count;
    table(40,i+5)=data(i).analysis_data.vesicle_number.fccv_count;
    table(57,i+5)=data(i).analysis_data.vesicle_number.particle_count;
    
    table(5,i+5)=table(2,i+5) + table(3,i+5) + table(4,i+5);
    table(18,i+5)=table(15,i+5) + table(16,i+5) + table(17,i+5);
    end
   
end



for i = 1:length(data)
    
    if isfield(data(i).analysis_data,'dp') && isfield(data(i).distance_data, 'endosome')
        
        for j = 1:length(data(i).distance_data.endosome)
        
            if data(i).distance_data.endosome(j).dist2dp <= 100
     
                table(55,i+5) = table(55,i+5) + 1;
                
            end   
        end
    end
end
for i = 1:length(data)
    
    if isfield(data(i).analysis_data,'dp') && isfield(data(i).distance_data, 'fendosome')
        
        for j = 1:length(data(i).distance_data.fendosome)
        
            if data(i).distance_data.fendosome(j).dist2dp <= 100
     
                table(56,i+5) = table(56,i+5) + 1;
                
            end   
        end
    end
end

for i = 1:length(data)
    
    if isfield(data(i).analysis_data,'dp') && isfield(data(i).distance_data, 'mvb')
        
        for j = 1:length(data(i).distance_data.mvb)
        
            if data(i).distance_data.mvb(j).dist2dp <= 100
     
                table(58,i+5) = table(58,i+5) + 1;
                
            end   
        end
    end
end
for i = 1:length(data)
    
    if isfield(data(i).analysis_data,'dp') && isfield(data(i).distance_data, 'fmvb')
        
        for j = 1:length(data(i).distance_data.fmvb)
        
            if data(i).distance_data.fmvb(j).dist2dp <= 100
     
                table(59,i+5) = table(59,i+5) + 1;
                
            end   
        end
    end
end

for i = 1:59
    
    table(i,1) = mean(table(i,6:length(data)+5));
    table(i,2) = median(table(i,6:length(data)+5));
    table(i,3) = std(table(i,6:length(data)+5));
    table(i,4) = table(i,3)/sqrt(length(data));
    table(i,5) = (table(i,1)-table(i,2))/table(i,3);
    
end



end

                
                
              
                    
            