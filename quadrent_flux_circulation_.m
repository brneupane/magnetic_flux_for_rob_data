%% This calculates the diffrent quadrant magnetic flux circulation 
clc
clear all
%%Rading of the magnetometer data 
load Mag_1M_data.mat;
Data=magenetometer_data;
A(:,1)=Data(1,:);A(:,2)=Data(2,:);A(:,3)=Data(3,:);A(:,4)=Data(4,:);A(:,5)=Data(5,:);A(:,6)=Data(6,:);
mag_dates=24*60*datenum(A);
B_r=magenetometer_data(7,:); B_t=magenetometer_data(8,:); B_phi=magenetometer_data(9,:);


%%Reading of Rob data 

path_name='/Users/brneupane/Desktop/Physics_project/rob_wilson_data/';
 file_name='CAS_CAPS_FITTED_PARAMETERS_WILSON_V01.CSV';
  format_spec='%s %d %f %f %f %f %f %f %f %f  %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f';
 full_file_name = horzcat(path_name,file_name);
fid=fopen(full_file_name);
 
 rob_Data=textscan(fid,format_spec,'HeaderLines',1,'Delimiter',',');
fid(close)
%%Looks direction vector
load total_both_direction.mat
 I=find(both_direction1==1);
 
 %%This is diffrent moments conforming both look direction of space-craft 
 R=rob_Data{3}(I); vr=rob_Data{29}(I);vt=rob_Data{30}(I);rob_fit=rob_Data{56}(I);LT=rob_Data{4}(I);
 
Dates=rob_Data{1};
for i=1:length(Dates)
    rob_yr(i,:)=str2num(Dates{i}(1:4));rob_day(i,:)=str2num(Dates{i}(6:8));rob_hr(i,:)=str2num(Dates{i}(10:11));
    rob_min(i,:)=str2num(Dates{i}(13:14));rob_sec(i,:)=str2num(Dates{i}(16:end));
end

yr=datenum(rob_yr(I),1,1); day=rob_day(I)-1; hr=rob_hr(I)./(24); min=rob_min(I)./(60*24); sec=rob_sec(I)./(60*60*24);
rob_date=24*60*(yr+day+hr+min+sec);

%%Taking all the magnetic field data assiciated with date with in +1 AND -1
%%MIN INTERVAL

 for i=1:length(rob_date)
    ze_condition=(mag_dates>=(rob_date(i)-1) &  mag_dates<=(rob_date(i)+1));
    
   ref_mat(i)=sum(ze_condition); 
    B_r_rel(i)=mean(B_r(ze_condition)); B_t_rel(i)=mean(B_t(ze_condition)); B_phi_rel(i)=mean(B_phi(ze_condition));
    %my_LT(i)=mean(magenetometer_data(14,ze_condition));
end
 
 
 %%NOW CALCCULATION OF THE PHI COMPONENT OF THE ELECTRIC FIELD 
 E=vt.*B_r_rel'-B_t_rel'.*vr;
 II=((LT>19 & LT<24)|(LT>0 & LT<2) );
 E1=E(II);R1=R(II);
 k=0;
 for i=3:3:27
    k=k+1;
    map_E=E1(R1>=i & R1<i+1);
    II=~isnan(map_E);
    net_flux(k)=mean(map_E(II));
end
 plot(3:3:27,net_flux,'-k','linewidth',5)
 xlabel('[Rs]')
 ylabel('E_{\phi}')
 title('Flux Circulation  at local time between 9 to 18')
 set(gca,'fontsize',30,'FontWeight','bold')
 xlim([10 27])
 
 
 
 
 
 
 
 
 
 
 
 