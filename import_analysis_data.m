function analysis_data = import_analysis_data (filename, pixel_size)

% this function is used in conjuction with the "get_data" function. It is
% called out from the get_data function. This program will open up the text
% files, count the number of structures in each file, and distance from
% those structures to the plasma membrane and active zone membranes. 

fid = fopen(filename);
% disp(filename);
% initialting index values
a = 1;%variables for ribbon
a_1 = 1;%variables for dense projection
b = 1;%variables for active zone
c = 1;%variables for plasma membrane
d = 1; %variables for SV diameter
d_1 = 1;%variables for fSV
e = 1; %variables for DCV diameter
f = 1; %variables for LV diameter
f_1 = 1;%variables for fLV
k = 1; %variables for endosome
k_1 = 1; %variables for fEndosome
m = 1; %variables for closed circles
n = 1; %variables for open-ended structures
t = 1; %variables for Pits
t_1=1; %variables for fPits
t_2=1; %variables for buds
t_3=1; %variables for fbuds
t_4=1; %variables for freeh endosomes
t_5=1; %variables for freeh fendosomes
t_6=1; %variables for freeh mvb
t_7=1; %variables for freeh fmvb
u = 1; %variables for coated_pits
u_1=1; %variables for coated_fpits
y = 1; %variables for ccv
y_1 = 1;%variables for fccv
y_2 = 1;%variables for particle
% initiating counters
cytosolic_sv_count =0;
cytosolic_fsv_count=0;
docked_sv_count    =0;
docked_fsv_count   =0;
tethered_sv_count  =0;
tethered_fsv_count =0;
dcv_count          =0;
docked_dcv_count   =0;
lv_count           =0;
flv_count          =0;
ccv_count          =0;
fccv_count         =0;
particle_count     =0;


