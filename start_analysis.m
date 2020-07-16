function data = start_analysis

% this is the master function to initiate the analysis for synapse
% morphometry. This function will import .txt files generated from
% ImageJ/Fiji macros for sv analysis. the txt files must contain one plasma
% membrane and one active zone. Note that if there is more than one plasma
% membrane, this program is designed to give an error. Before running this
% program, please use start_data_check to make sure the text files meet the
% minimal requirement. 

% prompt users to input the pixel size.  
pixel_size = str2num(input('What is the pixel size (nm/pixel):', 's'));
 
% binning the numbers by x nm relative to the active zone when plotting the
% distribution. 
bin = str2num(input('what is the bin size:', 's'));

% importing the data using the get_data function. 
data.raw_data = get_data (pixel_size); 

%number of vesicles in active zone, in non-active zone, and in the terminal
data.vesicle_number = vesicle_count (data.raw_data);

%number of vesicles near synaptic ribbons
if isfield (data.raw_data(1).analysis_data, 'sr')
    
    data.vesicle_number_sr = vesicle_count_sr (data.raw_data);
end

%number of vesicles near synaptic ribbons
if isfield (data.raw_data(1).analysis_data, 'dp')
    
    data.vesicle_number_dp = vesicle_count_dp (data.raw_data);
end
    

%distribution of vesicles relative to active zone. 
data.vesicle_distribution.docked_SV = distribution (data.raw_data, data.vesicle_number, bin, 'docked_SV', 'total');
data.vesicle_distribution.tethered_SV = distribution (data.raw_data, data.vesicle_number,bin, 'tethered_SV', 'total');
data.vesicle_distribution.cytosolic_SV = distribution (data.raw_data, data.vesicle_number,bin, 'SV', 'total');

data.vesicle_distribution.docked_fSV = distribution (data.raw_data, data.vesicle_number, bin, 'docked_fSV', 'total');
data.vesicle_distribution.tethered_fSV = distribution (data.raw_data, data.vesicle_number,bin, 'tethered_fSV', 'total');
data.vesicle_distribution.cytosolic_fSV = distribution (data.raw_data, data.vesicle_number,bin, 'fSV', 'total');

data.vesicle_distribution.all_SV = distribution_all_SV (data.vesicle_distribution);

data.vesicle_distribution.DCV = distribution (data.raw_data, data.vesicle_number,bin, 'DCV', 'total');
data.vesicle_distribution.docked_DCV = distribution (data.raw_data, data.vesicle_number,bin, 'docked_DCV', 'total');

data.vesicle_distribution.LV = distribution (data.raw_data, data.vesicle_number,bin, 'LV', 'total');
data.vesicle_distribution.fLV = distribution (data.raw_data, data.vesicle_number,bin, 'fLV', 'total');

data.vesicle_distribution.ccv = distribution (data.raw_data, data.vesicle_number,bin, 'CCV', 'total');
data.vesicle_distribution.fccv = distribution (data.raw_data, data.vesicle_number,bin, 'fCCV', 'total');


%for pits data, the distribution can be shown from all pits in the dataset
%or just those outside the active zone (excluding the putative exocytic
%pits from the dataset)
data.vesicle_distribution.pits.total = distribution (data.raw_data, data.vesicle_number, bin, 'pits', 'total');
data.vesicle_distribution.pits.periactive_zone = distribution (data.raw_data, data.vesicle_number, bin, 'pits', 'non_az');

data.vesicle_distribution.fpits.total = distribution (data.raw_data, data.vesicle_number, bin, 'fpits', 'total');
data.vesicle_distribution.fpits.periactive_zone = distribution (data.raw_data, data.vesicle_number, bin, 'fpits', 'non_az');

data.vesicle_distribution.coated_pits.total = distribution (data.raw_data, data.vesicle_number, bin, 'coated_pits', 'total');
data.vesicle_distribution.coated_pits.periactive_zone = distribution (data.raw_data, data.vesicle_number, bin, 'coated_pits', 'non_az');

data.vesicle_distribution.coated_fpits.total = distribution (data.raw_data, data.vesicle_number, bin, 'coated_fpits', 'total');
data.vesicle_distribution.coated_fpits.periactive_zone = distribution (data.raw_data, data.vesicle_number, bin, 'coated_fpits', 'non_az');

