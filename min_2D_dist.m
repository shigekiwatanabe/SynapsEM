%Modified 3/06/2017 by Morven Chin, Written by Shigeki Watanabe for Watanabe Lab use

function distance_data = min_2D_dist (analysis_data, pixel_size)

%this function calculates the minimal distance between two membranes (i.e.
%between vesicle memb and plasma membrane). 

if isfield(analysis_data, 'vesicle')
%calculate distance to AZ(s) for all vesicles, uses closer AZ
for j=1:length(analysis_data.vesicle)
    temp_min = Inf;
    closest_az = 0; %initializes index for closer AZ
    
    for h = 1:length(analysis_data.az)
    
        %calculate distance from vesicle center to all points on this AZ
        for i= 1:length(analysis_data.az(h).x)

            temp_distance(1,i)  = dist2 (analysis_data.vesicle(j).x,...
                                         analysis_data.vesicle(j).y,...
                                         analysis_data.vesicle(j).r,...
                                         analysis_data.az(h).x(i),...
                                         analysis_data.az(h).y(i));
        end

        distance_data.vesicle(j).type = analysis_data.vesicle(j).name;
        
        %if find a closer AZ, use that as distance to az
        if ceil(min(temp_distance(1,:))*pixel_size) < temp_min
            
            temp_min = ceil(min(temp_distance(1,:))*pixel_size);
            closest_az = h;
        end
        
        % if dist2dp gives the minus value, it means that sv membrane and 
        % dp membrane overlaps, so the distance should be 0.
        if (temp_min < 0)

            temp_min = 0;
        end
        
%         disp(temp_distance);
        clear temp_distance
        
    end
    
    %use closest AZ
    distance_data.vesicle(j).dist2az = temp_min;
    distance_data.vesicle(j).closest_az = closest_az;
    
    %automatically labels docked SV if not labeled by user
    if distance_data.vesicle(j).dist2az == 0 
        distance_data.vesicle(j).type = 'docked_SV';
    end
    
    if strcmp(distance_data.vesicle(j).type, 'docked_SV')
        
        distance_data.vesicle(j).dist2az = 0;
        
    elseif strcmp(distance_data.vesicle(j).type, 'docked_fSV')
        
        distance_data.vesicle(j).dist2az = 0;
    end
end

clear temp_distance

%calculates PM distance
for j=1:length(analysis_data.vesicle)
    
    for i = 1:length(analysis_data.pm.x)
        
        temp_distance(1, i) = dist2(analysis_data.vesicle(j).x,...
                                    analysis_data.vesicle(j).y,...
                                    analysis_data.vesicle(j).r,...
                                    analysis_data.pm.x(i),...
                                    analysis_data.pm.y(i));
    end
    % if it's docked_sv then distance should be 0.
    if strcmp(distance_data.vesicle(j).type, 'docked_SV')
        
        distance_data.vesicle(j).dist2pm = 0;
        
    elseif strcmp(distance_data.vesicle(j).type, 'docked_fSV')
        
        distance_data.vesicle(j).dist2pm = 0;
    
    else
        % applying pixel size to the distance, and rounds up the value
        distance_data.vesicle(j).dist2pm = ceil(min(temp_distance(1,:))*pixel_size);
    end

    % dist2dp gives the minus value, it means that sv membrane and
    % pm membrane overlaps, so the distance should be 0.
    if (distance_data.vesicle(j).dist2pm <0)

        distance_data.vesicle(j).dist2pm = 0;

    end
    
    clear temp_distance
    
end

clear temp_distance

%calculates distance to synaptic ribbons (SR)
if isfield (analysis_data, 'sr')
for j=1:length(analysis_data.vesicle)
    
    
    for i = 1:length(analysis_data.sr.x)
        
        temp_distance(1, i) = dist2(analysis_data.vesicle(j).x,...
                                    analysis_data.vesicle(j).y,...
                                    analysis_data.vesicle(j).r,...
                                    analysis_data.sr.x(i),...
                                    analysis_data.sr.y(i));
    end
    % if it's docked_sv then distance should be 0.
   
        % applying pixel size to the distance, and rounds up the value
        distance_data.vesicle(j).dist2sr = ceil(min(temp_distance(1,:))*pixel_size);
 

    % dist2dp gives the minus value, it means that sv membrane and
    % pm membrane overlaps, so the distance should be 0.
    if (distance_data.vesicle(j).dist2sr <0)

        distance_data.vesicle(j).dist2sr = 0;

    end
    
    clear temp_distance
    
