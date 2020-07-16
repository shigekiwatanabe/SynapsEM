function distribution_data = distribution (data, vesicle_number, bin, vesicle_type, analysis_type)

% this function will count the number of vesicles at certain distances from
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

% generating a table based on the bin size
a = floor (1000/bin);
distribution_data = zeros (a+2, length(data)+6);

% the last bin would be all vesicles over 1000 nm away
distribution_data(a+2,1) = 1001;

%adding the bin to the first column
for i = 2:a+1
    
    distribution_data(i,1) = (i-1)*bin;
    
end

if strcmp(vesicle_type, 'pits')
    
    for i = 1:length(data)
        
        if isfield (data(i), 'distance_data')
            
            if isfield (data(i).distance_data, 'pits')
                
                for j = 1:length(data(i).distance_data.pits)
                    
                    if data(i).distance_data.pits(j).dist2az == 0
                        
                        distribution_data(1,i+6) = distribution_data(1,i+6) +1;
                        
                    elseif data(i).distance_data.pits(j).dist2az > a*bin
                        
                        distribution_data(a+2,i+6) = distribution_data(a+2,i+6) +1;
                        
                    else
                        for k = 1:a
                            
                            if (bin*k - bin) < data(i).distance_data.pits(j).dist2az...
                                    & data(i).distance_data.pits(j).dist2az <= bin*k
                                
                                distribution_data(k+1,i+6) = distribution_data(k+1,i+6) +1;
                                
                            end
                        end
                    end
                end
            end
            
        end
    end
    % for pit data, some pits may be in the active zone, and they should be
    % excluded from the distribution to just show the pits in the
    % periactive zones. 
    if strcmp(analysis_type, 'non_az')
        
        for i = 7:length(data)+6
            
            if distribution_data(1,i) > 0
                
                distribution_data(1,i) = distribution_data(1,i) - vesicle_number (41,i-1);
                
            end
        end
    end
    
elseif strcmp(vesicle_type, 'fpits')
    
    for i = 1:length(data)
        
        if isfield (data(i), 'distance_data')
            
            if isfield (data(i).distance_data, 'fpits')
                
                for j = 1:length(data(i).distance_data.fpits)
                    
                    if data(i).distance_data.fpits(j).dist2az == 0
                        
                        distribution_data(1,i+6) = distribution_data(1,i+6) +1;
                        
                    elseif data(i).distance_data.fpits(j).dist2az > a*bin
                        
                        distribution_data(a+2,i+6) = distribution_data(a+2,i+6) +1;
                        
                    else
                        for k = 1:a
                            
                            if (bin*k - bin) < data(i).distance_data.fpits(j).dist2az...
                                    & data(i).distance_data.fpits(j).dist2az <= bin*k
                                
                                distribution_data(k+1,i+6) = distribution_data(k+1,i+6) +1;
                                
                            end
                        end
                    end
                end
            end
        end
    end
    % for pit data, some pits may be in the active zone, and they should be
    % excluded from the distribution to just show the pits in the
    % periactive zones. 
    if strcmp(analysis_type, 'non_az')
        
        for i = 7:length(data)+6
            
            if distribution_data(1,i) > 0
                
                distribution_data(1,i) = distribution_data(1,i) - vesicle_number (47,i-1);
                
            end
        end
    end
    
