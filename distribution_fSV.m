
bin=50;

data.vesicle_distribution.docked_fSV = distribution (CR521_KD_20s.raw_data, CR521_KD_20s.vesicle_number, bin, 'docked_fSV', 'total');
data.vesicle_distribution.tethered_fSV = distribution (CR521_KD_20s.raw_data, CR521_KD_20s.vesicle_number,bin, 'tethered_fSV', 'total');
data.vesicle_distribution.cytosolic_fSV = distribution (CR521_KD_20s.raw_data, CR521_KD_20s.vesicle_number,bin, 'fSV', 'total');




[a,b]=size(data.vesicle_distribution.docked_fSV);

table = zeros(a,b);


for i = 1:a
    
    for j = 7:b
        
        
       table (i,j) = data.vesicle_distribution.docked_fSV(i,j)...
                   + data.vesicle_distribution.tethered_fSV(i,j)...
                   + data.vesicle_distribution.cytosolic_fSV(i,j);
               
    end
end


for i=1:a
    
    table(i,1)=data.vesicle_distribution.docked_fSV(i,1);
    table(i,2)=sum(table(i,7:b));
    table(i,3)=mean(table(i,7:b));
    table(i,4)=std(table(i,7:b))/sqrt(b-6);
       
end

clear a b i j data