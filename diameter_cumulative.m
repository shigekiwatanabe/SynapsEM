function table = diameter_cumulative (data)

% this function generates cumulative frequency data for the diameter of all
% clear-core vesicles (both synaptic vesicles and large vesicles). 

m = 1; 

for i = 6:length(data.vesicle_diameter.SV.average_total)
    
    temp_diameter (1, m) = round(data.vesicle_diameter.SV.average_total(1, i));
    
    m=m+1;
    
end

for i = 6:length(data.vesicle_diameter.LV.average_total)
    
    temp_diameter (1,m) = round(data.vesicle_diameter.LV.average_total(1, i));
    
    m=m+1;
    
end
    
    
table = zeros (200, 4);

% 1st column is the size of vesicles binned by 1nm (1-100nm)
for i = 1:200
    
    table(i,1) = (i-1) + 1;
    
end

for i = 1:m-1 
    
    for j = 1:200
        
        % if it falles into a bin , add 1 to that bin
        if (table(j,1) == temp_diameter(1,i))
            
            table(j,2) = table(j,2) + 1;
            
        end
            
    end
end

table (1,3) = table(1,2);

for i = 2:200
   
    table(i,3) = table (i-1,3) + table (i,2);
    
end

for i = 1:200
    
    table (i,4) = (table (i,3) / table (200,3)) *100;
    
end

end
    