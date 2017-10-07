%%%%%%looking at the section in terms of quadrant 
clear all
clc
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
%%%%%%%%%%%%%%%%%%%%%%%%%Here booth look direction is from 2004 to 2007
%%%%%%%%%%%%%%%%%%%%%%%%%313day

load total_both_direction.mat
 I=find(both_direction1==1);

 R=rob_Data{3}(I); vr=rob_Data{29}(I);vt=rob_Data{30}(I);vp=rob_Data{31}(I);
 nw=rob_Data{32}(I); fit_ref=rob_Data{56}(I); Tpara=rob_Data{34}(I);LT=rob_Data{4}(I);
 m=0; n=0;k1=1; k2=1;
for i=0:k1:23
    m=m+1;
 for j=5:k2:27
     n=n+1;
     mapV(m,n)=nanmean(vr(R>j & R<=j+k1 & LT>i & LT<=i+k2));
     map_x(m,n)=j.*cos(i.*pi./12-pi);map_y(m,n)=j.*sin(i.*pi./12-pi);
 end
 n=0;
end
figure()
colormap jet(50)
pcolor(map_x,map_y,mapV)
caxis([-50 50])
daspect([1 1 1])
colorbar
m=0;k2=1;
II=(LT>06 & LT <12);LT1=LT(II);R1=R(II);vr1=vr(II);
for j=2:k2:29
    m=m+1;
    average_V(m)=nanmean(vr1(R1>j & R1<j+k2));
end
figure()
plot(2:k2:29,average_V,'linewidth',7)
grid on
xlabel('[Rs]');ylabel('Mean Value of Radial Flow')
title('Flow of Plasma at Local Time between 06 and 12')
set(gca,'fontsize',30,'fontweight','bold')
xlim([ 5 26])