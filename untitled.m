
%% This is the calculation of the local entropy using the Rob-data y conforming the look direction 

clear all;
 clc
%%%%This is basically reads all the rob dates and momnets from rob file

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

load both_direction.mat
 I=find(both_direction==1);

 R=rob_Data{3}(I); vr=rob_Data{29}(I);vt=rob_Data{30}(I);vp=rob_Data{31}(I);
 nw=rob_Data{32}(I); fit_ref=rob_Data{56}(I); Tpara=rob_Data{34}(I);LT=rob_Data{4}(I);
 gamma=1.4;%%%%considering water group as di-atomic 
 %%%calculation of local entopy
 local_entropy=Tpara./(nw.^(gamma-1));
 semilogy(R,local_entropy,'.')
 xlim([5 30])
 m=0;
 for i=5:30
     m=m+1;
     map_local_entropy=local_entropy(R>i & R<=i+1);
     II=~isnan(map_local_entropy);
     mean_local_entropy(m)=mean(log(map_local_entropy(II)));
     deviation(m)=std(log(map_local_entropy(II)));
     high(m)=exp(mean_local_entropy(m)+(deviation(m)));
     low(m)=exp(mean_local_entropy(m)-(deviation(m)));
 end
 hold on 
 semilogy(5:30,exp(mean_local_entropy),'r','linewidth',5)
 semilogy(5:30,high,'k','linewidth',5)
 semilogy(5:30,low,'y','linewidth',5)
 xlim([5 29])
 
 %%%%%%%% adibats plot of entropy acoording to +ve and -ve flow 
 m=0;
 for i=3:20
     m=m+1;
     I=R>i & R<=i+1;
     map_T=Tpara(I);map_nw=nw(I);
     
     T1=map_T(vr(I)>0);nw1=map_nw(vr(I)>0);
     
     x1=log10(nw1);y1=log(T1);
     figure(2)
     subplot(6,3,m)
     scatter(x1,y1,'b')
     hold on
     
     T2=map_T(vr(I)<0);nw2=map_nw(vr(I)<0);
 x2=log10(nw2);y2=log(T2);
 scatter(x2,y2,'r');
 title([' RS=' num2str(i)  ' '])
 xlabel('log10(Density)');ylabel('log10(T)');
 legend('+ Vr','-Vr')
 hold on 
  x=linspace(-5,5,100);y=linspace(-5,10,100);
  [xa,ya]=meshgrid(x,y);value=ya-0.4*xa;
  contour(xa,ya,value,10)
end
 