end
end
clear temp_distance

%calculates distance to dense projection (dp)
if isfield (analysis_data, 'dp')
for j=1:length(analysis_data.vesicle)
    
    
    for i = 1:length(analysis_data.dp.x)
        
        temp_distance(1, i) = dist2(analysis_data.vesicle(j).x,...
                                    analysis_data.vesicle(j).y,...
                                    analysis_data.vesicle(j).r,...
                                    analysis_data.dp.x(i),...
                                    analysis_data.dp.y(i));
    end
    % if it's docked_sv then distance should be 0.
   
        % applying pixel size to the distance, and rounds up the value
        distance_data.vesicle(j).dist2dp = ceil(min(temp_distance(1,:))*pixel_size);
 

    % dist2dp gives the minus value, it means that sv membrane and
    % pm membrane overlaps, so the distance should be 0.
    if (distance_data.vesicle(j).dist2dp <0)

        distance_data.vesicle(j).dist2dp = 0;

    end
    
    clear temp_distance
    
end
end
clear temp_distance

end

if isfield(analysis_data, 'pits')
    
    %iterate through all pits in image
    for i = 1:length(analysis_data.pits)
        
        for h = 1:length(analysis_data.az)
        
            for l =1:length(analysis_data.pits(i).x)

                for j = 1:length(analysis_data.az(h).x)

                    %create a table of distances to every pixel in AZ from
                    %a single pixel in pit
                    temp_data(h,j) = dist2(analysis_data.pits(i).x(l),...
                                         analysis_data.pits(i).y(l),...
                                         0,...
                                         analysis_data.az(h).x(j),...
                                         analysis_data.az(h).y(j));
                end

                %compile array of distances to AZ for each pit pixel
                temp_data_min(h,l) = min(temp_data(h,:))*pixel_size;
                clear temp_data
            end
            
            %find both intersection points' distance from AZ in nm
            min_dist_1(h) = min(temp_data_min(h,1:floor(length(temp_data_min(h,:))/2)));
            min_dist_2(h) = min(temp_data_min(h,ceil(length(temp_data_min(h,:))/2):length(temp_data_min(h,:))));
            min_dist(h) = min(min_dist_1(h),min_dist_2(h)); %use closer intersection pt for that AZ
        
        end
        
        distance_data.pits(i).dist2az = min(min_dist); %use closest AZ
       
        if min(min_dist) < 5
            distance_data.pits(i).dist2az = 0;
        end
        
        distance_data.pits(i).in_az = 0;
        %determine if pit is in AZ
        if distance_data.pits(i).dist2az == 0
            
            if min(min_dist_1) < 5 && min(min_dist_2) < 5
                
                distance_data.pits(i).in_az = 1;
                
            elseif min(min_dist_1) > min(min_dist_2) && min(min_dist_1) < (analysis_data.pits(i).neck_width)/2
                
                distance_data.pits(i).in_az = 1;
                
            elseif min(min_dist_1) < min(min_dist_2) && min(min_dist_2) < (analysis_data.pits(i).neck_width)/2
                
                distance_data.pits(i).in_az = 1;
            end
        end
        
    clear temp_data_min    
    end
end

clear temp_distance