data.vesicle_distribution.endosome.total = distribution (data.raw_data, data.vesicle_number, bin, 'endosome', 'total');
data.vesicle_distribution.fendosome.total = distribution (data.raw_data, data.vesicle_number, bin, 'fendosome', 'total');

data.vesicle_distribution.mvb.total = distribution (data.raw_data, data.vesicle_number, bin, 'mvb', 'total');
data.vesicle_distribution.fmvb.total = distribution (data.raw_data, data.vesicle_number, bin, 'fmvb', 'total');

%distribution of vesicles relative to synaptic ribbons. 
if isfield (data.raw_data(1).analysis_data, 'sr')
    data.vesicle_distribution_sr.docked_SV = distribution_sr (data.raw_data, bin, 'docked_SV');
    data.vesicle_distribution_sr.tethered_SV = distribution_sr (data.raw_data, bin, 'tethered_SV');
    data.vesicle_distribution_sr.cytosolic_SV = distribution_sr (data.raw_data, bin, 'SV');
    
    data.vesicle_distribution_sr.docked_fSV = distribution_sr (data.raw_data,  bin, 'docked_fSV');
    data.vesicle_distribution_sr.tethered_fSV = distribution_sr (data.raw_data, bin, 'tethered_fSV');
    data.vesicle_distribution_sr.cytosolic_fSV = distribution_sr (data.raw_data, bin, 'fSV');
    
    data.vesicle_distribution_sr.all_SV = distribution_sr_all_SV (data.vesicle_distribution_sr);
    
    data.vesicle_distribution_sr.LV = distribution_sr (data.raw_data, bin, 'LV');
    data.vesicle_distribution_sr.fLV = distribution_sr (data.raw_data, bin, 'fLV');
    
    data.vesicle_distribution_sr.ccv = distribution_sr (data.raw_data, bin, 'CCV');
    data.vesicle_distribution_sr.fccv = distribution_sr (data.raw_data, bin, 'fCCV');
    
    data.vesicle_distribution_sr.endosome.total = distribution_sr (data.raw_data, bin, 'endosome');
    data.vesicle_distribution_sr.fendosome.total = distribution_sr (data.raw_data, bin, 'fendosome');
    
    data.vesicle_distribution_sr.mvb.total = distribution_sr (data.raw_data, bin, 'mvb');
    data.vesicle_distribution_sr.fmvb.total = distribution_sr (data.raw_data, bin, 'fmvb');
end

%distribution of vesicles relative to dense projections. 
if isfield (data.raw_data(1).analysis_data, 'dp')
    data.vesicle_distribution_dp.docked_SV = distribution_dp (data.raw_data, bin, 'docked_SV');
    data.vesicle_distribution_dp.tethered_SV = distribution_dp (data.raw_data, bin, 'tethered_SV');
    data.vesicle_distribution_dp.cytosolic_SV = distribution_dp (data.raw_data, bin, 'SV');
    
    data.vesicle_distribution_dp.docked_fSV = distribution_dp (data.raw_data,  bin, 'docked_fSV');
    data.vesicle_distribution_dp.tethered_fSV = distribution_dp (data.raw_data, bin, 'tethered_fSV');
    data.vesicle_distribution_dp.cytosolic_fSV = distribution_dp (data.raw_data, bin, 'fSV');
    
    data.vesicle_distribution_dp.all_SV = distribution_dp_all_SV (data.vesicle_distribution_dp);
    
    data.vesicle_distribution_dp.LV = distribution_dp (data.raw_data, bin, 'LV');
    data.vesicle_distribution_dp.fLV = distribution_dp (data.raw_data, bin, 'fLV');
    
    data.vesicle_distribution_dp.ccv = distribution_dp (data.raw_data, bin, 'CCV');
    data.vesicle_distribution_dp.fccv = distribution_dp (data.raw_data, bin, 'fCCV');
    
    data.vesicle_distribution_dp.endosome.total = distribution_dp (data.raw_data, bin, 'endosome');
    data.vesicle_distribution_dp.fendosome.total = distribution_dp (data.raw_data, bin, 'fendosome');
    
    data.vesicle_distribution_dp.mvb.total = distribution_dp (data.raw_data, bin, 'mvb');
    data.vesicle_distribution_dp.fmvb.total = distribution_dp (data.raw_data, bin, 'fmvb');