while (true)
    
    tline = fgetl(fid);
    
    if ( ~ischar(tline))
        break,
    end

    %extracting data
    [type, records] = strtok(tline);
    
    %1 is line tool used in imageJ for measuring closed circular structures such as SV,LV,and DCV.
    if (type == '1')
        
        [analysis_data.vesicle(m).name,...
         analysis_data.vesicle(m).x,...
         analysis_data.vesicle(m).y,...
         analysis_data.vesicle(m).r] = strread(records, '%s %f %f %f');
        
        analysis_data.vesicle(m).name = char(analysis_data.vesicle(m).name);
        
        % storing diameter values as a single array so that the average
        % diameter can be calculated easily later.  vesicle is counted as
        % it goes through depending on the type of vesicles
            if (strcmp (analysis_data.vesicle(m).name, 'SV'))
                
                analysis_data.diameter.SV(d) = analysis_data.vesicle(m).r *2*pixel_size;
                d=d+1;
                
                cytosolic_sv_count = cytosolic_sv_count + 1;
                
            elseif (strcmp (analysis_data.vesicle(m).name, 'fSV'))
                
                analysis_data.diameter.fSV(d_1) = analysis_data.vesicle(m).r *2*pixel_size;
                d_1=d_1+1;
                
                cytosolic_fsv_count = cytosolic_fsv_count + 1;
                
            elseif (strcmp (analysis_data.vesicle(m).name, 'tethered_SV'))
                
                analysis_data.diameter.SV(d) = analysis_data.vesicle(m).r *2*pixel_size;
                d=d+1;
                
                tethered_sv_count = tethered_sv_count + 1;
                
            elseif (strcmp (analysis_data.vesicle(m).name, 'tethered_fSV'))
                
                analysis_data.diameter.fSV(d_1) = analysis_data.vesicle(m).r *2*pixel_size;
                d_1=d_1+1;
                
                tethered_fsv_count = tethered_fsv_count + 1;
                
            elseif (strcmp (analysis_data.vesicle(m).name, 'docked_SV'))

                analysis_data.diameter.SV(d) = analysis_data.vesicle(m).r *2*pixel_size;
                d=d+1;
                
                docked_sv_count = docked_sv_count + 1;
                
            elseif (strcmp (analysis_data.vesicle(m).name, 'docked_fSV'))

                analysis_data.diameter.fSV(d_1) = analysis_data.vesicle(m).r *2*pixel_size;
                d_1=d_1+1;
                
                docked_fsv_count = docked_fsv_count + 1;
                
            elseif (strcmp (analysis_data.vesicle(m).name, 'DCV'))
            
                analysis_data.diameter.DCV(e) = analysis_data.vesicle(m).r *2*pixel_size;
                e=e+1;
                
                dcv_count = dcv_count +1;
                
            elseif (strcmp (analysis_data.vesicle(m).name, 'docked_DCV'))

                analysis_data.diameter.DCV(e) = analysis_data.vesicle(m).r *2*pixel_size;
                e=e+1;
                
                docked_dcv_count = docked_dcv_count + 1;
                
            elseif (strcmp (analysis_data.vesicle(m).name, 'LV'))

                analysis_data.diameter.LV(f) = analysis_data.vesicle(m).r *2*pixel_size;
                f=f+1;
                
                lv_count = lv_count + 1;
                
            elseif (strcmp (analysis_data.vesicle(m).name, 'fLV'))

                analysis_data.diameter.fLV(f_1) = analysis_data.vesicle(m).r *2*pixel_size;
                f_1=f_1+1;
                
                flv_count = flv_count + 1;
                
            elseif (strcmp (analysis_data.vesicle(m).name, 'CCV'))
                
                analysis_data.diameter.CCV(y) = analysis_data.vesicle(m).r *2*pixel_size;
                y=y+1;
                
                ccv_count = ccv_count +1;
                
            elseif (strcmp (analysis_data.vesicle(m).name, 'fCCV'))
                
                analysis_data.diameter.fCCV(y_1) = analysis_data.vesicle(m).r *2*pixel_size;
                y_1=y_1+1;
                
                fccv_count = fccv_count +1;
            
            elseif (strcmp (analysis_data.vesicle(m).name, 'particle'))
                
                analysis_data.diameter.particle(y_2) = analysis_data.vesicle(m).r *2*pixel_size;
                y_2=y_2+1;
                
                particle_count = particle_count +1;

            end
        
        
        m=m+1;
    
    %7 is freehand line tool used in imageJ to annotate open-ended coutour     
    elseif (type == '7')
        
        [freel(n).name,...
         freel(n).length,...
         freel(n).xcoords,...
         freel(n).ycoords] = strread(records, '%s %f %s %s');
        
    structure_type = char(freel(n).name);
    
    switch(structure_type)
     
        case 'Ribbon'
        
            analysis_data.sr(a).name = char(freel(n).name);
            
            analysis_data.sr(a).length = freel(n).length*pixel_size;
            
            analysis_data.sr(a).x    = strread(freel(n).xcoords{1},...
                                 '%f','delimiter',',');
            
            analysis_data.sr(a).y    = strread(freel(n).ycoords{1},...
                                 '%f','delimiter',',');
            
            a = a+1;
        
        case 'Dense_projection'
        
            analysis_data.dp(a_1).name = char(freel(n).name);
            
            analysis_data.dp(a_1).length = freel(n).length*pixel_size;
            
            analysis_data.dp(a_1).x    = strread(freel(n).xcoords{1},...
                                 '%f','delimiter',',');
            
            analysis_data.dp(a_1).y    = strread(freel(n).ycoords{1},...
                                 '%f','delimiter',',');
            
            a_1 = a_1+1;
        case 'Active_zone'
            
            analysis_data.az(b).name = char(freel(n).name);
            
            analysis_data.az(b).length = freel(n).length*pixel_size;
            
            analysis_data.az(b).x    = strread(freel(n).xcoords{1},...
                                 '%f','delimiter',',');
            
            analysis_data.az(b).y    = strread(freel(n).ycoords{1},...
                                 '%f','delimiter',',');
            
            b = b+1;
            
        case'Plasma_membrane'
            
            analysis_data.pm(c).name = char(freel(n).name);
            
            analysis_data.pm(c).length = freel(n).length*pixel_size;
            
            analysis_data.pm(c).x    = strread(freel(n).xcoords{1},...
                                 '%f','delimiter',',');
            
            analysis_data.pm(c).y    = strread(freel(n).ycoords{1},...
                                 '%f','delimiter',',');
            
            c = c+1;
    % for pits, their sizes (depth, diameter, neck width, perimeter, and
    % suraface area) are determined. 
        case'pits'
            
            analysis_data.pits(t).name = char(freel(n).name);
            
            analysis_data.pits(t).length = freel(n).length*pixel_size;
            
            analysis_data.pits(t).x    = strread(freel(n).xcoords{1},...
                                 '%f','delimiter',',');
            
            analysis_data.pits(t).y    = strread(freel(n).ycoords{1},...
                                 '%f','delimiter',',');
            % point_1 is the half point (the heighest part) of the pit
            point_1 = ceil(length(analysis_data.pits(t).x)/2);
            
            %temp_distance is the width at the base of a pit
            temp_distance = dist2(analysis_data.pits(t).x(1),...
                            analysis_data.pits(t).y(1),...
                            0,...
                            analysis_data.pits(t).x(length(analysis_data.pits(t).x)),...
                            analysis_data.pits(t).y(length(analysis_data.pits(t).x)));
            %temp_distance is the distance between the first point to the
            %top of the pit
            temp_distance_2 = dist2(analysis_data.pits(t).x(1),...
                              analysis_data.pits(t).y(1),...
                              0,...
                              analysis_data.pits(t).x(point_1),...
                              analysis_data.pits(t).y(point_1));
            % neck width = temp_distance, but need to be multiplied by the pixel size            
            analysis_data.pits(t).neck_width = abs(temp_distance)*pixel_size;
            % for height, use pythagorean theorem to determine the height.
            % the width at the base needs to be divided by 2. 
            temp_height = sqrt(((temp_distance_2^2)-((temp_distance/2)^2)));
            
            analysis_data.pits(t).height = abs(pixel_size*temp_height);
            
            % the diameter is calculated at the full-width, half-maximum.
            % basically, taking 1/4 and 3/4 points and measuring the
            % distance. 
            point_2 = ceil(length(analysis_data.pits(t).x)/4);
            point_3 = ceil((length(analysis_data.pits(t).x)/4)*3);
           
            
            temp_distance = dist2(analysis_data.pits(t).x(point_2),...
                            analysis_data.pits(t).y(point_2),...
                            0,...
                            analysis_data.pits(t).x(point_3),...
                            analysis_data.pits(t).y(point_3));
                           
            analysis_data.pits(t).diameter = abs(temp_distance)*pixel_size; 
            
            analysis_data.pits(t).surface_area = pi*(((analysis_data.pits(t).neck_width/2)^2)+(analysis_data.pits(t).height^2));
                
                             
            t = t+1;
            
            clear temp_distance temp_distance_2
        
        % see 'pits' section for the descriptions
        case'fpits'
            
            analysis_data.fpits(t_1).name = char(freel(n).name);
            
            analysis_data.fpits(t_1).length = freel(n).length*pixel_size;
            
            analysis_data.fpits(t_1).x    = strread(freel(n).xcoords{1},...
                                 '%f','delimiter',',');
            
            analysis_data.fpits(t_1).y    = strread(freel(n).ycoords{1},...
                                 '%f','delimiter',',');
            
            point_1 = ceil(length(analysis_data.fpits(t_1).x)/2);
                             
            temp_distance = dist2(analysis_data.fpits(t_1).x(1),...
                            analysis_data.fpits(t_1).y(1),...
                            0,...
                            analysis_data.fpits(t_1).x(length(analysis_data.fpits(t_1).x)),...
                            analysis_data.fpits(t_1).y(length(analysis_data.fpits(t_1).x)));
            
            temp_distance_2 = dist2(analysis_data.fpits(t_1).x(1),...
                              analysis_data.fpits(t_1).y(1),...
                              0,...
                              analysis_data.fpits(t_1).x(point_1),...
                              analysis_data.fpits(t_1).y(point_1));
                        
            analysis_data.fpits(t_1).neck_width = abs(temp_distance)*pixel_size;
            
            temp_height = sqrt(((temp_distance_2^2)-((temp_distance/2)^2)));
            
            analysis_data.fpits(t_1).height = abs(pixel_size*temp_height);
            
            point_2 = ceil(length(analysis_data.fpits(t_1).x)/4);
            point_3 = ceil((length(analysis_data.fpits(t_1).x)/4)*3);
           
            
            temp_distance = dist2(analysis_data.fpits(t_1).x(point_2),...
                            analysis_data.fpits(t_1).y(point_2),...
                            0,...
                            analysis_data.fpits(t_1).x(point_3),...
                            analysis_data.fpits(t_1).y(point_3));
                           
            analysis_data.fpits(t_1).diameter = abs(temp_distance)*pixel_size; 
            
            analysis_data.fpits(t_1).surface_area = pi*(((analysis_data.fpits(t_1).neck_width/2)^2)+(analysis_data.fpits(t_1).height^2));
                
                             
            t_1 = t_1+1;
            
            clear temp_distance temp_distance_2
        
        % see 'pits' section for the descriptions
        case 'coated_pits'
            
            analysis_data.coated_pits(u).name = char(freel(n).name);
            
            analysis_data.coated_pits(u).length = freel(n).length*pixel_size;
            
            analysis_data.coated_pits(u).x    = strread(freel(n).xcoords{1},...
                                 '%f','delimiter',',');
            
            analysis_data.coated_pits(u).y    = strread(freel(n).ycoords{1},...
                                 '%f','delimiter',',');
            
            point_1 = ceil(length(analysis_data.coated_pits(u).x)/2);
                             
            temp_distance = dist2(analysis_data.coated_pits(u).x(1),...
                            analysis_data.coated_pits(u).y(1),...
                            0,...
                            analysis_data.coated_pits(u).x(length(analysis_data.coated_pits(u).x)),...
                            analysis_data.coated_pits(u).y(length(analysis_data.coated_pits(u).x)));
            
            temp_distance_2 = dist2(analysis_data.coated_pits(u).x(1),...
                              analysis_data.coated_pits(u).y(1),...
                              0,...
                              analysis_data.coated_pits(u).x(point_1),...
                              analysis_data.coated_pits(u).y(point_1));
                        
            analysis_data.coated_pits(u).neck_width = abs(temp_distance)*pixel_size;
            
            temp_height = sqrt(((temp_distance_2^2)-((temp_distance/2)^2)));
            
            analysis_data.coated_pits(u).height = abs(pixel_size*temp_height);
            
            point_2 = ceil(length(analysis_data.coated_pits(u).x)/4);
            point_3 = ceil((length(analysis_data.coated_pits(u).x)/4)*3);
           
            
            temp_distance = dist2(analysis_data.coated_pits(u).x(point_2),...
                            analysis_data.coated_pits(u).y(point_2),...
                            0,...
                            analysis_data.coated_pits(u).x(point_3),...
                            analysis_data.coated_pits(u).y(point_3));
                           
            analysis_data.coated_pits(u).diameter = abs(temp_distance)*pixel_size; 
            
            analysis_data.coated_pits(u).surface_area = pi*(((analysis_data.coated_pits(u).neck_width/2)^2)+(analysis_data.coated_pits(u).height^2));
                
                             
            u = u+1;
            
            clear temp_distance temp_distance_2
      
       % see 'pits' section for the descriptions     
       case 'coated_fpits'
            
            analysis_data.coated_fpits(u_1).name = char(freel(n).name);
            
            analysis_data.coated_fpits(u_1).length = freel(n).length*pixel_size;
            
            analysis_data.coated_fpits(u_1).x    = strread(freel(n).xcoords{1},...
                                 '%f','delimiter',',');
            
            analysis_data.coated_fpits(u_1).y    = strread(freel(n).ycoords{1},...
                                 '%f','delimiter',',');
            
            point_1 = ceil(length(analysis_data.coated_fpits(u_1).x)/2);
                             
            temp_distance = dist2(analysis_data.coated_fpits(u_1).x(1),...
                            analysis_data.coated_fpits(u_1).y(1),...
                            0,...
                            analysis_data.coated_fpits(u_1).x(length(analysis_data.coated_fpits(u_1).x)),...
                            analysis_data.coated_fpits(u_1).y(length(analysis_data.coated_fpits(u_1).x)));
            
            temp_distance_2 = dist2(analysis_data.coated_fpits(u_1).x(1),...
                              analysis_data.coated_fpits(u_1).y(1),...
                              0,...
                              analysis_data.coated_fpits(u_1).x(point_1),...
                              analysis_data.coated_fpits(u_1).y(point_1));
                        
            analysis_data.coated_fpits(u_1).neck_width = abs(temp_distance)*pixel_size;
            
            temp_height = sqrt(((temp_distance_2^2)-((temp_distance/2)^2)));
            
            analysis_data.coated_fpits(u_1).height = abs(pixel_size*temp_height);
            
            point_2 = ceil(length(analysis_data.coated_fpits(u_1).x)/4);
            point_3 = ceil((length(analysis_data.coated_fpits(u_1).x)/4)*3);
           
            
            temp_distance = dist2(analysis_data.coated_fpits(u_1).x(point_2),...
                            analysis_data.coated_fpits(u_1).y(point_2),...
                            0,...
                            analysis_data.coated_fpits(u_1).x(point_3),...
                            analysis_data.coated_fpits(u_1).y(point_3));
                           
            analysis_data.coated_fpits(u_1).diameter = abs(temp_distance)*pixel_size; 
            
            analysis_data.coated_fpits(u_1).surface_area = pi*(((analysis_data.coated_fpits(u_1).neck_width/2)^2)+(analysis_data.coated_fpits(u_1).height^2));
                
                             
            u_1 = u_1+1;
            
            clear temp_distance temp_distance_2
            
       % see 'pits' section for the descriptions     
       case'buds'
            
            analysis_data.buds(t_2).name = char(freel(n).name);
            
            analysis_data.buds(t_2).length = freel(n).length*pixel_size;
            
            analysis_data.buds(t_2).x    = strread(freel(n).xcoords{1},...
                                 '%f','delimiter',',');
            
            analysis_data.buds(t_2).y    = strread(freel(n).ycoords{1},...
                                 '%f','delimiter',',');
            
            point_1 = ceil(length(analysis_data.buds(t_2).x)/2);
                             
            temp_distance = dist2(analysis_data.buds(t_2).x(1),...
                            analysis_data.buds(t_2).y(1),...
                            0,...
                            analysis_data.buds(t_2).x(length(analysis_data.buds(t_2).x)),...
                            analysis_data.buds(t_2).y(length(analysis_data.buds(t_2).x)));
            
            temp_distance_2 = dist2(analysis_data.buds(t_2).x(1),...
                              analysis_data.buds(t_2).y(1),...
                              0,...
                              analysis_data.buds(t_2).x(point_1),...
                              analysis_data.buds(t_2).y(point_1));
                        
            analysis_data.buds(t_2).neck_width = abs(temp_distance)*pixel_size;
            
            temp_height = sqrt(((temp_distance_2^2)-((temp_distance/2)^2)));
            
            analysis_data.buds(t_2).height = abs(pixel_size*temp_height);
            
            point_2 = ceil(length(analysis_data.buds(t_2).x)/4);
            point_3 = ceil((length(analysis_data.buds(t_2).x)/4)*3);
           
            
            temp_distance = dist2(analysis_data.buds(t_2).x(point_2),...
                            analysis_data.buds(t_2).y(point_2),...
                            0,...
                            analysis_data.buds(t_2).x(point_3),...
                            analysis_data.buds(t_2).y(point_3));
                           
            analysis_data.buds(t_2).diameter = abs(temp_distance)*pixel_size; 
            
            analysis_data.buds(t_2).surface_area = pi*(((analysis_data.buds(t_2).neck_width/2)^2)+(analysis_data.buds(t_2).height^2));
                
                             
            t_2 = t_2+1;
            
            clear temp_distance temp_distance_2
        
        % see 'pits' section for the descriptions
        case'fbuds'
            
            analysis_data.fbuds(t_3).name = char(freel(n).name);
            
            analysis_data.fbuds(t_3).length = freel(n).length*pixel_size;
            
            analysis_data.fbuds(t_3).x    = strread(freel(n).xcoords{1},...
                                 '%f','delimiter',',');
            
            analysis_data.fbuds(t_3).y    = strread(freel(n).ycoords{1},...
                                 '%f','delimiter',',');
            
            point_1 = ceil(length(analysis_data.fbuds(t_3).x)/2);
                             
            temp_distance = dist2(analysis_data.fbuds(t_3).x(1),...
                            analysis_data.fbuds(t_3).y(1),...
                            0,...
                            analysis_data.fbuds(t_3).x(length(analysis_data.fbuds(t_3).x)),...
                            analysis_data.fbuds(t_3).y(length(analysis_data.fbuds(t_3).x)));
            
            temp_distance_2 = dist2(analysis_data.fbuds(t_3).x(1),...
                              analysis_data.fbuds(t_3).y(1),...
                              0,...
                              analysis_data.fbuds(t_3).x(point_1),...
                              analysis_data.fbuds(t_3).y(point_1));
                        
            analysis_data.fbuds(t_3).neck_width = abs(temp_distance)*pixel_size;
            
            temp_height = sqrt(((temp_distance_2^2)-((temp_distance/2)^2)));
            
            analysis_data.fbuds(t_3).height = abs(pixel_size*temp_height);
            
            point_2 = ceil(length(analysis_data.fbuds(t_3).x)/4);
            point_3 = ceil((length(analysis_data.fbuds(t_3).x)/4)*3);
           
            
            temp_distance = dist2(analysis_data.fbuds(t_3).x(point_2),...
                            analysis_data.fbuds(t_3).y(point_2),...
                            0,...
                            analysis_data.fbuds(t_3).x(point_3),...
                            analysis_data.fbuds(t_3).y(point_3));
                           
            analysis_data.fbuds(t_3).diameter = abs(temp_distance)*pixel_size; 
            
            analysis_data.fbuds(t_3).surface_area = pi*(((analysis_data.fbuds(t_3).neck_width/2)^2)+(analysis_data.fbuds(t_3).height^2));
                
                             
            t_3 = t_3+1;
            
            clear temp_distance temp_distance_2     
            
            
    end
        
        n=n+1;
        
    elseif (type == '3')%this is the freehand selection tool in imageJ to annotate closed objects with irregular shape

        [freeh(k).name,...
         freeh(k).area,...
         freeh(k).xelements,...
         freeh(k).yelements] = strread(records, '%s %f %s %s');

        if strcmp(freeh(k).name, 'Endosome')
            %(x, y) of each pixels on the outer surface of dense
            %projection
            
            analysis_data.endosome(t_4).name = char(freeh(k).name); 
            
            analysis_data.endosome(t_4).area = freeh(k).area*pixel_size^2;
            
            analysis_data.endosome(t_4).x    = strread(freeh(k).xelements{1},...
                              '%f','delimiter',',');
            
            analysis_data.endosome(t_4).y    = strread(freeh(k).yelements{1},...
                              '%f','delimiter',',');
                          
            t_4 = t_4+1;
            
        elseif strcmp(freeh(k).name, 'fEndosome')
            %(x, y) of each pixels on the outer surface of dense
            %projection
            
            analysis_data.fendosome(t_5).name = char(freeh(k_1).name); 
            
            analysis_data.fendosome(t_5).area = freeh(k_1).area*pixel_size^2;
            
            analysis_data.fendosome(t_5).x    = strread(freeh(k_1).xelements{1},...
                              '%f','delimiter',',');
            
            analysis_data.fendosome(t_5).y    = strread(freeh(k_1).yelements{1},...
                              '%f','delimiter',',');
                          
            t_5 = t_5+1;
        
        elseif strcmp(freeh(k).name, 'MVB')
            %(x, y) of each pixels on the outer surface of dense
            %projection
            
            analysis_data.mvb(t_6).name = char(freeh(k).name); 
            
            analysis_data.mvb(t_6).area = freeh(k).area*pixel_size^2;
            
            analysis_data.mvb(t_6).x    = strread(freeh(k).xelements{1},...
                              '%f','delimiter',',');
            
            analysis_data.mvb(t_6).y    = strread(freeh(k).yelements{1},...
                              '%f','delimiter',',');
                          
            t_6 = t_6+1;
            
        elseif strcmp(freeh(k).name, 'fMVB')
            %(x, y) of each pixels on the outer surface of dense
            %projection
            
            analysis_data.fmvb(t_7).name = char(freeh(k_1).name); 
            
            analysis_data.fmvb(t_7).area = freeh(k_1).area*pixel_size^2;
            
            analysis_data.fmvb(t_7).x    = strread(freeh(k_1).xelements{1},...
                              '%f','delimiter',',');
            
            analysis_data.fmvb(t_7).y    = strread(freeh(k_1).yelements{1},...
                              '%f','delimiter',',');
                          
            t_7 = t_7+1;
        
        else 
            
            disp(type);
            disp(records);
            
        end
        
        k=k+1;
        
    else
        
        disp(type);
        disp(records);
        
    end
end


% vesicle numbers data into structure array
analysis_data.vesicle_number = struct('cytosolic_sv_count', {cytosolic_sv_count},...
                                      'cytosolic_fsv_count', {cytosolic_fsv_count},...
                                      'docked_sv_count', {docked_sv_count},...
                                      'docked_fsv_count', {docked_fsv_count},...
                                      'tethered_sv_count', {tethered_sv_count},...
                                      'tethered_fsv_count', {tethered_fsv_count},...
                                      'dcv_count', {dcv_count},...
                                      'docked_dcv_count', {docked_dcv_count},...
                                      'lv_count', {lv_count},...
                                      'flv_count', {flv_count},...
                                      'ccv_count', {ccv_count},...
                                      'fccv_count', {fccv_count},...
                                      'particle_count', {particle_count}); 




fclose(fid);
clear fid

end    

        