if isfield(analysis_data, 'coated_pits')
    
    %iterate through all pits in image
    for i = 1:length(analysis_data.coated_pits)
        
        for h = 1:length(analysis_data.az)
        
            for l =1:length(analysis_data.coated_pits(i).x)

                for j = 1:length(analysis_data.az(h).x)

                    %create a table of distances to every pixel in AZ from
                    %a single pixel in pit
                    temp_data(h,j) = dist2(analysis_data.coated_pits(i).x(l),...
                                         analysis_data.coated_pits(i).y(l),...
                                         0,...
                                         analysis_data.az(h).x(j),...
                                         analysis_data.az(h).y(j));
                end

                %compile array of distances to AZ for each pit pixel
                temp_data_min(h,l) = min(temp_data(h,:))*pixel_size;
                clear temp_data
            end
            
            %find both intersection points' distance from AZ in nm
            min_dist_1(h) = min(temp_data_min(h,1:floor(length(temp_data_min(h,:))/2)));
            min_dist_2(h) = min(temp_data_min(h,ceil(length(temp_data_min(h,:))/2):length(temp_data_min(h,:))));
            min_dist(h) = min(min_dist_1(h),min_dist_2(h)); %use closer intersection pt for that AZ
        
        end
               
        distance_data.coated_pits(i).dist2az = min(min_dist); %use closest AZ
       
        if min(min_dist) < 5
            distance_data.coated_pits(i).dist2az = 0;
        end
        
        distance_data.coated_pits(i).in_az = 0;
        %determine if pit is in AZ
        if distance_data.coated_pits(i).dist2az == 0
            
            if min(min_dist_1) < 5 && min(min_dist_2) < 5
                
                distance_data.coated_pits(i).in_az = 1;
                
            elseif min(min_dist_1) > min(min_dist_2) && min(min_dist_1) < (analysis_data.coated_pits(i).neck_width)/2
                
                distance_data.coated_pits(i).in_az = 1;
                
            elseif min(min_dist_1) < min(min_dist_2) && min(min_dist_2) < (analysis_data.coated_pits(i).neck_width)/2
                
                distance_data.coated_pits(i).in_az = 1;
            end
        end
    end
end

if isfield(analysis_data, 'fpits')
    
    %iterate through all pits in image
    for i = 1:length(analysis_data.fpits)
        
        for h = 1:length(analysis_data.az)
        
            for l =1:length(analysis_data.fpits(i).x)

                for j = 1:length(analysis_data.az(h).x)

                    %create a table of distances to every pixel in AZ from
                    %a single pixel in pit
                    temp_data(h,j) = dist2(analysis_data.fpits(i).x(l),...
                                         analysis_data.fpits(i).y(l),...
                                         0,...
                                         analysis_data.az(h).x(j),...
                                         analysis_data.az(h).y(j));
                end

                %compile array of distances to AZ for each pit pixel
                temp_data_min(h,l) = min(temp_data(h,:))*pixel_size;
                clear temp_data
            end
            
            %find both intersection points' distance from AZ in nm
            min_dist_1(h) = min(temp_data_min(h,1:floor(length(temp_data_min(h,:))/2)));
            min_dist_2(h) = min(temp_data_min(h,ceil(length(temp_data_min(h,:))/2):length(temp_data_min(h,:))));
            min_dist(h) = min(min_dist_1(h),min_dist_2(h)); %use closer intersection pt for that AZ
        
        end
               
        distance_data.fpits(i).dist2az = min(min_dist); %use closest AZ
       
        if min(min_dist) < 5
            distance_data.fpits(i).dist2az = 0;
        end
        
        distance_data.fpits(i).in_az = 0;
        %determine if pit is in AZ
        if distance_data.fpits(i).dist2az == 0
            
            if min(min_dist_1) < 5 && min(min_dist_2) < 5
                
                distance_data.fpits(i).in_az = 1;
                
            elseif min(min_dist_1) > min(min_dist_2) && min(min_dist_1) < (analysis_data.fpits(i).neck_width)/2
                
                distance_data.fpits(i).in_az = 1;
                
            elseif min(min_dist_1) < min(min_dist_2) && min(min_dist_2) < (analysis_data.fpits(i).neck_width)/2
                
                distance_data.fpits(i).in_az = 1;
            end
        end
    end
end

