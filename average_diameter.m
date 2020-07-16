function diameter_data = average_diameter (data, type)

% this function calculates the average diameter of vesicles in a dataset.
% the number can be averaged per profile or from total 

% the first 5 columns is summary of the data 
% column 1 = mean
% column 2 = median
% column 3 = std 
% column 4 = sem 
% column 5 = skewness

m=6;
n=6;
a=0;
b=0;

for i = 1:length(data)
    
    if isfield(data(i).analysis_data, 'diameter')
        
        if isfield(data(i).analysis_data.diameter, type)
            
            a = a+1;
            
            switch (type)
                
                case 'SV'
                    
                    b = b+length(data(i).analysis_data.diameter.SV);
                    
                case 'fSV'
                    
                    b = b+length(data(i).analysis_data.diameter.fSV);
                    
                case 'DCV'
                    
                    b = b+length(data(i).analysis_data.diameter.DCV);
                    
                case 'LV'
                    
                    b = b+length(data(i).analysis_data.diameter.LV);
                    
                case 'fLV'
                    
                    b = b+length(data(i).analysis_data.diameter.fLV);
                    
            end
        end
    end
end

diameter_data.average_total = zeros(1,b+5);
diameter_data.average_profile = zeros(1,a+5);

for i = 1:length(data)
    
    if isfield(data(i).analysis_data, 'diameter')
        
        if isfield(data(i).analysis_data.diameter, type)
            
            switch (type)
                
                case 'SV'
                    
                    diameter_data.average_profile (1,n) = mean (data(i).analysis_data.diameter.SV);
                    
                    n=n+1;
                    
                    for j = 1:length(data(i).analysis_data.diameter.SV)
                        
                        diameter_data.average_total (1,m) = data(i).analysis_data.diameter.SV(j);
                        
                        m=m+1;
                        
                    end
                    
                case 'fSV'
                    
                    diameter_data.average_profile (1,n) = mean (data(i).analysis_data.diameter.fSV);
                    
                    n=n+1;
                    
                    for j = 1:length(data(i).analysis_data.diameter.fSV)
                        
                        diameter_data.average_total (1,m) = data(i).analysis_data.diameter.fSV(j);
                        
                        m=m+1;
                        
                    end
                    
                case 'DCV'
                    
                    diameter_data.average_profile (1,n) = mean (data(i).analysis_data.diameter.DCV);
                    
                    n=n+1;
                    
                    for j = 1:length(data(i).analysis_data.diameter.DCV)
                        
                        diameter_data.average_total (1,m) = data(i).analysis_data.diameter.DCV(j);
                        
                        m=m+1;
                        
                    end
                    
                case 'LV'
                    
                    diameter_data.average_profile (1,n) = mean (data(i).analysis_data.diameter.LV);
                    
                    n=n+1;
                    
                    for j = 1:length(data(i).analysis_data.diameter.LV)
                        
                        diameter_data.average_total (1,m) = data(i).analysis_data.diameter.LV(j);
                        
                        m=m+1;
                        
                    end
                    
                case 'fLV'
                    
                    diameter_data.average_profile (1,n) = mean (data(i).analysis_data.diameter.fLV);
                    
                    n=n+1;
                    
                    for j = 1:length(data(i).analysis_data.diameter.fLV)
                        
                        diameter_data.average_total (1,m) = data(i).analysis_data.diameter.fLV(j);
                        
                        m=m+1;
                        
                    end
                    
                case 'CCV'
                    
                    diameter_data.average_profile (1,n) = mean (data(i).analysis_data.diameter.CCV);
                    
                    n=n+1;
                    
                    for j = 1:length(data(i).analysis_data.diameter.CCV)
                        
                        diameter_data.average_total (1,m) = data(i).analysis_data.diameter.CCV(j);
                        
                        m=m+1;
                        
                    end
                    
                case 'fCCV'
                    
                    diameter_data.average_profile (1,n) = mean (data(i).analysis_data.diameter.fCCV);
                    
                    n=n+1;
                    
                    for j = 1:length(data(i).analysis_data.diameter.fCCV)
                        
                        diameter_data.average_total (1,m) = data(i).analysis_data.diameter.fCCV(j);
                        
                        m=m+1;
                        
                    end
            end
        end
    end
end

diameter_data.average_total(1,1) = mean (diameter_data.average_total(1,6:b+5));
diameter_data.average_total(1,2) = median (diameter_data.average_total(1,6:b+5));
diameter_data.average_total(1,3) = std (diameter_data.average_total(1,6:b+5));
diameter_data.average_total(1,4) = diameter_data.average_total(1,3)/sqrt(b);
diameter_data.average_total(1,5) = (diameter_data.average_total(1,1)...
                               -  diameter_data.average_total(1,2))...
                               /  diameter_data.average_total(1,3);

diameter_data.average_profile(1,1) = mean (diameter_data.average_profile(1,6:a+5));
diameter_data.average_profile(1,2) = median (diameter_data.average_profile(1,6:a+5));
diameter_data.average_profile(1,3) = std (diameter_data.average_profile(1,6:a+5));
diameter_data.average_profile(1,4) = diameter_data.average_profile(1,3)/sqrt(a);
diameter_data.average_profile(1,5) = (diameter_data.average_profile(1,1)...
                                 -  diameter_data.average_profile(1,2))...
                                 /  diameter_data.average_profile(1,3);
        
        

end