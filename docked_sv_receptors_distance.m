


function [output_data] = docked_sv_receptors_distance (docked_sv, receptors)

[a,b] = size(docked_sv.DockedSVData);

[e,f] = size(receptors.DockedSVData);

c=b/5;% maximum # of docked_sv in the whole set
g=f/5;% maximum # of gold particles/receptors in the whole set
dist (1,1) = 0;
x=1;
for i = 1:a %for every row of the table
    
    for j = 1:c % for every pit
    
        if docked_sv.DockedSVData(i,j*5-2)>0 & docked_sv.DockedSVData(i,j*5-2)<1 
        %if docked_sv exist (the 3rd column of the table is the normalized distance to the center so only contain number between 0 to 1)
            
            for k = 1:g %for every receptor
                
                if receptors.DockedSVData(i,k*5-2)>0 & receptors.DockedSVData(i,k*5-2)<1
                %if receptors exist (the 3rd column of the table is the normalized distance to the center so only contain number between 0 to 1)
                
                    if docked_sv.DockedSVData(i,j*5) == receptors.DockedSVData(i,k*5)
                    %if receptors and docked_sv are on the same side of an
                    %active zone
                         
                        dist(x,1) = abs(docked_sv.DockedSVData(i,j*5-3)-receptors.DockedSVData(i,k*5-3));
                        %distance-to-center values should be subtracted to
                        %give the distance between each toher
                        
                    else %otherwise distance should be added
                        
                        dist(x,1) = abs(docked_sv.DockedSVData(i,j*5-3)+receptors.DockedSVData(i,k*5-3));
                    end
                    x=x+1;
                end
            end
       
        end
    end
end

output_data.SVDist = dist;
end



                
            
            
            
            
            