if isfield(analysis_data, 'coated_fpits')
    
    %iterate through all pits in image
    for i = 1:length(analysis_data.coated_fpits)
        
        for h = 1:length(analysis_data.az)
        
            for l =1:length(analysis_data.coated_fpits(i).x)

                for j = 1:length(analysis_data.az(h).x)

                    %create a table of distances to every pixel in AZ from
                    %a single pixel in pit
                    temp_data(h,j) = dist2(analysis_data.coated_fpits(i).x(l),...
                                         analysis_data.coated_fpits(i).y(l),...
                                         0,...
                                         analysis_data.az(h).x(j),...
                                         analysis_data.az(h).y(j));
                end

                %compile array of distances to AZ for each pit pixel
                temp_data_min(h,l) = min(temp_data(h,:))*pixel_size;
                clear temp_data
            end
            
            %find both intersection points' distance from AZ in nm
            min_dist_1(h) = min(temp_data_min(h,1:floor(length(temp_data_min(h,:))/2)));
            min_dist_2(h) = min(temp_data_min(h,ceil(length(temp_data_min(h,:))/2):length(temp_data_min(h,:))));
            min_dist(h) = min(min_dist_1(h),min_dist_2(h)); %use closer intersection pt for that AZ
        
        end
               
        distance_data.coated_fpits(i).dist2az = min(min_dist); %use closest AZ
       
        if min(min_dist) < 5
            distance_data.coated_fpits(i).dist2az = 0;
        end
        
        distance_data.coated_fpits(i).in_az = 0;
        %determine if pit is in AZ
        if distance_data.coated_fpits(i).dist2az == 0
            
            if min(min_dist_1) < 5 && min(min_dist_2) < 5
                
                distance_data.coated_fpits(i).in_az = 1;
                
            elseif min(min_dist_1) > min(min_dist_2) && min(min_dist_1) < (analysis_data.coated_fpits(i).neck_width)/2
                
                distance_data.coated_fpits(i).in_az = 1;
                
            elseif min(min_dist_1) < min(min_dist_2) && min(min_dist_2) < (analysis_data.coated_fpits(i).neck_width)/2
                
                distance_data.coated_fpits(i).in_az = 1;
            end
        end
    end
end

if isfield(analysis_data, 'buds')
    
    %iterate through all pits in image
    for i = 1:length(analysis_data.buds)
        
        for h = 1:length(analysis_data.az)
        
            for l =1:length(analysis_data.buds(i).x)

                for j = 1:length(analysis_data.az(h).x)

                    %create a table of distances to every pixel in AZ from
                    %a single pixel in pit
                    temp_data(h,j) = dist2(analysis_data.buds(i).x(l),...
                                         analysis_data.buds(i).y(l),...
                                         0,...
                                         analysis_data.az(h).x(j),...
                                         analysis_data.az(h).y(j));
                end

                %compile array of distances to AZ for each pit pixel
                temp_data_min(h,l) = min(temp_data(h,:))*pixel_size;
                clear temp_data
            end
            
            %find both intersection points' distance from AZ in nm
            min_dist_1(h) = min(temp_data_min(h,1:floor(length(temp_data_min(h,:))/2)));
            min_dist_2(h) = min(temp_data_min(h,ceil(length(temp_data_min(h,:))/2):length(temp_data_min(h,:))));
            min_dist(h) = min(min_dist_1(h),min_dist_2(h)); %use closer intersection pt for that AZ
        
        end
               
        distance_data.buds(i).dist2az = min(min_dist); %use closest AZ
       
        if min(min_dist) < 5
            distance_data.buds(i).dist2az = 0;
        end
        
        distance_data.buds(i).in_az = 0;
        %determine if pit is in AZ
        if distance_data.buds(i).dist2az == 0
            
            if min(min_dist_1) < 5 && min(min_dist_2) < 5
                
                distance_data.buds(i).in_az = 1;
                
            elseif min(min_dist_1) > min(min_dist_2) && min(min_dist_1) < (analysis_data.buds(i).neck_width)/2
                
                distance_data.buds(i).in_az = 1;
                
            elseif min(min_dist_1) < min(min_dist_2) && min(min_dist_2) < (analysis_data.buds(i).neck_width)/2
                
                distance_data.buds(i).in_az = 1;
            end
        end
    end
end

