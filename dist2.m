function temp_distance = dist2(x, y, r, pm_x, pm_y)

% 
% Record of revisions:
%      Date             programmer              Description of change
%      ====             ==========              =====================
%    02/20/2008      Shigeki Watanabe           Original code

% dist2 function will calculates distance between 2 points and subtract
% radius of vesicles so that the calculation starts from the edge of the
% vesicles
%
% calling sequence:
% temp_distance = dist2(x, y, r, pm_x, pm_y)

% calculating distance from vesicles to psedo DP on the section
temp_distance = sqrt((x - pm_x)^2+(y - pm_y)^2)-r;

end