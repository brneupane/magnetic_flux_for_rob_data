%%%%% This is looking the direction and calculating the magnetic flux for
%%%%% odd magnetic flux
clear all
clc
load Mag_1M_data.mat;
Data=magenetometer_data;
A(:,1)=Data(1,:);A(:,2)=Data(2,:);A(:,3)=Data(3,:);A(:,4)=Data(4,:);A(:,5)=Data(5,:);A(:,6)=Data(6,:);
mag_dates=24*60*datenum(A);
B_r=magenetometer_data(7,:); B_t=magenetometer_data(8,:); B_phi=magenetometer_data(9,:);

%%%%%%%%%%%%%%%%%Use of rob data This section involves reading of rob data
%%%%% files 

path_name='/Users/brneupane/Desktop/Physics_project/rob_wilson_data/';
 file_name='CAS_CAPS_FITTED_PARAMETERS_WILSON_V01.CSV';
  format_spec='%s %d %f %f %f %f %f %f %f %f  %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f';
 full_file_name = horzcat(path_name,file_name);
fid=fopen(full_file_name);
 
 rob_Data=textscan(fid,format_spec,'HeaderLines',1,'Delimiter',',');
fid(close)
%%%%%Here both direction gives the look of the space craft at both at the
%%%%%same time 
load both_direction.mat


I=find(both_direction==1);
R=rob_Data{3}(I); vr=rob_Data{29}(I);vt=rob_Data{30}(I);rob_fit=rob_Data{56}(I);LT=rob_Data{4}(I);
%%%Reading of rob date from rob data
Dates=rob_Data{1};
for i=1:length(Dates)
    rob_yr(i,:)=str2num(Dates{i}(1:4));rob_day(i,:)=str2num(Dates{i}(6:8));rob_hr(i,:)=str2num(Dates{i}(10:11));
    rob_min(i,:)=str2num(Dates{i}(13:14));rob_sec(i,:)=str2num(Dates{i}(16:end));
end
yr=datenum(rob_yr(I),1,1); day=rob_day(I)-1; hr=rob_hr(I)./(24); min=rob_min(I)./(60*24); sec=rob_sec(I)./(60*60*24);

%%%%%%%%rob dates in minute 
%rob_date=24*60*(datenum([rob_yr,1,1])+rob_day+rob_hr./24+rob_min./(60*24)+rob_sec./(24*60*60));
rob_date=24*60*(yr+day+hr+min+sec);

for i=1:length(rob_date)
    ze_condition=(mag_dates>=(rob_date(i)-1) &  mag_dates<=(rob_date(i)+1));
    
   ref_mat(i)=sum(ze_condition); 
    B_r_rel(i)=mean(B_r(ze_condition)); B_t_rel(i)=mean(B_t(ze_condition)); B_phi_rel(i)=mean(B_phi(ze_condition));
    %my_LT(i)=mean(magenetometer_data(14,ze_condition));
end
%%%%%%%%%%%%%Finding the value for which field is negative and and vr is
%%%%%%%%%%%%%positive

I1=find(B_t_rel'<0 & vr>0);
Bt_neg=B_t_rel(I1);vr_pos=vr(I1);
flux=-vr_pos.*Bt_neg';
R_neg=R(I1);