if isfield(analysis_data, 'fbuds')
    
    %iterate through all pits in image
    for i = 1:length(analysis_data.fbuds)
        
        for h = 1:length(analysis_data.az)
        
            for l =1:length(analysis_data.fbuds(i).x)

                for j = 1:length(analysis_data.az(h).x)

                    %create a table of distances to every pixel in AZ from
                    %a single pixel in pit
                    temp_data(h,j) = dist2(analysis_data.fbuds(i).x(l),...
                                         analysis_data.fbuds(i).y(l),...
                                         0,...
                                         analysis_data.az(h).x(j),...
                                         analysis_data.az(h).y(j));
                end

                %compile array of distances to AZ for each pit pixel
                temp_data_min(h,l) = min(temp_data(h,:))*pixel_size;
                clear temp_data
            end
            
            %find both intersection points' distance from AZ in nm
            min_dist_1(h) = min(temp_data_min(h,1:floor(length(temp_data_min(h,:))/2)));
            min_dist_2(h) = min(temp_data_min(h,ceil(length(temp_data_min(h,:))/2):length(temp_data_min(h,:))));
            min_dist(h) = min(min_dist_1(h),min_dist_2(h)); %use closer intersection pt for that AZ
        
        end
               
        distance_data.fbuds(i).dist2az = min(min_dist); %use closest AZ
       
        if min(min_dist) < 5
            distance_data.fbuds(i).dist2az = 0;
        end
        
        distance_data.fbuds(i).in_az = 0;
        %determine if pit is in AZ
        if distance_data.fbuds(i).dist2az == 0
            
            if min(min_dist_1) < 5 && min(min_dist_2) < 5
                
                distance_data.fbuds(i).in_az = 1;
                
            elseif min(min_dist_1) > min(min_dist_2) && min(min_dist_1) < (analysis_data.fbuds(i).neck_width)/2
                
                distance_data.fbuds(i).in_az = 1;
                
            elseif min(min_dist_1) < min(min_dist_2) && min(min_dist_2) < (analysis_data.fbuds(i).neck_width)/2
                
                distance_data.fbuds(i).in_az = 1;
            end
        end
    end
end

if isfield(analysis_data, 'endosome')
        
    for i = 1:length(analysis_data.endosome)
        
        for h = 1:length(analysis_data.az)

            a=1;

            pt(1) = 1;
            pt(2) = length(analysis_data.endosome(i).x);
            pt(3) = floor(pt(2)/4);
            pt(4) = floor(pt(2)*3/4);

            for j = 1:length(analysis_data.az(h).x)

                for k=1:4

                    temp_distance_1(h,a) = dist2(analysis_data.endosome(i).x(pt(k)),...
                                                 analysis_data.endosome(i).y(pt(k)),...
                                                 0,...
                                                 analysis_data.az(h).x(j),...
                                                 analysis_data.az(h).y(j));

                    a=a+1;
                end
            end

            
        end
        distance_data.endosome(i).dist2az = floor(min(temp_distance_1(1:h,:))*pixel_size);
        
        if distance_data.endosome(i).dist2az < 5
            
            distance_data.endosome(i).dist2az = 0;
            
        end
        
        clear temp_distance_1
    end
    
    for h = 1:length(analysis_data.pm)
        
        for i = 1:length(analysis_data.endosome)

            a=1;

            pt(1) = 1;
            pt(2) = length(analysis_data.endosome(i).x);
            pt(3) = floor(pt(2)/4);
            pt(4) = floor(pt(2)*3/4);

            for j = 1:length(analysis_data.pm(h).x)

                for k=1:4

                    temp_distance_1(h,a) = dist2(analysis_data.endosome(i).x(pt(k)),...
                                                 analysis_data.endosome(i).y(pt(k)),...
                                                 0,...
                                                 analysis_data.pm(h).x(j),...
                                                 analysis_data.pm(h).y(j));

                    a=a+1;
                end
            end

            distance_data.endosome(i).dist2pm = floor(min(temp_distance_1(1:h,:))*pixel_size);

            if distance_data.endosome(i).dist2pm < 5

                distance_data.endosome(i).dist2pm = 0;

            end

            clear temp_distance_1 
        end 
    end
    
    if isfield (analysis_data, 'sr')
    for i = 1:length(analysis_data.endosome)
        
        a=1;
        
        for j = 1:length(analysis_data.sr.x)
            
            for k = 1:length(analysis_data.endosome(i).x)
            
                temp_distance_1(1,a) = dist2(analysis_data.endosome(i).x(k),...
                                             analysis_data.endosome(i).y(k),...
                                             0,...
                                             analysis_data.sr.x(j),...
                                             analysis_data.sr.y(j));
            
                a=a+1;
            end
        end
        
        distance_data.endosome(i).dist2sr = floor(min(temp_distance_1(1,:))*pixel_size);
        
        if distance_data.endosome(i).dist2sr < 5
            
            distance_data.endosome(i).dist2sr = 0;
            
        end
        
        clear temp_distance_1 
    end 
    end
    
    if isfield (analysis_data, 'dp')
    for i = 1:length(analysis_data.endosome)
        
        a=1;
        
        for j = 1:length(analysis_data.dp.x)
            
            for k = 1:length(analysis_data.endosome(i).x)
            
                temp_distance_1(1,a) = dist2(analysis_data.endosome(i).x(k),...
                                             analysis_data.endosome(i).y(k),...
                                             0,...
                                             analysis_data.dp.x(j),...
                                             analysis_data.dp.y(j));
            
                a=a+1;
            end
        end
        
        distance_data.endosome(i).dist2dp = floor(min(temp_distance_1(1,:))*pixel_size);
        
        if distance_data.endosome(i).dist2dp < 5
            
            distance_data.endosome(i).dist2dp = 0;
            
        end
        
        clear temp_distance_1 
    end 
    end
