function correct_data = check_data (filename, pixel_size, ribbon_tf, dp_tf)

% 
% Record of revisions:
%      Date             programmer              Description of change
%      ====             ==========              =====================
%    01/21/2010      Shigeki Watanabe           Original code
%

fid = fopen(filename);

% initialting index values
a = 1;
a_1 = 1;
b = 1;
c = 1;
k = 1; %variables for dp and pm
m = 1; %variables for vesicles
n = 1; %variables for adherens junction
t = 1;
u = 1;
y = 1;


while (true)
    
    tline = fgetl(fid);
    
    if ( ~ischar(tline))
        break,
    end

    %extracting data
    [type, records] = strtok(tline);
    
    %1 is line tool used in imageJ for measuring SV,LV,and DCV.
    if (type == '1')
        
        [vesicle(m).name,...
         vesicle(m).x,...
         vesicle(m).y,...
         vesicle(m).r] = strread(records, '%s %f %f %f');
        
        vesicle(m).name = char(vesicle(m).name);

        m=m+1;
        
    
    %7 is freehand line tool used in imageJ to mearsure adherens
    %junction    
    elseif (type == '7')
        
        [freel(n).name,...
         freel(n).length,...
         freel(n).xcoords,...
         freel(n).ycoords] = strread(records, '%s %f %s %s');
        
    structure_type = char(freel(n).name);
    
    switch(structure_type)
     
        case 'Ribbon'
        
            sr(a).name = char(freel(n).name);
            
            sr(a).length = freel(n).length*pixel_size;
            
            sr(a).x    = strread(freel(n).xcoords{1},...
                                 '%f','delimiter',',');
            
            sr(a).y    = strread(freel(n).ycoords{1},...
                                 '%f','delimiter',',');
            
            a = a+1;
        case 'Dense_projection'
        
            dp(a).name = char(freel(n).name);
            
            dp(a).length = freel(n).length*pixel_size;
            
            dp(a).x    = strread(freel(n).xcoords{1},...
                                 '%f','delimiter',',');
            
            dp(a).y    = strread(freel(n).ycoords{1},...
                                 '%f','delimiter',',');
            
            a_1 = a_1+1;    
        case 'Active_zone'
            
            az(b).name = char(freel(n).name);
            
            az(b).length = freel(n).length*pixel_size;
            
            az(b).x    = strread(freel(n).xcoords{1},...
                                 '%f','delimiter',',');
            
            az(b).y    = strread(freel(n).ycoords{1},...
                                 '%f','delimiter',',');
            
            b = b+1;
            
        case'Plasma_membrane'
            
            pm(c).name = char(freel(n).name);
            
            pm(c).length = freel(n).length*pixel_size;
            
            pm(c).x    = strread(freel(n).xcoords{1},...
                                 '%f','delimiter',',');
            
            pm(c).y    = strread(freel(n).ycoords{1},...
                                 '%f','delimiter',',');
            
            c = c+1;
        
        case'pits'
            
            pits(t).name = char(freel(n).name);
            
            pits(t).length = freel(n).length*pixel_size;
            
            pits(t).x    = strread(freel(n).xcoords{1},...
                                 '%f','delimiter',',');
            
            pits(t).y    = strread(freel(n).ycoords{1},...
                                 '%f','delimiter',',');
                 
            t = t+1;
            
        case 'coated_pits'
            
            coated_pits(u).name = char(freel(n).name);
            
            coated_pits(u).length = freel(n).length*pixel_size;
            
            coated_pits(u).x    = strread(freel(n).xcoords{1},...
                                 '%f','delimiter',',');
            
            coated_pits(u).y    = strread(freel(n).ycoords{1},...
                                 '%f','delimiter',',');

            u = u+1;
    end
        
        n=n+1;
        
    elseif (type == '3')

        [freeh(k).name,...
         freeh(k).area,...
         freeh(k).xelements,...
         freeh(k).yelements] = strread(records, '%s %f %s %s');

        if strcmp(freeh(k).name, 'Endosome')
            %(x, y) of each pixels on the outer surface of dense
            %projection
            
            analysis_data.endosome.name = char(freeh(k).name); 
            
            analysis_data.endosome.area = freeh(k).area;
            
            analysis_data.endosome.x    = strread(freeh(k).xelements{1},...
                              '%f','delimiter',',');
            
            analysis_data.endosome.y    = strread(freeh(k).yelements{1},...
                              '%f','delimiter',',');
        end
        k=k+1;
    else
        
        disp(type);
        disp(records);
        disp(filename);
    end
end



% exporting analysis_data
if ribbon_tf == 1
    p = exist ('sr'); 
    
end

if dp_tf == 1
    e = exist ('dp');
end

g = exist ('az');

s = exist ('pm');

if g == 0
    
    disp (filename);
    disp ('active zone missing');
    
end
    

if ribbon_tf ==1 && p == 0
    
    disp (filename); 
    disp ('ribbon missing');
elseif ribbon_tf ==1 && p == 1
    if length(sr)>1
        
        disp (filename);
        disp ('too many synaptic ribbon data');
        
    end
    
end

if dp_tf ==1 && e == 0
    
    disp (filename); 
    disp ('dense projection missing');
   
elseif dp_tf ==1 && e == 1
    if length(dp)>1
        
        disp (filename);
        disp ('too many dense projection data');
        
    end
end
if s == 0
    
    disp (filename);
    disp('plasma membrane missing');
    
else
    
    if length(pm) > 1
        
        disp (filename);
        disp ('too many plasma membrane data');
        
    end
    
end



correct_data = 0;

fclose (fid);

end    