elseif strcmp(vesicle_type, 'coated_pits')
    
    for i = 1:length(data)
        
        if isfield (data(i), 'distance_data')
            
            if isfield (data(i).distance_data, 'coated_pits')
                
                for j = 1:length(data(i).distance_data.coated_pits)
                    
                    if data(i).distance_data.coated_pits(j).dist2az == 0
                        
                        distribution_data(1,i+6) = distribution_data(1,i+6) +1;
                        
                    elseif data(i).distance_data.coated_pits(j).dist2az > a*bin
                        
                        distribution_data(a+2,i+6) = distribution_data(a+2,i+6) +1;
                        
                    else
                        for k = 1:a
                            
                            if (bin*k - bin) < data(i).distance_data.coated_pits(j).dist2az...
                                    & data(i).distance_data.coated_pits(j).dist2az <= bin*k
                                
                                distribution_data(k+1,i+6) = distribution_data(k+1,i+6) +1;
                                
                            end
                        end
                    end
                end
            end
        end
        
    end
    % for pit data, some pits may be in the active zone, and they should be
    % excluded from the distribution to just show the pits in the
    % periactive zones. 
    if strcmp(analysis_type, 'non_az')
        
        for i = 7:length(data)+6
            
            if distribution_data(1,i) > 0
                
                distribution_data(1,i) = distribution_data(1,i) - vesicle_number (44,i-1);
                
            end
        end
    end
    
elseif strcmp(vesicle_type, 'coated_fpits')
    
    for i = 1:length(data)
        
        if isfield (data(i), 'distance_data')
            
            if isfield (data(i).distance_data, 'coated_fpits')
                
                for j = 1:length(data(i).distance_data.coated_fpits)
                    
                    if data(i).distance_data.coated_fpits(j).dist2az == 0
                        
                        distribution_data(1,i+6) = distribution_data(1,i+6) +1;
                        
                    elseif data(i).distance_data.coated_fpits(j).dist2az > a*bin
                        
                        distribution_data(a+2,i+6) = distribution_data(a+2,i+6) +1;
                        
                    else
                        for k = 1:a
                            
                            if (bin*k - bin) < data(i).distance_data.coated_fpits(j).dist2az...
                                    & data(i).distance_data.coated_fpits(j).dist2az <= bin*k
                                
                                distribution_data(k+1,i+6) = distribution_data(k+1,i+6) +1;
                                
                            end
                        end
                    end
                end
            end
        end
    end
    % for pit data, some pits may be in the active zone, and they should be
    % excluded from the distribution to just show the pits in the
    % periactive zones. 
    if strcmp(analysis_type, 'non_az')
        
        for i = 7:length(data)+6
            
            if distribution_data(1,i) > 0
                
                distribution_data(1,i) = distribution_data(1,i) - vesicle_number (50,i-1);
                
            end
        end
    end
    
elseif strcmp(vesicle_type, 'endosome')
    
    for i = 1:length(data)
        
        if isfield (data(i), 'distance_data')
            
            if isfield (data(i).distance_data, 'endosome')
                
                for j = 1:length(data(i).distance_data.endosome)
                    
                    if data(i).distance_data.endosome(j).dist2az == 0
                        
                        distribution_data(1,i+6) = distribution_data(1,i+6) +1;
                        
                    elseif data(i).distance_data.endosome(j).dist2az > a*bin
                        
                        distribution_data(a+2,i+6) = distribution_data(a+2,i+6) +1;
                        
                    else
                        for k = 1:a
                            
                            if (bin*k - bin) < data(i).distance_data.endosome(j).dist2az...
                                    & data(i).distance_data.endosome(j).dist2az <= bin*k
                                
                                distribution_data(k+1,i+6) = distribution_data(k+1,i+6) +1;
                                
                            end
                        end
                    end
                end
            end
        end
    end
    
elseif strcmp(vesicle_type, 'fendosome')
    
    for i = 1:length(data)
        
        if isfield (data(i), 'distance_data')
            
            if isfield (data(i).distance_data, 'fendosome')
                
                for j = 1:length(data(i).distance_data.fendosome)
                    
                    if data(i).distance_data.fendosome(j).dist2az == 0
                        
                        distribution_data(1,i+6) = distribution_data(1,i+6) +1;
                        
                    elseif data(i).distance_data.fendosome(j).dist2az > a*bin
                        
                        distribution_data(a+2,i+6) = distribution_data(a+2,i+6) +1;
                        
                    else
                        for k = 1:a
                            
                            if (bin*k - bin) < data(i).distance_data.fendosome(j).dist2az...
                                    & data(i).distance_data.fendosome(j).dist2az <= bin*k
                                
                                distribution_data(k+1,i+6) = distribution_data(k+1,i+6) +1;
                                
                            end
                        end
                    end
                end
            end
        end
    end 