end


if isfield(analysis_data, 'fendosome')
   
    for i = 1:length(analysis_data.fendosome)
        
        for h = 1:length(analysis_data.az)

            a=1;

            pt(1) = 1;
            pt(2) = length(analysis_data.fendosome(i).x);
            pt(3) = floor(pt(2)/4);
            pt(4) = floor(pt(2)*3/4);

            for j = 1:length(analysis_data.az(h).x)

                for k=1:4

                    temp_distance_1(h,a) = dist2(analysis_data.fendosome(i).x(pt(k)),...
                                                 analysis_data.fendosome(i).y(pt(k)),...
                                                 0,...
                                                 analysis_data.az(h).x(j),...
                                                 analysis_data.az(h).y(j));

                    a=a+1;
                end
            end

            
        end
        distance_data.fendosome(i).dist2az = floor(min(temp_distance_1(1:h,:))*pixel_size);
        
        if distance_data.fendosome(i).dist2az < 5
            
            distance_data.fendosome(i).dist2az = 0;
            
        end
        
        clear temp_distance_1
    end
    
    for h = 1:length(analysis_data.pm)
        
        for i = 1:length(analysis_data.fendosome)

            a=1;

            pt(1) = 1;
            pt(2) = length(analysis_data.fendosome(i).x);
            pt(3) = floor(pt(2)/4);
            pt(4) = floor(pt(2)*3/4);

            for j = 1:length(analysis_data.pm(h).x)

                for k=1:4

                    temp_distance_1(h,a) = dist2(analysis_data.fendosome(i).x(pt(k)),...
                                                 analysis_data.fendosome(i).y(pt(k)),...
                                                 0,...
                                                 analysis_data.pm(h).x(j),...
                                                 analysis_data.pm(h).y(j));

                    a=a+1;
                end
            end

            distance_data.fendosome(i).dist2pm = floor(min(temp_distance_1(1:h,:))*pixel_size);

            if distance_data.fendosome(i).dist2pm < 5

                distance_data.fendosome(i).dist2pm = 0;

            end

            clear temp_distance_1 
        end 
    end
    
    if isfield (analysis_data, 'sr')
    for i = 1:length(analysis_data.fendosome)
        
        a=1;
        
        for j = 1:length(analysis_data.sr.x)
            
            for k = 1:length(analysis_data.fendosome(i).x)
            
                temp_distance_1(1,a) = dist2(analysis_data.fendosome(i).x(k),...
                                             analysis_data.fendosome(i).y(k),...
                                             0,...
                                             analysis_data.sr.x(j),...
                                             analysis_data.sr.y(j));
            
                a=a+1;
            end
        end
        
        distance_data.fendosome(i).dist2sr = floor(min(temp_distance_1(1,:))*pixel_size);
        
        if distance_data.fendosome(i).dist2sr < 5
            
            distance_data.fendosome(i).dist2sr = 0;
            
        end
        
        clear temp_distance_1 
    end 
    end
    
    if isfield (analysis_data, 'dp')
    for i = 1:length(analysis_data.fendosome)
        
        a=1;
        
        for j = 1:length(analysis_data.dp.x)
            
            for k = 1:length(analysis_data.fendosome(i).x)
            
                temp_distance_1(1,a) = dist2(analysis_data.fendosome(i).x(k),...
                                             analysis_data.fendosome(i).y(k),...
                                             0,...
                                             analysis_data.dp.x(j),...
                                             analysis_data.dp.y(j));
            
                a=a+1;
            end
        end
        
        distance_data.fendosome(i).dist2dp = floor(min(temp_distance_1(1,:))*pixel_size);
        
        if distance_data.fendosome(i).dist2dp < 5
            
            distance_data.fendosome(i).dist2dp = 0;
            
        end
        
        clear temp_distance_1 
    end 
    end
