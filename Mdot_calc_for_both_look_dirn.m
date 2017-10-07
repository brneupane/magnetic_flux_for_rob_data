%%%%%%%%This calculates the value of M dot on the magnetosphere of saturn
%%%%%%%%using the both look direction 


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
%%%%%%%%%%%%%%%%%%%%%%%%%Here booth look direction is from 2004 to 2007
%%%%%%%%%%%%%%%%%%%%%%%%%313day

 load total_both_direction.mat
  I=find(both_direction1==1);

 R=rob_Data{3}(I); vr=rob_Data{29}(I);vt=rob_Data{30}(I);vp=rob_Data{31}(I);
 nw=rob_Data{32}(I); fit_ref=rob_Data{56}(I); Tpara=rob_Data{34}(I);LT=rob_Data{4}(I);
 
 kk=vr<0;
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% satisfying the given condition for
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% kk
 R_neg=R(kk);vr_neg=abs(vr(kk));nw_neg=nw(kk);Tpara_neg=Tpara(kk);
 %%%%%%%%%%%%%%%%%%%%%%%%
 mw=17*1.67*10^(-27); % mass of water group in kg
Rs=58232;% Radius of saturn in Km
cof=10^(15)*(2*pi^1.5).*Rs.*Rs*mw;
 min_R=3; max_R=27;k1=2;
 m=0;
 for i=min_R:k1:max_R
     m=m+1;
    
     map_T1=Tpara_neg(R_neg>=i & R_neg<i+k1);
      h1=scaleheight(map_T1);
     map_mass1=nw_neg(R_neg>=i & R_neg<i+k1).*h1.*(i);
     map_vr1=vr_neg(R_neg>=i & R_neg<i+k1);
     map_flow1=map_mass1.*map_vr1;
     inwardflow_mass(m)=geomean(map_flow1).*cof;
 end
 %%%%%%%%%%%%%%%outward mass transport 
 kk1=vr>0;
 R_pos=R(kk1);vr_pos=abs(vr(kk1));nw_pos=nw(kk1);Tpara_pos=Tpara(kk1);
  m=0;
for i=min_R:k1:max_R
     m=m+1;
    
     map_T2=Tpara_pos(R_pos>=i & R_pos<i+k1);
      h2=scaleheight(map_T2);
     map_mass2=nw_pos(R_pos>=i & R_pos<i+k1).*h2.*(i);
     map_vr2=vr_pos(R_pos>=i & R_pos<i+k1);
     map_flow1=map_mass2.*map_vr2;
     outwardflow_mass(m)=geomean(map_flow1).*cof;
 end
 
 figure()
 plot(min_R:k1:max_R,outwardflow_mass,'k','linewidth',4)
 hold on
 plot(min_R:k1:max_R,-1*inwardflow_mass,'linewidth',4)
 net=outwardflow_mass-inwardflow_mass;
 plot(min_R:k1:max_R,net,'-','linewidth',4)
 xlim([5 26])
 grid on
 legend('Outward','Inward','Net')
 h1=title('Rate of Mass transport in Saturn $\dot{M}$ (Kg/sec)');
 h3=xlabel('[Rs]');h2=ylabel(' $\dot{M}$ (Kg/sec)');
 set(h1, 'Interpreter', 'latex');
 set(h2, 'Interpreter', 'latex');
 set(h3, 'Interpreter', 'latex');
 set(gca,'fontsize',25,'fontweight','bold')