%%%%%%%This evaluates the net flux circulation in the magnetosphere of Saturn making both look direction conform 
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
load total_both_direction.mat
 I=find(both_direction1==1);
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
%%%%%%%%%%%%%calculation of magnetic flux circulation


E=vt.*B_r_rel'-B_t_rel'.*vr;


        
%%%%%finding the value for current sheeth crossing 
  I1=(B_t_rel'<0 & vr>0);
%%%%% neglecting the current sheeth crossing vlaue
  E=E(~I1); R=R(~I1);
kI=find(E>0);E_pos=abs(E(kI));R1=R(kI);
k=0;
for i=3:3:30
    k=k+1;
    E1=E_pos(R1>=i & R1<i+1);
    II=~isnan(E1);
    mean_E_pos(k)=mean(E1(II));
end
k=0;
figure(1)
plot(3:3:30,mean_E_pos,'r','linewidth',5)
hold on
kII=find(E<0);E_neg=abs(E(kII));R2=R(kII);
for i=3:3:30
    k=k+1;
    E2=E_neg(R2>=i & R2<i+1);
    II=~isnan(E2);
    mean_E_neg(k)=mean(E2(II));
end
plot(3:3:30,-1*mean_E_neg,'b','linewidth',5)
net=mean_E_pos-mean_E_neg;
plot(3:3:30,net,'k','linewidth',5)
grid on
xlim([5 26])
xlabel('[Rs]');ylabel('E_{\phi}')
title('Magnetic Flux Circulation')
legend('Inward Flux','Outward Flux','Net Flux')
set(gca,'fontsize',30,'fontweight','bold')
