%updated 4/17/2018; orginal code written by Morven Chin, modified by Shigeki, for Watanabe Lab use
%for calculating localization of docked vesicles, compatible with
%analysis data from single section or serial reconstructions images
%
%Notes concerning output array: Four consecutive Inf indicates a docked
%vesicle
%not in AZ. Four consecutive zeros indicates either that a docked vesicle has been
%assigned to another AZ in the same section, or that there is no docked
%vesicle
%
%Will print Section/Synapse # and # of docked vesicle in the section if pits are present
%Use start_docked_vesicle_reconstruct to automate the docked vesicle measurements
%
%ANALYZING MULTIPLE AZ WITH 3D RECONSTRUCTION IS BROKEN... DO NOT TRY

function [output_data] = docked_vesicle_reconstruct(filename, reconstruct_tf, pix_size, sect_thick, height_cut)

mult_az = 1; %defaults # of AZ to 1
output_data = struct('DockedSVData', []);

vesicle_data = []; %initialize empty array for docked vesicle data
misc_data = {}; %initialize empty cell array for misc data eg. Pr, Pvr...
missing_sect = []; %holds the numbers corresponding to the missing sections

sv_num = []; %holds vesicles w/in 30nm (per az per section/synapse)
az_lengths = []; %holds length of AZ (per az per section/synapse)
pits_num = []; %holds # of pits (per az per section/synapse)
pits_pvr = [];

az_tot = 0; %holds # of AZ through entire image set

%find AZ midpoint, counts sv w/in 30nm per AZ and # of pits
for i = 1:length(filename.raw_data)
    
    if length(filename.raw_data(i).analysis_data.az) > mult_az
        
        mult_az = length(filename.raw_data(i).analysis_data.az);
    end
    
    for h = 1:length(filename.raw_data(i).analysis_data.az)
        
        az_tot = az_tot + 1;
        
        pits_num(end + 1) = 0; %defaults # of pits in this AZ 0
        sv_num(end + 1) = 0; %initializes SV count for this AZ
        az_lengths(end + 1) = filename.raw_data(i).analysis_data.az(h).length(1); %collects length of AZ
        
        %count # of sv w/in 30nm of each AZ in the section
        
        if isfield (filename.raw_data(i), 'distance_data')
            
            if isfield (filename.raw_data(i).distance_data, 'vesicle')
                for sv = 1:length(filename.raw_data(i).distance_data.vesicle)
                    
                    type = filename.raw_data(i).distance_data.vesicle(sv).type;
                    if strcmp(type, 'SV') || strcmp(type, 'docked_SV') || strcmp(type, 'tethered_SV')
                        
                        if filename.raw_data(i).distance_data.vesicle(sv).dist2az <= 30 && filename.raw_data(i).distance_data.vesicle(sv).closest_az == h
                            
                            sv_num(end)  = sv_num(end) + 1;
                        end
                    end
                end
            end
        end
        
        
        %get az midpt
        %index of AZ midpoint
        mid_pt(h,i) = (floor(length(filename.raw_data(i).analysis_data.az(h).x)/2));
        
        %retrieve AZ half-length
        az_half_length(h,i) = filename.raw_data(i).analysis_data.az(h).length(1)/2;
    end
end

%multiple AZ per synapse will run into problem with 3D reconstruction
%if AZ are different sizes and thus have different centers; prompts for
%USER-CALCULATED centers... if only 1 AZ, then matlab calculates center for
%user... ONLY RELEVANT FOR 3D RECONSTRUCTION. MUST DRAW AZ IN SAME
%ORDER EVERY TIME WHEN ANALYZING

if reconstruct_tf == 1
    
    %if there are missing sections for any reason in a 3D reconstruct
    missing_tf = ismember(char('y'),char(input('Are there any missing sections? (yes/no)', 's')));
    if missing_tf
        missing_sect = strsplit(input('Separate the numbers of multiple missing sections with whitespace: ', 's'));
    end
    
    if mult_az ~= 1
        
        for i = 1:mult_az
            %must input center corresponding to AZ in the order that it was drawn... also, center of 2 sections is 1.5, center of 3 is 2 etc.
            az_cent_sect(i) = input(['What is the center section of synapse ' int2str(i) ' (section #): ' ]);
        end
        
    else
        cent_sect = (length(filename.raw_data) + length(missing_sect))/2 + .5;
    end
    