end

%distribution relative to plasma membrane
data.vesicle_distribution_pm.docked_SV = distribution_pm (data.raw_data, bin, 'docked_SV');
data.vesicle_distribution_pm.tethered_SV = distribution_pm (data.raw_data, bin, 'tethered_SV');
data.vesicle_distribution_pm.cytosolic_SV = distribution_pm (data.raw_data, bin, 'SV');

data.vesicle_distribution_pm.docked_fSV = distribution_pm (data.raw_data,  bin, 'docked_fSV');
data.vesicle_distribution_pm.tethered_fSV = distribution_pm (data.raw_data, bin, 'tethered_fSV');
data.vesicle_distribution_pm.cytosolic_fSV = distribution_pm (data.raw_data, bin, 'fSV');

data.vesicle_distribution_pm.all_SV = distribution_pm_all_SV (data.vesicle_distribution_pm);

data.vesicle_distribution_pm.LV = distribution_pm (data.raw_data, bin, 'LV');
data.vesicle_distribution_pm.fLV = distribution_pm (data.raw_data, bin, 'fLV');

data.vesicle_distribution_pm.ccv = distribution_pm (data.raw_data, bin, 'CCV');
data.vesicle_distribution_pm.fccv = distribution_pm (data.raw_data, bin, 'fCCV');

data.vesicle_distribution_pm.endosome.total = distribution_pm (data.raw_data, bin, 'endosome');
data.vesicle_distribution_pm.fendosome.total = distribution_pm (data.raw_data, bin, 'fendosome');

data.vesicle_distribution_pm.mvb.total = distribution_pm (data.raw_data, bin, 'mvb');
data.vesicle_distribution_pm.fmvb.total = distribution_pm (data.raw_data, bin, 'fmvb');


%diameter of vesicles
data.vesicle_diameter.SV = average_diameter (data.raw_data, 'SV');
data.vesicle_diameter.DCV = average_diameter (data.raw_data, 'DCV');
data.vesicle_diameter.LV = average_diameter (data.raw_data, 'LV');

data.vesicle_diameter.fSV = average_diameter (data.raw_data, 'fSV');
data.vesicle_diameter.fLV = average_diameter (data.raw_data, 'fLV');

data.vesicle_diameter.CCV = average_diameter (data.raw_data, 'CCV');
data.vesicle_diameter.fCCV = average_diameter (data.raw_data, 'fCCV');

data.vesicle_diameter.pits.active_zone = average_pits_diameter (data.raw_data, 'az');
data.vesicle_diameter.pits.periactive_zone = average_pits_diameter (data.raw_data, 'non_az');
data.vesicle_diameter.pits.total = average_pits_diameter (data.raw_data, 'total');

data.vesicle_diameter.fpits.active_zone = average_fpits_diameter (data.raw_data, 'az');
data.vesicle_diameter.fpits.periactive_zone = average_fpits_diameter (data.raw_data, 'non_az');
data.vesicle_diameter.fpits.total = average_fpits_diameter (data.raw_data, 'total');

data.vesicle_diameter.coated_pits.active_zone = average_coated_pits_diameter (data.raw_data, 'az');
data.vesicle_diameter.coated_pits.periactive_zone = average_coated_pits_diameter (data.raw_data, 'non_az');
data.vesicle_diameter.coated_pits.total = average_coated_pits_diameter (data.raw_data, 'total');

data.vesicle_diameter.coated_fpits.active_zone = average_coated_fpits_diameter (data.raw_data, 'az');
data.vesicle_diameter.coated_fpits.periactive_zone = average_coated_fpits_diameter (data.raw_data, 'non_az');
data.vesicle_diameter.coated_fpits.total = average_coated_fpits_diameter (data.raw_data, 'total');



data.vesicle_diameter.cumulative = diameter_cumulative (data);


disp ('so far so good');



end