elseif strcmp(vesicle_type, 'mvb')
    
    for i = 1:length(data)
        
        if isfield (data(i), 'distance_data')
            
            if isfield (data(i).distance_data, 'mvb')
                
                for j = 1:length(data(i).distance_data.mvb)
                    
                    if data(i).distance_data.mvb(j).dist2az == 0
                        
                        distribution_data(1,i+6) = distribution_data(1,i+6) +1;
                        
                    elseif data(i).distance_data.mvb(j).dist2az > a*bin
                        
                        distribution_data(a+2,i+6) = distribution_data(a+2,i+6) +1;
                        
                    else
                        for k = 1:a
                            
                            if (bin*k - bin) < data(i).distance_data.mvb(j).dist2az...
                                    & data(i).distance_data.mvb(j).dist2az <= bin*k
                                
                                distribution_data(k+1,i+6) = distribution_data(k+1,i+6) +1;
                                
                            end
                        end
                    end
                end
            end
        end
    end
    
elseif strcmp(vesicle_type, 'fmvb')
    
    for i = 1:length(data)
        
        if isfield (data(i), 'distance_data')
            
            if isfield (data(i).distance_data, 'fmvb')
                
                for j = 1:length(data(i).distance_data.fmvb)
                    
                    if data(i).distance_data.fmvb(j).dist2az == 0
                        
                        distribution_data(1,i+6) = distribution_data(1,i+6) +1;
                        
                    elseif data(i).distance_data.fmvb(j).dist2az > a*bin
                        
                        distribution_data(a+2,i+6) = distribution_data(a+2,i+6) +1;
                        
                    else
                        for k = 1:a
                            
                            if (bin*k - bin) < data(i).distance_data.fmvb(j).dist2az...
                                    & data(i).distance_data.fmvb(j).dist2az <= bin*k
                                
                                distribution_data(k+1,i+6) = distribution_data(k+1,i+6) +1;
                                
                            end
                        end
                    end
                end
            end
        end
    end 
else
    
    for i = 1:length(data)
        
        if isfield (data(i), 'distance_data')
            
            if isfield (data(i).distance_data, 'vesicle')
                
                for j = 1:length(data(i).distance_data.vesicle)
                    
                    if strcmp(data(i).distance_data.vesicle(j).type, vesicle_type)
                        
                        if data(i).distance_data.vesicle(j).dist2az == 0
                            
                            distribution_data(1,i+6) = distribution_data(1,i+6) +1;
                            
                        elseif data(i).distance_data.vesicle(j).dist2az > a*bin
                            
                            distribution_data(a+2,i+6) = distribution_data(a+2,i+6) +1;
                            
                        else
                            for k = 1:a
                                
                                if (bin*k - bin) < data(i).distance_data.vesicle(j).dist2az...
                                        & data(i).distance_data.vesicle(j).dist2az <= bin*k
                                    
                                    distribution_data(k+1,i+6) = distribution_data(k+1,i+6) +1;
                                    
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end


for i = 1:a+2
    
    distribution_data(i,2) = mean(distribution_data(i,7:length(data)+6));
    distribution_data(i,3) = std(distribution_data(i,7:length(data)+6));
    distribution_data(i,4) = distribution_data(i,2)/sqrt(length(data));
    distribution_data(i,5) = sum(distribution_data(i,7:length(data)+6));
    
end

%calculating the total number of vesicles
total_num = sum(distribution_data(:,5));

%calculating the nomralized abundance at each bin
for i = 1:a+2
    distribution_data(i,6) = (distribution_data(i,5)/total_num);
end

end
              