end

if isfield(analysis_data, 'mvb')
   
    for i = 1:length(analysis_data.mvb)
        
        for h = 1:length(analysis_data.az)

            a=1;

            pt(1) = 1;
            pt(2) = length(analysis_data.mvb(i).x);
            pt(3) = floor(pt(2)/4);
            pt(4) = floor(pt(2)*3/4);

            for j = 1:length(analysis_data.az(h).x)

                for k=1:4

                    temp_distance_1(h,a) = dist2(analysis_data.mvb(i).x(pt(k)),...
                                                 analysis_data.mvb(i).y(pt(k)),...
                                                 0,...
                                                 analysis_data.az(h).x(j),...
                                                 analysis_data.az(h).y(j));

                    a=a+1;
                end
            end

            
        end
        distance_data.mvb(i).dist2az = floor(min(temp_distance_1(1:h,:))*pixel_size);
        
        if distance_data.mvb(i).dist2az < 5
            
            distance_data.mvb(i).dist2az = 0;
            
        end
        
        clear temp_distance_1
    end
    
    for h = 1:length(analysis_data.pm)
        
        for i = 1:length(analysis_data.mvb)

            a=1;

            pt(1) = 1;
            pt(2) = length(analysis_data.mvb(i).x);
            pt(3) = floor(pt(2)/4);
            pt(4) = floor(pt(2)*3/4);

            for j = 1:length(analysis_data.pm(h).x)

                for k=1:4

                    temp_distance_1(h,a) = dist2(analysis_data.mvb(i).x(pt(k)),...
                                                 analysis_data.mvb(i).y(pt(k)),...
                                                 0,...
                                                 analysis_data.pm(h).x(j),...
                                                 analysis_data.pm(h).y(j));

                    a=a+1;
                end
            end

            distance_data.mvb(i).dist2pm = floor(min(temp_distance_1(1:h,:))*pixel_size);

            if distance_data.mvb(i).dist2pm < 5

                distance_data.mvb(i).dist2pm = 0;

            end

            clear temp_distance_1 
        end 
    end
    
    if isfield (analysis_data, 'sr')
    for i = 1:length(analysis_data.mvb)
        
        a=1;
        
        for j = 1:length(analysis_data.sr.x)
            
            for k = 1:length(analysis_data.mvb(i).x)
            
                temp_distance_1(1,a) = dist2(analysis_data.mvb(i).x(k),...
                                             analysis_data.mvb(i).y(k),...
                                             0,...
                                             analysis_data.sr.x(j),...
                                             analysis_data.sr.y(j));
            
                a=a+1;
            end
        end
        
        distance_data.mvb(i).dist2sr = floor(min(temp_distance_1(1,:))*pixel_size);
        
        if distance_data.mvb(i).dist2sr < 5
            
            distance_data.mvb(i).dist2sr = 0;
            
        end
        
        clear temp_distance_1 
    end 
    end
    
    if isfield (analysis_data, 'dp')
    for i = 1:length(analysis_data.mvb)
        
        a=1;
        
        for j = 1:length(analysis_data.dp.x)
            
            for k = 1:length(analysis_data.mvb(i).x)
            
                temp_distance_1(1,a) = dist2(analysis_data.mvb(i).x(k),...
                                             analysis_data.mvb(i).y(k),...
                                             0,...
                                             analysis_data.dp.x(j),...
                                             analysis_data.dp.y(j));
            
                a=a+1;
            end
        end
        
        distance_data.mvb(i).dist2dp = floor(min(temp_distance_1(1,:))*pixel_size);
        
        if distance_data.mvb(i).dist2dp < 5
            
            distance_data.mvb(i).dist2dp = 0;
            
        end
        
        clear temp_distance_1 
    end 
    end
