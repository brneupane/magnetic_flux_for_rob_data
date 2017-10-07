 clear all;
 clc
%%%%This is basically calculation of rob dates and used it as the input
%%%%date to look  at the look direction
path_name='/Users/brneupane/Desktop/Physics_project/rob_wilson_data/';
 file_name='CAS_CAPS_FITTED_PARAMETERS_WILSON_V01.CSV';
  format_spec='%s %d %f %f %f %f %f %f %f %f  %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f';
 full_file_name = horzcat(path_name,file_name);
fid=fopen(full_file_name);
 
 rob_Data=textscan(fid,format_spec,'HeaderLines',1,'Delimiter',',');
fid(close)
Dates=rob_Data{1};
for i=1:length(Dates)
    rob_yr(i,:)=str2num(Dates{i}(1:4));rob_day(i,:)=str2num(Dates{i}(6:8));rob_hr(i,:)=str2num(Dates{i}(10:11));
    rob_min(i,:)=str2num(Dates{i}(13:14));rob_sec(i,:)=str2num(Dates{i}(16:end));
end


%%%%%%getting both look direction 1:10784
for i=1:length(rob_yr)
    yr=rob_yr(i);day=rob_day(i);hr=rob_hr(i);min=rob_min(i);sec=rob_sec(i);
    try
    [both_direction1(i)]=looking_at_both_direction(yr,day,hr,min,sec);
    
    catch
        both_direction1(i)=0;
    end 
   i
end


 
 