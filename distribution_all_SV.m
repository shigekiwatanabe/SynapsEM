function distribution_data = distribution_all_SV (vesicle_distribution)

% this function will count the number of all vesicles at certain distances from
% the active zone (based on the bin you choose) and generate a summary
% table that has an average number of vesicles at each bin. 

% a new addition 6/25/2020. the function now calculates the normalized
% distribution by dividing the number in each bin by the total. 

% the column 1: bin
% the column 2: average
% the column 3: std
% the column 4: sem
% the column 5: sum
% the column 6: normalized abundance


[a,b] = size(vesicle_distribution.docked_SV);

distribution_data = zeros(a,b);

for i = 1:a
    
    distribution_data (i,1) = vesicle_distribution.docked_SV(i,1);
    
end

for i = 1:a
    
    for j = 7:b
        
        distribution_data (i,j) = vesicle_distribution.docked_SV(i,j)...
                                + vesicle_distribution.tethered_SV(i,j)...
                                + vesicle_distribution.cytosolic_SV(i,j);
                            
    end
end


for i = 1:a
    
    distribution_data(i,2) = mean(distribution_data(i,7:b));
    distribution_data(i,3) = std(distribution_data(i,7:b));
    distribution_data(i,4) = distribution_data(i,2)/sqrt(b-6);
    distribution_data(i,5) = sum(distribution_data(i,7:b));
    
end

%calculating the total number of vesicles
total_num = sum(distribution_data(:,5));

%calculating the nomralized abundance at each bin
for i = 1:a
    distribution_data(i,6) = (distribution_data(i,5)/total_num);
end
end

    
    