end

if isfield(analysis_data, 'fmvb')
   
    for i = 1:length(analysis_data.fmvb)
        
        for h = 1:length(analysis_data.az)

            a=1;

            pt(1) = 1;
            pt(2) = length(analysis_data.fmvb(i).x);
            pt(3) = floor(pt(2)/4);
            pt(4) = floor(pt(2)*3/4);

            for j = 1:length(analysis_data.az(h).x)

                for k=1:4

                    temp_distance_1(h,a) = dist2(analysis_data.fmvb(i).x(pt(k)),...
                                                 analysis_data.fmvb(i).y(pt(k)),...
                                                 0,...
                                                 analysis_data.az(h).x(j),...
                                                 analysis_data.az(h).y(j));

                    a=a+1;
                end
            end

            
        end
        distance_data.fmvb(i).dist2az = floor(min(temp_distance_1(1:h,:))*pixel_size);
        
        if distance_data.fmvb(i).dist2az < 5
            
            distance_data.fmvb(i).dist2az = 0;
            
        end
        
        clear temp_distance_1
    end
    
    for h = 1:length(analysis_data.pm)
        
        for i = 1:length(analysis_data.fmvb)

            a=1;

            pt(1) = 1;
            pt(2) = length(analysis_data.fmvb(i).x);
            pt(3) = floor(pt(2)/4);
            pt(4) = floor(pt(2)*3/4);

            for j = 1:length(analysis_data.pm(h).x)

                for k=1:4

                    temp_distance_1(h,a) = dist2(analysis_data.fmvb(i).x(pt(k)),...
                                                 analysis_data.fmvb(i).y(pt(k)),...
                                                 0,...
                                                 analysis_data.pm(h).x(j),...
                                                 analysis_data.pm(h).y(j));

                    a=a+1;
                end
            end

            distance_data.fmvb(i).dist2pm = floor(min(temp_distance_1(1:h,:))*pixel_size);

            if distance_data.fmvb(i).dist2pm < 5

                distance_data.fmvb(i).dist2pm = 0;

            end

            clear temp_distance_1 
        end 
    end
    
    if isfield (analysis_data, 'sr')
    for i = 1:length(analysis_data.fmvb)
        
        a=1;
        
        for j = 1:length(analysis_data.sr.x)
            
            for k = 1:length(analysis_data.fmvb(i).x)
            
                temp_distance_1(1,a) = dist2(analysis_data.fmvb(i).x(k),...
                                             analysis_data.fmvb(i).y(k),...
                                             0,...
                                             analysis_data.sr.x(j),...
                                             analysis_data.sr.y(j));
            
                a=a+1;
            end
        end
        
        distance_data.fmvb(i).dist2sr = floor(min(temp_distance_1(1,:))*pixel_size);
        
        if distance_data.fmvb(i).dist2sr < 5
            
            distance_data.fmvb(i).dist2sr = 0;
            
        end
        
        clear temp_distance_1 
    end 
    end
    
    if isfield (analysis_data, 'dp')
    for i = 1:length(analysis_data.fmvb)
        
        a=1;
        
        for j = 1:length(analysis_data.dp.x)
            
            for k = 1:length(analysis_data.fmvb(i).x)
            
                temp_distance_1(1,a) = dist2(analysis_data.fmvb(i).x(k),...
                                             analysis_data.fmvb(i).y(k),...
                                             0,...
                                             analysis_data.dp.x(j),...
                                             analysis_data.dp.y(j));
            
                a=a+1;
            end
        end
        
        distance_data.fmvb(i).dist2dp = floor(min(temp_distance_1(1,:))*pixel_size);
        
        if distance_data.fmvb(i).dist2dp < 5
            
            distance_data.fmvb(i).dist2dp = 0;
            
        end
        
        clear temp_distance_1 
    end 
    end
end

end

    