else
    cent_sect = Inf;
end

%find intersection points of drawn pits with AZ

a=1; %holds table row number, section number
pit_amt = 0; %counts total number of pits
synapse_count = 0; %holds # of synapses w/ pits
max_pit = 0; %holds max # of pits in a synapse across all synapses

active_tf = ismember(char('y'),char(input('Do you want to skip sections without pits? (yes/no)', 's')));
    
if active_tf == 1
        
    for i = 1:length(filename.raw_data)
        c=1;%holds table column number
        if isfield(filename.raw_data(i).analysis_data, 'pits') 
            
            for k = 1:length(filename.raw_data(i).analysis_data.vesicle)
                
                
                
                %only consider sections having docked vesicles
                type = filename.raw_data(i).distance_data.vesicle(k).type;
                if strcmp (type, 'docked_SV') 
                    %            disp(['synapse/section ' int2str(i)]);
                    
                    for h = 1:length(filename.raw_data(i).analysis_data.az)
                        
                        for l = 1:length(filename.raw_data(i).analysis_data.vesicle(k).x)
                            
                            for j = 1:length(filename.raw_data(i).analysis_data.az(h).x)
                                
                                
                                %create a table of distances to every pixel in AZ from
                                %a single pixel in pit
                                temp_dist(j) = dist2(filename.raw_data(i).analysis_data.vesicle(k).x(l),...
                                    filename.raw_data(i).analysis_data.vesicle(k).y(l),...
                                    0,...
                                    filename.raw_data(i).analysis_data.az(h).x(j),...
                                    filename.raw_data(i).analysis_data.az(h).y(j));
                            end
                            
                            
                            %compile array of distances of nearest AZ pixel for each pit pixel, and the index of that nearest AZ pixel
                            [temp_dist_min(h,l), az_pix_ind(h,l)] = min(temp_dist);
                            clear temp_dist
                        end
                        
                        %find both intersecting pixels from the pit (ind_1 and 2 holds pixel # of the intersection pt)
                        [min_dist_1(h),ind_1(h)] = min(temp_dist_min(h,:));
                        
                        
                        
                        %stores index of closest AZ pixel corresponding to the pit intersecting pixels
                        min_az_ind_1(h) = az_pix_ind(h, ind_1(h));
                        
                    end
                    
                    [throwaway,az_num] = min(min_dist_1); %az_num holds index of closer AZ
                    
                    if min_az_ind_1(h) < mid_pt(az_num,i)
                        
                        side_index = 0;
                        
                    else
                        side_index = 1;
                    end
                    
                    clear temp_dist_min min_dist_1  az_pix_ind ind_1
                    
                    %find distance (xy_dist_1 and 2) from the intersection point to center of (closer) AZ within section
                    xy_dist_1 = 0;
                    
                    
                    if (min_az_ind_1(az_num) < mid_pt(az_num,i))
                        
                        for index = min_az_ind_1: mid_pt(az_num,i) - 1
                            xy_dist_1 = xy_dist_1 + dist2(filename.raw_data(i).analysis_data.az(az_num).x(index),...
                                filename.raw_data(i).analysis_data.az(az_num).y(index),...
                                0,...
                                filename.raw_data(i).analysis_data.az(az_num).x(index+1),...
                                filename.raw_data(i).analysis_data.az(az_num).y(index+1));
                        end
                        
                    elseif (min_az_ind_1(az_num) > mid_pt(az_num,i))
                        
                        for index = mid_pt(az_num,i) : min_az_ind_1(az_num)-1
                            xy_dist_1 = xy_dist_1 + dist2(filename.raw_data(i).analysis_data.az(az_num).x(index),...
                                filename.raw_data(i).analysis_data.az(az_num).y(index),...
                                0,...
                                filename.raw_data(i).analysis_data.az(az_num).x(index+1),...
                                filename.raw_data(i).analysis_data.az(az_num).y(index+1));
                        end
                    end
                    
                    
                    
                    
                    %calculate distance to center slice or edge slice based on section #
                    %if only 1 AZ, center of AZ is center of images
                    if reconstruct_tf == 1
                        if mult_az == 1
                            z_cent_dist = abs(i-cent_sect);
                        else %if multiple AZ
                            z_cent_dist = abs(i-az_cent_sect(az_num));
                        end
                        
                        %if not doing 3d reconstruct, reset z distance to 0 for
                        %subsequent calculation of distance
                    else
                        z_cent_dist = 0;
                    end
                    
                    
                    %deal with missing sections
                    for num = 1:length(missing_sect)
                        
                        %if the missing section is between current section and
                        %the center, deals with both cases if current section is
                        %above/below center; adds 1 section worth of thickness
                        %per missing section
                        if str2double(missing_sect(num)) < cent_sect && i < str2double(missing_sect(num))
                            z_cent_dist = z_cent_dist + sect_thick;
                            
                        elseif str2double(missing_sect(num)) > cent_sect && i > str2double(missing_sect(num))
                            z_cent_dist = z_cent_dist + sect_thick;
                        end
                    end
                    
                    
                    %half-total thickness of entire synapse
                    z_half = (length(filename.raw_data) + length(missing_sect))/2;
                    %distance to edge in z direction
                    z_edge_dist = abs(z_half - z_cent_dist);
                    z_dist_norm = z_edge_dist/z_cent_dist;
                    
                    if reconstruct_tf == 0
                        z_edge_dist = Inf;
                    end
                    
                    %closest leg to AZ midpt
                    pit_az_cent = min(xy_dist_1)*pix_size;
                    
                    %distance of pit center to the AZ edge
                    %             pit_horiz_edge = abs(az_half_length(az_num,i) - pit_az_cent);
                    %             xy_dist_norm = pit_horiz_edge/az_half_length(az_num,i);
                    
                    
                    %normalize to the center
                    pit_horiz_edge = abs(az_half_length(az_num,i) - pit_az_cent);
                    xy_dist_norm = pit_az_cent/az_half_length(az_num,i);
                    
                    %pick normalized data to use (smaller normalized distance =
                    %more peripheral)
                    %             if min(z_edge_dist,pit_horiz_edge) == z_edge_dist
                    %                 norm_dist = z_dist_norm;
                    %
                    %             else
                    %                 norm_dist = xy_dist_norm;
                    %             end
                    
                    vesicle_diameter = filename.raw_data(i).analysis_data.vesicle(k).r;
                    
                    
                    %only add pit data if it is within az, this will also create
                    %separate rows for separate AZs
                    
                    if reconstruct_tf == 0
                        vesicle_data(a,1+(c-1)*5) = pit_horiz_edge; %xy or z distance from edge of AZ
                        vesicle_data(a,2+(c-1)*5) = pit_az_cent; %distance from center of AZ
                        vesicle_data(a,3+(c-1)*5) = pit_az_cent/(pit_horiz_edge+pit_az_cent); %normalized distance to center
                        vesicle_data(a,4+(c-1)*5) = vesicle_diameter;
                        vesicle_data(a,5+(c-1)*5) = side_index;
                        
                    else
                        dist_cent = sqrt((z_cent_dist*sect_thick)^2 + pit_az_cent^2);
                        
                        dist_edge = (dist_cent * z_dist_norm);
                        
                        if dist_edge < pit_horiz_edge
                            
                            z_dist = dist_edge + dist_cent;
                            
                        else
                            z_dist = pit_horiz_edge + dist_cent;
                            
                            
                        end
                        
                        vesicle_data(a,1+(c-1)*5) = abs(z_dist-dist_cent); %xy or z distance from edge of AZ
                        vesicle_data(a,2+(c-1)*5) = dist_cent; %distance from center of AZ
                        vesicle_data(a,3+(c-1)*5) = (dist_cent/z_dist)^2; %normalized fractional area to center
                        vesicle_data(a,4+(c-1)*5) = vesicle_diameter;
                        vesicle_data(a,5+(c-1)*5) = side_index;
                        
                    end
                    
                    c=c+1;
                    
                end
                
                
                
                synapse_count = synapse_count + length(filename.raw_data(i).analysis_data.az); %first assume all AZs in this section have pits... if not, will be removed later
            end
            a = a + 1; %increment the array row counter by the # of AZ in the particular section
        else
            vesicle_data(a,1) = 0;
            vesicle_data(a,2) = 0; 
            vesicle_data(a,3) = 0; 
            vesicle_data(a,4) = 0;
            vesicle_data(a,5) = 0; 
            a=a+1;
        end
    end
    
    
else
       
    %iterate through each synapse
    for i = 1:length(filename.raw_data)
        
        
        c=1;%holds table column number
        for k = 1:length(filename.raw_data(i).analysis_data.vesicle)
            
            %only consider sections having docked vesicles
            type = filename.raw_data(i).analysis_data.vesicle(k).name;
            if strcmp (type, 'docked_SV')
                %            disp(['synapse/section ' int2str(i)]);
                
                for h = 1:length(filename.raw_data(i).analysis_data.az)
                    
                    for l = 1:length(filename.raw_data(i).analysis_data.vesicle(k).x)
                        
                        for j = 1:length(filename.raw_data(i).analysis_data.az(h).x)
                            
                    
                    %create a table of distances to every pixel in AZ from
                    %a single pixel in pit
                        temp_dist(j) = dist2(filename.raw_data(i).analysis_data.vesicle(k).x(l),...
                                         filename.raw_data(i).analysis_data.vesicle(k).y(l),...
                                         0,...
                                         filename.raw_data(i).analysis_data.az(h).x(j),...
                                         filename.raw_data(i).analysis_data.az(h).y(j));
                    end
                
            
                %compile array of distances of nearest AZ pixel for each pit pixel, and the index of that nearest AZ pixel
                    [temp_dist_min(h,l), az_pix_ind(h,l)] = min(temp_dist);
                    clear temp_dist
                end
               
                    %find both intersecting pixels from the pit (ind_1 and 2 holds pixel # of the intersection pt) 
                    [min_dist_1(h),ind_1(h)] = min(temp_dist_min(h,:));
                    
                    

                    %stores index of closest AZ pixel corresponding to the pit intersecting pixels
                    min_az_ind_1(h) = az_pix_ind(h, ind_1(h));
            
            end
            
            [throwaway,az_num] = min(min_dist_1); %az_num holds index of closer AZ
            
            if min_az_ind_1(h) < mid_pt(az_num,i)
                
                side_index = 0;
                
            else
                side_index = 1;
            end
            
            clear temp_dist_min min_dist_1  az_pix_ind ind_1 
            
            %find distance (xy_dist_1 and 2) from the intersection point to center of (closer) AZ within section
            xy_dist_1 = 0;
            
            
            if (min_az_ind_1(az_num) < mid_pt(az_num,i))
                
                for index = min_az_ind_1: mid_pt(az_num,i) - 1
                    xy_dist_1 = xy_dist_1 + dist2(filename.raw_data(i).analysis_data.az(az_num).x(index),...
                        filename.raw_data(i).analysis_data.az(az_num).y(index),...
                        0,...
                        filename.raw_data(i).analysis_data.az(az_num).x(index+1),...
                        filename.raw_data(i).analysis_data.az(az_num).y(index+1));
                end
                
            elseif (min_az_ind_1(az_num) > mid_pt(az_num,i))
                
                for index = mid_pt(az_num,i) : min_az_ind_1(az_num)-1 
                    xy_dist_1 = xy_dist_1 + dist2(filename.raw_data(i).analysis_data.az(az_num).x(index),...
                        filename.raw_data(i).analysis_data.az(az_num).y(index),...
                        0,...
                        filename.raw_data(i).analysis_data.az(az_num).x(index+1),...
                        filename.raw_data(i).analysis_data.az(az_num).y(index+1));
                end
            end
            
            
            
            
            %calculate distance to center slice or edge slice based on section #
            %if only 1 AZ, center of AZ is center of images
            if reconstruct_tf == 1
                if mult_az == 1
                    z_cent_dist = abs(i-cent_sect);
                else %if multiple AZ
                    z_cent_dist = abs(i-az_cent_sect(az_num));
                end
                
                %if not doing 3d reconstruct, reset z distance to 0 for
                %subsequent calculation of distance
            else
                z_cent_dist = 0;
            end
            
            
            %deal with missing sections
            for num = 1:length(missing_sect)
                
                %if the missing section is between current section and
                %the center, deals with both cases if current section is
                %above/below center; adds 1 section worth of thickness
                %per missing section
                if str2double(missing_sect(num)) < cent_sect && i < str2double(missing_sect(num))
                    z_cent_dist = z_cent_dist + sect_thick;
                    
                elseif str2double(missing_sect(num)) > cent_sect && i > str2double(missing_sect(num))
                    z_cent_dist = z_cent_dist + sect_thick;
                end
            end
            
            
            %half-total thickness of entire synapse
            z_half = (length(filename.raw_data) + length(missing_sect))/2;
            %distance to edge in z direction
            z_edge_dist = abs(z_half - z_cent_dist);
            z_dist_norm = z_edge_dist/z_cent_dist;
            
            if reconstruct_tf == 0
                z_edge_dist = Inf;
            end
            
            %closest leg to AZ midpt
            pit_az_cent = min(xy_dist_1)*pix_size;
            
            %distance of pit center to the AZ edge
%             pit_horiz_edge = abs(az_half_length(az_num,i) - pit_az_cent);
%             xy_dist_norm = pit_horiz_edge/az_half_length(az_num,i);
            
            
             %normalize to the center
            pit_horiz_edge = abs(az_half_length(az_num,i) - pit_az_cent);
            xy_dist_norm = pit_az_cent/az_half_length(az_num,i);
            
            %pick normalized data to use (smaller normalized distance =
            %more peripheral)
%             if min(z_edge_dist,pit_horiz_edge) == z_edge_dist
%                 norm_dist = z_dist_norm;
%                 
%             else
%                 norm_dist = xy_dist_norm;
%             end
            
            vesicle_diameter = filename.raw_data(i).analysis_data.vesicle(k).r;
            
            
            %only add pit data if it is within az, this will also create
            %separate rows for separate AZs
            
            if reconstruct_tf == 0
                vesicle_data(a,1+(c-1)*5) = pit_horiz_edge; %xy or z distance from edge of AZ
                vesicle_data(a,2+(c-1)*5) = pit_az_cent; %distance from center of AZ
                vesicle_data(a,3+(c-1)*5) = pit_az_cent/(pit_horiz_edge+pit_az_cent); %normalized distance to center
                vesicle_data(a,4+(c-1)*5) = vesicle_diameter;
                vesicle_data(a,5+(c-1)*5) = side_index;
                
            else 
                dist_cent = sqrt((z_cent_dist*sect_thick)^2 + pit_az_cent^2);
                
                dist_edge = (dist_cent * z_dist_norm);
                
                if dist_edge < pit_horiz_edge
                    
                    z_dist = dist_edge + dist_cent;
                    
                else
                    z_dist = pit_horiz_edge + dist_cent;
                    
                
                end
                
                vesicle_data(a,1+(c-1)*5) = abs(z_dist-dist_cent); %xy or z distance from edge of AZ
                vesicle_data(a,2+(c-1)*5) = dist_cent; %distance from center of AZ
                vesicle_data(a,3+(c-1)*5) = (dist_cent/z_dist)^2; %normalized fractional area to center
                vesicle_data(a,4+(c-1)*5) = vesicle_diameter;
                vesicle_data(a,5+(c-1)*5) = side_index;
                
            end
               
               c=c+1; 
               
        end
        
        
        
        synapse_count = synapse_count + length(filename.raw_data(i).analysis_data.az); %first assume all AZs in this section have pits... if not, will be removed later
    end
    
    a = a + 1; %increment the array row counter by the # of AZ in the particular section
    
    end
end





clear mid_pt
clear az_half_length

%runs through output array and removes synapses w/o exocytic events from total count
% if ~isempty(vesicle_data)
%     
%     for i = 1:length(vesicle_data(:,1));
%         
%         has_exo = 0; %does this synapse have exocytic events? set initial to false
%         for j = 1:max_pit
%             
%             %only check if haven't detected exo pits yet
%             if has_exo == 0
%                 
%                 %if entry is not infinite and not 0, then the pit is exocytic
%                 if ~(vesicle_data(i,1+(j-1)*4) == Inf || vesicle_data(i,1+(j-1)*4) == 0)
%                     has_exo = 1;
%                 end
%             end
%         end
%         
%         %remove synapse from count if only has endo pits
%         if has_exo == 0
%             synapse_count = synapse_count - 1;
%         end
%     end
% end





output_data.DockedSVData = vesicle_data;

disp([char(10) 'Done.']);
end